with PolyORB_HI.Errors;
with PolyORB_HI_Generated.Deployment;
with PolyORB_HI.Streams;
with PolyORB_HI.Utils;

package PolyORB_HI_Drivers_Native_UART is

   use PolyORB_HI.Errors;
   use PolyORB_HI_Generated.Deployment;
   use PolyORB_HI.Streams;

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type);

   procedure Receive;

   function Send
     (Node    : Node_Type;
      Message : Stream_Element_Array;
      Size    : Stream_Element_Offset)
     return Error_Kind;

end PolyORB_HI_Drivers_Native_UART;
