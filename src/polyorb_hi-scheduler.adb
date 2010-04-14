------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                 P O L Y O R B _ H I . S C H E D U L E R                  --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2009, GET-Telecom Paris.                   --
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

package body PolyORB_HI.Scheduler is

   procedure Next_Iteration;

   Current_Iteration : Integer := 0;

   --------------------
   -- Mode_Scheduler --
   --------------------

   procedure Mode_Scheduler is
   begin
      Next_Iteration;
      Change_Mode (Schedule_Table (Current_Iteration));
   end Mode_Scheduler;

   --------------------
   -- Next_Iteration --
   --------------------

   procedure Next_Iteration is
   begin
      if Current_Iteration < Array_Size then
         Current_Iteration := Current_Iteration + 1;
      else
         Current_Iteration := 0;
      end if;
      --  should be
      --  Current_Iteration := (Current_Iteration +1) mod Array_Size;
      --  but not analyzable by bound-t...
   end Next_Iteration;

   -----------------
   -- Next_Period --
   -----------------

   procedure Next_Period is
   begin
      R_Continue := False;
   end Next_Period;

end PolyORB_HI.Scheduler;
