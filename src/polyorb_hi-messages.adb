------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                  P O L Y O R B _ H I . M E S S A G E S                   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2006-2009 Telecom ParisTech,                 --
--                 2010-2019 ESA & ISAE, 2019-2020 OpenAADL                 --
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
--              PolyORB-HI/Ada is maintained by the OpenAADL team           --
--                             (info@openaadl.org)                          --
--                                                                          --
------------------------------------------------------------------------------

with Interfaces;
with PolyORB_HI.Utils;
with Ada.Unchecked_Conversion;

package body PolyORB_HI.Messages is

   use PolyORB_HI.Utils;
   use Interfaces;

   --  Message format:
   --  - the first byte is set to the message length,
   --  - the second one is the destination entity (Thread),
   --  - the third one is the sender entity (Thread),
   --  - other bytes are the message payload.

   type Wrapper is new Stream_Element_Count range
     0 .. 2 ** (8 * Message_Length_Size) - 1;
   for Wrapper'Size use Message_Length_Size * 8;

   function Internal_To_Length is new Ada.Unchecked_Conversion
     (Message_Size_Buffer, Wrapper);
   pragma Annotate (GNATProve, Intentional, "type", "reviewed"); --  SPARKWAG: Uncheck_Conversion

   function Internal_To_Buffer is new Ada.Unchecked_Conversion
     (Wrapper, Message_Size_Buffer);
   pragma Annotate (GNATProve, Intentional, "type", "reviewed"); --  SPARKWAG: Uncheck_Conversion

   --  The message header offsets. Must be synchronized with the
   --  header size.

   Receiver_Offset : constant Stream_Element_Offset := Message_Length_Size + 1;
   Sender_Offset   : constant Stream_Element_Offset := Message_Length_Size + 2;

   -----------------
   -- Encapsulate --
   -----------------

   procedure Encapsulate
     (Message : Message_Type;
      From    : Entity_Type;
      Entity  : Entity_Type;
      R : in out Stream_Element_Array)
   is
      L : constant Stream_Element_Count := Message.Last + Header_Size;

      P : Stream_Element_Array renames
        Message.Content (Message.First .. Message.Last);

   begin
      R (1 .. Message_Length_Size) := To_Buffer (L - 1);
      R (Receiver_Offset) := Stream_Element (Internal_Code (Entity));
      R (Sender_Offset)   := Stream_Element (Internal_Code (From));
      if Length (Message) > 0 then
         R (Header_Size +  1 .. Header_Size + Length (Message)) := P;
      end if;
   end Encapsulate;

   ------------
   -- Sender --
   ------------

   function Sender (M : Stream_Element_Array) return Entity_Type is
   begin
      return Corresponding_Entity (Unsigned_8 (M (Sender_Offset)));
   end Sender;

   ----------
   -- Read --
   ----------

   procedure Read
     (Stream : in out Message_Type;
      Item   : in out Stream_Element_Array;
      Last   :    out Stream_Element_Offset)
   is
      Read_Elts : constant Stream_Element_Count
        := Stream_Element_Count'Min (Item'Length, Length (Stream));
   begin
      Item := (others => 0);

      if Read_Elts < 1 then
         --  We have nothing to read, exit
         Last := 0;
         return;
      elsif Read_Elts = Item'Length then
         Last := Item'Last;
      else
         Last := Item'First + (Read_Elts - 1);
      end if;

      Item (Item'First .. Last)
        := Stream.Content (Stream.First .. Stream.First + (Read_Elts - 1));

      if Stream.First + Read_Elts < Stream.Last then
         Stream.First := Stream.First + Read_Elts;
      else
         Stream.First := Stream.Last;
      end if;
   end Read;

   ----------------
   -- Reallocate --
   ----------------

   procedure Reallocate (M : out Message_Type) is
   begin
      M := Empty_Message;
   end Reallocate;

   -----------
   -- Write --
   -----------

   procedure Write
     (Stream : in out Message_Type;
      Item   :        Stream_Element_Array)
   is
   Current_Index : Stream_Element_Offset;
   begin
      if Stream.First > Stream.Last then
         Reallocate (Stream);
         -- The message is invalid, we reset it
         -- XXX Do we need to do that ???
      end if;

      Current_Index := Stream.Last;

      if Item'Length <= Stream.Content'Last - Stream.Last then
         --  Operations should be in this order to preserve the
         --  dynamic predicate on Message_Type
         Stream.Last := Stream.Last + Item'Length;
         Stream.Content (Current_Index + 1 .. Current_Index + Item'Length)
           := Item;

      end if;
   end Write;

   ---------------
   -- To_Length --
   ---------------

   function To_Length (B : Message_Size_Buffer) return Stream_Element_Count is
   begin
      return Stream_Element_Count
        (Swap_Bytes
           (Interfaces.Unsigned_16 (Internal_To_Length (B))));
   end To_Length;

   ---------------
   -- To_Buffer --
   ---------------

   function To_Buffer (L : Stream_Element_Count) return Message_Size_Buffer is
   begin
      return Internal_To_Buffer
        (Wrapper (Swap_Bytes (Interfaces.Unsigned_16 (L))));
   end To_Buffer;

end PolyORB_HI.Messages;
