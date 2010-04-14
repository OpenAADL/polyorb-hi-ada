------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--               P O L Y O R B _ H I . H Y B R I D _ T A S K                --
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

--  Define a hybrid task that receives data from one particular
--  entity. A hybrid task of period P is a task that has:

--  1 - A periodic behavior done in instants 0, P, 2P, 3P...
--  2 - A sporadic behavior that allow the task to react to event
--  received between two period occurrences.

--  Hybrid threads are modeled like an aperiodic threads. The periodic
--  behavior will be quaranteed through events sent by the Hybrid task
--  driver.

--  BEGIN LOOP
--   1 - Blocks until a triggering event comes
--       triggering event may be a classical event or a Hybrid event
--       sent by the Hybrid task driver
--   2 - Do the job
--  END LOOP

with System;
with Ada.Real_Time;
with PolyORB_HI.Errors;
with PolyORB_HI_Generated.Deployment;

generic
   type Port_Type is (<>);
   --  Enumeration type representing the thread ports

   Entity          : in PolyORB_HI_Generated.Deployment.Entity_Type;
   --  So that the task know from which AADL entity it has been
   --  mapped.

   Task_Period     : in Ada.Real_Time.Time_Span;
   --  Task minimal inter-arrival time of events (Unused for now).

   Task_Deadline   : in Ada.Real_Time.Time_Span;
   --  Task deadline

   Task_Priority   : in System.Any_Priority;
   --  Task priority

   Task_Stack_Size : in Natural;
   --  Task stack size

   with procedure Wait_For_Incoming_Events
     (Entity :     PolyORB_HI_Generated.Deployment.Entity_Type;
      Port   : out Port_Type);
   --  Blocks the next triggering of the thread

   with function Job (Port : Port_Type) return PolyORB_HI.Errors.Error_Kind;
   --  Procedure to call at each dispatch of the hybrid thread

   with procedure Initialize_Entrypoint is null;
   --  If given, the task run Initialize_Entrypoint after the global
   --  initialization and before the task main loop.

   with procedure Recover_Entrypoint is null;
   --  If given, the task runs Recover_Entrypoint when an error is
   --  detected.

package PolyORB_HI.Hybrid_Task is

   task The_Hybrid_Task is
      pragma Priority (Task_Priority);
      pragma Storage_Size (Task_Stack_Size);
   end The_Hybrid_Task;

   function Next_Deadline return Ada.Real_Time.Time;
   --  Return the value of the next deadline (in absolute time)

end PolyORB_HI.Hybrid_Task;
