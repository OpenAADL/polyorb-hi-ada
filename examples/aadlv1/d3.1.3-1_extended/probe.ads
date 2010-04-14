------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                                P R O B E                                 --
--                                                                          --
--                                 S p e c                                  --
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

--  $Id: probe.ads 5381 2007-12-23 12:39:41Z zalila $

--  This package implements all the subprograms of the GNC/TMTC/POS/GP
--  extended toy example AADL model.

with PolyORB_HI_Generated.Types; use PolyORB_HI_Generated.Types;

package Probe is

   procedure Read
     (Read_Value :    out POS_Internal_Type;
      Field      : in out POS_Internal_Type);
   procedure Update (Field : in out POS_Internal_Type);

   procedure GNC_Job;
   procedure TMTC_Job;

   procedure GNC_Identity;
   procedure TMTC_Identity;
   --  At the first call, these subprogram print a welcome message. At
   --  the second call they print a "good bye" message.

   procedure Send_Spg
     (Sent_Data   :     POS_Internal_Type;
      Data_Source : out POS_Internal_Type);
   procedure Receive_Spg (Data_Sink : POS_Internal_Type);

end Probe;
