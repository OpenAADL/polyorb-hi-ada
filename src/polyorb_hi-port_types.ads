------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                P O L Y O R B _ H I . P O R T _ T Y P E S                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2017-2019 ESA & ISAE, 2019-2020 OpenAADL           --
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

with PolyORB_HI_Generated.Deployment; use PolyORB_HI_Generated.Deployment;
with Interfaces; use Interfaces;

package PolyORB_HI.Port_Types
    with SPARK_Mode => On
is

   function Internal_Code (P : Port_Type) return Unsigned_16;
   function Corresponding_Port (I : Unsigned_16) return Port_Type;

   type Destinations_Array is array (Standard.Positive range <>)
     of PolyORB_HI_Generated.Deployment.Port_Type;

   Empty_Destination : constant Destinations_Array (1 .. 0)
     := (others => Port_Type'First);

end PolyORB_HI.Port_Types;
