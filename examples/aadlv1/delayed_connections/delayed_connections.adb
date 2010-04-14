------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                  D E L A Y E D _ C O N N E C T I O N S                   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                 Copyright (C) 2007, GET-Telecom Paris.                   --
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

with PolyORB_HI.Output; use PolyORB_HI.Output;

package body Delayed_Connections is

   N_Sender_Cycles   : Simple_Type := 0;
   N_Receiver_Cycles : Simple_Type := 0;
   Msg               : Simple_Type := 0;

   ----------
   -- Send --
   ----------

   procedure Send
     (Data_Source : out Simple_Type;
      N_Cycle     : out Simple_Type)
   is
   begin
      N_Sender_Cycles := N_Sender_Cycles + 1;
      Msg             := Msg + 1;

      N_Cycle     := N_Sender_Cycles;
      Data_Source := Msg;

      Put_Line ("Sender: Cycle" & Simple_Type'Image (N_Cycle)
                & " sending" & Simple_Type'Image (Data_Source));
   end Send;

   -------------
   -- Receive --
   -------------

   procedure Receive
     (Data_Sink : Simple_Type;
      N_Cycle   : Simple_Type)
   is
   begin
      N_Receiver_Cycles := N_Receiver_Cycles + 1;

      Put_Line ("Receiver: Cycle" & Simple_Type'Image (N_Receiver_Cycles));
      Put_Line ("   received sender cycle:" & Simple_Type'Image (N_Cycle));
      Put_Line ("   received message     :" & Simple_Type'Image (Data_Sink));
   end Receive;

end Delayed_Connections;
