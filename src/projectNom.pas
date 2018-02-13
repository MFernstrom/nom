program projectNom;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cwstring,
  {$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, UpdateNightly, HTMLTools, Udf,
  RunProject, NewProject, AddNomProject, ShowProject
  { you can add units after this };

var
  RunLocation : String;

type

  { TMyApplication }

  TMyApplication = class (TCustomApplication)
  protected
    procedure DoRun; override;
    procedure ShowHelp;
  public
    constructor Create(TheOwner: TComponent); override;
  end ;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('huxi:arspc', 'nom run');
  if ErrorMsg<>'' then begin
    WriteLn(ErrorMsg);
    Terminate;
    Exit;
  end ;

  if HasOption('p') then begin
    showProjectInfo();
    Halt;
  end;

  if HasOption('s') then begin
    addNom('');
    Halt;
  end;

  if HasOption('r', 'run') then begin
    runServer(RunLocation);
    Halt;
  end;

  if HasOption('a') then begin
    writeln( 'Adding ' +  GetOptionValue('a'));
    Halt;
  end;

  if HasOption('nom') then begin
    writeln( 'Upgrading Nom' );
    Halt;
  end;

  if HasOption('i') then begin
    GetUdf(GetOptionValue('i'));
    Halt;
  end;

  if HasOption('u') then begin
    if HasOption('full') then
      UpdateOpenBD( true )
    else
      UpdateOpenBD( false );

    Halt;
  end;

  if HasOption('c') then begin
    CreateProject( GetOptionValue('c') );
    addNom(GetOptionValue('c') + '/');
    Halt;
  end;

  if HasOption('x') then begin
		writeln('TEST THINGS');
    Halt;
  end;

  if HasOption('h') then begin
    ShowHelp();
    Halt;
  end;

  { add your program here }

  // stop program loop
  Terminate;
end ;

procedure TMyApplication.ShowHelp;
var
  Version : String = '0.1.0';
begin
  writeln('');
	writeln(' <-. (`-'')_            <-. (`-'')  ');
  writeln('    \( OO) )     .->      \(OO )_ ');
  writeln(' ,--./ ,--/ (`-'')----. ,--./  ,-.)');
  writeln(' |   \ |  | ( OO).-.  ''|   `.''   |');
  writeln(' |  . ''|  |)( _) | |  ||  |''.''|  |   Nom, the OpenBD utility');
  writeln(' |  |\    |  \|  |)|  ||  |   |  |');
  writeln(' |  | \   |   ''  ''-''  ''|  |   |  |   Version ' + Version);
  writeln(' `--''  `--''    `-----'' `--''   `--''');
  writeln(' ');
  writeln('nom -c      Create a new OpenBD project');
  writeln('            Example: nom -c AwesomeProject creates a new folder AwesomeProject and installs the latest OpenBD version');
  writeln(' ');
  writeln('nom -r      Runs the project with a Jetty server');
  writeln(' ');
  writeln('nom -u      Update the projects version of OpenBD to the current Nightly');
  writeln(' ');
  writeln('nom -h      Shows this wonderful help');
  writeln(' ');
  writeln('nom -x      Runs your unit tests at /mxunit/tests');
  writeln(' ');
  writeln('nom -i      Downloads and installs a CFLib UDF to WEB-INF/customtags/cflib/');
  writeln('            Example: nom -i IsWeekend. It''s then available by calling IsWeekend() from CFML');
  writeln(' ');
  writeln('nom -s      Turn existing project into Nom project');
  writeln(' ');
  writeln('nom -p      Show information about the current project');
  writeln(' ');
  writeln('nom --nom   Update Nom to the latest version');
  writeln(' ');
end ;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end ;

var
  Application: TMyApplication;

{$R *.res}

begin
  Application:=TMyApplication.Create(nil);
  RunLocation := Application.Location;
  Application.Title:='nom';
  Application.Run;
  Application.Free;
end .

