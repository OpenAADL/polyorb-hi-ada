------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             P O L Y O R B _ H I . M A R S H A L L E R S _ G              --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--    Copyright (C) 2006-2009 Telecom ParisTech, 2010-2013 ESA & ISAE.      --
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
with PolyORB_HI.Streams;

package body PolyORB_HI.Marshallers_G is
   use type PolyORB_HI.Streams.Stream_Element_Offset;

   Data_Size : constant PolyORB_HI.Streams.Stream_Element_Offset
     := Data_Type'Object_Size / 8;

   subtype Data_Type_Stream is
     PolyORB_HI.Streams.Stream_Element_Array (1 .. Data_Size);

   function Data_Type_To_Stream is
      new Ada.Unchecked_Conversion (Data_Type, Data_Type_Stream);
   function Stream_To_Data_Type is
      new Ada.Unchecked_Conversion (Data_Type_Stream, Data_Type);

   --------------
   -- Marshall --
   --------------

   procedure Marshall
     (R :        Data_Type;
      M : in out Messages.Message_Type)
   is
      Data : constant Data_Type_Stream := Data_Type_To_Stream (R);

   begin
      Messages.Write (M, Data);
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

      if Last = Data_Size then --  XXX Data'Size [attribute]
         R := Stream_To_Data_Type (Data_Type_Stream (Data));
      end if;
   end Unmarshall;

end PolyORB_HI.Marshallers_G;
