
with Computations; use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;

package body MPD_Tactical_Display is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("MPD_Tactical_Display: BEGIN");
      Compute_During_N_Times_1ms (9);
      Put_Line ("MPD_Tactical_Display: END");
   end Job;

end MPD_Tactical_Display;
