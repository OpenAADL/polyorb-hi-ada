------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                     P O L Y O R B _ H I . U T I L S                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2007-2010, GET-Telecom Paris.                --
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

--  This package contains some utility routines used by PolyORB-HI

with Interfaces;
with PolyORB_HI_Generated.Deployment;

with Ada.Unchecked_Conversion;

package PolyORB_HI.Utils is

   pragma Preelaborate;

   use Interfaces;
   use PolyORB_HI_Generated.Deployment;

   ---------------------------
   -- Low-level marshallers --
   ---------------------------

   --  These subprograms allow to get the proper enumerator depending
   --  on their internal codes specified as representation clause in
   --  the deployment package.
   --
   --  Note:
   --  1) these converters require that the size of the various
   --  enumerators be fixed to either 8 or 16 bits. This requirement
   --  is enforced in the PolyORB_HI_Generated.Deployment package
   --  spec.
   --  2) these converters must be endianness-independent

   function Internal_Code is new Ada.Unchecked_Conversion
     (Entity_Type, Integer_8);
   function Corresponding_Entity is new Ada.Unchecked_Conversion
     (Integer_8, Entity_Type);

   function Internal_Code is new Ada.Unchecked_Conversion
     (Node_Type, Integer_8);
   function Corresponding_Node is new Ada.Unchecked_Conversion
     (Integer_8, Node_Type);

   function Internal_Code (P : Port_Type) return Unsigned_16;
   function Corresponding_Port (I : Unsigned_16) return Port_Type;

   function Swap_Bytes (B : Interfaces.Unsigned_16)
                       return Interfaces.Unsigned_16;
   --  Swap bytes iff the host is little endian. This function is
   --  notionnally equivalent to htons().

   ------------
   -- String --
   ------------

   type HI_String is record
      S : String (1 .. 16);
      L : Natural;
   end record;

   function To_Hi_String (S : String) return HI_String;
   function To_String (H : HI_String) return String;

   ------------------
   -- Naming Table --
   ------------------

   type Naming_Entry is record
      Location : PolyORB_HI.Utils.HI_String;
      Port : Natural;
   end record;

   type Naming_Table_Type is array (Node_Type'Range)
     of PolyORB_HI.Utils.Naming_Entry;

end PolyORB_HI.Utils;
