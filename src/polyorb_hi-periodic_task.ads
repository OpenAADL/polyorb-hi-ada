------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             P O L Y O R B _ H I . P E R I O D I C _ T A S K              --
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

--  Define a periodic task that executes a Job

with System;
with Ada.Real_Time;
with PolyORB_HI.Errors;
with PolyORB_HI_Generated.Deployment;

generic
   Entity          : in PolyORB_HI_Generated.Deployment.Entity_Type;
   --  So that the task know from which AADL entity it has been mapped

   Dispatch_Offset     : in Ada.Real_Time.Time_Span
     := Ada.Real_Time.To_Time_Span (0.0);
   --  Dispatch offset

   Task_Period     : in Ada.Real_Time.Time_Span;
   --  Task period

   Task_Deadline   : in Ada.Real_Time.Time_Span;
   --  Task deadline

   Task_Priority   : in System.Any_Priority;
   --  Task priority

   Task_Stack_Size : in Natural;
   --  Task stack size

   with function Job return PolyORB_HI.Errors.Error_Kind;
   --  Parameterless procedure executed by the periodic task

   with procedure Activate_Entrypoint is null;
   --  If given, the task runs Activate_Entrypoint after the global
   --  initialization and before the task main loop.

   with procedure Recover_Entrypoint is null;
   --  If given, the task runs Recover_Entrypoint when an error is
   --  detected.

package PolyORB_HI.Periodic_Task is

   task The_Periodic_Task is
      pragma Priority (Task_Priority);
      pragma Storage_Size (Task_Stack_Size);
   end The_Periodic_Task;

   function Next_Deadline return Ada.Real_Time.Time;
   --  Return the value of the next deadline (in absolute time)

end PolyORB_HI.Periodic_Task;
