--------------------------------------------------------
--  This file was automatically generated by Ocarina  --
--  Do NOT hand-modify this file, as your             --
--  changes will be lost when you re-run Ocarina      --
--------------------------------------------------------
pragma Style_Checks
 ("NM32766");
with PolyORB_HI.Utils;
with PolyORB_HI_Generated.Deployment;

package PolyORB_HI_Generated.Naming is

  --  Naming Table for bus the_bus

  Naming_Table : constant PolyORB_HI.Utils.Naming_Table_Type :=
   (PolyORB_HI_Generated.Deployment.Node_A_K =>
     (PolyORB_HI.Utils.To_Hi_String
       ("127.0.0.1"),
      0),
    PolyORB_HI_Generated.Deployment.Node_B_K =>
     (PolyORB_HI.Utils.To_Hi_String
       ("127.0.0.1"),
      12002));

end PolyORB_HI_Generated.Naming;
