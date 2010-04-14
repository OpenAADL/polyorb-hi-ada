
with Computations; use Computations;
with PolyORB_HI.Output;       use PolyORB_HI.Output;

package body Builtin_Test is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Builtin_Test: BEGIN");
      Compute_During_N_Times_1ms (1);
      Put_Line ("Builtin_Test: END");
   end Job;

end Builtin_Test;
