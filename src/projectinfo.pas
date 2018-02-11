unit ProjectInfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  INIFiles;

function GetRunPort( PathToProject: String ):String;
function GetMaxMem( PathToProject: String ):String;

implementation

function GetRunPort(PathToProject: String): String;
var
  INI: TINIFile;
  RunPort: String;
begin
  INI := TINIFile.Create( PathToProject + 'nomolicious.ini' );

  try
    RunPort := INI.ReadString('Nom', 'Port', '8080');
  finally
    INI.Free;
  end;

  GetRunPort := RunPort;
end;

function GetMaxMem(PathToProject: String): String;
var
  INI: TINIFile;
  MaxMem: String;
begin
  INI := TINIFile.Create( PathToProject + 'nomolicious.ini' );

  try
    MaxMem := INI.ReadString('Nom', 'MaxMem', '500');
  finally
    INI.Free;
  end;

  GetMaxMem := MaxMem;
end;

end.

