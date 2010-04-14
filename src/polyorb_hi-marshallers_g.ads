------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             P O L Y O R B _ H I . M A R S H A L L E R S _ G              --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2006-2007, GET-Telecom Paris.                --
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

--  Generic marshallers, based on Ada unchecked conversion

with PolyORB_HI.Messages;

generic
   type Data_Type (<>) is private;

package PolyORB_HI.Marshallers_G is

   procedure Marshall
     (R :        Data_Type;
      M : in out Messages.Message_Type);
   --  Marshall a data R in message M

   procedure Unmarshall
     (R :    out Data_Type;
      M : in out Messages.Message_Type);
   --  Unmarshall a data R from message M

end PolyORB_HI.Marshallers_G;
