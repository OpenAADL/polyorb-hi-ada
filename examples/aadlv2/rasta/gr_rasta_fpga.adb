with PolyORB_HI.Output;

--  This package provides support for the GR_RASTA_FPGA device driver
--  as defined in the GR_RASTA_FPGA AADLv2 model.

package body GR_RASTA_FPGA is

   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      pragma Unreferenced (Name_Table);
   begin
      Put_Line (Normal, "Initialization of SpaceWire subsystem"
                  & " is complete");
   end Initialize;

   -------------
   -- Receive --
   -------------

   procedure Receive is
   begin
      null;
   end Receive;

   ----------
   -- Send --
   ----------

   function Send
     (Node    : Node_Type;
      Message : Stream_Element_Array;
      Size    : Stream_Element_Offset)
     return Error_Kind
   is
      pragma Unreferenced (Node);
   begin
      Put_Line ("Using user-provided FPGA stack to send");
      Put_Line ("Sending" & Stream_Element_Offset'Image (Size)
                  & " bytes");

      Dump (Message (Message'First .. Message'First + Size - 1), Normal);

      return Error_Kind'(Error_None);
      --  Note: we have no way to no there was an error here
   end Send;

end GR_RASTA_FPGA;
