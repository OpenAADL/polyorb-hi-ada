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
with PolyORB_HI.Unprotected_Queue;

package body PolyORB_HI.Thread_Interrogators is

   use type PolyORB_HI.Streams.Stream_Element_Offset;
   use PolyORB_HI.Port_Kinds;
   use Ada.Real_Time;
   use PolyORB_HI_Generated.Deployment;
   use PolyORB_HI.Output;
   use PolyORB_HI.Utils;

   --------
   -- UQ --
   --------

   package UQ is new PolyORB_HI.Unprotected_Queue
     (Port_Type,
      Integer_Array,
      Port_Kind_Array,
      Port_Image_Array,
      Overflow_Protocol_Array,
      Thread_Interface_Type,
      Current_Entity,
      Thread_Port_Kinds,
      Has_Event_Ports,
      Thread_Port_Images,
      Thread_Fifo_Sizes,
      Thread_Fifo_Offsets,
      Thread_Overflow_Protocols,
      Urgencies,
      Global_Data_Queue_Size);
   use UQ;

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

        Message   : PolyORB_HI.Messages.Message_Type;
        Value     : constant Thread_Interface_Type := Stream_To_Interface
          (UQ.Read_Out (Port).Payload);

      Error : Error_Kind := Error_None;
   begin
      pragma Debug (Put_Line (Verbose,
                              CE
                                + ": Send_Output: port "
                                + Thread_Port_Images (Port)));

      --  If no valid value is to be sent, quit

      if UQ.Is_Invalid (Port) then
         pragma Debug (Put_Line (Verbose,
                                 CE
                                   + ": Send_Output: Invalid value in port "
                                   + Thread_Port_Images (Port)));
         null;
      else
         --  Mark the port value as invalid to impede future sendings

         UQ.Set_Invalid (Port);

         --  Begin the sending to all destinations

         for To in 1 .. N_Dst loop
            --  First, we marshall the destination

            Port_Type_Marshallers.Marshall
              (Internal_Code (Dst (To)), Message);

            --  Then marshall the time stamp in case of a data port

            if not Is_Event (P_Kind) then
               Time_Marshallers.Marshall
                 (UQ.Get_Time_Stamp (Port),
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

      UQ.Store_Out
        ((Current_Entity, Interface_To_Stream (Thread_Interface)),
         Next_Deadline);
   end Put_Value;

   -------------------
   -- Receive_Input --
   -------------------

   procedure Receive_Input (Port : Port_Type) is
      pragma Unreferenced (Port);
   begin
      null; -- XXX Cannot raise an exception here
   end Receive_Input;

   ---------------
   -- Get_Value --
   ---------------

   function Get_Value (Port : Port_Type) return Thread_Interface_Type is
      Stream : constant Port_Stream := UQ.Read_In (Port).Payload;
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
      Sender : constant Entity_Type := UQ.Read_In (Port).From;
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
      Count : constant Integer := UQ.Count (Port);
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
      Not_Empty : Boolean;
   begin
      pragma Debug (Put_Line (Verbose,
                              CE
                              + ": Next_Value for port "
                              + Thread_Port_Images (Port)));

      UQ.Dequeue (Port, P, Not_Empty);
   end Next_Value;

   ------------------------------
   -- Wait_For_Incoming_Events --
   ------------------------------

   procedure Wait_For_Incoming_Events (Port : out Port_Type) is
      Valid, Not_Empty : Boolean;
      pragma Warnings (Off, Not_Empty);
      --  Under this implementation, Not_Empty is not used.

   begin
      pragma Debug (Put_Line (Verbose, CE + ": Wait_For_Incoming_Events"));

      UQ.Read_Event (Port, Valid, Not_Empty);

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
      Not_Empty : Boolean;
      pragma Warnings (Off, Not_Empty);
      --  Under this implementation, Not_Empty is not used.
   begin
      UQ.Read_Event (Port, Valid, Not_Empty);

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
      Not_Empty : Boolean;
      pragma Unreferenced (Not_Empty);
   begin
      pragma Debug (Put_Line (Verbose, CE + ": Store_Received_Message"));

      UQ.Store_In
        ((From, Interface_To_Stream (Thread_Interface)), Time_Stamp, Not_Empty);
   end Store_Received_Message;

   --------------------
   -- Get_Time_Stamp --
   --------------------

   function Get_Time_Stamp (P : Port_Type) return Time is
   begin
      return UQ.Get_Time_Stamp (P);
   end Get_Time_Stamp;

end PolyORB_HI.Thread_Interrogators;
