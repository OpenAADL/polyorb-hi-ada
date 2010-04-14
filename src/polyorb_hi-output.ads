------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                    P O L Y O R B _ H I . O U T P U T                     --
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

--  Debug facility of PolyORB HI

with PolyORB_HI.Streams;

package PolyORB_HI.Output is
   pragma Elaborate_Body;

   use PolyORB_HI.Streams;

   type Verbosity is
     (Verbose,
      --  Developer interest only, should never be displayed
      --  in a production environment.

      Normal,
      --  Informational message indicating progress of normal
      --  operation.

      Error
      --  Indication that an abnormal condition has been identified
      );

   Current_Mode : constant Verbosity := Normal;
   --  Curent debug level

   procedure Put_Line (Mode : in Verbosity := Normal; Text : in String);
   --  Display Text iff Mode is greater than Current_Mode. This
   --  routine is thread-safe.

   procedure Put_Line (Text : in String);
   --  As above but displays the message reguards less the mode

   procedure Unprotected_Put_Line (Text : in String);
   --  As above but this routine is not thread-safe

   procedure Put (Mode : in Verbosity := Normal; Text : in String);
   --  Display Text iff Mode is greater than Current_Mode. This
   --  routine is thread-safe.

   procedure Put (Text : in String);
   --  As above but displays the message reguards less the mode

   procedure Unprotected_Put (Text : in String);
   --  As above but this routine is not thread-safe

   procedure Dump (Stream : Stream_Element_Array; Mode : Verbosity := Verbose);
   --  Dump the content of Stream in an hexadecimal format

private

   pragma Inline (Put_Line);
   pragma Inline (Unprotected_Put_Line);

end PolyORB_HI.Output;
