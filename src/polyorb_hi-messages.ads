------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                  P O L Y O R B _ H I . M E S S A G E S                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2006-2008, GET-Telecom Paris.                --
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

--  Definition of the messages exchanged by PolyORB HI partitions

with PolyORB_HI.Streams;
with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Messages is

   pragma Preelaborate;

   use PolyORB_HI.Streams;
   use PolyORB_HI_Generated.Deployment;

   type Message_Type is private;
   --  Base type of messages exchanged between nodes

   Invalid_Message : constant Message_Type;

   Message_Length_Size : constant := 2;
   --  Number of bytes to store a message size

   Header_Size : constant := Message_Length_Size + 2;
   --  Size of the header (see the documentation in the body for
   --  details on the header internal structure).

   PDU_Size : constant := Header_Size + (Max_Payload_Size / 8) + 1;
   --  Maximum size of a request

   subtype Message_Size_Buffer is Stream_Element_Array
     (1 .. Message_Length_Size);
   --  The sub-buffer that holds the message length

   function To_Length (B : Message_Size_Buffer) return Stream_Element_Count;
   function To_Buffer (L : Stream_Element_Count) return Message_Size_Buffer;
   --  Conversion functions to store/extract a length in/from a sub-buffer.

   procedure Read
     (Stream : in out Message_Type;
      Item   :    out Stream_Element_Array;
      Last   :    out Stream_Element_Offset);
   --  Move Item'Length stream elements from the specified stream to
   --  fill the array Item. The index of the last stream element
   --  transferred is returned in Last. Last is less than Item'Last
   --  only if the end of the stream is reached.

   procedure Write
     (Stream : in out Message_Type;
      Item   :        Stream_Element_Array);
   --  Append Item to the specified stream

   procedure Reallocate (M : in out Message_Type);
   --  Reset M

   function Length (M : Message_Type) return Stream_Element_Count;
   --  Return length of message M

   function Payload (M : Message_Type) return Stream_Element_Array;
   --  Return the remaining payload of message M

   function Sender (M : Message_Type) return Entity_Type;
   function Sender (M : Stream_Element_Array) return Entity_Type;
   --  Return the sender of the message M

   function Encapsulate
     (Message : Message_Type;
      From    : Entity_Type;
      Entity  : Entity_Type)
     return Stream_Element_Array;
   --  Return a byte array including a two byte header (length and
   --  originator entity) and Message payload.

private

   type Message_Type is record
      Content : Stream_Element_Array (1 .. PDU_Size);
      First   : Stream_Element_Count := 1;
      Last    : Stream_Element_Count := 0;
   end record;

   Invalid_Message : constant Message_Type :=
     (Content => (1 .. PDU_Size => Stream_Element (0)),
      First   => 1,
      Last    => 0);

   pragma Inline (To_Length);
   pragma Inline (To_Buffer);

end PolyORB_HI.Messages;
