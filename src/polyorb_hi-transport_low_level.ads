------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--       P O L Y O R B _ H I . T R A N S P O R T _ L O W _ L E V E L        --
--                                                                          --
--                                 S p e c                                  --
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

--  Transport low-level service of PolyORB HI, interact with actual
--  transport interface.

with PolyORB_HI.Errors;
with PolyORB_HI.Streams;
with PolyORB_HI_Generated.Deployment;

package PolyORB_HI.Transport_Low_Level is
   pragma SPARK_Mode (Off);
   --  SPARK_Mode is disabled for this unit, it relies on OS-specific
   --  libraries. We discard this unit for now.

   pragma Elaborate_Body;

   use PolyORB_HI.Errors;
   use PolyORB_HI.Streams;
   use PolyORB_HI_Generated.Deployment;

   procedure Initialize;
   --  Initialize Transport facility

   function Send (Node : Node_Type; Message : Stream_Element_Array)
     return Error_Kind;
   --  Send Message

end PolyORB_HI.Transport_Low_Level;
