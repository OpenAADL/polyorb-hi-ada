
with Computations; use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;

package body RWR_Threat_Response is

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("RWR_Threat_Response: BEGIN");
      Compute_During_N_Times_1ms (5);
      Put_Line ("RWR_Threat_Response: END");
   end Job;

end RWR_Threat_Response;
