------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                                 P I N G                                  --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2008-2009, GET-Telecom Paris.                --
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

--  $Id: ping.adb 6936 2009-08-18 15:33:06Z lanarre $

with PolyORB_HI.Output;

package body Ping is

   use PolyORB_HI.Output;

   Var   : Simple_Type := 0;
   Var2  : Simple_Type := 0;
   Order : Opaque_Type := False;

   -----------------
   -- Do_Ping_Spg --
   -----------------

   procedure Do_Ping_Spg (Data_Source : out Opaque_Type) is
   begin
      Order := not Order;
      Data_Source := Order;
      Put_Line (Normal, "Sending ORDER: " & Opaque_Type'Image (Order));
   end Do_Ping_Spg;

   --------------------
   -- Do_Convert_Spg --
   --------------------

   procedure Do_Convert_Spg
     (Data_Sink   :     Opaque_Type;
      Data_Source : out Simple_type)
   is
   begin
      Put_Line (Normal, "ORDER: " & Opaque_Type'Image (Data_Sink));

      Var := Var + 1;
      Put_Line (Normal, "Sending (+1) PING" & Simple_Type'Image (Var));

      Data_Source := Var;
   end Do_Convert_Spg;

   ---------------------
   -- Do_Convert_Spg2 --
   ---------------------

   procedure Do_Convert_Spg2
     (Data_Sink   :     Opaque_Type;
      Data_Source : out Simple_type)
   is
   begin
      Put_Line (Normal, "ORDER: " & Opaque_Type'Image (Data_Sink));

      Var2 := Var2 + 5;
      Put_Line (Normal, "Sending (+5) PING" & Simple_Type'Image (Var2));

      Data_Source := Var2;
   end Do_Convert_Spg2;

end Ping;
