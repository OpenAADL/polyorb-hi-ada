------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             P O L Y O R B _ H I . M A R S H A L L E R S _ G              --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2006-2008, GET-Telecom Paris.                --
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

with Ada.Unchecked_Conversion;
with PolyORB_HI.Streams;

package body PolyORB_HI.Marshallers_G is
   use type PolyORB_HI.Streams.Stream_Element_Offset;

   function Data_Size return PolyORB_HI.Streams.Stream_Element_Count;
   --  Return the smallest integer greater than or equal
   --  Data_Type'Size/8.0.

   ---------------
   -- Data_Size --
   ---------------

   function Data_Size return PolyORB_HI.Streams.Stream_Element_Count is
      use PolyORB_HI.Streams;

      Size_In_Bits : constant Stream_Element_Count := Data_Type'Size;
   begin
      if Size_In_Bits mod 8 = 0 then
         return Size_In_Bits / 8;
      else
         return Size_In_Bits / 8 + 1;
      end if;
   end Data_Size;

   type Data_Type_Stream is
     new PolyORB_HI.Streams.Stream_Element_Array
     (1 .. Data_Size);

   function Data_Type_To_Stream is
      new Ada.Unchecked_Conversion (Data_Type, Data_Type_Stream);
   function Stream_To_Data_Type is
      new Ada.Unchecked_Conversion (Data_Type_Stream, Data_Type);

   --------------
   -- Marshall --
   --------------

   procedure Marshall
     (R :        Data_Type;
      M : in out Messages.Message_Type) is
   begin
      Messages.Write
        (M, PolyORB_HI.Streams.Stream_Element_Array (Data_Type_To_Stream (R)));
   end Marshall;

   ----------------
   -- Unmarshall --
   ----------------

   procedure Unmarshall
     (R :    out Data_Type;
      M : in out Messages.Message_Type)
   is
      Data : PolyORB_HI.Streams.Stream_Element_Array (1 .. Data_Size);
      Last : PolyORB_HI.Streams.Stream_Element_Offset;
   begin
      Messages.Read (M, Data, Last);

      if Last /= Data'Length then
         raise Program_Error with "Incomplete message";
      end if;

      R := Stream_To_Data_Type (Data_Type_Stream (Data));
   end Unmarshall;

end PolyORB_HI.Marshallers_G;
