------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--       P O L Y O R B _ H I . T R A N S P O R T _ L O W _ L E V E L        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2006-2009, GET-Telecom Paris.                --
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

--  Transport low-level service of PolyORB HI, interact with actual
--  transport interface.

with PolyORB_HI.Errors;
with PolyORB_HI.Streams;
with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Transport_Low_Level is

   pragma Elaborate_Body;

   use PolyORB_HI.Errors;
   use PolyORB_HI.Streams;
   use PolyORB_HI_Generated.Deployment;

   procedure Initialize;
   --  Initialize Transport facility

   function Send (Node : Node_Type; Message : Stream_Element_Array)
     return Error_Kind;
   --  Send Message

end PolyORB_HI.Transport_Low_Level;
