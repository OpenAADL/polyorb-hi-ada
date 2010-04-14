
with Computations;      use Computations;
with PolyORB_HI.Output;            use PolyORB_HI.Output;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body HOTAS is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
   begin
      Put_Line ("Hotas: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Value (Entity, Hotas_T_Interface'(Port => Manual_Weapon_Release));
      Put_Line ("Hotas: END");
   end Job;

end HOTAS;
