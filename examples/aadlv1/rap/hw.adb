with Computations;      use Computations;

with PolyORB_HI.Output; use PolyORB_HI.Output;
with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body HW is

   ---------------
   -- Radar_Job --
   ---------------

   procedure Radar_Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("Radar: BEGIN");
      Compute_During_N_Times_1ms (2);
      Put_Line ("Radar: END");
   end Radar_Job;

   -------------
   -- RWR_Job --
   -------------

   procedure RWR_Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("RWR: BEGIN");
      Compute_During_N_Times_1ms (20);
      Put_Line ("RWR: END");
   end RWR_Job;

   ----------------
   -- Keyset_Job --
   ----------------

   procedure Keyset_Job (Entity : Entity_Type) is
      W : constant RAP_Int_32 := Get_Value
        (Entity,
         Keyset_H_Port_Type'
           (Waypoint_Steering_Selected)).Waypoint_Steering_Selected_DATA;
      Q : constant RAP_Int_32 := Get_Value
        (Entity,
         Keyset_H_Port_Type'
           (Quantity_Select_Request)).Quantity_Select_Request_DATA;
   begin
      Put_Line ("Keyset: BEGIN");
      Put_Line ("Waypoint_Steering_Selected => " & RAP_Int_32'Image (W));
      Put_Line ("Quantity_Select_Request    => " & RAP_Int_32'Image (Q));
      Compute_During_N_Times_1ms (2);
      Put_Line ("Keyset: END");
   end Keyset_Job;

   -------------
   -- INS_Job --
   -------------

   procedure INS_Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("INS: BEGIN");
      Compute_During_N_Times_1ms (2);
      Put_Line ("INS: END");
   end INS_Job;

   -------------
   -- NAV_Job --
   -------------

   procedure NAV_Job (Entity : Entity_Type) is
      pragma Unreferenced (Entity);
   begin
      Put_Line ("INS: BEGIN");
      Compute_During_N_Times_1ms (2);
      Put_Line ("INS: END");
   end NAV_Job;

end HW;
