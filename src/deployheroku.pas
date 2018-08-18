unit DeployHeroku;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}
  cmem,{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  CRT, Process, FileUtil, IniFiles, RegExpr;

Type
    { TMyThread }

    TMyThread = class(TThread)
    protected
      procedure Execute; override;
    public
      Constructor Create(CreateSuspended : boolean);
    end;

function DeployOnHeroku():Boolean;

var
  AProcess  : TProcess;
  Spinners : array [1..4] of String;
  X,Y, spinnerId: Integer;
  OpenBDFileName: TFileName;
  IsBusy : Boolean;
  HerokuProjectName: String;
  SpinnerSpace : String = '   ';
  DeploySuccess: Boolean;
  d: String;

implementation

function DeployOnHeroku(): boolean;
var
  DeployOnHerokuThread : TMyThread;
  INI: TINIFile;
begin
  DeployOnHerokuThread := TMyThread.Create(True); // This way it doesn't start automatically
  DeploySuccess := false;
	spinnerId := 1;

  spinners[1] := '\';
  spinners[2] := '|';
  spinners[3] := '/';
  spinners[4] := '-';

  INI := TINIFile.Create( 'nomolicious.ini' );

  try
    HerokuProjectName := INI.ReadString('Heroku', 'ProjectName', '');

    if Length(HerokuProjectName) > 0 then begin
      WriteLn(SpinnerSpace + 'Creating WAR file and deploying ' + HerokuProjectName + ' to Heroku (This might take a while)');

      Y := WhereY -1;

	    IsBusy := true;

      DeployOnHerokuThread.Start;

      CursorOff;
      while IsBusy do
      begin
        GotoXY(1, Y);
        write( spinners[spinnerId] );
		    spinnerId := spinnerId + spinnerId;
        if( spinnerId > length(spinners) ) then
          spinnerId := 1;

        delay(80);
      end;

      CursorOn;
	    GotoXY(1, Y);
      write(' ');
      writeln(' ');
      if DeploySuccess = true then
        WriteLn('App has been deployed to https://' + HerokuProjectName + '.herokuapp.com');
    end
    else
      WriteLn('This is not a Heroku project')

  finally
  end;

  DeployOnHeroku := true;
end;

{ TMyThread }

procedure TMyThread.Execute;
var
  s: String;
begin
  RunCommandIndir(GetCurrentDir, '/bin/bash',['-c','jar -cvf Heroku.war *'], s);
  RunCommandIndir(GetCurrentDir, '/bin/bash',['-c','heroku war:deploy Heroku.war --app ' + HerokuProjectName], s);

  IsBusy := false;

  WriteLn(' ');

  if pos('https://' + HerokuProjectName + '.herokuapp.com', s) > 0 then
    DeploySuccess := true
  else begin
    WriteLn('App could not deploy');
    WriteLn( ReplaceRegExpr('\s+', s, ' ', true) );
  end;
end;

constructor TMyThread.Create(CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended); // because this is black box in OOP and can reset inherited to the opposite again...
  FreeOnTerminate := True;  // better code...
end;

end.

