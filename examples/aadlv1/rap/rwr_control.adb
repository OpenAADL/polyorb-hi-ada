
with Computations; use Computations;

package body RWR_Control is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
   begin
      Compute_During_N_Times_1ms (20);
   end Job;

end RWR_Control;
