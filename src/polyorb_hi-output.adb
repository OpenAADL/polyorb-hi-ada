------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                    P O L Y O R B _ H I . O U T P U T                     --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--    Copyright (C) 2006-2009 Telecom ParisTech, 2010-2017 ESA & ISAE.      --
--                                                                          --
-- PolyORB-HI is free software; you can redistribute it and/or modify under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion. PolyORB-HI is distributed in the hope that it will be useful, but  --
-- WITHOUT ANY WARRANTY; without even the implied warranty of               --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
--                                                                          --
------------------------------------------------------------------------------

pragma SPARK_MOde (Off);

with PolyORB_HI.Output_Low_Level;
with PolyORB_HI.Suspenders;
pragma Elaborate_All (PolyORB_HI.Suspenders);

with Ada.Real_Time;
with System;

package body PolyORB_HI.Output is

   use Ada.Real_Time;

   procedure Unprotected_Put_Line (Text : in String);
   --  Not thread-safe Put_Line function

   procedure Unprotected_Put (Text : in String);
   --  Not thread-safe Put function

   --  This package encapsulates specific elements to protect against
   --  race condition on the output buffer. It is in a package to
   --  abide with SPARK restrictions.

   package Output_Lock is

      procedure Put_Line (Text : in String);
      --  As above but always displays the message

      procedure Put (Text : in String);

   end Output_Lock;

   package body Output_Lock is

      protected Lock is
      --  This lock has been defined to guarantee thread-safe output
      --  display

      procedure Put (Text : in String);

      procedure Put_Line (Text : in String);

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

      procedure Put_Line (Text : in String) is
      begin
         Lock.Put_Line (Text);
      end Put_Line;

      procedure Put (Text : in String) is
      begin
         Lock.Put (Text);
      end Put;

   end Output_Lock;

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

   procedure Put_Line (Text : in String) is
   begin
      Output_Lock.Put_Line (Text);
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

   procedure Put (Text : in String) is
   begin
      Output_Lock.Put (Text);
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
      Start_Time : Time renames PolyORB_HI.Suspenders.System_Startup_Time;
      Elapsed    : Time_Span;
   begin
      if Start_Time = Time_First then
         Elapsed := To_Time_Span (0.0);
      else
         Elapsed := Clock - Start_Time;
      end if;

      PolyORB_HI.Output_Low_Level.Put ("[");
      --  XXX The following is disabled as some cross-runtime do not have
      --  the capability to build Duration'Image
      --      PolyORB_HI.Output_Low_Level.Put
      --        (Duration'Image (To_Duration (Elapsed * 1000)));
      PolyORB_HI.Output_Low_Level.Put ("] ");
      PolyORB_HI.Output_Low_Level.Put (Text);
   end Unprotected_Put;

   ----------
   -- Dump --
   ----------

   subtype Output_Position is Positive range 1 .. 48;

   subtype Output_Line is String (Output_Position);

   Hex : constant array (0 .. 15) of Character := "0123456789ABCDEF";
   Nil : constant Output_Line := (Output_Line'Range => ' ');

   procedure Dump
     (Stream : Stream_Element_Array;
      Mode   : Verbosity            := Verbose)
   is
      Index   : Output_Position := Output_Position'First;
      Output  : Output_Line := Nil;
   begin
      for J in Stream'Range loop
         if Index + 3 <= Output'Last then
            Output (Index)     := ' ';
            Output (Index + 1) := Hex (Natural (Stream (J) / 16));
            Output (Index + 2) := Hex (Natural (Stream (J) mod 16));
            Index := Index + 3;
         else
            Put_Line (Mode, Output);
            Index := 1;
            Output := Nil;
         end if;
      end loop;

      Put_Line (Mode,  Output);
   end Dump;

   ---------
   -- "+" --
   ---------

   function "+" (S1 : String; S2 : String) return String is
      S : String (1 .. S1'Length + S2'Length) := (others => ' ');
   begin
      S (1 .. S1'Length) := S1 (S1'First .. S1'Last);
      S (S1'Length + 1 .. S'Last) := S2 (S2'First .. S2'Last);

      return S;
   end "+";

end PolyORB_HI.Output;
