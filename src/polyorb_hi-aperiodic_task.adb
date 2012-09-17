------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--            P O L Y O R B _ H I . A P E R I O D I C _ T A S K             --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--       Copyright (C) 2009 Telecom ParisTech, 2010-2012 ESA & ISAE.        --
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
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Synchronous_Task_Control;

with PolyORB_HI.Output;
with PolyORB_HI.Suspenders;

package body PolyORB_HI.Aperiodic_Task is

   use PolyORB_HI.Errors;
   use PolyORB_HI.Output;
   use PolyORB_HI_Generated.Deployment;
   use PolyORB_HI.Suspenders;
   use Ada.Real_Time;
   use Ada.Synchronous_Task_Control;

   -----------------------
   -- The_Aperiodic_Task --
   -----------------------

   task body The_Aperiodic_Task is
      Port  : Port_Type;
      Error : Error_Kind;

   begin
      --  Run the initialize entrypoint (if any)

      Activate_Entrypoint;

      --  Wait for the network initialization to be finished

      pragma Debug
        (Put_Line
         (Verbose,
          "Aperiodic Task "
          & Entity_Image (Entity)
          & ": Wait initialization"));

      Suspend_Until_True (Task_Suspension_Objects (Entity));
      delay until System_Startup_Time;

      pragma Debug (Put_Line
                    (Verbose,
                     "Aperiodic task initialized for entity "
                     & Entity_Image (Entity)));


      --  Main task loop

      loop
         pragma Debug
           (Put_Line
            (Verbose,
             "Aperiodic Task "
             & Entity_Image (Entity)
             & ": New Dispatch"));

         --  Block until an event is received

         Wait_For_Incoming_Events (Entity, Port);

         pragma Debug
           (Put_Line
            (Verbose,
             "Aperiodic Task "
             & Entity_Image (Entity)
             & ": received event"));

         --  Execute the job

         Error := Job (Port);

         if Error /= Error_None then
            Recover_Entrypoint;
         end if;
      end loop;
   end The_Aperiodic_Task;

   -------------------
   -- Next_Deadline --
   -------------------

   function Next_Deadline return Ada.Real_Time.Time is
   begin
      return Ada.Real_Time.Clock;
   end Next_Deadline;

end PolyORB_HI.Aperiodic_Task;
