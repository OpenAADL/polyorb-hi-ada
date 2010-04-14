------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                               P I N G E D                                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2008, GET-Telecom Paris.                   --
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

with PolyORB_HI.Output;

package body Pinged is

   use PolyORB_HI.Output;

   --------------
   -- Ping_Spg --
   --------------

   procedure Ping_Spg (Data_Sink : Simple_Type) is
   begin
      Put_Line (Normal, "*** PING ***" & Simple_Type'Image (Data_Sink));
   end Ping_Spg;

   ---------------
   -- Ping2_Spg --
   ---------------

   procedure Ping2_Spg (Msg_In : Simple_Type; Msg_Out : out Simple_Type)
   is
   begin
      Put_Line (Normal, "*** PRE-PING ***" & Simple_Type'Image (Msg_In));
      Msg_Out := Msg_In;
   end Ping2_Spg;

end Pinged;
