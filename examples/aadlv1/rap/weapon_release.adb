
with Computations;      use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body Weapon_Release is

   --  WCET = 3 Ms

   Var : Integer := 0;

   ------------------------------
   -- On_Manual_Weapon_Release --
   ------------------------------

   procedure On_Manual_Weapon_Release (Entity : Entity_Type) is
   begin
      Put_Line ("Weapon_Release::On_Manual_Weapon_Release: BEGIN");
      Compute_During_N_Times_1ms (3);
      Var := Var + 1;

      if Var mod 11 = 0 then
         Put_Value (Entity, Weapon_Release_T_Interface'(Port => Do_Relaunch));
      end if;

      Put_Line ("Weapon_Release::On_Manual_Weapon_Release: END");
   end On_Manual_Weapon_Release;

   -----------------
   -- On_Relaunch --
   -----------------

   procedure On_Relaunch (Entity : Entity_Type) is
   begin
      Put_Line ("Weapon_Release::On_Relaunch: BEGIN");
      Put_Value (Entity, Weapon_Release_T_Interface'(Port => Do_Relaunch));
      Put_Line ("Weapon_Release::On_Relaunch: END");
   end On_Relaunch;

end Weapon_Release;
