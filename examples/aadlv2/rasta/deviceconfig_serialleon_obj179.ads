------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--       D E V I C E C O N F I G _ S E R I A L L E O N _ O B J 1 7 9        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                     Copyright (C) 2015 ESA & ISAE.                       --
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
--              PolyORB-HI/Ada is maintained by the TASTE project           --
--                      (taste-users@lists.tuxfamily.org)                   --
--                                                                          --
------------------------------------------------------------------------------

WITH Ada.Strings.Fixed;
USE ADA.Strings.Fixed;

WITH Interfaces;
USE Interfaces;

WITH Ada.Characters.latin_1;


WITH AdaAsn1RTL;
USE AdaAsn1RTL;
with POHICDRIVER_UART;
use POHICDRIVER_UART;

package DeviceConfig_serialleon_obj179 is



pohidrv_serialleon_obj179_cv:aliased Serial_Conf_T:=(devname => "/dev/apburasta0" & 5*Character'Val(0) & Character'Val(0),
speed => b38400,
parity => even,
bits => 7,
use_paritybit => FALSE,
exist => (speed => 1, parity => 0, bits => 0, use_paritybit => 0));

--END;
end DeviceConfig_serialleon_obj179;
