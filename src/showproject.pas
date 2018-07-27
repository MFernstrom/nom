unit ShowProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  IniFiles;

function showProjectInfo(): Boolean;

implementation

function showProjectInfo: Boolean;
var
  INI: TINIFile;
begin
  try
    INI := TINIFile.Create('nomolicious.ini');
      try
        if Not FileExists('nomolicious.ini') then
          WriteLn('This is not a Nom project')
        else
          begin
            WriteLn( '               Port : ' + INI.ReadString('Nom', 'Port', '') );
            WriteLn( '    Max Memory (mb) : ' + INI.ReadString('Nom', 'MaxMem', '') );
            WriteLn( '            Created : ' + INI.ReadString('Nom', 'Created', 'Unknown') );
            WriteLn( 'Heroku project name : ' + INI.ReadString('Heroku', 'ProjectName', '[Not defined]') );
      end;
    result := true;

	except
    on E: Exception do
    	result := false;
  end;
  finally
    INI.Free;
  end;
end;

end.

