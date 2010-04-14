
with Computations;      use Computations;
with PolyORB_HI.Output; use PolyORB_HI.Output;
with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body Keyset is

   W : RAP_Int_32 := 0;
   Q : RAP_Int_32 := 0;

   ---------
   -- Job --
   ---------

   procedure Job (Entity : Entity_Type) is
   begin
      Put_Line ("Keyset: BEGIN");

      W := W + 2;
      Put_Line ("Keyset: Send Waypoint_Steering_Selected "
                & RAP_Int_32'Image (W));
      Put_Value
        (Entity,
         Keyset_T_Interface'
         (Port                            => Waypoint_Steering_Selected,
          Waypoint_Steering_Selected_DATA => W));


      Q := Q + 7;
      Put_Line ("Keyset: Send Quantity_Select_Request"
                & RAP_Int_32'Image (Q));
      Put_Value
        (Entity,
         Keyset_T_Interface'
         (Port                         => Quantity_Select_Request,
          Quantity_Select_Request_DATA => Q));
      Compute_During_N_Times_1ms (1);
      Put_Line ("Keyset: END");
   end Job;

end Keyset;
