
with Computations; use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;

package body MPD_Status_Display is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("MPD_Status_Display: BEGIN");
      Compute_During_N_Times_1ms (3);
      Put_Line ("MPD_Status_Display: END");
   end Job;

end MPD_Status_Display;
