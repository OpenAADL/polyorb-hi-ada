------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                P O L Y O R B _ H I . S U S P E N D E R S                 --
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

   procedure Suspend_Forever
     with SPARK_Mode => Off
     --  XXX: delay until not supported in GNATProve GPL2014
   is
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
         (Verbose, "Initialization finished, system startup in 1 second(s)"));

      for J in Task_Suspension_Objects'Range loop
         pragma Debug
           (Put_Line
            (Verbose, "Unblocking task "
               + PolyORB_HI_Generated.Deployment.Entity_Image (J)));

         Set_True (Task_Suspension_Objects (J));

         pragma Debug
           (Put_Line
            (Verbose, "Task "
             + PolyORB_HI_Generated.Deployment.Entity_Image (J)
             + " unblocked"));
      end loop;
   end Unblock_All_Tasks;

end PolyORB_HI.Suspenders;
