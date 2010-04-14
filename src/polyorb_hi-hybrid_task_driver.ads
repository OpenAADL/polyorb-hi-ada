------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--        P O L Y O R B _ H I . H Y B R I D _ T A S K _ D R I V E R         --
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

--  This package contains the archetype for the High-Priority task
--  that will trigger periodically all the Hybrid threads in the
--  current node.

with System;
with PolyORB_HI.Streams;
with Ada.Real_Time;
with Ada.Synchronous_Task_Control;

with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Hybrid_Task_Driver is

   --  Some type definitions that are useful for implementing AADL
   --  Hybrid threads.

   type Hybrid_Task_Info is record
      The_Task               : PolyORB_HI_Generated.Deployment.Entity_Type;
      --  The task entity

      Period_Event           : PolyORB_HI_Generated.Deployment.Port_Type;
      --  Denotes the fake event port added to the task to receive
      --  period-events.

      Period                 : Ada.Real_Time.Time_Span;
      --  The hybrid task period

      Next_Periodic_Dispatch : Ada.Real_Time.Time;
      --  The value (in absolute real time) of the next dispatch of
      --  the hybrid task.

      Eligible               : Boolean;
      --  True if this task must be awakened during the driver's next
      --  dispatch.
   end record;

   type Hybrid_Task_Info_Array is array (Positive range <>)
     of Hybrid_Task_Info;
   --  Used to store the set of Hybrid thread info of the current node

   Driver_Suspender : Ada.Synchronous_Task_Control.Suspension_Object;
   --  Suspends the driver until all the system is initialized

   --  The task below needs to be encapsulated in a generic package
   --  because the elements we give to it cannot be set as type
   --  discriminants and cannot be directly visible since they would
   --  lead to a cyclic package dependancy.

   generic
      Hybrid_Task_Set : in out Hybrid_Task_Info_Array;
      --  The set of Hybrid thread information. We assume that the
      --  initial value of this array is sorted increasingly
      --  (depending on the period). If the user wants all hybrid task
      --  to be triggered at instant zero, the Eligible flag of the
      --  initial value of the Hybrid_Task_Set element must be set to
      --  True.

      Task_Priority  : in System.Any_Priority;
      --  Task priority: equal to 1 plus the maximum Hybrid thread
      --  priority.

      Task_Stack_Size : in Natural;
      --  Driver stack size

      with procedure Deliver
        (Entity  : PolyORB_HI_Generated.Deployment.Entity_Type;
         Message : PolyORB_HI.Streams.Stream_Element_Array);
      --  The local delivery procedure of the current node.
   package Driver is

      task The_Driver is
         pragma Priority (Task_Priority);
         pragma Storage_Size (Task_Stack_Size);
      end The_Driver;

   end Driver;

end PolyORB_HI.Hybrid_Task_Driver;
