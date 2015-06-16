------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                               P R I M E S                                --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--       Copyright (C) 2009 Telecom ParisTech, 2010-2015 ESA & ISAE.        --
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

--  $Id: primes.ads 6273 2009-03-25 17:36:51Z lasnier $

with PolyORB_HI_Generated.Types;      use PolyORB_HI_Generated.Types;
with PolyORB_HI_Generated.Deployment; use PolyORB_HI_Generated.Deployment;

package Primes is

   procedure Raise_If_Prime (Entity : Entity_Type);

   procedure On_Received_Prime_One
     (Entity         : Entity_Type;
      Received_Prime : Integer_Type);
   procedure On_Received_Prime_Two
     (Entity         : Entity_Type;
      Received_Prime : Integer_Type);
   procedure On_Received_Prime_Three
     (Entity         : Entity_Type;
      Received_Prime : Integer_Type);

   procedure Report_One (Entity : Entity_Type);
   procedure Report_Two (Entity : Entity_Type);
   procedure Report_Three (Entity : Entity_Type);

end Primes;
