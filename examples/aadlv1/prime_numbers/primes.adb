------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                               P R I M E S                                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2007-2008, GET-Telecom Paris.                --
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

with PolyORB_HI.Output;             use PolyORB_HI.Output;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body Primes is

   Finder_Cycle   : Integer_Type := 0;
   N_Primes_One   : Integer_Type := 0;
   N_Primes_Two   : Integer_Type := 0;
   N_Primes_Three : Integer_Type := 0;

   function Is_Prime (N : Integer_Type) return Boolean;

   --------------------
   -- Raise_If_Prime --
   --------------------

   procedure Raise_If_Prime (Entity : Entity_Type) is
   begin
      if Is_Prime (Finder_Cycle) then
         Put_Value (Entity,
                    Prime_Finder_Impl_Interface'(Found_Prime, Finder_Cycle));
      end if;

      Finder_Cycle := Finder_Cycle + 1;
   end Raise_If_Prime;

   ---------------------------
   -- On_Received_Prime_One --
   ---------------------------

   procedure On_Received_Prime_One
     (Entity         : Entity_Type;
      Received_Prime : Integer_Type)
   is
      pragma Unreferenced (Entity);
   begin
      N_Primes_One := N_Primes_One + 1;

      Put_Line ("Reporter ONE: received new prime:"
                & Integer_Type'Image (Received_Prime));
   end On_Received_Prime_One;

   ---------------------------
   -- On_Received_Prime_Two --
   ---------------------------

   procedure On_Received_Prime_Two
     (Entity         : Entity_Type;
      Received_Prime : Integer_Type)
   is
      pragma Unreferenced (Entity);
   begin
      N_Primes_Two := N_Primes_Two + 1;

      Put_Line ("Reporter TWO: received new prime:"
                & Integer_Type'Image (Received_Prime));
   end On_Received_Prime_Two;

   -----------------------------
   -- On_Received_Prime_Three --
   -----------------------------

   procedure On_Received_Prime_Three
     (Entity         : Entity_Type;
      Received_Prime : Integer_Type)
   is
      pragma Unreferenced (Entity);
   begin
      N_Primes_Three := N_Primes_Three + 1;

      Put_Line ("Reporter THREE: received new prime:"
                & Integer_Type'Image (Received_Prime));
   end On_Received_Prime_Three;

   ----------------
   -- Report_One --
   ----------------

   procedure Report_One (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("*** Reporter ONE periodic report, total primes:"
                & Integer_Type'Image (N_Primes_One)
                & " ***");
   end Report_One;

   ----------------
   -- Report_Two --
   ----------------

   procedure Report_Two (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("*** Reporter TWO periodic report, total primes:"
                & Integer_Type'Image (N_Primes_Two)
                & " ***");
   end Report_Two;

   ------------------
   -- Report_Three --
   ------------------

   procedure Report_Three (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("*** Reporter THREE periodic report, total primes:"
                & Integer_Type'Image (N_Primes_Three)
                & " ***");
   end Report_Three;

   --------------
   -- Is_Prime --
   --------------

   function Is_Prime (N : Integer_Type) return Boolean is
      P : Boolean := True;
   begin
      if N < 2 then
         return False;
      elsif N = 2 then
         return True;
      else
         for D in 2 .. N / 2 + 1 loop
            P := N mod D /= 0 and then P;
            exit when not P;
         end loop;

         return P;
      end if;
   end Is_Prime;

end Primes;
