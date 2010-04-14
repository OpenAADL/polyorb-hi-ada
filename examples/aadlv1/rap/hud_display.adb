
with Computations;      use Computations;

with PolyORB_HI.Output; use PolyORB_HI.Output;
with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body HUD_Display is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      A : constant RAP_Int_32 := Get_Value
        (Entity,
         HUD_Display_T_Port_Type'(Angle_Of_Attack)).Angle_Of_Attack_DATA;
   begin
      Put_Line ("HUD_Display: BEGIN");
      Put_Line ("Angle_Of_Attack => " & RAP_Int_32'Image (A));
      Compute_During_N_Times_1ms (2);
      Put_Line ("HUD_Display: END");
   end Job;

end HUD_Display;
