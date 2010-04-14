pragma Warnings (Off);

with Interfaces;
with Ada.Unchecked_Conversion;
with Ada.Streams;
with Uart.HLInterface;
with Uart.Core;

with PolyORB_HI.Output;
with PolyORB_HI.Messages;

with PolyORB_HI_Generated.Transport;

--  This package provides support for the GRUART device driver as
--  defined in the GRUART AADLv2 model.

package body GRUART is

   pragma Suppress (Elaboration_Check, PolyORB_HI_Generated.Transport);
   --  We do not want a pragma Elaborate_All to be implicitely
   --  generated for Transport.

   use Interfaces;
   use PolyORB_HI.Messages;
   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

   type Node_Record is record
      --  SpaceWire is a simple protocol, we use one core to send,
      --  another to receive.

      UART_Port_Send   : Uart.HLInterface.Serial_Port;
      UART_Device_Send : Uart.Core.UART_Device;

      UART_Port_Receive   : Uart.HLInterface.Serial_Port;
      UART_Device_Receive : Uart.Core.UART_Device;

   end record;

   Nodes : array (Node_Type) of Node_Record;


   subtype AS_One_Element_Stream is Ada.Streams.Stream_Element_Array (1 .. 1);
   subtype AS_Message_Length_Stream is Ada.Streams.Stream_Element_Array
     (1 .. Message_Length_Size);
   subtype Message_Length_Stream is Stream_Element_Array
     (1 .. Message_Length_Size);

   subtype AS_Full_Stream is Ada.Streams.Stream_Element_Array (1 .. PDU_Size);
   subtype Full_Stream is Stream_Element_Array (1 .. PDU_Size);

   function To_PO_HI_Message_Length_Stream is new Ada.Unchecked_Conversion
     (AS_Message_Length_Stream, Message_Length_Stream);
   function To_PO_HI_Full_Stream is new Ada.Unchecked_Conversion
     (AS_Full_Stream, Full_Stream);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      Success : Boolean;

   begin
      Uart.HLInterface.Initialize (Success);
      if not Success then
         Put_Line (Normal,
                   "Initialization failure: cannot find UART cores");
      end if;

      for J in Name_Table'Range loop
         Nodes (J).UART_Device_Send
           := Uart.Core.UART_Device'Value
           (To_String (Name_Table (J).Location) (1 .. 1));

         Nodes (J).UART_Device_Receive
           := Uart.Core.UART_Device'Value
           (To_String (Name_Table (J).Location) (3 .. 3));

      end loop;

      Uart.HLInterface.Open (Port   => Nodes (My_Node).UART_Port_Send,
                             Number => Nodes (My_Node).UART_Device_Send);

      Uart.HLInterface.Open (Port   => Nodes (My_Node).UART_Port_Receive,
                             Number => Nodes (My_Node).UART_Device_Receive);

      Uart.HLInterface.Set (Port   => Nodes (My_Node).UART_Port_Send,
                            Rate => Uart.HLInterface.B19200);

      Uart.HLInterface.Set (Port   => Nodes (My_Node).UART_Port_Receive,
                            Rate => Uart.HLInterface.B19200,
                            Block => True);

      pragma Debug (Put_Line (Normal, "Initialization of UART subsystem"
                                & " is complete"));
   end Initialize;

   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type Ada.Streams.Stream_Element_Offset;

      SEL : AS_Message_Length_Stream;
      SEA : AS_Full_Stream;
      SEO : Ada.Streams.Stream_Element_Offset;
      Data_Received_Index : Ada.Streams.Stream_Element_Offset;
   begin

      Main_Loop : loop
         Put_Line ("Using user-provided GRUART stack to receive");
         Put_Line ("Waiting on UART #"
                     & Nodes (My_Node).UART_Device_Receive'Img);

         --  UART is a character-oriented protocol

         --  1/ Receive message length

         Uart.HLInterface.Read (Nodes (My_Node).UART_Port_Receive, SEL, SEO);

         SEO := Ada.Streams.Stream_Element_Offset
           (To_Length (To_PO_HI_Message_Length_Stream (SEL)));
         SEA (1 .. Message_Length_Size) := SEL;

         Data_Received_Index := Message_Length_Size + 1;

         while Data_Received_Index < SEO loop
            --  We must loop to make sure we receive all data

            Uart.HLInterface.Read (Nodes (My_Node).UART_Port_Receive,
                                   SEA (Data_Received_Index .. SEO + 1),
                                   SEO);
            Data_Received_Index := 1 + SEO;
         end loop;

         --  2/ Receive full message

         if SEO /= SEA'First - 1 then
            Put_Line
              (Normal,
               "UART #"
                 & Nodes (My_Node).UART_Device_Receive'Img
                 & " received"
                 & Ada.Streams.Stream_Element_Offset'Image (SEO)
                 & " bytes");

            --  Deliver to the peer handler

            PolyORB_HI_Generated.Transport.Deliver
              (Corresponding_Entity
                 (Integer_8 (SEA (Message_Length_Size + 1))),
               To_PO_HI_Full_Stream (SEA)
                 (1 .. Stream_Element_Offset (SEO)));
         else
            Put_Line ("Got error");
         end if;
      end loop Main_Loop;
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
      --  We cannot cast both array types using
      --  Ada.Unchecked_Conversion because they are unconstrained
      --  types. We cannot either use direct casting because component
      --  types are incompatible. The only time efficient manner to do
      --  the casting is to use representation clauses.

      Msg : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Size));
      pragma Import (Ada, Msg);
      for Msg'Address use Message'Address;

   begin
      Put_Line ("Using user-provided UART stack to send");
      Put_Line ("Sending through UART #"
                  & Nodes (Node).UART_Device_Send'Img
                  & Size'Img & " bytes");

      Uart.HLInterface.Write (Port   => Nodes (My_Node).UART_Port_Send,
                              Buffer => Msg);

      return Error_Kind'(Error_None);
      --  Note: we have no way to no there was an error here
   end Send;

end GRUART;
