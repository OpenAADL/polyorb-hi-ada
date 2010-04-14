------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                  P O L Y O R B _ H I . M E S S A G E S                   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2006-2007, GET-Telecom Paris.                --
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
--                PolyORB HI is maintained by GET Telecom Paris             --
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

   -----------------
   -- Encapsulate --
   -----------------

   function Encapsulate
     (Message : Message_Type;
      From    : Entity_Type;
      Entity  : Entity_Type)
     return Stream_Element_Array
   is
      L : constant Stream_Element_Count := Length (Message) + Header_Size;
      R : Stream_Element_Array (1 .. L);
   begin
      R (1 .. Message_Length_Size) := To_Buffer (L - 1);
      R (Receiver_Offset) := Stream_Element (Internal_Code (Entity));
      R (Sender_Offset)   := Stream_Element (Internal_Code (From));

      for J in 1 .. Length (Message) loop
         R (Header_Size + J) := Message.Content (J);
      end loop;

      return R;
   end Encapsulate;

   ------------
   -- Length --
   ------------

   function Length (M : Message_Type) return Stream_Element_Count is
   begin
      return M.Last + 1 - M.First;
   end Length;

   -------------
   -- Payload --
   -------------

   function Payload (M : Message_Type) return Stream_Element_Array is
      Payload : Stream_Element_Array (M.First .. M.Last);
   begin
      for J in M.First .. M.Last loop
         Payload (J) := M.Content (J);
      end loop;

      return Payload;
   end Payload;

   ------------
   -- Sender --
   ------------

   function Sender (M : Message_Type) return Entity_Type is
   begin
      return Sender (M.Content (M.First .. M.Last));
   end Sender;

   ------------
   -- Sender --
   ------------

   function Sender (M : Stream_Element_Array) return Entity_Type is
   begin
      return Corresponding_Entity (Integer_8 (M (Sender_Offset)));
   end Sender;

   ----------
   -- Read --
   ----------

   procedure Read
     (Stream : in out Message_Type;
      Item   :    out Stream_Element_Array;
      Last   :    out Stream_Element_Offset)
   is
      L1 : constant Stream_Element_Count := Item'Length;
      L2 : Stream_Element_Count := Length (Stream);
   begin
      if L1 < L2 then
         L2 := L1;
      end if;

      for J in 0 .. L2 - 1 loop
         Item (Item'First + J) := Stream.Content (Stream.First + J);
      end loop;

      Last := Item'First + L2 - 1;
      Stream.First := Stream.First + L2;
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
         Stream.First := 1;
         Stream.Last := 0;
      end if;

      for J in Item'Range loop
         Stream.Content (Stream.Last
                         + Stream_Element_Offset (J - Item'First + 1))
           := Item (J);
      end loop;

      Stream.Last := Stream.Last + Item'Length;
   end Write;

   ---------------
   -- To_Length --
   ---------------

   function To_Length (B : Message_Size_Buffer) return Stream_Element_Count is
   begin
      return Stream_Element_Count
        (Swap_Bytes
           (Interfaces.Integer_16 (Internal_To_Length (B))));
   end To_Length;

   ---------------
   -- To_Buffer --
   ---------------

   function To_Buffer (L : Stream_Element_Count) return Message_Size_Buffer is
   begin
      return Internal_To_Buffer
        (Wrapper (Swap_Bytes (Interfaces.Integer_16 (L))));
   end To_Buffer;

end PolyORB_HI.Messages;
