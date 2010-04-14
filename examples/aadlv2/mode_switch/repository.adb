------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                           R E P O S I T O R Y                            --
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

with PolyORB_HI.Output; use PolyORB_HI.Output;

package body Repository is

   Cycle_Number  : Integer := 1;
   Message_Value : Simple_Type := 0;

   -----------------
   -- Init_Raiser --
   -----------------

   procedure Init_Raiser is
   begin
      Put_Line ("Raiser thread initialized");
   end Init_Raiser;

   -----------------
   -- Init_Worker --
   -----------------

   procedure Init_Worker is
   begin
      Put_Line ("Worker thread initialized");
   end Init_Worker;

   ------------
   -- Raiser --
   ------------

   procedure Raiser (M : out Simple_Type) is
   begin
      M := Message_Value;
      Message_Value := Message_Value + 1;
   end Raiser;

   --------------------
   -- Normal_Handler --
   --------------------

   procedure Normal_Handler (M : Simple_Type) is
   begin
      Put_Line ("NORMAL HANDLER received:" & Simple_Type'Image (M));
   end Normal_Handler;

   -----------------------
   -- Emergency_Handler --
   -----------------------

   procedure Emergency_Handler (M : Simple_Type) is
   begin
      Put_Line ("EMERGENCY HANDLER received:" & Simple_Type'Image (M));
   end Emergency_Handler;

   ------------------
   -- Lazy_Handler --
   ------------------

   procedure Lazy_Handler (M : Simple_Type) is
   begin
      Put_Line ("LAZY HANDLER received:" & Simple_Type'Image (M));
   end Lazy_Handler;

   -----------------------
   -- CE_Normal_Handler --
   -----------------------

   procedure CE_Normal_Handler
     (Entity : Entity_Type;
      P      : ModesC_Worker_Impl_Port_Type) is
   begin
      if P = Message then
         Normal_Handler (Get_Value (Entity, P).Message_DATA);
      else
         Put_Line ("Received event: Work_Normally");
      end if;

      Next_Value (Entity, ModesC_Worker_Impl_Port_Type'(P));
   end CE_Normal_Handler;

   --------------------------
   -- CE_Emergency_Handler --
   --------------------------

   procedure CE_Emergency_Handler
     (Entity : Entity_Type;
      P      : ModesC_Worker_Impl_Port_Type) is
   begin
      if P = Message then
         Emergency_Handler (Get_Value (Entity, P).Message_DATA);
      else
         Put_Line ("Received event: Emergency_Occurred");
      end if;

      Next_Value (Entity, ModesC_Worker_Impl_Port_Type'(P));
   end CE_Emergency_Handler;

   ---------------------
   -- CE_Lazy_Handler --
   ---------------------

   procedure CE_Lazy_Handler
     (Entity : Entity_Type;
      P      : ModesC_Worker_Impl_Port_Type) is
   begin
      if P = Message then
         Lazy_Handler (Get_Value (Entity, P).Message_DATA);
      else
         Put_Line ("Received event: Everything_Is_Cool");
      end if;

      Next_Value (Entity, ModesC_Worker_Impl_Port_Type'(P));
   end CE_Lazy_Handler;

   -----------
   -- Drive --
   -----------

   procedure Drive (Entity : Entity_Type) is
   begin
      if Cycle_Number mod 41 = 0 then
         Put_Line ("******** Emitting Work_Normally ********");
         Put_Value (Entity,
                    Common_Driver_Impl_Interface'(Port => Work_Normally));
      elsif Cycle_Number mod 201 = 0 then
         Put_Line ("******** Emitting Everything_Is_Cool ********");
         Put_Value (Entity,
                    Common_Driver_Impl_Interface'(Port => Everything_Is_Cool));
      elsif Cycle_Number mod 400 = 0 then
         Put_Line ("******** Emitting Emergency_Occurred ********");
         Put_Value (Entity,
                    Common_Driver_Impl_Interface'(Port => Emergency_Occurred));
      end if;

      Cycle_Number := Cycle_Number + 1;
   end Drive;

end Repository;
