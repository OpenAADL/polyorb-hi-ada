------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                P O L Y O R B _ H I . S U S P E N D E R S                 --
--                                                                          --
--                                 B o d y                                  --
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

with PolyORB_HI.Output;

package body PolyORB_HI.Suspenders is

   use Ada.Real_Time;
   use PolyORB_HI.Output;

   --  The_Suspender : Suspension_Object;
   --  XXX: we cannot use the suspension object because of
   --  gnatforleon 2.0w5

   ---------------------
   -- Suspend_Forever --
   ---------------------

   procedure Suspend_Forever is
   begin
      --  Suspend_Until_True (The_Suspender);

      --  XXX: we cannot use the suspension object because of
      --  gnatforleon 2.0w5
      delay until Time_Last;
   end Suspend_Forever;

   -----------------------
   -- Unblock_All_Tasks --
   -----------------------

   procedure Unblock_All_Tasks is
      pragma Suppress (Range_Check);
   begin
      System_Startup_Time :=
        Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds (1_000);
      pragma Debug
        (Put_Line
         (Verbose, "Initialization of all subsystems finished,"
            & " system startup in 1 second(s)"));

      for J in Task_Suspension_Objects'Range loop
         pragma Debug
           (Put_Line
            (Verbose, "Unblocking task "
             & PolyORB_HI_Generated.Deployment.Entity_Image (J)));

         Set_True (Task_Suspension_Objects (J));

         pragma Debug
           (Put_Line
            (Verbose, "Task "
             & PolyORB_HI_Generated.Deployment.Entity_Image (J)
             & " unblocked"));
      end loop;

   end Unblock_All_Tasks;

end PolyORB_HI.Suspenders;
