------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                    P O L Y O R B _ H I . O U T P U T                     --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2006-2009 Telecom ParisTech,                 --
--                 2010-2019 ESA & ISAE, 2019-2020 OpenAADL                 --
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
--              PolyORB-HI/Ada is maintained by the OpenAADL team           --
--                             (info@openaadl.org)                          --
--                                                                          --
------------------------------------------------------------------------------

with System;
with PolyORB_HI.Output_Low_Level;

package body PolyORB_HI.Output
 with Refined_State => (Elaborated_Variables => Lock)

is
   use Ada.Real_Time;
   use PolyORB_HI.Epoch;

   function Build_Timestamp return Time_Span
     with Global => (Input => (Epoch.Elaborated_Variables,
                               Ada.Real_Time.Clock_Time)),
          Volatile_Function;

   procedure Unprotected_Put (Text : in String);
   --  Not thread-safe Put function

   --  This package encapsulates specific elements to protect against
   --  race condition on the output buffer. It is in a package to
   --  abide with SPARK restrictions.

   protected Lock is
      --  This lock has been defined to guarantee thread-safe output
      --  display

      procedure Put (Text : in String);

      procedure Put_Line (Text : in String;
                          C1 : in String := "";
                          C2 : in String := "";
                          C3 : in String := ""
                         );

   private
      pragma Priority (System.Priority'Last);
   end Lock;

   protected body Lock is

      --------------
      -- Put_Line --
      --------------

      procedure Put_Line (Text : in String;
                          C1 : in String := "";
                          C2 : in String := "";
                          C3 : in String := ""
                         ) is
      begin
         Unprotected_Put (Text);
         pragma Annotate (GNATProve, Intentional, "call to potentially block",
                          "reviewed"); --  SPARKWAG: C code binding

         if C1 /= "" then
            Unprotected_Put (C1);
            pragma Annotate (GNATProve, Intentional, "call to potentially block",
                             "reviewed"); --  SPARKWAG: C code binding
         end if;
         if C2 /= "" then
            Unprotected_Put (C2);
            pragma Annotate (GNATProve, Intentional, "call to potentially block",
                             "reviewed"); --  SPARKWAG: C code binding
         end if;
         if C3 /= "" then
            Unprotected_Put (C3);
            pragma Annotate (GNATProve, Intentional, "call to potentially block",
                             "reviewed"); --  SPARKWAG: C code binding
         end if;
         PolyORB_HI.Output_Low_Level.New_Line;
         pragma Annotate (GNATProve, Intentional, "call to potentially block",
                          "reviewed"); --  SPARKWAG: C code binding
      end Put_Line;

      ---------
      -- Put --
      ---------

      procedure Put (Text : in String) is
      begin
         Unprotected_Put (Text);
         pragma Annotate (GNATProve, Intentional, "call to potentially block",
                          "reviewed"); --  SPARKWAG: C code binding
      end Put;
   end Lock;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line (Text : in String;
                       C1 : in String := "";
                       C2 : in String := "";
                       C3 : in String := ""
                      ) is
   begin
      Lock.Put_Line (Text, C1, C2, C3);
   end Put_Line;

   ---------
   -- Put --
   ---------

   procedure Put (Text : in String) is
   begin
      Lock.Put (Text);
   end Put;

   ---------------------
   -- Build_Timestamp --
   ---------------------

   function Build_Timestamp return Time_Span is
      Start_Time : Time;
      Elapsed    : Time_Span;
      Now : constant Ada.Real_Time.Time := Ada.Real_Time.Clock;
   begin
      System_Startup_Time (Start_Time);
      if Start_Time = Time_First then
         Elapsed := To_Time_Span (0.0);
      else
         Elapsed := Now - Start_Time;
      end if;
      return Elapsed;
   end Build_Timestamp;

   ---------------------
   -- Unprotected_Put --
   ---------------------

   procedure Unprotected_Put (Text : in String) is
      Elapsed : constant Time_Span := Build_Timestamp;

   begin
      PolyORB_HI.Output_Low_Level.Put ("[");
      PolyORB_HI.Output_Low_Level.Put
        (Duration'Image (To_Duration (Elapsed)));
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
      Mode   : Verbosity            := Verbose_L)
   is
      Index   : Output_Position := Output_Position'First;
      Output  : Output_Line := Nil;
   begin
      if Current_Mode >= Mode then
         for J in Stream'Range loop
            if Index + 3 <= Output'Last then
               Output (Index)     := ' ';
               Output (Index + 1) := Hex (Natural (Stream (J) / 16));
               Output (Index + 2) := Hex (Natural (Stream (J) mod 16));
               Index := Index + 3;
            else
               Put_Line (Output);
               Index := 1;
               Output := Nil;
            end if;
         end loop;

         Put_Line (Output);
      end if;
   end Dump;

end PolyORB_HI.Output;
