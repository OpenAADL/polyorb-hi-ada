with PolyORB_HI_Generated.Types;      use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Deployment; use PolyORB_HI_Generated.Deployment;

package Weapon_Selection is

   procedure On_Weapon_Select_Request (Entity : Entity_Type;
                                       Weapon_Select_Request : RAP_Int_32);

   procedure On_Quantity_Select_Request (Entity : Entity_Type;
                                         Quantity_Select_Request : RAP_Int_32);

   procedure On_Interval_Select_Request (Entity : Entity_Type;
                                         Interval_Select_Request : RAP_Int_32);

   procedure On_Auto_CCIP_Toggle (Entity : Entity_Type);

end Weapon_Selection;
