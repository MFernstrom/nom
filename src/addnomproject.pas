unit AddNomProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  IniFiles;

function addNom( PathToProject : String ): Boolean;

implementation

function addNom( PathToProject : String ): Boolean;
var
  Port, MaxMem : Integer;
  INI: TINIFile;
begin
  INI := TINIFile.Create( PathToProject + 'nomolicious.ini' );
  try
    if Not FileExists( PathToProject + 'nomolicious.ini' ) then
    begin
      WriteLn( 'No nomolicious.ini file found, creating new' );
      Write( 'Which port should we use?: ' );
      ReadLn( Port );

      Write( 'How much memory should we use in mb?: ' );
      ReadLn(MaxMem);

    end
    else
    begin
      WriteLn('Updating existing project.');
      Write( 'Which port should we use? Currently ' + INI.ReadString('Nom', 'Port', '') + ': ' );
      ReadLn(Port);

      Write( 'How much memory should we use in mb? Currently ' + INI.ReadString('Nom', 'MaxMem', '') + ': ' );
      ReadLn(MaxMem);
    end;

    INI.WriteInteger('Nom', 'Port', Port);
    INI.WriteInteger('Nom', 'MaxMem', MaxMem);

  finally
    // After the ini file was used it must be freed to prevent memory leaks.
    INI.Free;
  end;
end;

end.

