unit DeployHeroku;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}
  cmem,{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  CRT, Process, fphttpclient, Zipper, FileUtil, IniFiles, RegExpr;

function deployOnHeroku():Boolean;

var
  IsBusy    : Boolean;
  AProcess  : TProcess;

implementation

function deployOnHeroku: Boolean;
var
  INI: TINIFile;
  HerokuProjectName, s: String;
  RegexObj: TRegExpr;
begin
  AProcess := TProcess.Create(nil);
  INI := TINIFile.Create( 'nomolicious.ini' );
  RegexObj := TRegExpr.Create('.*\s+(https://mf-testwar.herokuapp.com/) deployed to Heroku');

  try
    WriteLn('Checking project');
    HerokuProjectName := INI.ReadString('Heroku', 'ProjectName', '');

    if Length(HerokuProjectName) > 0 then
    begin
      WriteLn('Found Heroku settings');
      WriteLn('Creating WAR file for deployment');
      RunCommandIndir(GetCurrentDir, '/bin/bash',['-c','jar -cvf Heroku.war *'], s);

      WriteLn('Deploying ' + HerokuProjectName + ' to Heroku');
      RunCommandIndir(GetCurrentDir, '/bin/bash',['-c','heroku war:deploy Heroku.war --app ' + HerokuProjectName], s);

      if pos('ERROR', s) > 0 then
      begin
        WriteLn('App could not deploy');
        WriteLn( s );
      end
      else
        begin
          if RegexObj.Exec(s) then
            WriteLn('App has been deployed to ' + RegexObj.Match[1]);
          RegexObj.Free;
        end;
    end
    else
      WriteLn('This is not a Heroku project')
  finally
  end;

end;

end.

