
with Computations; use Computations;

package body Steering is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Compute_During_N_Times_1ms (6);
   end Job;

end Steering;
