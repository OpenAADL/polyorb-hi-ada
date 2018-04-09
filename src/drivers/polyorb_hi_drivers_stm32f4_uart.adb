

--  Notes : in RM0090 section 10-3-3 we can find the mapping table for the DMA
--  it says for example that DMA1 can be connected to the transmitter of USART2
--  (USART2_Tx) using Channel 4 / Stream 6. This is the only right config
--  Main  mappings:
--  DMA1 : USART2_Tx / Channel 4 / Stream 6
--  DMA1 : USART2_Rx / Channel 5 / Stream 5
--  DMA2 : USART6_Tx / Channel 5 / Stream 6 or Stream 7
--  DMA2 : USART6_Rx / Chennel 5 / Stream 1 or Stream 2
--
--  Then the alternate functions map also to specific USARTs:
--  AF7 maps to USART 1..3
--  AF8 maps to USART 4..6
--
--  And in the Datasheet of STM32F405/7 we have the GPIO / AF mapping:
--  PC6 = USART6_Tx
--  PC7 = USART6_Rx
--  PA2 = USART2_Tx (AF7)
--  PA3 = USART2_Rx (AF7)


pragma Style_Checks (off);

with STM32.Board;            use STM32.Board;
with STM32.GPIO;             use STM32.GPIO;
with STM32.DMA;              use STM32.DMA;
with STM32.Device;           use STM32.Device;
with HAL;                    use HAL;
with STM32.USARTs;           use STM32.USARTs;
with Ada.Interrupts;         use Ada.Interrupts;
with Ada.Interrupts.Names;   use Ada.Interrupts.Names;
--  with Types;                  use Types;
with Interfaces;
--with CRC;		     use CRC;

With Ada.Exceptions;
with Ada.Unchecked_Conversion;
with Ada.Synchronous_Task_Control;
with Ada.Streams;

with PolyORB_HI.Output;
with PolyORB_HI.Messages;

with PolyORB_HI_Generated.Transport;

with System; use System;

with POHICDRIVER_UART; use POHICDRIVER_UART;


