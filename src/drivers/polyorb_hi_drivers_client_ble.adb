------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--         P O L Y O R B _ H I _ D R I V E R S _ C L I E N T _ B L E        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                   Copyright (C) 2012-2018 ESA & ISAE.                    --
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

with Ada.Streams;
with Ada.Exceptions;
with Ada.Real_Time;
with Interfaces;
with Ada.Unchecked_Conversion;
with System;

with GNAT.Sockets;

with PolyORB_HI.Messages;
with PolyORB_HI.Output;

with PolyORB_HI_Generated.Transport;

--  with POHICDRIVER_IP;

--  This package provides support for the TCP_IP device driver as
--  defined in the tcp_protocol.aadl AADLv2 model.

package body PolyORB_HI_Drivers_Client_BLE is

   pragma SPARK_Mode (Off);

   pragma Suppress (Elaboration_Check, PolyORB_HI_Generated.Transport);
   --  We do not want a pragma Elaborate_All to be implicitely
   --  generated for Transport.

   package AS renames Ada.Streams;

   use Ada.Real_Time;
   use Interfaces;
   use System;
   use GNAT.Sockets;
   use PolyORB_HI.Messages;
   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

--     use POHICDRIVER_IP;

   subtype AS_One_Element_Stream is AS.Stream_Element_Array (1 .. 1);
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

   --  Sockets
   Socket_Receive : Socket_Type;
   Socket_Send    : Socket_Type;


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      SEC       : AS_One_Element_Stream;
      SEO       : AS.Stream_Element_Offset;
      Next_Time : Time;
      Address_Receive : Sock_Addr_Type;
      Address_Send    : Sock_Addr_Type;
   begin
      pragma Warnings (Off);
      GNAT.Sockets.Initialize;
      --  XXX shutdown warning on this now obscoleted function
      pragma Warnings (On);

      --  Create the server to receive CRTP packets
      Address_Receive.Addr := Inet_Addr("127.0.0.1");
      Address_Receive.Port := 5490;

      Create_Socket (Socket_Receive);
      Set_Socket_Option
           (Socket_Receive,
            Socket_Level,
            (Reuse_Address, True));

      --  Since we always send small bursts of data and we do not
      --  get reponse (all communications are asynchronous), we
      --  disable the TCP "Nagle" algorithm and send ACK packets
      --  immediately.

      Set_Socket_Option
           (Socket_Receive,
            IP_Protocol_For_TCP_Level,
            (No_Delay, True));

      Bind_Socket
           (Socket_Receive,
            Address_Receive);
      Listen_Socket (Socket_Receive);

      --  pragma Debug (Verbose,
      --                Put_Line
      --                  ("Local socket created for "
      --                     & Image (Nodes (My_Node).Address)));

      --  Create the client to send CRTP packets
      Address_Send.Addr := Inet_Addr("127.0.0.1");
      Address_Send.Port := 5489;

      loop
         Create_Socket (Socket_Send);

         Next_Time := Clock + Milliseconds (200);
         begin
            --  pragma Debug (Verbose,
            --                Put_Line
            --                  ("Try to connect to "
            --                     & Image (Nodes (N).Address)));

            delay until Next_Time;

            Connect_Socket (Socket_Send, Address_Send);
            exit;
         exception
            when Socket_Error =>
               Close_Socket (Socket_Send);
         end;
      end loop;

      --  pragma Debug (Verbose,
      --                Put_Line
      --                  ("Connected to " & Image (Nodes (N).Address)));

      Initialize_Receiver;
      --  pragma Debug (Verbose, Put_Line ("Initialization of socket subsystem"
      --                          & " is complete"));
   exception
      when E : others =>
         --  pragma Debug (PolyORB_HI.Output.Error, Put_Line
         --                  ("Exception "
         --                     & Ada.Exceptions.Exception_Name (E)));
         --  pragma Debug (PolyORB_HI.Output.Error, Put_Line
         --                  ("Message "
         --                     & Ada.Exceptions.Exception_Message (E)));
      null;
   end Initialize;

   -------------------------
   -- Initialize_Receiver --
   -------------------------

   procedure Initialize_Receiver is
      Socket    : Socket_Type;
      Address   : Sock_Addr_Type;
   begin
      --  Wait for the connection of python socket

      --  pragma Debug (Verbose, Put_Line
      --                   ("Waiting on "
      --                    & Image (Nodes (My_Node).Address)));

      Address := No_Sock_Addr;
      Socket  := No_Socket;
      Accept_Socket (Socket_Receive, Socket, Address);

   end Initialize_Receiver;

   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type AS.Stream_Element_Offset;

      SEL       : AS_Message_Length_Stream;
      SEA       : AS_Full_Stream;
      SEO       : AS.Stream_Element_Offset;
   begin

      Main_Loop :
      loop

         --  Put_Line ("Using user-provided TCP/IP stack to receive");
         --  pragma Debug (Verbose, Put_Line ("Check mailboxes"));

         --  Receive message length

         Receive_Socket (Socket_Receive, SEL, SEO);

         --  Receive zero bytes means that peer is dead

         if SEO = 0 then
            --  pragma Debug (Verbose, Put_Line
            --                 ("Node " & Node_Type'Image (N)
            --                  & " is dead"));
            exit Main_Loop;
         end if;

         SEO := AS.Stream_Element_Offset
                 (To_Length (To_PO_HI_Message_Length_Stream (SEL)));
         --  pragma Debug (Verbose, Put_Line
         --                ("received"
         --                 & AS.Stream_Element_Offset'Image (SEO)
         --                 & " bytes from node " & Node_Type'Image (N)));

         --  Get the message and preserve message length to keep
         --  compatible with a local message delivery.

         SEA (1 .. Message_Length_Size) := SEL;
         Receive_Socket (Socket_Receive,
                               SEA (Message_Length_Size + 1 .. SEO + 1), SEO);

         --  Deliver to the peer handler

         PolyORB_HI_Generated.Transport.Deliver
                 (Corresponding_Entity
                  (Unsigned_8 (SEA (Message_Length_Size + 1))),
                  To_PO_HI_Full_Stream (SEA)
                    (1 .. Stream_Element_Offset (SEO)));
      end loop Main_Loop;

   exception
      when E : others =>
         --  pragma Debug (PolyORB_HI.Output.Error, Put_Line
         --                ("Exception "
         --                 & Ada.Exceptions.Exception_Name (E)));
         --  pragma Debug (PolyORB_HI.Output.Error, Put_Line
         --                ("Message "
         --                 & Ada.Exceptions.Exception_Message (E)));
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
      L : AS.Stream_Element_Offset;
      pragma Unreferenced (L);

      --  Note: we cannot cast both array types using
      --  Ada.Unchecked_Conversion because they are unconstrained
      --  types. We cannot either use direct casting because component
      --  types are incompatible. The only time efficient manner to do
      --  the casting is to use representation clauses.
      Msg : AS.Stream_Element_Array (1 .. AS.Stream_Element_Offset (Size));
      pragma Import (Ada, Msg);
      for Msg'Address use Message'Address;

   begin

      --  The message length should be less than 30 bytes to fit in 1 CRTP Packet
      if Integer (Size) > 30 --  CRTP_MAX_DATA_SIZE
      then
         return Error_Kind'(Error_Transport);
      end if;

      --  Put_Line ("Using user-provided TCP/IP stack to send");
      Send_Socket (Socket_Send, Msg, L);
      return Error_Kind'(Error_None);
   exception
      when E : others =>
         --  pragma Debug (PolyORB_HI.Output.Error, Put_Line
         --                  ("Exception "
         --                     & Ada.Exceptions.Exception_Name (E)));
         --  pragma Debug (PolyORB_HI.Output.Error, Put_Line
         --                  ("Message "
         --                     & Ada.Exceptions.Exception_Message (E)));
      return Error_Kind'(Error_Transport);
   end Send;

end PolyORB_HI_Drivers_Client_BLE;
