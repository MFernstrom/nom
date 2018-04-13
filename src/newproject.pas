unit NewProject;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}
  cmem,{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  CRT, Zipper, FileUtil;

function CreateProject( Name: String ): Boolean;

Type
    { TMyThread }

    TMyThread = class(TThread)
    protected
      procedure Execute; override;
    public
      Constructor Create(CreateSuspended : boolean);
    end;

var
  IsBusy : Boolean;
  Spinners : array [1..4] of String;
  X,Y, spinnerId: Integer;
  SpinnerSpace : String = '   ';
  ProjectName : String;

implementation

function CreateProject(Name: String): Boolean;
var
    NewOpenBDProjectThread : TMyThread;
begin
  ProjectName := Name;

  NewOpenBDProjectThread := TMyThread.Create(True); // This way it doesn't start automatically
	spinnerId := 1;

  spinners[1] := '\';
  spinners[2] := '|';
  spinners[3] := '/';
  spinners[4] := '-';
  //spinners[1] := '⠋';
  //spinners[2] := '⠙';
  //spinners[3] := '⠹';
  //spinners[4] := '⠸';
  //spinners[5] := '⠼';
  //spinners[6] := '⠴';
  //spinners[7] := '⠦';
  //spinners[8] := '⠧';
  //spinners[9] := '⠇';
  //spinners[10] := '⠏';

  Y := WhereY;

	IsBusy := true;

  NewOpenBDProjectThread.Start;
  writeln( SpinnerSpace + 'Unzipping into ' + ProjectName );

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
  CreateProject := true;
end;

{ TMyThread }

procedure TMyThread.Execute;
var
  UnZipper: TUnZipper;
  InstallTaffy: Boolean;
  OpenBDZip: TStringList;
begin
  OpenBDZip := TStringList.Create;
  try
    UnZipper := TUnZipper.Create;

    CreateDir(ProjectName);

    // Get engine zip file path + name
    FindAllFiles(OpenBDZip, GetUserDir() + 'nom' + PathDelim + 'engines', '*.zip', false);

    // Copy engine files
    UnZipper.FileName := OpenBDZip[0];
    UnZipper.OutputPath := ProjectName;
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;

    IsBusy := false;
  finally
    OpenBDZip.Free;
    UnZipper.Free;
  end;
end ;

constructor TMyThread.Create(CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended); // because this is black box in OOP and can reset inherited to the opposite again...
  FreeOnTerminate := True;  // better code...
end;

end.

