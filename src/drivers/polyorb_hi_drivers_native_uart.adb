with Ada.Exceptions;
with Ada.Streams;
with Ada.Unchecked_Conversion;
with Interfaces;

with GNAT.Serial_Communications;

with PolyORB_HI.Output;
with PolyORB_HI.Messages;

with PolyORB_HI_Generated.Transport;

--  This package provides support for the Native_UART device driver as
--  defined in the Native_UART AADLv2 model.

package body PolyORB_HI_Drivers_Native_UART is

   pragma Suppress (Elaboration_Check, PolyORB_HI_Generated.Transport);
   --  We do not want a pragma Elaborate_All to be implicitely
   --  generated for Transport.

   use Interfaces;
   use PolyORB_HI.Messages;
   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

   type Node_Record is record
      --  UART is a simple protocol, we use one port to send, another
      --  to receive.

      UART_Port_Send   : GNAT.Serial_Communications.Serial_Port;
      UART_Port_Receive   : GNAT.Serial_Communications.Serial_Port;
   end record;

   Nodes : array (Node_Type) of Node_Record;

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
      pragma Unreferenced (Name_Table);

   begin
      begin
         GNAT.Serial_Communications.Open
           (Port => Nodes (My_Node).UART_Port_Send,
            Name => "/dev/ttyS0");
      exception
         when E : others =>
            Put_Line (Ada.Exceptions.Exception_Information (E));
      end;
      begin
         GNAT.Serial_Communications.Open
           (Port => Nodes (My_Node).UART_Port_Receive,
            Name => "/dev/ttyUSB0");
      exception
         when E : others =>
            Put_Line (Ada.Exceptions.Exception_Information (E));
      end;

      GNAT.Serial_Communications.Set
        (Port   => Nodes (My_Node).UART_Port_Send,
         Parity => GNAT.Serial_Communications.Even,
         Rate => GNAT.Serial_Communications.B19200);

      GNAT.Serial_Communications.Set
        (Port   => Nodes (My_Node).UART_Port_Receive,
         Parity => GNAT.Serial_Communications.Even,
         Rate => GNAT.Serial_Communications.B19200,
         Block => True);

      Put_Line (Normal, "Initialization of UART subsystem"
                  & " is complete");
   exception
      when others =>
         Put_Line (Normal, "Initialization of UART subsystem"
                     & " dead");
   end Initialize;

   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type Ada.Streams.Stream_Element_Offset;

      SEL : AS_Message_Length_Stream;
      SEA : AS_Full_Stream;
      SEO : Ada.Streams.Stream_Element_Offset;
      Packet_Size : Ada.Streams.Stream_Element_Offset;
      Data_Received_Index : Ada.Streams.Stream_Element_Offset;
   begin

      Main_Loop : loop
         Put_Line ("Using user-provided Native_UART stack to receive");

         --  UART is a character-oriented protocol

         --  1/ Receive message length

         GNAT.Serial_Communications.Read
           (Nodes (My_Node).UART_Port_Receive, SEL, SEO);

         Packet_Size := Ada.Streams.Stream_Element_Offset
           (To_Length (To_PO_HI_Message_Length_Stream (SEL)));
         SEO := Packet_Size;

         SEA (1 .. Message_Length_Size) := SEL;

         Data_Received_Index := Message_Length_Size + 1;

         while Data_Received_Index <= Packet_Size + Message_Length_Size loop
            --  We must loop to make sure we receive all data

            GNAT.Serial_Communications.Read
              (Nodes (My_Node).UART_Port_Receive,
               SEA (Data_Received_Index .. SEO + 1),
               SEO);
            Data_Received_Index := 1 + SEO + 1;
         end loop;

         --  2/ Receive full message

         if SEO /= SEA'First - 1 then
            Put_Line
              (Normal,
               "UART received"
                 & Ada.Streams.Stream_Element_Offset'Image (SEO)
                 & " bytes");

            --  Deliver to the peer handler

            begin
               PolyORB_HI_Generated.Transport.Deliver
                 (Corresponding_Entity
                    (Integer_8 (SEA (Message_Length_Size + 1))),
                  To_PO_HI_Full_Stream (SEA)
                    (1 .. Stream_Element_Offset (SEO)));
            exception
               when E : others =>
                  Put_Line (Ada.Exceptions.Exception_Information (E));
            end;
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
      pragma Unreferenced (Node);

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
                  & Size'Img & " bytes");

      GNAT.Serial_Communications.Write
        (Port   => Nodes (My_Node).UART_Port_Send,
         Buffer => Msg);

      return Error_Kind'(Error_None);
      --  Note: we have no way to no there was an error here

   end Send;

end PolyORB_HI_Drivers_Native_UART;
