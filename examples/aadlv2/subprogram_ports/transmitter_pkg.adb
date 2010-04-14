------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                      T R A N S M I T T E R _ P K G                       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2009, GET-Telecom Paris.                   --
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

--  $Id: transmitter_pkg.adb 6851 2009-07-22 12:37:17Z hugues $

with PolyORB_HI_Generated.Types;
with PolyORB_HI.Output;

package body Transmitter_Pkg is

   use PolyORB_HI_Generated.Types;
   use PolyORB_HI.Output;

   Seed : Integer_Type := 0;

   ---------------
   -- Send_Data --
   ---------------

   procedure Send_Data (Status : in out Software_Send_Data_Status) is
   begin
      Seed := Seed + 1;

      if Seed mod 3 = 0 then
         Put_Line ("Transmitter: Raise event data on Data_Source:"
                   & Integer_Type'Image (Seed));
         Put_Value (Status, (Data_Source, Seed));
      else
         Put_Line ("Transmitter: Do not raise any port");
      end if;
   end Send_Data;

end Transmitter_Pkg;
