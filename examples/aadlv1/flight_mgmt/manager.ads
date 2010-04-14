------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                              M A N A G E R                               --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2007-2008, GET-Telecom Paris.                --
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

--  Implementation routines for the Flight manager application

with PolyORB_HI_Generated.Types;      use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Deployment; use PolyORB_HI_Generated.Deployment;

package Manager is

   --  Landing_Gear_T thread

   procedure On_Req (Entity : Entity_Type);
   procedure On_Dummy_In (Entity : Entity_Type);

   --  HCI_T thread

   procedure On_Stall_Warning
     (Entity        : Entity_Type;
      Stall_Warning : Ravenscar_Integer);
   procedure On_Engine_Failure (Entity : Entity_Type);
   procedure On_Gear_Cmd (Entity : Entity_Type);
   procedure On_Gear_Ack (Entity : Entity_Type);

   --  Operator_T thread

   procedure On_Operator (Entity : Entity_Type);

   --  Sensor_Sim_T.RS thread

   procedure On_Sensor_Sim (Entity : Entity_Type);

   --  Stall_Monitor_T.RS

   procedure On_Stall_Monitor (Entity : Entity_Type);

end Manager;
