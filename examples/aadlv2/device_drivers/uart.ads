with PolyORB_HI.Errors;
with PolyORB_HI_Generated.Deployment;
with PolyORB_HI.Streams;
with PolyORB_HI.Utils;

package UART is

   use PolyORB_HI.Errors;
   use PolyORB_HI_Generated.Deployment;
   use PolyORB_HI.Streams;

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type);

   procedure Receive;

   pragma Warnings (Off);
   function Send
     (Node    : Node_Type;
      Message : Stream_Element_Array;
      Size    : Stream_Element_Offset)
     return Error_Kind;
   pragma Export (C, Send, "uart_device.impl_send");
   pragma Warnings (On);

end UART;