package body PolyORB_HI_Drivers_STM32F4_UART is

   type Serial_Conf_T_Acc is access all POHICDRIVER_UART.Serial_Conf_T;
   function To_Serial_Conf_T_Acc is new Ada.Unchecked_Conversion
     (System.Address, Serial_Conf_T_Acc);

   To_GNAT_Baud_Rate : constant array (POHICDRIVER_UART.Baudrate_T) of
     STM32.USARTs.Baud_Rates :=
     (B9600 => 9600,
      B19200 => 19200,
      B38400 => 38400,
      B57600 => 57600,
      B115200 => 115200,
      B230400 => 230400);

   To_GNAT_Parity_Check : constant array (POHICDRIVER_UART.Parity_T) of
     STM32.USARTs.Parities :=
     (Even => Even_Parity,
      Odd => Odd_Parity);

   To_GNAT_Bits : constant array (8 .. 9) of
     STM32.USARTs.Word_Lengths :=
     (8 => Word_Length_8,
      9 => Word_Length_9);

   pragma Suppress (Elaboration_Check, PolyORB_HI_Generated.Transport);
   --  We do not want a pragma Elaborate_All to be implicitely
   --  generated for Transport.

   use Interfaces;
   use PolyORB_HI.Messages;
   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

   package STC renames Ada.Synchronous_Task_Control;

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

   Transceiver    : USART renames USART_2;  --coulb be set by Nodes (My_Node).UART_Config.devname or Nodes (My_Node).UART_Port
   Transceiver_AF : constant STM32.GPIO_Alternate_Function := GPIO_AF_USART2_7;

   TX_Pin         : constant GPIO_Point           := PA2;
   RX_Pin         : constant GPIO_Point           := PA3;

   Controller     : DMA_Controller                renames DMA_1;
   Tx_Channel     : constant DMA_Channel_Selector := Channel_4;
   Tx_Stream      : constant DMA_Stream_Selector  := Stream_6;

   Rx_Channel     : constant DMA_Channel_Selector := Channel_5;
   Rx_Stream      : constant DMA_Stream_Selector  := Stream_5;

   --  DMA_Tx_IRQ : constant Interrupt_ID := DMA1_Stream6_Interrupt;
   --  DMA_Rx_IRQ : constant Interrupt_ID := DMA1_Stream5_Interrupt;
   USART_IRQ      : constant Interrupt_ID := USART2_Interrupt;

   type Node_Record is record
      --  UART is a simple protocol, we use one port to send, assuming
      --  it can be used in full duplex mode.

      --UART_Port   : USART;
      -- UART_Device : Uart.Core.UART_Device;
      UART_Config : Serial_Conf_T;
   end record;

   Nodes : array (Node_Type) of Node_Record;

   --  One-message buffer for reception --aliased ?
   Synchro : Boolean := False;
   Message_Ready  : STC.Suspension_Object;
   Len_Complete : Boolean := False;
   SEA : AS_Full_Stream;
   SEL : AS_Message_Length_Stream;
   Packet_Size : Ada.Streams.Stream_Element_Offset;
   Data_Received_Index : Ada.Streams.Stream_Element_Offset := 1;

   --  Start marker to synchronize
   START_MARKER : Unsigned_8 := 16#A0#;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      Config_GPIO : GPIO_Port_Configuration(Mode_AF);
      Config_DMA  : DMA_Stream_Configuration;
      Parity    : STM32.USARTs.Parities;
      Use_ASN1 : Boolean := False;
   begin

      ------------------------
      -- GPIO Configuration --
      ------------------------

      Enable_Clock (RX_Pin & TX_Pin);
      --  Config_GPIO.Speed       := Speed_50MHz;
      --  Config_GPIO.Output_Type := Push_Pull;
      Config_GPIO.Resistors   := Pull_Up;

      Configure_IO (RX_Pin & TX_Pin,
                    Config => Config_GPIO);

      ----------------------------------------------
      -- Connect USART pins to Alternate function --
      ----------------------------------------------
      Configure_Alternate_Function (RX_Pin & TX_Pin,
                                    AF => Transceiver_AF);

      -------------------------------
      -- Getting the configuration --
      -------------------------------
      for J in Name_Table'Range loop
         if Name_Table (J).Variable = System.Null_Address then
            --  The structure of the location information is
            --     "serial DEVICE BAUDS DATA_BITS PARITY STOP_BIT"

            declare
               S : constant String := PolyORB_HI.Utils.To_String
                 (Name_Table (J).Location);
               Device_First, Device_Last : Integer;
               Bauds     : STM32.USARTs.Baud_Rates;
               Bits      : STM32.USARTs.Word_Lengths;
               Stop_Bits : STM32.USARTs.Stop_Bits;

               First, Last : Integer;

            begin
               First := S'First;

               --  First parse the prefix "serial"

               Last := Parse_String (S, First, ' ');

               if S (First .. Last) /= "serial" then
                  raise Program_Error with "Invalid configuration";
               end if;

               --  Then, parse the device (not used)

               First := Last + 2;
               Last := Parse_String (S, First, ' ');
               Device_First := First;
               Device_Last := Last;

               --  Then, parse the baud rate

               First := Last + 2;
               Last := Parse_String (S, First, ' ');
               begin
                  Bauds := STM32.USARTs.Baud_Rates'Value
                    ('B' & S (First .. Last));
               exception
                  when others =>
                     --  Put_Line (Normal, "Wrong baud rate: " & S (First .. Last));
                     raise;
               end;

               --  Then, parse the data bits

               First := Last + 2;
               Last := Parse_String (S, First, ' ');

               if S (First) = '8' then
                  Bits := Word_Length_8;
               elsif S (First) = '9' then
                  Bits := Word_Length_9;
               else
                  raise Program_Error with "Wrong bits: " & S (First);
               end if;

               --  Then, parse the parity

               First := Last + 2;
               Last := Parse_String (S, First, ' ');

               if S (First) = 'N' then
                  Parity :=  No_Parity;
               elsif S (First) = 'E' then
                  Parity :=  Even_Parity;
               elsif S (First) = 'O' then
                  Parity :=  Odd_Parity;
               else
                  raise Program_Error with "Wrong parity: " & S (First);
               end if;

               --  Finally, parse the stop_bits

               First := Last + 2;
               Last := Parse_String (S, First, ' ');

               if S (First) = '1' then
                  Stop_Bits :=  Stopbits_1;
               elsif S (First) = '2' then
                  Stop_Bits :=  Stopbits_2;
               else
                  raise Program_Error with "Wrong stop bits: " & S (First);
               end if;

               Enable_Clock     (Transceiver);
               Enable           (Transceiver);
               Set_Baud_Rate    (Transceiver, Bauds);
               Set_Mode         (Transceiver, Tx_Rx_Mode);
               Set_Stop_Bits    (Transceiver, Stop_Bits);
               Set_Word_Length  (Transceiver, Bits);
               Set_Parity       (Transceiver, Parity);
               Set_Flow_Control (Transceiver, No_Flow_Control);

            exception
               when others =>
                  null; --  Put_Line (Normal, "Initialization of UART subsystem dead");
            end;
         else
            --  We got an ASN.1 configuration variable, use it
            --  directly.
	    Use_ASN1 := True;
            Nodes (J).UART_Config := To_Serial_Conf_T_Acc
              (Name_Table (J).Variable).all;

         end if;
      end loop;

      if Nodes (My_Node).UART_Config.Use_Paritybit then
	 Parity := To_GNAT_Parity_Check
	   (Nodes (My_Node).UART_Config.Parity);
      else
	 Parity := No_Parity;
      end if;

      -------------------------
      -- USART Configuration --
      -------------------------
      Enable_Clock     (Transceiver);
      Enable           (Transceiver);
      Set_Baud_Rate    (Transceiver, To_GNAT_Baud_Rate (Nodes (My_Node).UART_Config.Speed));
      Set_Mode         (Transceiver, Tx_Rx_Mode);
      Set_Stop_Bits    (Transceiver, Stopbits_1);
      Set_Word_Length  (Transceiver, To_GNAT_Bits (Integer (Nodes (My_Node).UART_Config.Bits)));
      Set_Parity       (Transceiver, Parity);
      Set_Flow_Control (Transceiver, No_Flow_Control);


      --------------------
      -- Initialize_DMA --
      --------------------

      Enable_Clock (Controller);
      Reset (Controller, Tx_Stream);

      Config_DMA.Channel                      := Tx_Channel;
      Config_DMA.Direction                    := Memory_To_Peripheral;
      Config_DMA.Increment_Peripheral_Address := False;
      Config_DMA.Increment_Memory_Address     := True;
      Config_DMA.Peripheral_Data_Format       := Bytes;
      Config_DMA.Memory_Data_Format           := Bytes;
      Config_DMA.Operation_Mode               := Normal_Mode;
      Config_DMA.Priority                     := Priority_Very_High;
      Config_DMA.FIFO_Enabled                 := True;
      Config_DMA.FIFO_Threshold               := FIFO_Threshold_Full_Configuration;
      Config_DMA.Memory_Burst_Size            := Memory_Burst_Single;
      Config_DMA.Peripheral_Burst_Size        := Peripheral_Burst_Single;
      Configure (Controller, Tx_Stream, Config_DMA);

      Enable    (Transceiver);
      Enable_Interrupts (Transceiver, Received_Data_Not_Empty);

      --  Put_Line (Normal, "Initialization of stm32_UART subsystem is complete");
      --  Put_Line (Normal, " -> Using ASN.1: " & Use_ASN1'Img);

   end Initialize;


   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type Ada.Streams.Stream_Element_Offset;
   begin

      Main_Loop : loop
         --Put_Line ("Using user-provided Native_UART stack to receive");

         --  UART is a character-oriented protocol

         --  Wait until a message is received
         STC.Suspend_Until_True(Message_Ready);
         Disable_Interrupts (Transceiver, Source => Received_Data_Not_Empty);

         --  Deliver to the peer handler
         begin
            PolyORB_HI_Generated.Transport.Deliver
              (Corresponding_Entity
                 (Unsigned_8 (SEA (Message_Length_Size + 1))),
               To_PO_HI_Full_Stream (SEA)
               (1 .. Stream_Element_Offset (Packet_Size + Message_Length_Size)));
         exception
            when E : others =>
               null; --  Put_Line (Ada.Exceptions.Exception_Information (E));
         end;

         Enable_Interrupts (Transceiver, Received_Data_Not_Empty);

      end loop Main_Loop;
   end Receive;


   protected Reception is
      -- Interrupt business must be done in a protected object

      pragma Interrupt_Priority;
      procedure Handle_Reception with Inline;
      procedure IRQ_Handler      with Attach_Handler => USART_IRQ;
   end Reception;

   protected body Reception is

      procedure Handle_Reception is
           use type Ada.Streams.Stream_Element_Offset;
           --  Receive one char.
           Received_char : constant Character := Character'Val(Current_Input (Transceiver));

       begin
           --No framing, escaping for now

         if not Synchro
         then
            Synchro := (Unsigned_8 (Current_Input (Transceiver)) = START_MARKER);
         else
            if not Len_Complete
            then
               SEL(Data_Received_Index) := Ada.Streams.Stream_Element
                 (Character'Pos(Received_char));
               Data_Received_Index := Data_Received_Index + 1;
               if Data_Received_Index = Message_Length_Size + 1
               then
                  -- Lenght received
                  Len_Complete := True;
                  Packet_Size := Ada.Streams.Stream_Element_Offset
                    (To_Length (To_PO_HI_Message_Length_Stream (SEL)));
                  SEA (1 .. Message_Length_Size) := SEL;
               end if;
            else
               SEA(Data_Received_Index) := Ada.Streams.Stream_Element
                 (Character'Pos(Received_char));
               Data_Received_Index := Data_Received_Index + 1;
               if Data_Received_Index = Message_Length_Size + Packet_Size + 1
               then
                  --  Reception complete
                  Len_Complete := False;
                  Data_Received_Index := 1;
                  loop
                     exit when not Status (Transceiver, Read_Data_Register_Not_Empty);
                  end loop;
                  STC.Set_True(Message_Ready);
               end if;
            end if;
         end if;

      end;

       procedure IRQ_Handler is
       begin
          --  check for data arrival
          if Status (Transceiver, Read_Data_Register_Not_Empty) and
           Interrupt_Enabled (Transceiver, Received_Data_Not_Empty)
         then
            Handle_Reception;
            Clear_Status (Transceiver, Read_Data_Register_Not_Empty);
         end if;
       end IRQ_Handler;
    end Reception;


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
      use type Ada.Streams.Stream_Element_Offset;

      --  We cannot cast both array types using
      --  Ada.Unchecked_Conversion because they are unconstrained
      --  types. We cannot either use direct casting because component
      --  types are incompatible. The only time efficient manner to do
      --  the casting is to use representation clauses.

      Msg : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Size));
      pragma Import (Ada, Msg);
      for Msg'Address use Message'Address;
      -- Msg_CRC : Unsigned_32 := Make(Msg);
      Packet : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Size + 1));

   begin
      -- Put_Line ("Using user-provided UART stack to send");
      -- Put_Line ("Sending through UART "
      --            & Nodes (My_Node).UART_Config.devname
      --          & Size'Img & " bytes");

      -- Adding a Start byte at the beginning
      Packet (1) := Ada.Streams.Stream_Element (START_MARKER);
      Packet (2 .. Ada.Streams.Stream_Element_Offset (Size + 1)) := Msg;

      -- Previous Send should have left status "Transfer Complete Indicated"
      -- We must clear it before starting a new transfer
      Clear_All_Status (Controller, Tx_Stream);
      Start_Transfer
        (Controller,
         Tx_Stream,
         Source      => Packet'Address,
         Destination => Data_Register_Address (Transceiver),
         Data_Count  => UInt16 (Size + 1)); --legal ?

      Enable_DMA_Transmit_Requests (Transceiver);

      return Error_Kind'(Error_None);
      --  Note: we have no way to know there was an error here
   end;

end PolyORB_HI_Drivers_STM32F4_UART;


