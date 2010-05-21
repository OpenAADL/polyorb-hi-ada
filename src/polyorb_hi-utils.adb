------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                     P O L Y O R B _ H I . U T I L S                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2009-2010, GET-Telecom Paris.                --
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

with System;

package body PolyORB_HI.Utils is

   ------------------
   -- To_HI_String --
   ------------------

   function To_Hi_String (S : String) return HI_String is
      R : String (1 .. 16) := (others => ' ');
   begin
      R (1 .. S'Length) := S;
      return HI_String'(S => R,
                        L => S'Length);
   end To_HI_String;

   ---------------
   -- To_String --
   ---------------

   function To_String (H : HI_String) return String is
   begin
      return H.S (1 .. H.L);
   end To_String;

   ----------------
   -- Swap_Bytes --
   ----------------

   function Swap_Bytes (B : Interfaces.Unsigned_16)
                       return Interfaces.Unsigned_16
   is
      use System;
   begin
      pragma Warnings (Off);
      --  Note: this is to disable a warning on the following test
      --  being always true/false on a node.

      if Default_Bit_Order = High_Order_First then
         return B;

         pragma Warnings (On);

      --  Little-endian case. We must swap the high and low bytes

      else
         return (B / 256) + (B mod 256) * 256;
      end if;
   end Swap_Bytes;

   -------------------
   -- Internal_Code --
   -------------------

   function Internal_Code (P : Port_Type) return Unsigned_16 is
      function To_Internal_Code is new Ada.Unchecked_Conversion
        (Port_Type, Unsigned_16);
   begin
      return Swap_Bytes (To_Internal_Code (P));
   end Internal_Code;

   ------------------------
   -- Corresponding_Port --
   ------------------------

   function Corresponding_Port (I : Unsigned_16) return Port_Type is
      function To_Corresponding_Port is new Ada.Unchecked_Conversion
        (Unsigned_16, Port_Type);
   begin
      return To_Corresponding_Port (Swap_Bytes (I));
   end Corresponding_Port;

end PolyORB_HI.Utils;
