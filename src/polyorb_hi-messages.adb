------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                  P O L Y O R B _ H I . M E S S A G E S                   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--    Copyright (C) 2006-2009 Telecom ParisTech, 2010-2013 ESA & ISAE.      --
--                                                                          --
-- PolyORB HI is free software; you  can  redistribute  it and/or modify it --
-- under terms of the GNU General Public License as published by the Free   --
-- Software Foundation; either version 2, or (at your option) any later.    --
-- PolyORB HI is distributed  in the hope that it will be useful, but       --
-- WITHOUT ANY WARRANTY;  without even the implied warranty of              --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General --
-- Public License for more details. You should have received  a copy of the --
-- GNU General Public  License  distributed with PolyORB HI; see file       --
-- COPYING. If not, write  to the Free  Software Foundation, 51 Franklin    --
-- Street, Fifth Floor, Boston, MA 02111-1301, USA.                         --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
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
   function Internal_To_Buffer is new Ada.Unchecked_Conversion
     (Wrapper, Message_Size_Buffer);

   --  The message header offsets. Must be synchronized with the
   --  header size.

   Receiver_Offset : constant Stream_Element_Offset := Message_Length_Size + 1;
   Sender_Offset   : constant Stream_Element_Offset := Message_Length_Size + 2;

   function Length (M : Message_Type) return PDU_Index;
   --  Return length of message M

   -----------------
   -- Encapsulate --
   -----------------

   function Encapsulate
     (Message : Message_Type;
      From    : Entity_Type;
      Entity  : Entity_Type)
     return Stream_Element_Array
   is
      L : constant Stream_Element_Count := Message.Last + Header_Size;
      R : Stream_Element_Array (1 .. L);
   begin
      R (1 .. Message_Length_Size) := To_Buffer (L - 1);
      R (Receiver_Offset) := Stream_Element (Internal_Code (Entity));
      R (Sender_Offset)   := Stream_Element (Internal_Code (From));
      R (Header_Size +  1 .. Header_Size + Message.Last)
        := Message.Content (Message.First .. Message.Last);

      return R;
   end Encapsulate;

   ------------
   -- Length --
   ------------

   function Length (M : Message_Type) return PDU_Index is
   begin
      if M.First >= 1
        and then M.Last - M.First >= 0
      then
         return M.Last - M.First + 1;
      else
         return 0; --  XXX defensive
      end if;
   end Length;

   -------------
   -- Payload --
   -------------

   function Payload (M : Message_Type) return Stream_Element_Array is
   begin
      return M.Content (M.First .. M.Last);
   end Payload;

   ------------
   -- Sender --
   ------------

   function Sender (M : Message_Type) return Entity_Type is
   begin
      return Sender (M.Content (M.First .. M.Last));
   end Sender;

   function Sender (M : Stream_Element_Array) return Entity_Type is
   begin
      return Corresponding_Entity (Unsigned_8 (M (Sender_Offset)));
   end Sender;

   ----------
   -- Read --
   ----------

   procedure Read
     (Stream : in out Message_Type;
      Item   :    out Stream_Element_Array;
      Last   :    out Stream_Element_Offset)
   is
      Read_Elts : constant Stream_Element_Count
        := Stream_Element_Count'Min (Item'Length, Length (Stream));
   begin
      if Read_Elts < 1 then
         --  We have nothing to read, exit
         Last := 0;
         return;
      elsif Read_Elts = Item'Length then
         Last := Item'Last;
      else
         Last := Item'First + Read_Elts - 1;
      end if;

      Item (Item'First .. Last)
        := Stream.Content (Stream.First .. Stream.First + Read_Elts - 1);

      if Stream.First + Read_Elts < Stream.Content'Last then
         Stream.First := Stream.First + Read_Elts;
      else
         Stream.First := 0;
      end if;
   end Read;

   ----------------
   -- Reallocate --
   ----------------

   procedure Reallocate (M : in out Message_Type) is
   begin
      M.First := 1;
      M.Last  := 0;
   end Reallocate;

   -----------
   -- Write --
   -----------

   procedure Write
     (Stream : in out Message_Type;
      Item   :        Stream_Element_Array)
   is
   begin
      if Stream.First > Stream.Last then
         -- The message is invalid, we reset it

         Stream.First := 1;
         Stream.Last := 0;
      end if;

      if Item'Length <= Stream.Content'Last - Stream.Last then
         Stream.Content (Stream.Last + 1 .. Stream.Last + Item'Length) := Item;
         Stream.Last := Stream.Last + Item'Length;
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
