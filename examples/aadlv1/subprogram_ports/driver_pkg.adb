------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                           D R I V E R _ P K G                            --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2007, GET-Telecom Paris.                   --
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

--  $Id: driver_pkg.adb 5381 2007-12-23 12:39:41Z zalila $

with PolyORB_HI_Generated.Types;
with PolyORB_HI.Output;

package body Driver_Pkg is

   use PolyORB_HI_Generated.Types;
   use PolyORB_HI.Output;
   use PolyORB_HI_Generated.Subprograms;

   Seed : Integer_Type := 0;

   ---------------------
   -- Driver_Identity --
   ---------------------

   procedure Driver_Identity is
   begin
      Put_Line ("Hello, this is the Driver node speaking");
   end Driver_Identity;

   --------------
   -- Do_Drive --
   --------------

   procedure Do_Drive
     (Status : in out PolyORB_HI_Generated.Subprograms.Do_Drive_Status)
   is
   begin
      Seed := Seed + 1;

      if Seed mod 2 = 0 then
         Put_Line ("Driver: Raise event data on Data_Source only:"
                   & Integer_Type'Image (Seed));
         Put_Value (Status, (Data_Source, Seed));
      elsif Seed mod 3 = 0 then
         Put_Line ("Driver: Raise event on Event_Source only");
         Put_Value (Status, (Port => Event_Source));
      elsif Seed mod 5 = 0 then
         Put_Line ("Driver: Raise event and data both ports:"
                   & Integer_Type'Image (Seed));
         Put_Value (Status, (Data_Source, Seed));
         Put_Value (Status, (Port => Event_Source));
      else
         Put_Line ("Driver: Do not raise any port");
      end if;
   end Do_Drive;

end Driver_Pkg;
