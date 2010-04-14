
with Computations; use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;

package body Target_Tracking is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Target_Tracking: BEGIN");
      Compute_During_N_Times_1ms (5);
      Put_Line ("Target_Tracking: END");
   end Job;

end Target_Tracking;
