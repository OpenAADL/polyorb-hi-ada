------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                P O L Y O R B _ H I . S U S P E N D E R S                 --
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

--  This package holds a routine to suspend the main application task

with Ada.Synchronous_Task_Control;
with Ada.Real_Time;
with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Suspenders is

   use Ada.Synchronous_Task_Control;
   use PolyORB_HI_Generated.Deployment;

   use type Ada.Real_Time.Time;

   procedure Suspend_Forever;
   --  Suspends for ever each task that call it

   Task_Suspension_Objects : array (Entity_Type'Range) of Suspension_Object;
   --  This array is used so that each task waits on its corresponding
   --  suspension object until the transport layer initialization is
   --  complete. We are obliged to do so since Ravenscar forbids that
   --  more than one task wait on a protected object entry.

   System_Startup_Time : Ada.Real_Time.Time := Ada.Real_Time.Time_First;
   --  Startup time of user tasks

   procedure Unblock_All_Tasks;
   --  Unblocks all the tasks waiting on the suspension objects of
   --  Task_Suspension_Objects.

end PolyORB_HI.Suspenders;
