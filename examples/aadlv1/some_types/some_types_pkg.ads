------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                       S O M E _ T Y P E S _ P K G                        --
--                                                                          --
--                                 S p e c                                  --
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

with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;

package Some_Types_Pkg is

   procedure Emit_Boolean (Data_Source : out Boolean_Type);
   procedure Receive_Boolean (Data_Sink : in Boolean_Type);

   procedure Emit_Enum (Data_Source : out Enum_Type);
   procedure Receive_Enum (Data_Sink : in Enum_Type);

   procedure Emit_Integer (Data_Source : out Integer_Type);
   procedure Receive_Integer (Data_Sink : in Integer_Type);

   procedure Emit_Array (Data_Source : out Array_Type_I);
   procedure Receive_Array (Data_Sink : in Array_Type_I);

   procedure Emit_String (Data_Source : out String_Type);
   procedure Receive_String (Data_Sink : in String_Type);

end Some_Types_Pkg;
