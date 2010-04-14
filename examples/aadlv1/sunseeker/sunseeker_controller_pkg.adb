------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--             S U N S E E K E R _ C O N T R O L L E R _ P K G              --
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

with PolyORB_HI.Output;
with PolyORB_HI_Generated.Deployment;

package body Sunseeker_Controller_Pkg is

   use PolyORB_HI.Output;
   use PolyORB_HI_Generated.Deployment;

   Sunseekercontroller_Transfer : Single_Float := 0.0;
   ReferenceInput               : Single_Float := 0.0;

   Clock  : Single_Float := 0.0;
   Period : constant Single_Float := 0.01;
   --  ATTENTION: Period MUST be equal to the controller thread period
   --  (in seconds).

   -----------------------------------------
   -- Sunseekercontroller_Subprogram_Impl --
   -----------------------------------------

   procedure Sunseekercontroller_Subprogram_Impl
     (Controllerinput : out Single_Float;
      Outputfeedback  :     Single_Float)
   is
      Error               : Single_Float;
      Gain_Error_1        : Single_Float;
      Gain_Error          : Single_Float;
      Transfer_Fcn_Update : Single_Float;
   begin
      Put_Line (Normal,
                Node_Image (My_Node)
                & " CONSTROLLER INPUT:"
                & Single_Float'Image (Outputfeedback));

      if Clock < 1.0 then
         ReferenceInput := 0.0;
      else
         ReferenceInput := Clock - 1.0;
      end if;

      Error := ReferenceInput - Outputfeedback;

      Gain_Error_1 := Error * 0.1;
      Gain_Error := Gain_Error_1 * (-10_000.0);

      Transfer_Fcn_Update := Gain_Error
        - 170.0 * Sunseekercontroller_Transfer;

      Controllerinput := 29.17 * Sunseekercontroller_Transfer
        + Transfer_Fcn_Update;

      Sunseekercontroller_Transfer := Sunseekercontroller_Transfer
        + Period * Transfer_Fcn_Update;

      --  Mark a new cycle

      Clock := Clock + Period;

      Put_Line (Normal,
                Node_Image (My_Node)
                & " CONSTROLLER OUTPUT:"
                & Single_Float'Image (Controllerinput));
   end Sunseekercontroller_Subprogram_Impl;

end Sunseeker_Controller_Pkg;
