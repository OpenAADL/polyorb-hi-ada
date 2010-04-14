------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                                  M P C                                   --
--                                                                          --
--                                 S p e c                                  --
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

--  $Id: mpc.ads 6273 2009-03-25 17:36:51Z lasnier $

--  Implementation routines for the MPC Project Pilot model

with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;

package MPC is

   procedure Update
     (Update_Value :        Record_Type_Impl;
      X            : in out Component_Type;
      Y            : in out Component_Type;
      Z            : in out Component_Type);

   procedure Read
     (Read_Value :    out Record_Type_Impl;
      X          : in out Component_Type;
      Y          : in out Component_Type;
      Z          : in out Component_Type);

   procedure Observe_Object (Data_Source : out Record_Type_Impl);

   procedure Watch_Object_Value (Read_Value : Record_Type_Impl);

end MPC;
