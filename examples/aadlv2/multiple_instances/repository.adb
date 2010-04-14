------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB HI COMPONENTS                           --
--                                                                          --
--                           R E P O S I T O R Y                            --
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

--  $Id: repository.adb 6851 2009-07-22 12:37:17Z hugues $

with PolyORB_HI.Output;             use PolyORB_HI.Output;
with PolyORB_HI_Generated.Activity; use PolyORB_HI_Generated.Activity;

package body Repository is

   Message_1 : Message := 0;
   Message_2 : Message := 0;
   Message_3 : Message := 0;

   ----------
   -- Send --
   ----------

   procedure Send (Entity : Entity_Type) is
      Msg : Message;
   begin
      case Entity is
         when Node_A_Sender_1_K =>
            Message_1 := Message_1 + 1;
            Msg       := Message_1;

         when Node_A_Sender_2_K =>
            Message_2 := Message_2 + 1;
            Msg       := Message_2;

         when Node_A_Sender_3_K =>
            Message_3 := Message_3 + 1;
            Msg       := Message_3;

         when others =>
            Put_Line ("[Send] ERROR: Entity = " &  Entity_Image (Entity));
            raise Program_Error;
      end case;

      Put_Line ("[Send] "
                &  Entity_Image (Entity)
                & " sends"
                & Message'Image (Msg));
      Put_Value (Entity,
                 MultipleInstances_Sender_Interface'
                   (MultipleInstances_Sender_Port_Type'(Output), Msg));

   end Send;

   -------------
   -- Receive --
   -------------

   procedure Receive (Entity : Entity_Type; Input : Message) is
   begin
      Put_Line ("[Receive] "
                &  Entity_Image (Entity)
                & " receives"
                & Message'Image (Input));
   end Receive;

end Repository;
