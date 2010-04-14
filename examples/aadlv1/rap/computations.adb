--  $Id: computations.adb 2119 2007-10-24 07:15:27Z zalila $

with Ada.Real_Time; use Ada.Real_Time;

package body Computations is

   --  At elaboration time, this package evaluates the number of fixed
   --  point operation 1.0 / X to consume CPU during 1 millisecond.

   --  We use fixed point types to be compliant with restrictions for
   --  HIgh-Integrity systems (pragma Restriction No_Float).

   type Fixed_12_6 is delta 1.0E-6 digits 12;

   N_Base : constant Natural     := 1_000;
   F_Base : constant Fixed_12_6  := 1.0001;

   --  XMS or X Milli Seconds
   XMS    : constant Time_Span := Milliseconds (1);
   N_XMS  : Natural; --  Is computed at elaboration time

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
      for J in 1 .. N_Base loop
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
end Computations;
