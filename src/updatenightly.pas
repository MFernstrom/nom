unit UpdateNightly;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  CRT, cmem, fphttpclient, Zipper, FileUtil;

function UpdateOpenBD( FullReplace : Boolean ): boolean;

Type
    { TMyThread }

    TMyThread = class(TThread)
    protected
      procedure Execute; override;
    public
      Constructor Create(CreateSuspended : boolean);
    end;

var
	Spinners : array [1..10] of String;
  X,Y, spinnerId: Integer;
  OpenBDFileName: TFileName;
  IsBusy : Boolean;
  SpinnerSpace : String = '   ';

implementation

function UpdateOpenBD( FullReplace : Boolean ): boolean;
var
    UpdateOpenBDThread : TMyThread;
begin
  UpdateOpenBDThread := TMyThread.Create(True); // This way it doesn't start automatically
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

  UpdateOpenBDThread.Start;
  writeln( SpinnerSpace + 'Updating project to latest OpenBD version' );

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
  UpdateOpenBD := true;
end;

{ TMyThread }

procedure TMyThread.Execute;
var
  UnZipper: TUnZipper;
  JarFiles: TStringList;
  CurrFile: String;
begin
	OpenBDFileName := 'OpenBlueDragon.zip';
	TFPHTTPClient.SimpleGet('http://openbd.org/download/nightly/openbd.war', OpenBDFileName);

  UnZipper := TUnZipper.Create;

  CreateDir('openbdtmp');

  try
    UnZipper.FileName := OpenBDFileName;
    UnZipper.OutputPath := 'openbdtmp';
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;
  finally
    UnZipper.Free;
  end;

  DeleteFile( OpenBDFileName );

  try
    // Instantiate stringlist
    JarFiles := TStringlist.Create;

    // Grab list of all jars in the temp libs
    FindAllFiles(JarFiles, 'openbdtmp/WEB-INF/lib', '*.jar', false);

    // Loop and copy them all to the project libs
    for CurrFile in JarFiles do
    begin
      CopyFile(CurrFile, 'WEB-INF/lib/' + ExtractFileName(CurrFile), [cffOverwriteFile]);
    end;

    // Delete files and remove the temp folder
    DeleteDirectory('openbdtmp', True);
    RmDir( 'openbdtmp' );

  finally
    JarFiles.Free;
    IsBusy := false;
  end;
end ;

constructor TMyThread.Create(CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended); // because this is black box in OOP and can reset inherited to the opposite again...
  FreeOnTerminate := True;  // better code...
end;


end .

