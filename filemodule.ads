with Ada.Text_IO; use Ada.Text_IO;

package FileModule is
   procedure Dbopen(S: in String);
   procedure Dbsave;
   procedure Dbclose;
   procedure DbWrite(S: String);
end FileModule;
