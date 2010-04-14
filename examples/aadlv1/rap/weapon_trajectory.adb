
with Computations;      use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body Weapon_Trajectory is

   --  WCET = 3 Ms

   -----------------
   -- On_Relaunch --
   -----------------

   procedure On_Relaunch (Entity : Entity_Type) is
   begin
      Put_Line ("Weapon_Trajectory::On_Relaunch: BEGIN");
      Compute_During_N_Times_1ms (3);

      Put_Value (Entity, Weapon_Trajectory_T_Interface'(Port => Do_Relaunch));
      Put_Line ("Weapon_Trajectory::On_Relaunch: END");
   end On_Relaunch;

end Weapon_Trajectory;
