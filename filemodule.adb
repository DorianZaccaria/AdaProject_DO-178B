with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with MemModule; use MemModule;
with Ada.Directories; use Ada.Directories;

package body FileModule is
    fd          :       File_Type;
    Filename    :       Unbounded_string;

    procedure Dbopen(S: in String) is
    begin
       if (Exists (S)) then
          Filename := To_Unbounded_String (S);
          Open(fd, In_File, S);
          while not end_of_file(fd) loop
             MemAdd(get_line(fd));
          end loop;
          Close(fd);
       end if;
    end Dbopen;

    procedure Dbsave is
    begin
       if (Exists(To_String (Filename))) then
          Open(fd, Out_File, To_String (Filename));
       else
          Create(fd, Out_File ,To_String (Filename));
       end if;
    end Dbsave;

    procedure Dbclose is
    begin
        Close(fd);
    end Dbclose;

    procedure Dbwrite(S: String) is
    begin
        Put_Line(fd, S);
    end Dbwrite;
end FileModule;
