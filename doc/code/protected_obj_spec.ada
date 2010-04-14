type Field_Type is new Integer;

protected type Protected_Object_Impl is
   procedure Update (P : in Field_Type);
   procedure Read (P : out Field_Type);
private
   Field : Field_Type;
end Protected_Object_Impl;
