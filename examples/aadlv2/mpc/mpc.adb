------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                                  M P C                                   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2009, GET-Telecom Paris.                   --
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

--  $Id: mpc.adb 6273 2009-03-25 17:36:51Z lasnier $

with PolyORB_HI.Output;
with PolyORB_HI_Generated.Deployment;

package body MPC is

   use PolyORB_HI.Output;
   use PolyORB_HI_Generated.Deployment;

   The_Observed_Object : Record_Type_Impl := (10, 13, 16);

   function Get_Node return String;
   pragma Inline (Get_Node);

   procedure Put_Line (M : String);
   pragma Inline (Put_Line);

   function Image (X : Component_Type) return String;
   pragma Inline (Image);

   function Image (R : Record_Type_Impl) return String;
   pragma Inline (Image);

   --------------
   -- Get_Node --
   --------------

   function Get_Node return String is
   begin
      return Node_Type'Image (My_Node);
   end Get_Node;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line (M : String) is
   begin
      Put_Line (Normal, Get_Node & ": " & M);
   end Put_Line;

   -----------
   -- Image --
   -----------

   function Image (X : Component_Type) return String is
      Img   : constant String := Component_Type'Image (X);
      Img_T : constant String (Img'First + 1 .. Img'Last)
        := Img (Img'First + 1 .. Img'Last);
   begin
      if Img (Img'First) /= ' ' then
         return Img;
      else
         return Img_T;
      end if;
   end Image;

   -----------
   -- Image --
   -----------

   function Image (R : Record_Type_Impl) return String is
   begin
      return "(" & Image (R.X) & ", " & Image (R.Y) & ", " & Image (R.Z) & ")";
   end Image;

   ------------
   -- Update --
   ------------

   procedure Update
     (Update_Value :        Record_Type_Impl;
      X            : in out Component_Type;
      Y            : in out Component_Type;
      Z            : in out Component_Type)
   is
   begin
      Put_Line ("Updating the local object.");
      X := Update_Value.X;
      Y := Update_Value.Y;
      Z := Update_Value.Z;
      Put_Line ("Local object updated. New value " & Image (Update_Value));
   end Update;

   ----------
   -- Read --
   ----------

   procedure Read
     (Read_Value :    out Record_Type_Impl;
      X          : in out Component_Type;
      Y          : in out Component_Type;
      Z          : in out Component_Type)
   is
      pragma Warnings (Off, X);
      pragma Warnings (Off, Y);
      pragma Warnings (Off, Z);
      --  To kill warning "mode could be "in" instead of "in out"

   begin
      Put_Line ("Reading the local object");
      Read_Value := (X, Y, Z);
      Put_Line ("Read value " & Image (Read_Value));
   end Read;

   --------------------
   -- Observe_Object --
   --------------------

   procedure Observe_Object (Data_Source : out Record_Type_Impl) is
   begin
      Data_Source := The_Observed_Object;
      Put_Line ("Order to set the local object to " & Image (Data_Source));
      The_Observed_Object.X := The_Observed_Object.X + 1;
      The_Observed_Object.Y := The_Observed_Object.Y + 2;
      The_Observed_Object.Z := The_Observed_Object.Z + 3;
   end Observe_Object;

   ------------------------
   -- Watch_Object_Value --
   ------------------------

   procedure Watch_Object_Value (Read_Value : Record_Type_Impl) is
   begin
      Put_Line ("Watched " & Image (Read_Value));
   end Watch_Object_Value;

end MPC;
