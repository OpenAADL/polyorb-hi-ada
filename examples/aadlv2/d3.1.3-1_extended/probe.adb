------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                                P R O B E                                 --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2009, GET-Telecom Paris.                   --
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
--                PolyORB HI is maintained by GET Telecom Paris             --
--                                                                          --
------------------------------------------------------------------------------

--  $Id: probe.adb 6273 2009-03-25 17:36:51Z lasnier $

with Ada.Real_Time; use Ada.Real_Time;

with PolyORB_HI.Output;

package body Probe is

   use PolyORB_HI.Output;

   --  Variables used for the thread identities resoving

   GNC_Welcome  : Boolean := True;
   TMTC_Welcome : Boolean := True;

   --  At elaboration time, this package evaluate the number of fixed
   --  point operation 1.0 / X to consume CPU during 1 millisecond.

   --  We use fixed point types to be compliant with restrictions for
   --  HIgh-Integrity systems (pragma Restriction No_Float).

   type Fixed_12_6 is delta 1.0E-6 digits 12;

   N_Base : constant Natural     := 1_000;
   F_Base : constant Fixed_12_6  := 1.0001;

   --  XMS or X Milli Seconds
   XMS    : constant Time_Span := Milliseconds (1);
   N_XMS  : Natural; --  Is computed at elaboration time

   procedure Compute_During_N_Times_1ms (N : Natural);
   --  Consume CPU during N * 1 Millisecond

   --------------------------------
   -- Compute_During_N_Times_1ms --
   --------------------------------

   procedure Compute_During_N_Times_1ms (N : Natural) is
      X : Fixed_12_6 := F_Base;
   begin
      for I in 1 .. N_XMS * N loop
         X := 1.0 / X;
      end loop;
   end Compute_During_N_Times_1ms;

   ----------
   -- Read --
   ----------

   procedure Read
     (Read_Value :    out POS_Internal_Type;
      Field      : in out POS_Internal_Type)
   is
      pragma Warnings (Off, Field);
      --  To kill warning "mode could be "in" instead of "in out"
   begin
      Read_Value := Field;
      Put_Line (Normal, "Value Read: " & POS_Internal_Type'Image (Field));
   end Read;

   ------------
   -- Update --
   ------------

   procedure Update (Field : in out POS_Internal_Type) is
   begin
      Field := Field + 1;
      Put_Line (Normal, "Value Updated: " & POS_Internal_Type'Image (Field));
   end Update;

   -------------
   -- GNC_Job --
   -------------

   procedure GNC_Job is
   begin
      Put_Line (Normal, "Begin computing: GNC");
      Compute_During_N_Times_1ms (600);
      Put_Line (Normal, "End computing: GNC");
   end GNC_Job;

   --------------
   -- TMTC_Job --
   --------------

   procedure TMTC_Job is
   begin
      Put_Line (Normal, "Begin computing: TMTC");
      Compute_During_N_Times_1ms (50);
      Put_Line (Normal, "End computing: TMTC");
   end TMTC_Job;

   ------------------
   -- GNC_Identity --
   ------------------

   procedure GNC_Identity is
   begin
      if GNC_Welcome then
         Put_Line (Normal, "Welcome GNC!");
      else
         Put_Line (Normal, "Good bye GNC!");
      end if;

      GNC_Welcome := not GNC_Welcome;
   end GNC_Identity;

   -------------------
   -- TMTC_Identity --
   -------------------

   procedure TMTC_Identity is
   begin
      if TMTC_Welcome then
         Put_Line (Normal, "Welcome TMTC!");
      else
         Put_Line (Normal, "Good bye TMTC!");
      end if;

      TMTC_Welcome := not TMTC_Welcome;
   end TMTC_Identity;

   --------------
   -- Send_Spg --
   --------------

   procedure Send_Spg
     (Sent_Data   :     POS_Internal_Type;
      Data_Source : out POS_Internal_Type)
   is
   begin
      Data_Source := Sent_Data;
      Put_Line (Normal, "Sending Data"
                & POS_Internal_Type'Image (Data_Source));
   end Send_Spg;

   -----------------
   -- Receive_Spg --
   -----------------

   procedure Receive_Spg (Data_Sink : POS_Internal_Type) is
   begin
      Put_Line (Normal, "*** RECEIVED DATA ***"
                & POS_Internal_Type'Image (Data_Sink));
   end Receive_Spg;

begin
   declare
      B : Time;
      --  Begin of the measure

      E : Time;
      --  End od the measure

      X : Fixed_12_6 := F_Base;
   begin

      --  Measure N_Base times the same operation 1/X

      B := Clock;
      for I in 1 .. N_Base loop
         X := 1.0 / X;
      end loop;
      E := Clock;

      --  Calculate the number of operation necessary to consume CPU
      --  during 1 sec.

      N_XMS := Natural ((XMS * N_Base) / (E - B));

      --  Redo the measure to obtain a more precise N_XMS value

      B := Clock;
      for I in 1 .. N_XMS loop
         X := 1.0 / X;
      end loop;
      E := Clock;
      N_XMS := Natural ((XMS * N_XMS) / (E - B));
   end;
end Probe;
