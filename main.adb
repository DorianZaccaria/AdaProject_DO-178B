with Ada.Characters.Latin_1; use Ada.Characters;
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.String_Split; use GNAT;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Memmodule; use Memmodule;
with FileModule; use FileModule;

procedure main is
   Cmd          :       String (1..80) ;
   Subs         :       String_Split.Slice_Set;
   Seps         :       constant String := " " & Latin_1.HT;
   Cmd_Size     :       Natural;
   Num          :       Integer;
begin
   Put_Line ("Starting program");
   loop
      Get_Line (Cmd, Cmd_Size);
      String_Split.Create (S          => Subs,
                           From       => Cmd (1..Cmd_Size),
                           Separators => Seps,
                           Mode       => String_Split.Multiple);
      Num := Integer'Value (String_Split.Slice_Number'Image
                              (String_Split.Slice_Count (Subs)));
      if (Num = 1) then
         declare
            Sub : constant String := String_Split.Slice (Subs, 1);
         begin
            if (Sub = "save") then
               Dbsave;
               MemFlush;
               Dbclose;
            else
               Put_Line ("unknown command");
            end if;
         end;
      elsif (Num = 2) then
         declare
            Sub : constant String := String_Split.Slice (Subs, 1);
            Arg1 : constant String := String_Split.Slice (Subs, 2);
         begin
            if (Sub = "load")  then
               Dbopen (Arg1);
            elsif (Sub = "status") then
               Memstatus (Arg1);
            else
               Put_Line ("unknown command");
            end if;
         end;
      elsif (Num = 3) then
         declare
            Sub : constant String := String_Split.Slice (Subs, 1);
            Arg1 : constant String := String_Split.Slice (Subs, 2);
            Arg2 : constant String := String_Split.Slice (Subs, 3);
         begin
            if (Sub = "add") then
               Memadd (Arg1, Integer'Value (Arg2));
            elsif (Sub = "remove") then
               Memremove (Arg1, Integer'Value (Arg2));
              else
               Put_Line ("unknown command");
            end if;
         end;
      end if;
   end loop;
end main;
