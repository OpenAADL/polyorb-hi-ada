protected body Protected_Object_Impl is

   ------------
   -- Update --
   ------------

   procedure Update (P : in Field_Type) is
   begin
      Repository.Protected_Update
        (P,      --  in
         Field); --  in out
   end Update;

   ----------
   -- Read --
   ----------

   procedure Read (P : out Field_Type) is
   begin
      Repository.Protected_Read
        (P,      --     out
         Field); --  in
   end Read;
end Protected_Object_Impl;
