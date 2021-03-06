------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                  P O L Y O R B _ H I . M E S S A G E S                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2006-2009 Telecom ParisTech,                 --
--                 2010-2019 ESA & ISAE, 2019-2021 OpenAADL                 --
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

--  Definition of the messages exchanged by PolyORB HI partitions

with PolyORB_HI.Streams;
with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Messages
    with SPARK_Mode => On
is

   use PolyORB_HI.Streams;
   use PolyORB_HI_Generated.Deployment;

   type Message_Type is private;
   --  Base type of messages exchanged between nodes

   Empty_Message : constant Message_Type;

   Message_Length_Size : constant := 2;
   --  Number of bytes to store a message size

   Header_Size : constant := Message_Length_Size + 2;
   --  Size of the header (see the documentation in the body for
   --  details on the header internal structure).

   PDU_Size : constant := Header_Size + (Max_Payload_Size / 8) + 1;
   --  Maximum size of a request

   subtype PDU_Index is Stream_Element_Count range 0 .. PDU_Size;
   subtype PDU is Stream_Element_Array (1 .. PDU_Index'Last);

   Empty_PDU : constant PDU := (others => 0);

   subtype Message_Size_Buffer is Stream_Element_Array
     (1 .. Message_Length_Size);
   --  The sub-buffer that holds the message length

   function To_Length (B : Message_Size_Buffer) return Stream_Element_Count;
   function To_Buffer (L : Stream_Element_Count) return Message_Size_Buffer
     with Pre => (L < 2**16 -1); -- XXX Provide a better bound for L
   --  Conversion functions to store/extract a length in/from a sub-buffer.

   function Length (M : Message_Type) return PDU_Index;
   function Size (M : Message_Type) return Stream_Element_Count
        with Pre => (Valid (M));
   --  Return length of message M

   procedure Read
     (Stream : in out Message_Type;
      Item   : in out Stream_Element_Array;
      Last   :    out Stream_Element_Offset)
     with Pre => (Valid (Stream) and then Valid (Item));
   --  Move Item'Length stream elements from the specified stream to
   --  fill the array Item. The index of the last stream element
   --  transferred is returned in Last. Last is less than Item'Last
   --  only if the end of the stream is reached.

   procedure Write
     (Stream : in out Message_Type;
      Item   :        Stream_Element_Array)
     with Pre => (Valid (Stream) and then
                    Valid (Item) and then
                    Size (Stream) + Item'Length <= PDU_Size + Header_Size),
          Post => (Valid (Stream));
   --  Append Item to the specified stream

   procedure Reallocate (M : out Message_Type)
     with Post => (Valid (M));
   --  Reset M

   function Is_Empty (M: Message_Type) return Boolean
     with Pre => (Valid (M));

   function Not_Empty (M: Message_Type) return Boolean
     with Pre => (Valid (M));

   function Payload (M : Message_Type) return Stream_Element_Array
   with Pre => (Valid (M) and then not Is_Empty (M)),
        Post => (Payload'Result'Length = Length (M));
   --  Return the remaining payload of message M

   function Sender (M : Stream_Element_Array) return Entity_Type
     with Pre =>(M'First = 1 and M'Last >= Header_Size);
   --  Return the sender of the message M

   procedure Encapsulate
     (Message : Message_Type;
      From    : Entity_Type;
      Entity  : Entity_Type;
      R : in out Stream_Element_Array)
     with Pre => (Valid (R) and then R'First = 1 and then
                    Valid (Message) and then not Is_Empty (Message) and then
                    R'Length >= Length (Message) + Header_Size),
          Post => (Valid (R));
   --  Return a byte array including a two byte header (length and
   --  originator entity) and Message payload.

   function Valid (Message : Message_Type) return Boolean;

   function Valid (S : Stream_Element_Array) return Boolean is
     (S'First >= 1 and then S'Length <= PDU_Size + Header_Size);

   function Full_Message (S : Stream_Element_Array) return Boolean is
     (S'First = 1 and then S'Last >= Header_Size
     and then S'Length <= PDU_Size + Header_Size);

private

   type Message_Type is record
      Content : PDU := Empty_PDU;
      First   : PDU_Index := 1;
      Last    : PDU_Index := 0;
   end record with Dynamic_Predicate =>
     (Message_Type = (Empty_PDU, 1, 0) or else
        (Message_Type.First >= Message_Type.Content'First
           and then Message_Type.Last <= Message_Type.Content'Last
           and then Message_Type.First <= Message_Type.Last));

   Empty_Message : constant Message_Type :=
     Message_Type'(Content => Empty_PDU, First => 1, Last => 0);

   function Valid (Message : Message_Type) return Boolean is
     (Message = Empty_Message or else
        (Message.First >= Message.Content'First
           and then Message.Last <= Message.Content'Last
           and then Message.First <= Message.Last));

   function Size (M : Message_Type) return Stream_Element_Count is
      (Length (M) + Header_Size);

   function Length (M : Message_Type) return PDU_Index is
      (if M = Empty_Message then 0 else (M.Last - M.First) + 1);
   --  Return length of message M

   function Is_Empty (M: Message_Type) return Boolean is
      (M = Empty_Message);

   function Not_Empty (M: Message_Type) return Boolean is
      (M /= Empty_Message and then Size (M) >= 1);

   function Payload (M : Message_Type) return Stream_Element_Array is
      (M.Content (M.First .. M.Last));

   pragma Inline (To_Length);
   pragma Inline (To_Buffer);

end PolyORB_HI.Messages;
