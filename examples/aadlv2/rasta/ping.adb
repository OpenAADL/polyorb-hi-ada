with PolyORB_HI.Output;

package body Ping is

   use PolyORB_HI.Output;

   Var : constant Simple_Type := 'a';

   -----------------
   -- Do_Ping_Spg --
   -----------------

   procedure Do_Ping_Spg (Data_Source : out Simple_Type) is
   begin
      Data_Source := Var;
      Put_Line (Normal, "Sending ORDER: " & Simple_Type'Image (Var));
   end Do_Ping_Spg;

end Ping;
