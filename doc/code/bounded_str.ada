with Ada.Strings.Bounded;

-- ...

package String_Data_PKG is new
   Ada.Strings.Bounded.Generic_Bounded_Length (30);

type String_Data is new String_Data_PKG.Bounded_String;
