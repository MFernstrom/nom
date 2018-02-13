unit NewProject;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}
  cmem,{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  CRT, fphttpclient, Zipper, FileUtil, AddNomProject;

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
  Spinners : array [1..10] of String;
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

  spinners[1] := '⠋';
  spinners[2] := '⠙';
  spinners[3] := '⠹';
  spinners[4] := '⠸';
  spinners[5] := '⠼';
  spinners[6] := '⠴';
  spinners[7] := '⠦';
  spinners[8] := '⠧';
  spinners[9] := '⠇';
  spinners[10] := '⠏';

  Y := WhereY;

	IsBusy := true;

  NewOpenBDProjectThread.Start;
  writeln( SpinnerSpace + 'Creating new OpenBD project' );

  while IsBusy do
  begin
    GotoXY(1, Y);
    write( spinners[spinnerId] );
		spinnerId := spinnerId + spinnerId;
    if( spinnerId > length(spinners) ) then
      spinnerId := 1;

    delay(80);
  end;
	GotoXY(1, Y);
  write(' ');
  writeln(' ');
	writeln(SpinnerSpace + 'Done');
  CreateProject := true;
end;

{ TMyThread }

procedure TMyThread.Execute;
var
  UnZipper: TUnZipper;
  JarFiles: TStringList;
  CurrFile: String;
  OpenBDFileName: TFileName;
begin
  try
    UnZipper := TUnZipper.Create;
	  OpenBDFileName := 'OpenBlueDragon.zip';

	  TFPHTTPClient.SimpleGet('http://openbd.org/download/nightly/openbd.war', OpenBDFileName);

    CreateDir(ProjectName);

    UnZipper.FileName := OpenBDFileName;
    UnZipper.OutputPath := ProjectName;
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;

    DeleteFile( OpenBDFileName );

    IsBusy := false;
  finally
    UnZipper.Free;
  end;
end ;

constructor TMyThread.Create(CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended); // because this is black box in OOP and can reset inherited to the opposite again...
  FreeOnTerminate := True;  // better code...
end;

end.

