------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                P O L Y O R B _ H I . P O R T _ K I N D S                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2007-2009, GET-Telecom Paris.                --
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

--  This package holds a set of routines to know the kinds and
--  orientation of AADL thread ports

package PolyORB_HI.Port_Kinds is

   type Port_Kind is
     (In_Event_Port,
      In_Event_Data_Port,
      In_Data_Port,
      In_Out_Event_Port,
      In_Out_Event_Data_Port,
      In_Out_Data_Port,
      Out_Event_Port,
      Out_Event_Data_Port,
      Out_Data_Port);

   type Overflow_Handling_Protocol is
     (DropOldest,
      DropNewest,
      Error);

   function Is_In (K : Port_Kind) return Boolean;
   function Is_Out (K : Port_Kind) return Boolean;

   function Is_Event (K : Port_Kind) return Boolean;
   function Is_Data (K : Port_Kind) return Boolean;

private

   pragma Inline (Is_In);
   pragma Inline (Is_Out);
   pragma Inline (Is_Event);
   pragma Inline (Is_Data);

end PolyORB_HI.Port_Kinds;
