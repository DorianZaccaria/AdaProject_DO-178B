with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors; use Ada.Containers;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.String_Split; use GNAT;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones; use Ada.Calendar.Time_Zones;
with FileModule; use FileModule;

package Memmodule is
   type Element is record
      Reference         :       unbounded_string;
      Quantity          :       Integer;
      Timestamp         :       unbounded_string;
   end record;


   procedure Memadd (Ref : String; Val : Integer);
   procedure Memadd (Line : String);
   procedure MemFlush;
   procedure Memremove (Ref : String; Val : Natural);
   procedure Memstatus (Ref : String);
end Memmodule;
