------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                     P O L Y O R B _ H I . U T I L S                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2007-2009 Telecom ParisTech,                 --
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

---
--  # PolyORB_HI.Utils { #sec:pohi_utils }
--
--  This package contains some utility routines used by PolyORB-HI
--

with Ada.Unchecked_Conversion;
with Interfaces;
with System;

with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Utils
    with SPARK_Mode => On
is

   use Interfaces;
   use PolyORB_HI_Generated.Deployment;

   ---
   -- ## Low-level marshallers
   --
   --  These subprograms allow to get the proper enumerator depending
   --  on their internal codes specified as representation clause in
   --  the deployment package.
   --
   --  Note:
   --
   --  1. these converters require that the size of the various
   --  enumerators be fixed to be 8 bit. This requirement is enforced
   --  in PolyORB_HI_Generated.Deployment.
   --  2. these converters must be
   --  endianness-independent

   ---
   -- ### $Entity\_Type \leftrightarrow Unsigned\_8$ mapping
   --
   --  These functions map Entity_Type to Unsigned_8 and reverse
   --
   --  $Internal\_Code : Entity\_Type \mapsto Unsigned\_8$
   --
   --  $Corresponding\_Entity :  : Unsigned\_8 \mapsto Entity\_Type$
   --
   --  These functions rely on `Ada.Unchecked_Conversion` to map an
   --  `Entity_Type` enumerator to its underlying representation.
   --
   --  Note: these functions assume the corresponding data has not
   --  been corrupted during transport.
   --
   function Internal_Code is new Ada.Unchecked_Conversion
     (Entity_Type, Unsigned_8);
   pragma Annotate (GNATProve, Intentional, "type", "reviewed");
   --  SPARKWAG: Uncheck_Conversion

   function Corresponding_Entity is new Ada.Unchecked_Conversion
     (Unsigned_8, Entity_Type);
   pragma Annotate (GNATProve, Intentional, "type", "reviewed");
   --  SPARKWAG: Uncheck_Conversion

   ---
   -- ### $Node\_Type \leftrightarrow Unsigned\_8$ mapping
   --
   --  These functions map Node_Type to Unsigned_8 and reverse
   --
   --  $Internal\_Code : Node\_Type \mapsto Unsigned\_8$
   --
   --  $Corresponding\_Node :  : Unsigned\_8 \mapsto Node\_Type$
   --
   --  These functions rely on `Ada.Unchecked_Conversion` to map an
   --  `Node_Type` enumerator to its underlying representation.
   --
   --  Note: these functions assume the corresponding data has not
   --  been corrupted during transport.
   --
   function Internal_Code is new Ada.Unchecked_Conversion
     (Node_Type, Unsigned_8);
   pragma Annotate (GNATProve, Intentional, "type", "reviewed");
   --  SPARKWAG: Uncheck_Conversion

   function Corresponding_Node is new Ada.Unchecked_Conversion
     (Unsigned_8, Node_Type);
   pragma Annotate (GNATProve, Intentional, "type", "reviewed");
   --  SPARKWAG: Uncheck_Conversion

   ---
   --  ## Swap_Bytes operator
   --
   --  Swap bytes iff the host is little endian. This function is
   --  notionnally equivalent to htons().
   --

   function Swap_Bytes
     (B : Interfaces.Unsigned_16)
     return Interfaces.Unsigned_16;

   ---
   -- ## HI_String type
   --
   -- Basic bounded string type. This type has been defined to avoid
   --  dragging the full `Ada.String.Bounded` package.

   HI_String_Size : constant := 80;

   type HI_String is private;

   ---
   --  ### `Valid` predicate
   --
   --  Returns true iff. `H` is a valid `HI_String`
   function Valid (H : HI_String) return Boolean;

   ---
   --  ### `To_HI_String`
   --
   --  Map an Ada string to a HI_String

   function To_Hi_String (S : String) return HI_String
     with Post => (Valid (To_Hi_String'Result));

   ---
   --  ### `To_String`
   --
   --  Map a HI_String to an Ada string

   function To_String (H : HI_String) return String
     with Pre => (Valid (H));

   ---
   --  ### `Length`
   --
   --  Return the length of `H`

   function Length (H : HI_String) return Natural
     with Pre => (Valid (H));

   ---
   --  ### `Parse_String`
   --
   --  Return index of the character just before Delimiter, or return S'last

   function Parse_String (S : String; First : Integer; Delimiter : Character)
                         return Integer
     with Pre => (First >= S'First and First <= S'Last);
   --  XXX GNATProve GPL2014 cannot prove this, TBI
   --            Post => ((Parse_String'Result = S'Last)
   --                     or (Parse_String'Result in S'Range
   --                           and then Parse_String'Result > S'First
   --                           and then S (Parse_String'Result - 1) = Delimiter));


   ---
   -- ## Naming Table
   --

   type Naming_Entry is record
      Location : PolyORB_HI.Utils.HI_String;
      Port     : Natural;
      Variable : System.Address;
   end record;

   type Naming_Table_Type is array (Node_Type'Range)
     of PolyORB_HI.Utils.Naming_Entry;

   ---
   -- ## Task_Id mapping
   --

   procedure Set_Task_Id (My_Id : Entity_Type);
   function Get_Task_Id return Entity_Type with Volatile_Function;

private

   type HI_String is record
      S : String (1 .. HI_String_Size);
      L : Natural;
      --  It is exepected L <= HI_String_Size
      --  XXX Todo add a type invariant
   end record;

   function Length (H : HI_String) return Natural is
      (H.L);

   function Valid (H : HI_String) return Boolean is
      (H.L <= HI_String_Size);

   function To_String (H : HI_String) return String is
      (H.S (1 .. H.L));

end PolyORB_HI.Utils;
