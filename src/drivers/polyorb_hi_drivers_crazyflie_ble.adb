------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--     P O L Y O R B _ H I _ D R I V E R S _ C R A Z Y F L I E _  B L E     --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                   Copyright (C) 2012-2015 ESA & ISAE.                    --
--                                                                          --
-- PolyORB-HI is free software; you can redistribute it and/or modify under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion. PolyORB-HI is distributed in the hope that it will be useful, but  --
-- WITHOUT ANY WARRANTY; without even the implied warranty of               --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
--                                                                          --
------------------------------------------------------------------------------

pragma Style_Checks (off);

with Types;               use Types;
with LEDS;		  use LEDS;
with Crazyflie_System;    use Crazyflie_System;
with Radiolink;           use Radiolink;
with CRTP;		  use CRTP;
with Syslink;		  use Syslink;
with EXT_UART;            use EXT_UART;
--  with Power_Management;    use Power_Management;

with Ada.Interrupts;         use Ada.Interrupts;
with Ada.Interrupts.Names;   use Ada.Interrupts.Names;
with Interfaces;
With Ada.Exceptions;
with Ada.Unchecked_Conversion;
with Ada.Synchronous_Task_Control;
with Ada.Streams;

with PolyORB_HI.Output;
with PolyORB_HI.Messages;
with PolyORB_HI_Generated.Transport;

with System; use System;


package body PolyORB_HI_Drivers_Crazyflie_BLE is

   --  TO DO : add BLE_Conf_T_Acc and Nodes

   pragma Suppress (Elaboration_Check, PolyORB_HI_Generated.Transport);
   --  We do not want a pragma Elaborate_All to be implicitely
   --  generated for Transport.

   package AS renames Ada.Streams;

   use Interfaces;
   use PolyORB_HI.Messages;
   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

   package STC renames Ada.Synchronous_Task_Control;

   subtype AS_Message_Length_Stream is AS.Stream_Element_Array
     (1 .. Message_Length_Size);
   subtype Message_Length_Stream is Stream_Element_Array
     (1 .. Message_Length_Size);

   subtype AS_Full_Stream is AS.Stream_Element_Array (1 .. PDU_Size);
   subtype Full_Stream is Stream_Element_Array (1 .. PDU_Size);

   function To_PO_HI_Message_Length_Stream is new Ada.Unchecked_Conversion
     (AS_Message_Length_Stream, Message_Length_Stream);
   function To_PO_HI_Full_Stream is new Ada.Unchecked_Conversion
     (AS_Full_Stream, Full_Stream);


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      Is_Init : Boolean;
   begin
      -- Initialize radio with default values (channel 80, 2 Mbps)
      Initialize_EXT_UART;
      Send_To_UART("[Crazyflie_BLE] Starting System initialization\n");
      System_Init;
      Send_To_UART("[Crazyflie_BLE] Starting System test\n");
      Is_Init := System_Self_Test;
      if Is_Init then
         Send_To_UART("[Crazyflie_BLE] System_Init succeeded\n");
      end if;

   end Initialize;


   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type Ada.Streams.Stream_Element_Offset;

      procedure CRTP_Get_T_Uint8_Data is new CRTP_Get_Data (T_Uint8);

      Rx_Packet : CRTP_Packet;
      Rx_Byte : T_Uint8;
      Has_Succeed : Boolean;
      SEA : AS_Full_Stream;
      SEO : AS.Stream_Element_Offset;
   begin

      Main_Loop : loop

         --  Receive and route one Syslink packet, changed into CRTP packet
         Syslink_Task_Type;
         --  should uart reception be disabled ? For now, bytes are still enqueued

         --  Wait until a CRTP Packet is received
         Radiolink_Receive_Packet_Blocking(Rx_Packet);

         --  Extract PolyORB message
         SEO := AS.Stream_Element_Offset (Rx_Packet.Data_2'Length);

         for i in Rx_Packet.Data_2'Range loop
            CRTP_Get_T_Uint8_Data (CRTP_Get_Handler_From_Packet (Rx_Packet),
                                   i, Rx_Byte, Has_Succeed);
            SEA (AS.Stream_Element_Offset (i)) := AS.Stream_Element (Rx_Byte);
         end loop;


         --  Deliver to the peer handler
         begin
            PolyORB_HI_Generated.Transport.Deliver
              (Corresponding_Entity
                 (Unsigned_8 (SEA (Message_Length_Size + 1))),
               To_PO_HI_Full_Stream (SEA)
                    (1 .. Stream_Element_Offset (SEO)));
         exception
            when E : others =>
               null; --  Put_Line (Ada.Exceptions.Exception_Information (E));
         end;

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
      procedure CRTP_Append_T_Uint8_Data is new CRTP_Append_Data (T_Uint8);

      --  We cannot cast both array types using
      --  Ada.Unchecked_Conversion because they are unconstrained
      --  types. We cannot either use direct casting because component
      --  types are incompatible. The only time efficient manner to do
      --  the casting is to use representation clauses.

      Msg : AS.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Size));
      pragma Import (Ada, Msg);
      for Msg'Address use Message'Address;
      --  Using CRTP protocol
      Packet_Handler : CRTP_Packet_Handler;
      Has_Succeed : Boolean;
      Free_Bytes_In_Packet : Boolean := True;

   begin

      --  The message length should be less than 30 bytes to fit in 1 CRTP Packet
      if Integer (Size) > CRTP_MAX_DATA_SIZE
      then
         return Error_Kind'(Error_Transport);
      end if;

      --  Use the Console Port to send the message to client (does not matter)
      Packet_Handler := CRTP_Create_Packet (CRTP_PORT_CONSOLE, 0);

      for SE of Msg loop
         CRTP_Append_T_Uint8_Data (Packet_Handler, T_Uint8 (SE), Free_Bytes_In_Packet);
      end loop;

      Has_Succeed := Radiolink_Send_Packet
        (CRTP_Get_Packet_From_Handler (Packet_Handler));
      CRTP_Reset_Handler (Packet_Handler);

      return Error_Kind'(Error_None);
      --  Note: we have no way to know there was an error here
   end;

end PolyORB_HI_Drivers_Crazyflie_BLE;
