
with Computations; use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;

package body MPD_Stores_Display is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("MPD_Stores_Display: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Line ("MPD_Stores_Display: END");
   end Job;

end MPD_Stores_Display;
