with Interfaces;
with Ada.Unchecked_Conversion;

with SpaceWire.HLInterface;

with PolyORB_HI.Output;
with PolyORB_HI.Messages;

with PolyORB_HI_Generated.Transport;

--  This package provides support for the GRSPW device driver as
--  defined in the GRSPW AADLv2 model.

package body GRSPW is

   task body Idle_Task  is
   begin
      loop
         null;
      end loop;
   end Idle_Task;

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

      SpaceWire_Core_Send : SpaceWire.HLInterface.SpaceWire_Device;
      SpaceWire_Core_Receive : SpaceWire.HLInterface.SpaceWire_Device;

   end record;

   Nodes : array (Node_Type) of Node_Record;

   subtype AS_Full_Stream is
     SpaceWire.HLInterface.Receiver_Packet_Type (1 .. PDU_Size);
   subtype Full_Stream is Stream_Element_Array (1 .. PDU_Size);

   function To_PO_HI_Full_Stream is new Ada.Unchecked_Conversion
     (AS_Full_Stream, Full_Stream);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Name_Table : PolyORB_HI.Utils.Naming_Table_Type) is
      Success : Boolean;

   begin
      SpaceWire.HLInterface.Initialize (Success);
      if not Success then
         Put_Line (Normal,
                   "Initialization failure: cannot find SpaceWire cores");
      end if;

      for J in Name_Table'Range loop
         Nodes (J).SpaceWire_Core_Send
           := SpaceWire.HLInterface.SpaceWire_Device'Value
           (To_String (Name_Table (J).Location) (1 .. 1));

         Nodes (J).SpaceWire_Core_Receive
           := SpaceWire.HLInterface.SpaceWire_Device'Value
           (To_String (Name_Table (J).Location) (3 .. 3));

         SpaceWire.HLInterface.Set_Node_Address
           (Nodes (J).SpaceWire_Core_Send,
            Interfaces.Unsigned_8 (Nodes (J).SpaceWire_Core_Receive));
      end loop;

      --  XXX remove code below

      SpaceWire.HLInterface.Set_Node_Address (1, 1);
      SpaceWire.HLInterface.Set_Node_Address (2, 2);

      pragma Debug (Put_Line (Normal, "Initialization of SpaceWire subsystem"
                                & " is complete"));
   end Initialize;

   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type SpaceWire.HLInterface.Receiver_Packet_Size_Type;
      SEA       : AS_Full_Stream;
      SEO       : SpaceWire.HLInterface.Receiver_Packet_Size_Type;

   begin
      Main_Loop : loop
         Put_Line ("Using user-provided GRSPW stack to receive");
         Put_Line ("Waiting on Spacewire core #" &
                     Nodes (My_Node).Spacewire_Core_Receive'Img);

         --  SpaceWire is packet oriented, we fetch in one call all
         --  required information.

         SpaceWire.HLInterface.Receive
           (Nodes (My_Node).Spacewire_Core_Receive, SEA, SEO);

         Put_Line
           (Normal,
            "Received"
              & SpaceWire.HLInterface.Receiver_Packet_Size_Type'Image (SEO)
              & " bytes on core "
              & Nodes (My_Node).SpaceWire_Core_Receive'Img);

         --  Deliver to the peer handler

         PolyORB_HI_Generated.Transport.Deliver
           (Corresponding_Entity
              (Integer_8 (SEA (Message_Length_Size + 1))),
            To_PO_HI_Full_Stream (SEA)
              (1 .. Stream_Element_Offset (SEO)));
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
      --  Note: we cannot cast both array types using
      --  Ada.Unchecked_Conversion because they are unconstrained
      --  types. We cannot either use direct casting because component
      --  types are incompatible. The only time efficient manner to do
      --  the casting is to use representation clauses.

      Msg : SpaceWire.HLInterface.Transmitter_Data_Packet_Type
        (1 .. SpaceWire.HLInterface.Transmitter_Packet_Data_Size_Type (Size));
      pragma Import (Ada, Msg);
      for Msg'Address use Message'Address;

   begin
      Put_Line ("Using user-provided SpaceWire stack to send");
      Put_Line ("Sending through Spacewire core #"
                  & Nodes (My_Node).SpaceWire_Core_Send'Img
                  & " to address"
                  & Nodes (Node).SpaceWire_Core_Receive'Img);

      SpaceWire.HLInterface.Send
        (Device   => Nodes (My_Node).SpaceWire_Core_Send,
         Address  =>
           Interfaces.Unsigned_8 (Nodes (Node).SpaceWire_Core_Receive),
         Data     => Msg,
         Blocking => False);

      return Error_Kind'(Error_None);
      --  Note: we have no way to no there was an error here
   end Send;

end GRSPW;
