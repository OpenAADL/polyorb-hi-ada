------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             P O L Y O R B _ H I . P E R I O D I C _ T A S K              --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--    Copyright (C) 2007-2009 Telecom ParisTech, 2010-2015 ESA & ISAE.      --
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
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Synchronous_Task_Control;

with PolyORB_HI.Output;
with PolyORB_HI.Suspenders;

package body PolyORB_HI.Periodic_Task is

   use PolyORB_HI.Errors;
   use PolyORB_HI.Output;
   use Ada.Real_Time;
   use PolyORB_HI.Suspenders;
   use PolyORB_HI_Generated.Deployment;
   use Ada.Synchronous_Task_Control;

   Next_Deadline_Val : Time;

   task body The_Periodic_Task is
      Next_Start : Ada.Real_Time.Time;
      --  T : Ada.Real_Time.Time;
      Error : Error_Kind;

   begin
      --  Run the initialize entrypoint (if any)

      Activate_Entrypoint;

      --  Wait for the network initialization to be finished

      pragma Debug
        (Put_Line
         (Verbose,
          "Periodic Task "
          + Entity_Image (Entity)
          + ": Wait initialization"));

      Suspend_Until_True (Task_Suspension_Objects (Entity));
      Next_Start := System_Startup_Time + Dispatch_Offset;

      delay until Next_Start;

      --  Main task loop

      Next_Start        := Next_Start + Task_Period;
      Next_Deadline_Val := System_Startup_Time
        + Dispatch_Offset + Task_Deadline;

      loop
         pragma Debug
           (Put_Line
            (Verbose,
             "Periodic Task " + Entity_Image (Entity) + ": New Cycle"));

         --  Execute the task's job

         Error := Job;

         if Error /= Error_None then
            Recover_Entrypoint;
         end if;

         --  T := Ada.Real_Time.Clock;
         --  if T > Next_Start then
         --     Put_Line (Normal, "***** Overload detected in task "
         --                 + Entity_Image (Entity) + " *****");
         --     Put_Line (Normal, "Lag: " +
         --                 Duration'Image (To_Duration (Next_Start - T)));
         --  end if;

         delay until Next_Start;
         Next_Start        := Next_Start + Task_Period;
         Next_Deadline_Val := Ada.Real_Time.Clock + Task_Deadline;
      end loop;
   end The_Periodic_Task;

   -------------------
   -- Next_Deadline --
   -------------------

   function Next_Deadline return Ada.Real_Time.Time is
   begin
      return Next_Deadline_Val;
   end Next_Deadline;

end PolyORB_HI.Periodic_Task;
