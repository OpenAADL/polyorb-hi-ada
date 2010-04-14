
with Computations; use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;

package body Radar_Controller is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Radar_Controller: END");
      Compute_During_N_Times_1ms (5);
      Put_Line ("Radar_Controller: END");
   end Job;

end Radar_Controller;
