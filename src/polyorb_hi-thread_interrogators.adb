------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--      P O L Y O R B _ H I . T H R E A D _ I N T E R R O G A T O R S       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--    Copyright (C) 2007-2009 Telecom ParisTech, 2010-2012 ESA & ISAE.      --
--                                                                          --
-- PolyORB HI is free software; you  can  redistribute  it and/or modify it --
-- under terms of the GNU General Public License as published by the Free   --
-- Software Foundation; either version 2, or (at your option) any later.    --
-- PolyORB HI is distributed  in the hope that it will be useful, but       --
-- WITHOUT ANY WARRANTY;  without even the implied warranty of              --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General --
-- Public License for more details. You should have received  a copy of the --
-- GNU General Public  License  distributed with PolyORB HI; see file       --
-- COPYING. If not, write  to the Free  Software Foundation, 51 Franklin    --
-- Street, Fifth Floor, Boston, MA 02111-1301, USA.                         --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;

with PolyORB_HI.Output;
with PolyORB_HI.Protocols;
with PolyORB_HI.Port_Type_Marshallers;
with PolyORB_HI.Streams;
with PolyORB_HI.Time_Marshallers;
with POlyORB_HI.Utils;

package body PolyORB_HI.Thread_Interrogators is

   use type PolyORB_HI.Streams.Stream_Element_Offset;
   use PolyORB_HI.Port_Kinds;
   use Ada.Real_Time;
   use PolyORB_HI_Generated.Deployment;
   use PolyORB_HI.Output;
   use PolyORB_HI.Utils;

   --  The types and the routines below give a flexible way to handle
   --  Thread_Interface_Type variables and to store them in arrays.

   type Port_Stream is
     new PolyORB_HI.Streams.Stream_Element_Array
     (1 .. Thread_Interface_Type'Size / 8);

   type Port_Stream_Entry is record
      From    : Entity_Type;
      Payload : Port_Stream;
   end record;
   --  A couple of a message and its sender

   N_Ports : constant Integer :=
     Port_Type'Pos (Port_Type'Last) - Port_Type'Pos (Port_Type'First) + 1;
   --  Number of ports in the thread

   function Interface_To_Stream is
      new Ada.Unchecked_Conversion (Thread_Interface_Type, Port_Stream);
   function Stream_To_Interface is
      new Ada.Unchecked_Conversion (Port_Stream, Thread_Interface_Type);

   function CE return String;
   pragma Inline (CE);
   --  Shortcut to Entity_Image (Current_Entity)

   type Port_Stream_Array is array (Port_Type) of Port_Stream_Entry;
   type Big_Port_Stream_Array is array
     (Integer range 0 .. Global_Data_Queue_Size) of Port_Stream_Entry;
   type Big_Port_Type_Array is array
     (Integer range 0 .. Global_Data_Queue_Size) of Port_Type;
   --  FIXME: We begin by 0 although the 0 position is unused. We do
   --  this to avoid compile time warning. After this package is
   --  deeply tested, begin by 1 and disable Index_Check and
   --  Range_Check for the Big_Port_Stream_Array type.

   procedure H_Increment_First (F : in out Integer);
   procedure H_Increment_Last  (L : in out Integer);
   pragma Inline (H_Increment_First);
   pragma Inline (H_Increment_Last);
   --  Cyclic incrementation and decrementation of F or L within the
   --  1..Global_Data_Queue_Size range.

   type Boolean_Array is array (Port_Type) of Boolean;
   type Time_Array is array (Port_Type) of Time;

   --  The protected object below handles all the received events or
   --  data on IN ports.
   --
   --  Finally, the protected object contains a second array to store
   --  the number of received values for each IN EVENT [DATA] (0 .. n)
   --  and IN DATA (0 .. 1) port.

   protected Global_Queue is
      pragma Priority (System.Priority'Last);

      entry Wait_Event (P : out Port_Type);
      --  Blocks until the thread receives a new event. Return the
      --  corresponding Port that received the event.

      procedure Read_Event (P : out Port_Type; Valid : out Boolean);
      --  Same as 'Wait_Event' but without blocking. Valid is set to
      --  False if there is nothing to receive.

      procedure Dequeue (T : Port_Type; P : out Port_Stream_Entry);
      --  Dequeue a value from the partial FIFO of port T. If there is
      --  no enqueued value, return the latest dequeued value.

      function Read_In (T : Port_Type) return Port_Stream_Entry;
      --  Read the oldest queued value on the partial FIFO of IN port
      --  T without dequeuing it. If there is no queued value, return
      --  the latest dequeued value.

      function Read_Out (T : Port_Type) return Port_Stream_Entry;
      --  Return the value put for OUT port T.

      function Is_Invalid (T : Port_Type) return Boolean;
      --  Return True if no Put_Value has been called for this port
      --  since the last Set_Invalid call.

      procedure Set_Invalid (T : Port_Type);
      --  Set the value stored for OUT port T as invalid to impede its
      --  future sending without calling Put_Value. This procedure is
      --  generally called just after Read_Out. However we cannot
      --  combine them in one routine because we need Read_Out to be a
      --  function and functions cannot modify protected object
      --  states.

      procedure Store_In (P : Port_Stream_Entry; T : Time);
      --  Stores a new incoming message in its corresponding
      --  position. If this is an event [data] incoming message, then
      --  stores it in the queue, updates its most recent value and
      --  unblock the barrier. Otherwise, it only overrides the most
      --  recent value. T is the time stamp associated to the port
      --  P. In case of data ports with delayed connections, it
      --  indicates the instant from which the data of P becomes
      --  deliverable.

      procedure Store_Out (P : Port_Stream_Entry; T : Time);
      --  Store a value of an OUT port to be sent at the next call to
      --  Send_Output and mark the value as valid.

      function Count (T : Port_Type) return Integer;
      --  Return the number of pending messages on IN port T.

      function Get_Time_Stamp (P : Port_Type) return Time;
      --  Return the time stamp associated to port T

   private
      Global_Data_Queue : Big_Port_Stream_Array;
      --  The structure of the buffer is as follows:

      --  ----------------------------------------------------------------
      --  |   Q1   |     Q2      |       Q3        |  ... |      Qn      |
      --  ----------------------------------------------------------------
      --  O1       O2            O3                O4 ... On

      --  'On' is the offset associated to IN [event] [data] port n,
      --  given from the generic formal, Thread_Fifo_Offsets. This
      --  guarantees an O(1) access and storage time of a given
      --  element in the global queue. Intrinsically, the global table
      --  is a concatenation of circular arrays each one corresponding
      --  to an port queue.

      Firsts : Integer_Array := (Port_Type'Range => 1);
      Lasts  : Integer_Array := (Port_Type'Range => 0);
      --  Used for IN [event] [data] ports to navigate in the global
      --  queue. For IN DATA ports, in case of immediate connection
      --  only the 'Lasts' value is relevant and it is 0 or 1, in case
      --  of a delayed connection both values are relevant.

      Empties : Boolean_Array := (Port_Type'Range => True);
      --  Indicates whether each port-FIFO is empty or not

      Global_Data_History : Big_Port_Type_Array;
      GH_First            : Integer := 1;
      GH_Last             : Integer := 0;
      --  This contains, in an increasing chronological order the IN
      --  EVENT ports that have a pending event. Example (P_1, P_3,
      --  P_1, P_2, P_3) means that the oldest pending message is
      --  received on P_1 then on P_3, then on P_1 again and so on...

      --  FIXME: Add N_Ports to the array size to handle the case the
      --  thread has an IN event [data] port with a FIFO size equal to
      --  zero which is not supported yet.

      Most_Recent_Values : Port_Stream_Array;
      Time_Stamps        : Time_Array;
      function Get_Most_Recent_Value (P : Port_Type) return Port_Stream_Entry;
      procedure Set_Most_Recent_Value
        (P : Port_Type;
         S : Port_Stream_Entry;
         T : Time);
      --  The protected object contains also an array to store the
      --  values of received IN DATA ports as well as the most recent
      --  value of IN EVENT DATA. For OUT port, the value is the
      --  message to be send when Send_Output is called. In case of an
      --  event data port, we do not use the 2 elements of the array
      --  to store most recent values because there is no delayed
      --  connections for event data ports.

      Initialized : Boolean_Array := (Port_Type'Range => False);
      --  To indicate whether the port ever received a data (or an
      --  event).

      Value_Put : Boolean_Array := (Port_Type'Range => False);
      --  To indicate whether the OUT port values have been set in
      --  order to be sent.

      Not_Empty : Boolean := False;
      --  The protected object barrier. True when there is at least
      --  one pending event [data].

      N_Empties : Integer := N_Ports;
      --  Number of empty partial queues. At the beginning, all the
      --  queues are empty.
   end Global_Queue;

   ------------------
   -- Global_Queue --
   ------------------

   protected body Global_Queue is

      ----------------
      -- Wait_Event --
      ----------------

      entry Wait_Event (P : out Port_Type) when Not_Empty is
      begin
         P := Global_Data_History (GH_First);

         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Wait_Event: oldest unread event port = "
                        + Thread_Port_Images (P)));
      end Wait_Event;

      ----------------
      -- Read_Event --
      ----------------

      procedure Read_Event (P : out Port_Type; Valid : out Boolean) is
      begin
         Valid := Not_Empty;

         if Valid then
            P := Global_Data_History (GH_First);

            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Read_Event: read valid event [data] on "
                           + Thread_Port_Images (P)));
         end if;
      end Read_Event;

      -------------
      -- Dequeue --
      -------------

      procedure Dequeue (T : Port_Type; P : out Port_Stream_Entry) is
         Is_Empty  : Boolean renames Empties (T);
         First     : Integer renames Firsts (T);
         Last      : Integer renames Lasts (T);
         Fifo_Size : Integer renames Thread_Fifo_Sizes (T);
         P_Kind    : Port_Kind renames Thread_Port_Kinds (T);
         Offset    : Integer renames Thread_Fifo_Offsets (T);
      begin
         --  This subprogram is called only when the thread has IN
         --  ports.

         pragma Assert (Is_In (P_Kind));

         if Is_Empty then
            --  If the FIFO is empty, return the latest received value
            --  during the previous dispatches.

            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Dequeue: Empty queue for "
                           + Thread_Port_Images (T)));

            P := Get_Most_Recent_Value (T);

         elsif Fifo_Size = 0 then
            --  If the FIFO is empty or non-existent, return the
            --  latest received value during the previous dispatches.

            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Dequeue: NO FIFO for "
                           + Thread_Port_Images (T)));

            P := Get_Most_Recent_Value (T);

         else
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Dequeue: dequeuing "
                           + Thread_Port_Images (T)));

            if First = Last then
               --  Update the value of N_Empties only when this is the
               --  first time we mark the partial queue as empty.

               if not Is_Empty and then Is_Event (P_Kind) then
                  N_Empties := N_Empties + 1;
               end if;

               Is_Empty := True;
            end if;

            P := Global_Data_Queue (First + Offset - 1);

            if First = Fifo_Size then
               First := 1;
            elsif Fifo_Size > 1 then
               First := First + 1;
            end if;

            --  Shift the First index of the global history queue

            H_Increment_First (GH_First);
         end if;

         --  Update the barrier

         Not_Empty := N_Empties < N_Ports;
      end Dequeue;

      -------------
      -- Read_In --
      -------------

      function Read_In (T : Port_Type) return Port_Stream_Entry is
         P         : Port_Stream_Entry;
         Is_Empty  : Boolean renames Empties (T);
         First     : Integer renames Firsts (T);
         Fifo_Size : Integer renames Thread_Fifo_Sizes (T);
         Offset    : Integer renames Thread_Fifo_Offsets (T);
         P_Kind    : Port_Kind renames Thread_Port_Kinds (T);
      begin
         --  This subprogram is called only when the thread has IN
         --  ports.

         pragma Assert (Is_In (P_Kind));

         if Is_Empty or else Fifo_Size = 0 then
            --  If the FIFO is empty or non-existent return the
            --  latest received value during the previous dispatches.

            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Read_In: Empty queue for port "
                           + Thread_Port_Images (T)
                           + ". Reading the last stored value."));

            P := Get_Most_Recent_Value (T);
         else
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Read_In: Reading the oldest element in the"
                           + " queue of port  "
                           + Thread_Port_Images (T)));

            P := Global_Data_Queue (First + Offset - 1);
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Read_In: Global reading position: "
                           + Integer'Image (First + Offset - 1)));
         end if;

         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Read_In: Value read from port "
                        + Thread_Port_Images (T)));
         return P;
      end Read_In;

      --------------
      -- Read_Out --
      --------------

      function Read_Out (T : Port_Type) return Port_Stream_Entry is
      begin
         --  There is no need here to go through the Get_ routine
         --  since we are sending, not receiving.

         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Read_Out: Value read from port "
                        + Thread_Port_Images (T)));

         return Most_Recent_Values (T);
      end Read_Out;

      ----------------
      -- Is_Invalid --
      ----------------

      function Is_Invalid (T : Port_Type) return Boolean is
      begin
         return not (Value_Put (T));
      end Is_Invalid;

      -----------------
      -- Set_Invalid --
      -----------------

      procedure Set_Invalid (T : Port_Type) is
      begin
         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Set_Invalid: Setting INVALID for sending: port "
                        + Thread_Port_Images (T)));

         Value_Put (T) := False;
      end Set_Invalid;

      --------------
      -- Store_In --
      --------------

      procedure Store_In (P : Port_Stream_Entry; T : Time) is
         Thread_Interface : constant Thread_Interface_Type
           := Stream_To_Interface (P.Payload);
         PT                : Port_Type renames Thread_Interface.Port;
         Is_Empty          : Boolean   renames Empties (PT);
         First             : Integer   renames Firsts (PT);
         Last              : Integer   renames Lasts (PT);
         P_Kind            : Port_Kind renames Thread_Port_Kinds (PT);
         Fifo_Size         : Integer   renames Thread_Fifo_Sizes (PT);
         Offset            : Integer   renames Thread_Fifo_Offsets (PT);
         Urgency           : Integer   renames Urgencies (PT);
         Overflow_Protocol : Overflow_Handling_Protocol
           renames Thread_Overflow_Protocols (PT);
         Replace           : Boolean := False;
      begin
         --  This subprogram is called only when the thread has IN
         --  ports.

         pragma Assert (Is_In (P_Kind));

         --  Set PT as initialized

         Initialized (PT) := True;

         if Has_Event_Ports then
            if Is_Event (P_Kind) then
               --  If the FIFO is full apply the overflow-policy
               --  indicated by the user.

               if Fifo_Size > 0 then
                  if not Is_Empty
                    and then (Last = First - 1
                                or else (First = 1 and then Last = Fifo_Size))
                  then
                     declare
                        Frst : Integer;
                        GDH : Big_Port_Type_Array renames Global_Data_History;
                     begin
                        case Overflow_Protocol is
                           when DropOldest =>
                              --  Drop the oldest element in the FIFO

                              Global_Data_Queue (First + Offset - 1) := P;
                              pragma Debug
                                (Put_Line
                                 (Verbose,
                                  CE
                                  + ": Store_In: FIFO is full."
                                  + " Dropping oldest element."
                                  + " Global storage position: "
                                  + Integer'Image (First + Offset - 1)));

                              Last := First;

                              if First = Fifo_Size then
                                 First := 1;
                              elsif Fifo_Size > 1 then
                                 First := First + 1;
                              end if;

                              --  Search the oldest element in the history

                              Frst := GH_First;
                              loop
                                 if GDH (Frst) = PT then
                                    exit;
                                 end if;
                                 Frst := Frst + 1;
                                 if Frst > Global_Data_Queue_Size then
                                    exit;
                                 end if;
                              end loop;

                              if Frst > Global_Data_Queue_Size then
                        --  Second configuration, We have only
                        --  searched from GH_First to Queue_Size,
                        --  continue from the beginning to GH_Last.

                        --  ---------------------------------------------
                        --  |xxxxxxxxx|x|               |x|xxxxxxxxxxxxx|
                        --  ---------------------------------------------
                        --   1         GH_Last          GH_First    Queue_Size
                                 Frst := 1;
                                 loop
                                    exit when GDH (Frst) = PT;
                                    Frst := Frst + 1;
                                 end loop;
                              end if;

                           when DropNewest =>
                              --  Drop the newest element in the FIFO

                              Global_Data_Queue (Last + Offset - 1) := P;
                              pragma Debug
                                (Put_Line
                                 (Verbose,
                                  CE
                                  + ": Store_In: FIFO is full."
                                  + " Dropping newest element"
                                  + " Global storage position: "
                                  + Integer'Image (Last + Offset - 1)));

                              --  Search the newest element in the history

                              Frst := GH_Last;
                              loop
                                 if GDH (Frst) = PT then
                                    exit;
                                 end if;
                                 Frst := Frst - 1;
                                 if Frst < 1 then
                                    exit;
                                 end if;
                              end loop;

                              if Frst < 1 then
                                 --  Continue the search from the end
                                 Frst := Global_Data_Queue_Size;
                                 loop
                                    exit when GDH (Frst) = PT;
                                    Frst := Frst - 1;
                                 end loop;
                              end if;
                           when Error =>
                              raise Program_Error with
                                CE + ": Store_In: FIFO is full";
                        end case;

                        --  Remove event in the history and shift
                        --  others with the same urgency

                        pragma Debug
                          (Put_Line
                           (Verbose,
                            CE
                              + ": Store_In: FIFO is full."
                              + " Removed element in history at"
                              + Integer'Image (Frst)));

                        loop
                           exit when Frst = Global_Data_Queue_Size
                             or else Urgencies (GDH (Frst)) < Urgency;
                           GDH (Frst) := GDH (Frst + 1);
                           Frst := Frst + 1;
                        end loop;

                        if Frst = Global_Data_Queue_Size
                          and then Urgencies (GDH (Frst)) < Urgency then
                           --  Continue suppressing from the beginning
                           Frst := 1;
                           GDH (Global_Data_Queue_Size) := GDH (Frst);
                           loop
                              exit when Urgencies (GDH (Frst)) < Urgency;
                              GDH (Frst) := GDH (Frst + 1);
                              Frst := Frst + 1;
                           end loop;
                        end if;
                     end;
                     Replace := True;
                  else
                     --  Update the value of N_Empties only when this is the
                     --  first time we mark the partial queue as NOT empty.

                     if Is_Empty then
                        N_Empties := N_Empties - 1;
                     end if;

                     Is_Empty := False;

                     if Last = Fifo_Size then
                        Last := 1;
                     else
                        Last := Last + 1;
                     end if;

                     Global_Data_Queue (Last + Offset - 1) := P;
                     pragma Debug (Put_Line
                                   (Verbose,
                                    CE
                                      + ": Store_In: Global storage position: "
                                      + Integer'Image (Last + Offset - 1)));

                  end if;

                  --  Update the oldest updated port value
                  declare
                     Frst : Integer := GH_Last;
                     Lst  : constant Integer := GH_Last;
                     GDH  : Big_Port_Type_Array renames Global_Data_History;
                  begin

                     --  Add an entry in the history
                     if not Replace then
                        H_Increment_Last (GH_Last);
                     end if;

                     if GH_First /= GH_Last then
                        --  Search the first entry with a higher urgency
                        --  and shift other entries
                        if Frst = Global_Data_Queue_Size
                          and then Urgencies (GDH (Frst)) < Urgency then
                           GDH (GH_Last) := GDH (Frst);
                           Frst := Frst - 1;
                        end if;
                        loop
                           if Urgencies (GDH (Frst)) >= Urgency then
                              exit;
                           end if;
                           GDH (Frst + 1) := GDH (Frst);
                           Frst := Frst - 1;
                           exit when (GH_First <= Lst
                                        and then Frst < GH_First)
                             or else Frst < 1;
                        end loop;

                        if Frst < 1 and then GH_First > Lst then
                           --  Continue the search from the end
                           Frst := Global_Data_Queue_Size;
                           if Urgencies (GDH (Frst)) < Urgency then
                              GDH (1 mod GDH'Length) := GDH (Frst);
                              Frst := Frst - 1;
                              loop
                                 if Urgencies (GDH (Frst)) >= Urgency then
                                    exit;
                                 end if;
                                 GDH (Frst + 1) := GDH (Frst);
                                 Frst := Frst - 1;
                                 exit when Frst < GH_First;
                              end loop;
                           end if;
                        end if;
                     end if;

                     --  Insert the port of the event
                     if Frst = Global_Data_Queue_Size then
                        GDH (1 mod GDH'Size) := PT;
                        --  The modulo avoids warning when accessing
                        --  GDH (1) while Queue_Size = 0
                        pragma Debug (Put_Line
                                      (Verbose,
                                       CE
                                         + ": Store_In: Insert event"
                                         + " in history at: "
                                         + Integer'Image (1)));
                     else
                        GDH (Frst + 1) := PT;
                        pragma Debug (Put_Line
                                      (Verbose,
                                       CE
                                         + ": Store_In: Insert event"
                                         + " in history at: "
                                         + Integer'Image (Frst + 1)));
                     end if;
                  end;

               end if;

               --  Update the most recent value corresponding to port PT

               Set_Most_Recent_Value (PT, P, T);

               pragma Debug (Put_Line
                             (Verbose,
                              CE
                                + ": Store_In: Enqueued Event [Data] message"
                                + " for port "
                                + Thread_Port_Images (PT)));

               --  Update the barrier

               Not_Empty := True;
            end if;
         end if;

         --  If this is a data port, we only override the
         --  Most_Recent_Value corresponding to the port.

         if not Is_Event (P_Kind) then
            pragma Debug (Put_Line
                            (Verbose,
                             CE
                             + ": Store_In: Storing Data message in DATA port "
                             + Thread_Port_Images (PT)));

            Set_Most_Recent_Value (PT, P, T);

            pragma Debug (Put_Line
                            (Verbose,
                             CE
                             + ": Store_In: Stored Data message in DATA port "
                             + Thread_Port_Images (PT)));

         end if;
      end Store_In;

      ---------------
      -- Store_Out --
      ---------------

      procedure Store_Out (P : Port_Stream_Entry; T : Time) is
         Thread_Interface : constant Thread_Interface_Type
           := Stream_To_Interface (P.Payload);
         PT               : Port_Type renames Thread_Interface.Port;
      begin
         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Store_Out: Storing value for sending: port "
                        + Thread_Port_Images (PT)));

         --  Mark as valid for sending

         Value_Put (PT) := True;

         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Store_Out: Value stored for sending: port "
                        + Thread_Port_Images (PT)));

         --  No need to go through the Set_ routine since we are
         --  sending, not receiving.

         Most_Recent_Values (PT) := P;
         Time_Stamps (PT) := T; -- overwritten below
         --  Maxime workaround for backdoor accesses
         Time_Stamps (PT) := Ada.Real_time.clock;

      end Store_Out;

      -----------
      -- Count --
      -----------

      function Count (T : Port_Type) return Integer is
         Is_Empty  : Boolean renames Empties (T);
         First     : Integer renames Firsts (T);
         Last      : Integer renames Lasts (T);
         P_Kind    : Port_Kind renames Thread_Port_Kinds (T);
         Fifo_Size : Integer renames Thread_Fifo_Sizes (T);
      begin
         --  This subprogram is called only when the thread has IN
         --  ports.

         pragma Assert (Is_In (P_Kind));

         if not Initialized (T) then
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Count: Not initialized port: "
                           + Thread_Port_Images (T)));

            return -1;
         elsif Is_Empty then
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Count: Empty FIFO for port "
                           + Thread_Port_Images (T)));

            return 0;
         elsif Fifo_Size = 0 then
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Count: No FIFO for port "
                           + Thread_Port_Images (T)));

            return 0;
         else
            pragma Debug (Put_Line
                          (Verbose,
                           CE
                           + ": Count: FIFO exists for port "
                           + Thread_Port_Images (T)));

            if Last >= First then
               --  First configuration

               --  -------------------------------------------------------
               --  |         |x|xxxxxxxxxxxxxxxxxxxxxxxxx|x|             |
               --  -------------------------------------------------------
               --            First                       Last

               return Last - First + 1;
            else
               --  Second configuration

               --  -------------------------------------------------------
               --  |xxxxxxxxx|x|                         |x|xxxxxxxxxxxxx|
               --  -------------------------------------------------------
               --            Last                        First

               return Fifo_Size - First + Last + 1;
            end if;
         end if;
      end Count;

      ---------------------------
      -- Get_Most_Recent_Value --
      ---------------------------

      function Get_Most_Recent_Value
        (P : Port_Type)
        return Port_Stream_Entry
      is
         First     : Integer renames Firsts (P);
         Last      : Integer renames Lasts (P);
         P_Kind    : Port_Kind renames Thread_Port_Kinds (P);
         Fifo_Size : Integer renames Thread_Fifo_Sizes (P);
         Offset    : Integer renames Thread_Fifo_Offsets (P);
         T         : constant Time := Clock;
         S         : Port_Stream_Entry;
      begin
         if Has_Event_Ports then
            if Is_Event (P_Kind) then
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                     + ": Get_Most_Recent_Value: event [data] port "
                     + Thread_Port_Images (P)));

               S := Most_Recent_Values (P);
            end if;
         end if;
         if not Is_Event (P_Kind) then
            if Fifo_Size = 1 then
               --  Immediate connection

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: data port "
                   + Thread_Port_Images (P)
                   + ". Immediate connection"));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: First  ="
                   + Integer'Image (First)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Last  = "
                   + Integer'Image (Last)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Offset = "
                   + Integer'Image (Offset)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Global_Data_Queue_Size = "
                   + Integer'Image (Global_Data_Queue_Size)));

               S :=  Global_Data_Queue (First + Offset - 1);

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Most recent value for"
                   + " data port "
                   + Thread_Port_Images (P)
                   + " got. Immediate connection"));
            else
               --  Delayed connection: The element indexed by First is
               --  the oldest element and the element indexed by Last
               --  is the most recent element.

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: data port "
                   + Thread_Port_Images (P)
                   + ". Delayed connection"));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: First  = "
                   + Integer'Image (First)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Last  = "
                   + Integer'Image (Last)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   " Offset = " + Integer'Image (Offset)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Global_Data_Queue_Size = "
                   + Integer'Image (Global_Data_Queue_Size)));

               if Time_Stamps (P) <= T then
                  pragma Debug
                    (Put_Line
                     (Verbose,
                      CE + ": Get_Most_Recent_Value: Getting NEW value"));

                  S := Global_Data_Queue (Last + Offset - 1);
               else
                  pragma Debug
                    (Put_Line
                     (Verbose,
                      CE + ": Get_Most_Recent_Value: Getting OLD value"));

                  S := Global_Data_Queue (First + Offset - 1);
               end if;

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Get_Most_Recent_Value: Most recent value"
                   + " for data port "
                   + Thread_Port_Images (P)
                   + " got. Delayed connection"));
            end if;
         end if;

         return S;
      end Get_Most_Recent_Value;

      ---------------------------
      -- Set_Most_Recent_Value --
      ---------------------------

      procedure Set_Most_Recent_Value
        (P : Port_Type;
         S : Port_Stream_Entry;
         T : Time)
      is
         First     : Integer renames Firsts (P);
         Last      : Integer renames Lasts (P);
         P_Kind    : Port_Kind renames Thread_Port_Kinds (P);
         Fifo_Size : Integer renames Thread_Fifo_Sizes (P);
         Offset    : Integer renames Thread_Fifo_Offsets (P);
      begin
         if Has_Event_Ports then
            if Is_Event (P_Kind) then
               pragma Debug (Put_Line
                             (Verbose,
                              CE
                                + ": Set_Most_Recent_Value: event [data] port "
                                + Thread_Port_Images (P)));

               Most_Recent_Values (P) := S;

               pragma Debug (Put_Line
                             (Verbose,
                              CE
                                + ": Set_Most_Recent_Value: event [data] port "
                                + Thread_Port_Images (P)
                                + ". Done."));
            end if;
         end if;
         if not Is_Event (P_Kind) then
            Time_Stamps (P) := T;

            if Fifo_Size = 1 then
               --  Immediate connection

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: data port "
                   + Thread_Port_Images (P)
                   + ". Immediate connection"));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: First  ="
                   + Integer'Image (First)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Last  = "
                   + Integer'Image (Last)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Offset = "
                   + Integer'Image (Offset)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Global_Data_Queue_Size = "
                   + Integer'Image (Global_Data_Queue_Size)));

               Global_Data_Queue (First + Offset - 1) := S;

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Most recent value"
                   + " for data port "
                   + Thread_Port_Images (P)
                   + " set. Immediate connection"));
            else
               --  Delayed connection: The element indexed by First must be
               --  the oldest element and the element indexed by Last
               --  is the most recent element.

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: data port "
                   + Thread_Port_Images (P)
                   + ". Delayed connection"));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: First  = "
                   + Integer'Image (First)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Last  = "
                   + Integer'Image (Last)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   " Offset = " + Integer'Image (Offset)));
               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Global_Data_Queue_Size = "
                   + Integer'Image (Global_Data_Queue_Size)));

               Global_Data_Queue (First + Offset - 1) :=
                 Global_Data_Queue (Last + Offset - 1);
               Global_Data_Queue (Last + Offset - 1)  := S;

               pragma Debug
                 (Put_Line
                  (Verbose,
                   CE
                   + ": Set_Most_Recent_Value: Most recent value"
                   + " for data port "
                   + Thread_Port_Images (P)
                   + " set. Delayed connection"));
            end if;
         end if;
      end Set_Most_Recent_Value;

      --------------------
      -- Get_Time_Stamp --
      --------------------

      function Get_Time_Stamp (P : Port_Type) return Time is
      begin
         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Get_Time_Stamp: port "
                        + Thread_Port_Images (P)));

         return Time_Stamps (P);
      end Get_Time_Stamp;

   end Global_Queue;

   -----------------
   -- Send_Output --
   -----------------

   function Send_Output (Port : Port_Type) return Error_Kind is

      type Port_Type_Array is array (Positive)
        of PolyORB_HI_Generated.Deployment.Port_Type;
      type Port_Type_Array_Access is access Port_Type_Array;

      function To_Pointer is new Ada.Unchecked_Conversion
        (System.Address, Port_Type_Array_Access);

      Dst       : constant Port_Type_Array_Access :=
        To_Pointer (Destinations (Port));
      N_Dst     : Integer renames N_Destinations (Port);
      P_Kind    : Port_Kind renames Thread_Port_Kinds (Port);

      Message   : aliased PolyORB_HI.Messages.Message_Type;
      Value     : constant Thread_Interface_Type := Stream_To_Interface
        (Global_Queue.Read_Out (Port).Payload);

      Error : Error_Kind := Error_None;
   begin
      pragma Debug (Put_Line (Verbose,
                              CE
                              + ": Send_Output: port "
                              + Thread_Port_Images (Port)));

      --  If no valid value is to be sent, quit

      if Global_Queue.Is_Invalid (Port) then
         pragma Debug (Put_Line (Verbose,
                                 CE
                                 + ": Send_Output: Invalid value in port "
                                 + Thread_Port_Images (Port)));
         null;
      else
         --  Mark the port value as invalid to impede future sendings

         Global_Queue.Set_Invalid (Port);

         --  Begin the sending to all destinations

         for To in 1 .. N_Dst loop
            --  First, we marshall the destination

            Port_Type_Marshallers.Marshall
              (Internal_Code (Dst (To)), Message);

            --  Then marshall the time stamp in case of a data port

            if not Is_Event (P_Kind) then
               Time_Marshallers.Marshall
                 (Global_Queue.Get_Time_Stamp (Port),
                  Message);
            end if;

            --  Then we marshall the value corresponding to the port

            Marshall (Value, Message);

            pragma Debug
              (Put_Line
               (Verbose,
                CE
                + ": Send_Output: to port "
                + PolyORB_HI_Generated.Deployment.Port_Image (Dst (To))
                + " of "
                + Entity_Image (Port_Table (Dst (To)))));

            Error := Protocols.Send (Current_Entity,
                                     Port_Table (Dst (To)),
                                     Message);

            PolyORB_HI.Messages.Reallocate (Message);

            if Error /= Error_None then
               return Error;
            end if;
         end loop;

         pragma Debug (Put_Line (Verbose,
                                 CE
                                 + ": Send_Output: port "
                                 + Thread_Port_Images (Port)
                                 + ". End."));
      end if;

      return Error;
   end Send_Output;

   ---------------
   -- Put_Value --
   ---------------

   procedure Put_Value (Thread_Interface : Thread_Interface_Type) is
   begin
      pragma Debug (Put_Line (Verbose, CE + ": Put_Value"));

      Global_Queue.Store_Out
        ((Current_Entity, Interface_To_Stream (Thread_Interface)),
         Next_Deadline);
   end Put_Value;

   -------------------
   -- Receive_Input --
   -------------------

   procedure Receive_Input (Port : Port_Type) is
      pragma Unreferenced (Port);
   begin
      raise Program_Error with CE + ": Receive_Input: Not implemented yet";
   end Receive_Input;

   ---------------
   -- Get_Value --
   ---------------

   function Get_Value (Port : Port_Type) return Thread_Interface_Type is
      Stream : constant Port_Stream := Global_Queue.Read_In (Port).Payload;
      T_Port : constant Thread_Interface_Type := Stream_To_Interface (Stream);
   begin
      pragma Debug (Put_Line
                    (Verbose,
                     CE
                     + ": Get_Value: Value of port "
                     + Thread_Port_Images (Port)
                     + " got"));
      return T_Port;
   end Get_Value;

   ----------------
   -- Get_Sender --
   ----------------

   function Get_Sender (Port : Port_Type) return Entity_Type is
      Sender : constant Entity_Type := Global_Queue.Read_In (Port).From;
   begin
      pragma Debug (Put_Line
                    (Verbose,
                     CE
                     + ": Get_Sender: Value of sender to port "
                     + Thread_Port_Images (Port)
                     + " = "
                     + Entity_Image (Sender)));
      return Sender;
   end Get_Sender;

   ---------------
   -- Get_Count --
   ---------------

   function Get_Count (Port : Port_Type) return Integer is
      Count : constant Integer := Global_Queue.Count (Port);
   begin
      pragma Debug (Put_Line (Verbose,
                              CE
                              + ": Get_Count: port "
                              + Thread_Port_Images (Port)
                              + " ="
                              + Integer'Image (Count)));

      return Count;
   end Get_Count;

   ----------------
   -- Next_Value --
   ----------------

   procedure Next_Value (Port : Port_Type) is
      P : Port_Stream_Entry;
   begin
      pragma Debug (Put_Line (Verbose,
                              CE
                              + ": Next_Value for port "
                              + Thread_Port_Images (Port)));

      Global_Queue.Dequeue (Port, P);
   end Next_Value;

   ------------------------------
   -- Wait_For_Incoming_Events --
   ------------------------------

   procedure Wait_For_Incoming_Events (Port : out Port_Type) is
   begin
      pragma Debug (Put_Line (Verbose, CE + ": Wait_For_Incoming_Events"));

      Global_Queue.Wait_Event (Port);

      pragma Debug (Put_Line
                    (Verbose,
                     CE
                     + ": Wait_For_Incoming_Events: reception of"
                     + " event [Data] message on port "
                     + Thread_Port_Images (Port)));
   end Wait_For_Incoming_Events;

   --------------------
   -- Get_Next_Event --
   --------------------

   procedure Get_Next_Event (Port : out Port_Type; Valid : out Boolean) is
   begin
      Global_Queue.Read_Event (Port, Valid);

      if Valid then
         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Get_Next_Event: read event [data] message"
                        + " for port "
                        + Thread_Port_Images (Port)));
         null;
      else
         pragma Debug (Put_Line
                       (Verbose,
                        CE
                        + ": Get_Next_Event: Nothing to read."));
         null;
      end if;
   end Get_Next_Event;

   ----------------------------
   -- Store_Received_Message --
   ----------------------------

   procedure Store_Received_Message
     (Thread_Interface : Thread_Interface_Type;
      From             : Entity_Type;
      Time_Stamp       : Ada.Real_Time.Time    := Ada.Real_Time.Clock)
   is
   begin
      pragma Debug (Put_Line (Verbose, CE + ": Store_Received_Message"));

      Global_Queue.Store_In
        ((From, Interface_To_Stream (Thread_Interface)), Time_Stamp);
   end Store_Received_Message;

   --------------------
   -- Get_Time_Stamp --
   --------------------

   function Get_Time_Stamp (P : Port_Type) return Time is
   begin
      return Global_Queue.Get_Time_Stamp (P);
   end Get_Time_Stamp;

   -----------------------
   -- H_Increment_First --
   -----------------------

   procedure H_Increment_First (F : in out Integer) is
   begin
      F := F + 1;

      if F > Global_Data_Queue_Size then
         F := 1;
      end if;

      pragma Debug (Put_Line
                    (Verbose,
                     CE
                     + ": H_Increment_First: F ="
                     + Integer'Image (F)));
   end H_Increment_First;

   ----------------------
   -- H_Increment_Last --
   ----------------------

   procedure H_Increment_Last (L : in out Integer) is
   begin
      L := L + 1;

      if L > Global_Data_Queue_Size then
         L := 1;
      end if;

      pragma Debug (Put_Line
                    (Verbose,
                     CE
                     + ": H_Increment_Last: L ="
                     + Integer'Image (L)));
   end H_Increment_Last;

   --------
   -- CE --
   --------

   function CE return String is
   begin
      return Entity_Image (Current_Entity);
   end CE;

end PolyORB_HI.Thread_Interrogators;
