with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings; use Ada.Strings;
with GNAT.String_Split; use GNAT;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones; use Ada.Calendar.Time_Zones;
with FileModule; use FileModule;

package body Memmodule is

   package Element_List is new Vectors (Positive, Element);
   use Element_List;

   V : Vector;

   procedure Memadd (Ref : String; Val : Integer) is
      Elt               :       Element;
      Check             :       Natural := 0;
      Now               :       Time;
      Subs              :       String_Split.Slice_Set;
      Tmp               :       String (1..19);
   begin
      for I in V.First_Index..V.Last_Index loop
         Elt := V.Element (I);
         if (Elt.Reference = Ref) then
            Elt.Quantity := Elt.Quantity + Val;
            Now := Clock;
            Tmp := Image (Date => Now, Time_Zone => 1*60);
            String_Split.Create (S          => Subs,
                                 From       => Tmp,
                                 Separators => " ",
                                 Mode       => String_Split.Multiple);
            Elt.Timestamp := To_Unbounded_String ("[" & String_Split.Slice (Subs, 1) & "/"
                                                    & String_Split.Slice (Subs, 2) & "]");
            V.Replace_Element (I, Elt);
            Check := 1;
         end if;
      end loop;

      if (Check = 0) then
         Elt.Reference := To_unbounded_string(Ref);
         Elt.Quantity := Val;
         Now := Clock;
         Tmp := Image (Date => Now, Time_Zone => 1*60);
         String_Split.Create (S          => Subs,
                              From       => Tmp,
                              Separators => " ",
                              Mode       => String_Split.Multiple);
         Elt.Timestamp := To_Unbounded_String ("[" & String_Split.Slice (Subs, 1) & "/"
                                                    & String_Split.Slice (Subs, 2) & "]");
         V.Append (Elt);
      end if;
   end Memadd;

   procedure Memadd (Line : String) is
      Subs              :       String_Split.Slice_Set;
      Elt               :       Element;
      Num               :       Integer;
   begin
      String_Split.Create (S          => Subs,
                           From       => Line,
                           Separators => " ",
                           Mode       => String_Split.Multiple);
      Num := Integer'Value (String_Split.Slice_Number'Image
                              (String_Split.Slice_Count (Subs)));
      if (Num = 3) then
         Elt.Reference := To_unbounded_string(String_Split.Slice (Subs, 1));
         Elt.Quantity := Integer'Value (String_Split.Slice (Subs, 2));
         Elt.Timestamp := To_unbounded_string(String_Split.Slice (Subs, 3));
         V.Append (Elt);
      end if;
   end Memadd;

   procedure MemFlush is
      Elt : Element;
    begin
        while (not Is_Empty (V)) loop
            Elt := First_Element (V);
            Delete_First (V);
            DbWrite(To_String (Elt.Reference) & " " & Integer'Image (Elt.Quantity));
        end loop;
    end MemFlush;

    procedure Memremove (Ref : String; Val : Natural) is
       Tmp              :       Element;
    begin
       for I in V.First_Index..V.Last_Index loop
          Tmp := V.Element (I);
          if (Tmp.Reference = Ref) then
             Tmp.Quantity := Tmp.Quantity - Val;
             V.Replace_Element (I, Tmp);
            if (Tmp.Quantity <= 0) then
              Delete (V, I);
            end if;
          end if;
       end loop;
    end Memremove;

    procedure Memstatus (Ref : String) is
       Tmp              :       Element;
    begin
       for I in V.First_Index..V.Last_Index loop
          Tmp := V.Element (I);
          if (Tmp.Reference = Ref) then
             Put_Line (To_String (Tmp.Reference) & " "
                         & Integer'Image (Tmp.Quantity) & " "
                         & To_String (Tmp.Timestamp));
          end if;
       end loop;
    end Memstatus;

end Memmodule;
