
with Computations; use Computations;
with PolyORB_HI.Output;       use PolyORB_HI.Output;

package body Weapon_Selection is

   --  WCET = 1 Ms

   ------------------------------
   -- On_Weapon_Select_Request --
   ------------------------------

   procedure On_Weapon_Select_Request (Entity : Entity_Type;
                                       Weapon_Select_Request : RAP_Int_32)
   is
      pragma Unreferenced (Weapon_Select_Request);
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Weapon_Selection::On_Weapon_Select_Request: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Line ("Weapon_Selection::On_Weapon_Select_Request: END");
   end On_Weapon_Select_Request;

   --------------------------------
   -- On_Quantity_Select_Request --
   --------------------------------

   procedure On_Quantity_Select_Request
     (Entity : Entity_Type; Quantity_Select_Request : RAP_Int_32)
   is
      pragma Unreferenced (Quantity_Select_Request);
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Weapon_Selection::On_Quantity_Select_Request: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Line ("Weapon_Selection::On_Quantity_Select_Request: END");
   end On_Quantity_Select_Request;

   --------------------------------
   -- On_Interval_Select_Request --
   --------------------------------

   procedure On_Interval_Select_Request
     (Entity : Entity_Type; Interval_Select_Request : RAP_Int_32)
   is
      pragma Unreferenced (Interval_Select_Request);
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Weapon_Selection::On_Interval_Select_Request: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Line ("Weapon_Selection::On_Interval_Select_Request: END");
   end On_Interval_Select_Request;

   -------------------------
   -- On_Auto_CCIP_Toggle --
   -------------------------

   procedure On_Auto_CCIP_Toggle (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Weapon_Selection::On_Auto_CCIP_Toggle: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Line ("Weapon_Selection::On_Auto_CCIP_Toggle: END");
   end On_Auto_CCIP_Toggle;

end Weapon_Selection;
