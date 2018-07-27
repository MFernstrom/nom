unit AskHeroku;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  IniFiles;

function AskIfHeroku( Path: String ):Boolean;

implementation

function AskIfHeroku( Path: String ): Boolean;
var
  INI: TINIFile;
  q: String;
begin
  Write('If this is a Heroku project, enter the name (Otherwise leave blank): ');
  ReadLn(q);
  if Length(q) > 0 then begin
    try
      INI := TINIFile.Create( Path + 'nomolicious.ini' );
      INI.WriteString('Heroku', 'ProjectName', q);
      WriteLn('Project set up for Heroku deployment. Deploy with ''nom --deploy --heroku''');
    finally
      INI.Free;
    end;
  end;
end;

end.

