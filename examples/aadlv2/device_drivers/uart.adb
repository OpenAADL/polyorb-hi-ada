with Ada.Streams;
with Ada.Exceptions;
with Ada.Real_Time;
with Interfaces;
with Ada.Unchecked_Conversion;

with GNAT.Sockets;

with PolyORB_HI.Output;
with PolyORB_HI.Messages;

with PolyORB_HI_Generated.Transport;

--  XXX

package body UART is

   pragma Suppress (Elaboration_Check, PolyORB_HI_Generated.Transport);
   --  We do not want a pragma Elaborate_All to be implicitely
   --  generated for Transport.

   package AS renames Ada.Streams;

   use Ada.Real_Time;
   use Interfaces;
   use GNAT.Sockets;
   use PolyORB_HI.Messages;
   use PolyORB_HI.Utils;
   use PolyORB_HI.Output;

   type Node_Record is record
      Address        : Sock_Addr_Type;
      Socket_Send    : Socket_Type;
      Socket_Receive : Socket_Type;
   end record;

   pragma Warnings (Off);
   Nodes : array (Node_Type) of Node_Record;
   pragma Warnings (On);

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

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      SEC       : AS_One_Element_Stream;
      SEO       : AS.Stream_Element_Offset;
      Next_Time : Time;
      Node      : Node_Type;
      Socket    : Socket_Type;
      Address   : Sock_Addr_Type;
   begin
      pragma Warnings (Off);
      --  XXX shutdown warning on this now obscoleted function
      GNAT.Sockets.Initialize;
      pragma Warnings (On);

      for J in Name_Table'Range loop
         if Name_Table (J).Location.L = 0 then
            Nodes (J).Address := (GNAT.Sockets.Family_Inet,
                                  GNAT.Sockets.No_Inet_Addr,
                                  GNAT.Sockets.No_Port);
         else
            Nodes (J).Address := (GNAT.Sockets.Family_Inet,
                                  GNAT.Sockets.Inet_Addr
                                    (PolyORB_HI.Utils.To_String
                                       (Name_Table (J).Location)),
                                  GNAT.Sockets.Port_Type
                                    (Name_Table (J).Port));
         end if;
      end loop;

      --  Create the local socket if the node is remote-callable

      if Nodes (My_Node).Address.Addr /= No_Inet_Addr then
         Create_Socket (Nodes (My_Node).Socket_Receive);
         Set_Socket_Option
           (Nodes (My_Node).Socket_Receive,
            Socket_Level,
            (Reuse_Address, True));

         --  Since we always send small bursts of data and we do not
         --  get reponse (all communications are asynchronous), we
         --  disable the TCP "Nagle" algorithm and send ACK packets
         --  immediately.

         Set_Socket_Option
           (Nodes (My_Node).Socket_Receive,
            IP_Protocol_For_TCP_Level,
            (No_Delay, True));

         Bind_Socket
           (Nodes (My_Node).Socket_Receive,
            Nodes (My_Node).Address);
         Listen_Socket (Nodes (My_Node).Socket_Receive);

         pragma Debug (Put_Line
                       (Verbose,
                        "Local socket created for "
                        & Image (Nodes (My_Node).Address)));
      end if;

      --  Connect to other nodes and send my node id

      for N in Nodes'Range loop
         if N /= My_Node
           and then Nodes (N).Address.Addr /= No_Inet_Addr
         then
            loop
               Create_Socket (Nodes (N).Socket_Send);

               Next_Time := Clock + Milliseconds (200);
               begin
                  pragma Debug
                    (Put_Line
                     (Verbose,
                      "Try to connect to " & Image (Nodes (N).Address)));

                  delay until Next_Time;

                  Connect_Socket (Nodes (N).Socket_Send, Nodes (N).Address);
                  exit;
               exception
                  when Socket_Error =>
                     Close_Socket (Nodes (N).Socket_Send);
               end;
            end loop;

            --  Send my node number

            SEC (1) := AS.Stream_Element (Node_Type'Pos (My_Node));
            Send_Socket (Nodes (N).Socket_Send, SEC, SEO);

            pragma Debug (Put_Line
                            (Verbose,
                             "Connected to " & Image (Nodes (N).Address)));
         end if;
      end loop;

      --  Wait for the connection of all the other nodes.

      --  XXX is this OK to do this here ????

      if Nodes (My_Node).Address.Addr /= No_Inet_Addr then
         pragma Debug (Put_Line
                       (Verbose, "Waiting on "
                        & Image (Nodes (My_Node).Address)));

         for N in Nodes'Range loop
            if N /= My_Node then
               Address := No_Sock_Addr;
               Socket  := No_Socket;
               Accept_Socket (Nodes (My_Node).Socket_Receive, Socket, Address);
               Receive_Socket (Socket, SEC, SEO);

               --  Identify peer node

               Node := Node_Type'Val (SEC (1));
               Nodes (Node).Socket_Receive := Socket;
               pragma Debug (Put_Line (Verbose, "Connection from node "
                                       & Node_Type'Image (Node)));
            end if;
         end loop;
      end if;

      pragma Debug (Put_Line (Verbose, "Initialization of socket subsystem"
                              & " is complete"));
   end Initialize;

   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type AS.Stream_Element_Offset;

      SEL       : AS_Message_Length_Stream;
      SEA       : AS_Full_Stream;
      SEO       : AS.Stream_Element_Offset;
      R_Sockets : Socket_Set_Type;
      W_Sockets : Socket_Set_Type;
      Selector  : Selector_Type;
      Status    : Selector_Status;
   begin
      --  Wait on several descriptors at a time

      Create_Selector (Selector);
      Empty (W_Sockets);

      Main_Loop :
      loop
         pragma Debug (Put_Line (Verbose, "****"));

         --  Build the socket descriptor set

         Empty (R_Sockets);
         for N in Node_Type'Range loop
            if N /= My_Node then
               Set (R_Sockets, Nodes (N).Socket_Receive);
            end if;
         end loop;

         Put_Line ("Using user-provided TCP/IP stack to receive");
         Check_Selector (Selector, R_Sockets, W_Sockets, Status);

         for N in Node_Type'Range loop
            pragma Debug (Put_Line (Verbose, "Check mailboxes"));

            --  If there is something to read on a node different from
            --  the current node.

            if N /= My_Node
              and then Is_Set (R_Sockets, Nodes (N).Socket_Receive)
            then
               --  Receive message length

               Receive_Socket (Nodes (N).Socket_Receive, SEL, SEO);

               --  Receive zero bytes means that peer is dead

               if SEO = 0 then
                  pragma Debug (Put_Line
                                  (Verbose,
                                   "Node " & Node_Type'Image (N)
                                   & " is dead"));
                  exit Main_Loop;
               end if;

               SEO := AS.Stream_Element_Offset
                 (To_Length (To_PO_HI_Message_Length_Stream (SEL)));
               pragma Debug (Put_Line
                               (Verbose,
                                "received"
                                & AS.Stream_Element_Offset'Image (SEO)
                                & " bytes from node " & Node_Type'Image (N)));

               --  Get the message and preserve message length to keep
               --  compatible with a local message delivery.

               SEA (1 .. Message_Length_Size) := SEL;
               Receive_Socket (Nodes (N).Socket_Receive,
                               SEA (Message_Length_Size + 1 .. SEO + 1), SEO);

               --  Deliver to the peer handler

               PolyORB_HI_Generated.Transport.Deliver
                 (Corresponding_Entity
                  (Integer_8 (SEA (Message_Length_Size + 1))),
                  To_PO_HI_Full_Stream (SEA)
                    (1 .. Stream_Element_Offset (SEO)));
            end if;
         end loop;
      end loop Main_Loop;

   exception
      when E : others =>
         pragma Debug (Put_Line
                       (Normal, "Exception "
                        & Ada.Exceptions.Exception_Name (E)));
         pragma Debug (Put_Line
                       (Normal, "Message "
                        & Ada.Exceptions.Exception_Message (E)));
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
      Put_Line ("Using user-provided TCP/IP stack to send");
      Send_Socket (Nodes (Node).Socket_Send, Msg, L);
      return Error_Kind'(Error_None);
   exception
      when E : others =>
         pragma Debug (Put_Line
                       (Normal, "Exception "
                          & Ada.Exceptions.Exception_Name (E)));
         pragma Debug (Put_Line
                       (Normal, "Message "
                          & Ada.Exceptions.Exception_Message (E)));
      return Error_Kind'(Error_Transport);
   end Send;

end UART;
