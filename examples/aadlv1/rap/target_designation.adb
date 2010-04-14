
with Computations; use Computations;

package body Target_Designation is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
   begin
      Compute_During_N_Times_1ms (2);
   end Job;

end Target_Designation;
