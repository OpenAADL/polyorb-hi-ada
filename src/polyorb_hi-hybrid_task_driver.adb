------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--        P O L Y O R B _ H I . H Y B R I D _ T A S K _ D R I V E R         --
--                                                                          --
--                                 B o d y                                  --
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

with PolyORB_HI.Utils;
with PolyORB_HI.Output;
with PolyORB_HI.Port_Type_Marshallers;
with PolyORB_HI.Messages;
with PolyORB_HI.Suspenders;

package body PolyORB_HI.Hybrid_Task_Driver is

   package body Driver is
      use PolyORB_HI.Utils;
      use PolyORB_HI.Output;
      use PolyORB_HI_Generated.Deployment;
      use Ada.Real_Time;
      use PolyORB_HI.Streams;
      use Ada.Synchronous_Task_Control;
      use PolyORB_HI.Port_Type_Marshallers;
      use PolyORB_HI.Messages;
      use PolyORB_HI.Suspenders;

      procedure Trigger (T : Hybrid_Task_Info);
      --  Sends an event to the Period ports of task T.The_Task

      -------------
      -- Trigger --
      -------------

      procedure Trigger (T : Hybrid_Task_Info) is
         Message : aliased PolyORB_HI.Messages.Message_Type;
      begin
         Marshall (Internal_Code (T.Period_Event), Message);
         Deliver (T.The_Task, Encapsulate (Message, T.The_Task, T.The_Task));
      end Trigger;

      ----------------
      -- The_Driver --
      ----------------

      task body The_Driver is
         Next_Start     : Time;
         New_Next_Start : Time;
      begin
         --  Wait for the network initialization to be finished

         pragma Debug
           (Put_Line (Verbose, "Hybrid thread driver: Wait initialization"));

         Suspend_Until_True (Driver_Suspender);
         delay until System_Startup_Time;

         pragma Debug
           (Put_Line (Verbose, "Hybrid thread driver initialized"));

         Next_Start := Clock;

         --  Main task loop

         loop
            pragma Debug
              (Put_Line (Verbose, "Hybrid thread driver: new cycle"));

            --  Trigger the tasks that have to be triggered

            for TI in Hybrid_Task_Set'Range loop
               declare
                  T : Hybrid_Task_Info renames Hybrid_Task_Set (TI);
               begin
                  if T.Eligible then
                     T.Eligible := False;

                     pragma Debug
                       (Put_Line
                        (Verbose,
                         "Hybrid thread driver: Triggering task: "
                         & Entity_Image (T.The_Task)));

                     Trigger (T);
                  end if;
               end;
            end loop;

            --  Compute the next dispatch time of each hybrid task and
            --  set Next_Start to the closest activation time.

            New_Next_Start := Time_Last;

            for TI in Hybrid_Task_Set'Range loop
               declare
                  T : Hybrid_Task_Info renames Hybrid_Task_Set (TI);
               begin
                  if T.Next_Periodic_Dispatch <= Next_Start then
                     T.Next_Periodic_Dispatch :=
                       T.Next_Periodic_Dispatch + T.Period;
                  end if;

                  if T.Next_Periodic_Dispatch <= New_Next_Start then
                     New_Next_Start := T.Next_Periodic_Dispatch;
                  end if;
               end;
            end loop;

            Next_Start := New_Next_Start;

            --  Set eligible tasks

            for TI in Hybrid_Task_Set'Range loop
               declare
                  T : Hybrid_Task_Info renames Hybrid_Task_Set (TI);
               begin
                  if T.Next_Periodic_Dispatch <= Next_Start then
                     pragma Debug
                       (Put_Line
                        (Verbose,
                         "Hybrid thread driver: Eligible task: "
                         & Entity_Image (T.The_Task)));

                     T.Eligible := True;
                  end if;
               end;
            end loop;

            delay until Next_Start;
         end loop;
      end The_Driver;
   end Driver;

end PolyORB_HI.Hybrid_Task_Driver;
