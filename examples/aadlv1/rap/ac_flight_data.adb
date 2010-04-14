
with Computations;      use Computations;

with PolyORB_HI.Output; use PolyORB_HI.Output;
with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body AC_Flight_Data is

   A : RAP_Int_32 := 0;

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
   begin
      Put_Line ("AC_Flight_Data: BEGIN");
      A := A + 2;
      Put_Line ("AC_Flight_Data: Send Angle_Of_Attack "
                & RAP_Int_32'Image (A));
      Put_Value
        (Entity,
         AC_Flight_Data_T_Interface'
           (Port                 => Angle_Of_Attack,
            Angle_Of_Attack_DATA => A));

      Compute_During_N_Times_1ms (8);
      Put_Line ("AC_Flight_Data: END");
   end Job;

end AC_Flight_Data;
