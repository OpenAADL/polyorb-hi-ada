------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                    P O L Y O R B _ H I . O U T P U T                     --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2006-2009, GET-Telecom Paris.                --
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

with PolyORB_HI.Output_Low_Level;
with PolyORB_HI.Suspenders;
with Ada.Real_Time;
with System;

package body PolyORB_HI.Output is
   use Ada.Real_Time;

   protected Lock is
      procedure Put (Text : in String);
      --  To guarantee thread-safe output display

      procedure Put_Line (Text : in String);
      --  To guarantee thread-safe output display

   private
      pragma Priority (System.Priority'Last);
   end Lock;

   protected body Lock is

      --------------
      -- Put_Line --
      --------------

      procedure Put_Line (Text : in String) is
      begin
         Unprotected_Put_Line (Text);
      end Put_Line;

      ---------
      -- Put --
      ---------

      procedure Put (Text : in String) is
      begin
         Unprotected_Put (Text);
      end Put;
   end Lock;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line (Mode : in Verbosity := Normal; Text : in String) is
   begin
      pragma Warnings (Off);
      --  Disable warnings on "Condition always true/false" because
      --  Current_Mode is a constant.

      if Mode >= Current_Mode then
         pragma Warnings (On);
         Put_Line (Text);
      end if;

   end Put_Line;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line (Text : in String) is
   begin
      Lock.Put_Line (Text);
   end Put_Line;

   ---------
   -- Put --
   ---------

   procedure Put (Mode : in Verbosity := Normal; Text : in String) is
   begin
      pragma Warnings (Off);
      --  Disable warnings on "Condition always true/false" because
      --  Current_Mode is a constant.

      if Mode >= Current_Mode then
         pragma Warnings (On);
         Put (Text);
      end if;

   end Put;

   ---------
   -- Put --
   ---------

   procedure Put (Text : in String) is
   begin
      Lock.Put (Text);
   end Put;

   --------------------------
   -- Unprotected_Put_Line --
   --------------------------

   procedure Unprotected_Put_Line (Text : in String) is
   begin
      Unprotected_Put (Text);
      PolyORB_HI.Output_Low_Level.New_Line;
   end Unprotected_Put_Line;

   ---------------------
   -- Unprotected_Put --
   ---------------------

   procedure Unprotected_Put (Text : in String) is
      Start_Time : Time renames  PolyORB_HI.Suspenders.System_Startup_Time;
      Elapsed    : Time_Span;
   begin
      if Start_Time = Time_First then
         Elapsed := To_Time_Span (0.0);
      else
         Elapsed := Clock - Start_Time;
      end if;

      PolyORB_HI.Output_Low_Level.Put ("[");
      PolyORB_HI.Output_Low_Level.Put (Duration'Image (To_Duration (Elapsed)));
      PolyORB_HI.Output_Low_Level.Put ("] ");
      PolyORB_HI.Output_Low_Level.Put (Text);
   end Unprotected_Put;

   ----------
   -- Dump --
   ----------

   subtype Output_Line is String (1 .. 48);

   Hex : constant String := "0123456789ABCDEF";
   Nil : constant Output_Line := (Output_Line'Range => ' ');

   procedure Dump
     (Stream : Stream_Element_Array;
      Mode   : Verbosity            := Verbose)
   is
      Index   : Natural := 1;
      Output  : Output_Line := Nil;
   begin
      for J in Stream'Range loop
         Output (Index)     := ' ';
         Output (Index + 1) := Hex (Natural (Stream (J) / 16) + 1);
         Output (Index + 2) := Hex (Natural (Stream (J) mod 16) + 1);
         Index := Index + 3;

         if Index > Output'Length then
            Put_Line (Mode, Output);
            Index := 1;
            Output := Nil;
         end if;
      end loop;

      Put_Line (Mode, "DUMP" & Output);
   end Dump;

end PolyORB_HI.Output;
