------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             P O L Y O R B _ H I . S P O R A D I C _ T A S K              --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2007-2009 Telecom ParisTech,                 --
--                 2010-2019 ESA & ISAE, 2019-2021 OpenAADL                 --
--                                                                          --
-- PolyORB-HI is free software; you can redistribute it and/or modify under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion. PolyORB-HI is distributed in the hope that it will be useful, but  --
-- WITHOUT ANY WARRANTY; without even the implied warranty of               --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
--              PolyORB-HI/Ada is maintained by the OpenAADL team           --
--                             (info@openaadl.org)                          --
--                                                                          --
------------------------------------------------------------------------------

---
--  # PolyORB_HI.Sporadic_Task { #sec:pohi_sporadic_task }
--
--  Define a sporadic task
--

with System;
with Ada.Real_Time;
with PolyORB_HI_Generated.Deployment;
with PolyORB_HI.Errors;

generic
   type Port_Type is (<>);
   --  Enumeration type representing the thread ports

   Entity          : in PolyORB_HI_Generated.Deployment.Entity_Type;
   --  So that the task know from which AADL entity it has been
   --  mapped.

   Task_Period     : in Ada.Real_Time.Time_Span;
   --  Task minimal inter-arrival time of events

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

   with procedure Job
     (Port : Port_Type;
      Result : out PolyORB_HI.Errors.Error_Kind);
   --  Procedure to call at each dispatch of the sporadic thread

   with procedure Activate_Entrypoint is null;
   --  If given, the task run Activate_Entrypoint after the global
   --  initialization and before the task main loop.

   with procedure Recover_Entrypoint is null;
   --  If given, the task runs Recover_Entrypoint when an error is detected.

package PolyORB_HI.Sporadic_Task
    with SPARK_Mode => On
is

   task The_Sporadic_Task
       with Priority => (Task_Priority),
            Storage_Size => (Task_Stack_Size),
            Annotate => (GNATprove, False_Positive,
                         "possible data race when accessing variable",
                         "XXX");
   pragma Annotate (GNATprove, False_Positive,
                     "multiple tasks might suspend on suspension object",
                     "XXX");

   function Next_Deadline return Ada.Real_Time.Time;
   --  Return the value of the next deadline (in absolute time)

end PolyORB_HI.Sporadic_Task;
