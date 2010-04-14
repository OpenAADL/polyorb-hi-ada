------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                           R E P O S I T O R Y                            --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--               Copyright (C) 2007-2008, GET-Telecom Paris.                --
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

with PolyORB_HI_Generated.Types;      use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Activity;   use PolyORB_HI_Generated.Activity;
with PolyORB_HI_Generated.Deployment; use PolyORB_HI_Generated.Deployment;

package Repository is

   procedure Init_Raiser;
   procedure Init_Worker;

   procedure Raiser (M : out Simple_Type);
   --  Raise a message M

   procedure Normal_Handler (M : Simple_Type);
   procedure Emergency_Handler (M : Simple_Type);
   procedure Lazy_Handler (M : Simple_Type);
   procedure CE_Normal_Handler
     (Entity : Entity_Type;
      P      : Worker_Impl_Port_Type);
   procedure CE_Emergency_Handler
     (Entity : Entity_Type;
      P      : Worker_Impl_Port_Type);
   procedure CE_Lazy_Handler
     (Entity : Entity_Type;
      P      : Worker_Impl_Port_Type);
   --  Handle a received message

   procedure Drive (Entity : Entity_Type);
   --  Raise an event depending on the cycle number
end Repository;
