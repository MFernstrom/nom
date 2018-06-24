program projectNom;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cwstring,
    {$IFDEF UseCThreads}
      cthreads, cmem,
    {$ENDIF}
  {$ENDIF}
  Classes, SysUtils, CustApp, UpdateNightly, HTMLTools, Udf, RunProject,
  NewProject, AddNomProject, ShowProject, MxUnit, fphttpclient, DeployHeroku,
  FileUtil, zipper, GetOpenSSL, CheckIfNewOpenBD;

CONST
  CurrentVersion = '0.1.6';
  CurrentVersionInt = 16;

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
  LatestVersion, ErrorMsg, nomUserPath: String;
  FoundOpenSSL: Boolean;
begin
  // Random ad
  Randomize;
  if Random > 0.8 then
    WriteLn( 'Don''t forget to Star Nom on GitHub :)' );

  // Set nomUserPath
  nomUserPath := getUserDir() + 'nom';

  if not DirectoryExists( nomUserPath ) then
    begin
      WriteLn('Creating Nom directory at ' + nomUserPath + ' for settings and caching engine versions.');
      CreateDir( nomUserPath );
    end;

  // Version check, before anything else
  LatestVersion := TFPHTTPClient.SimpleGet('http://marcusfernstrom.com/nom/latestversionint.txt');
  if LatestVersion.ToInteger > CurrentVersionInt then
    begin
      WriteLn( 'There''s a new version of Nom available, you probably want to update' );
    end;

  // OpenSSL checks
  {$IFDEF UNIX}
    if Length(FindDefaultExecutablePath('openssl')) > 0 then
      FoundOpenSSL := true
    else
      FoundOpenSSL := false;
  {$ENDIF}
  {$IFDEF WINDOWS}
    InstallOpenSSL( ExtractFilePath(ParamStr(0)) );
  {$ENDIF}

  if Not FoundOpenSSL then
    WriteLn('No OpenSSL, can''t download UDFs');

  // quick check parameters
  ErrorMsg := CheckOptions('huxi:arspcvx', 'nom run version deploy heroku open');
  if ErrorMsg <> '' then begin
    WriteLn(ErrorMsg);
    Terminate;
    Exit;
  end ;

  if HasOption('deploy') then begin
    if HasOption('heroku') then
      DeployOnHeroku();
    Halt;
  end;

  if HasOption('x') then begin
    InstallMxunit('');
    Halt;
  end;

  if HasOption('v', 'version') then begin
    WriteLn('Nom version ' + CurrentVersion);
    Halt;
  end;

  if HasOption('p') then begin
    showProjectInfo();
    Halt;
  end;

  if HasOption('s') then begin
    addNom('');
    Halt;
  end;

  if HasOption('r', 'run') then begin
    runServer(RunLocation, HasOption('open'));
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
    try
      // Check for OpenBD updates
      updateOpenBDIfPossible();

      CreateProject( GetOptionValue('c') );
      addNom(GetOptionValue('c') + '/');
      InstallMxunit( GetOptionValue('c') + '/' );

      WriteLn('Project created. CD into ' + GetOptionValue('c') + ' and type ''nom -r'' to run it');

    except
      on E: Exception do
        WriteLn(E.Message);
    end;
    Halt;
  end;

  if HasOption('h') then begin
    ShowHelp();
    Halt;
  end;

  // If no option was given, display help.
  ShowHelp();

  Terminate;
end ;

procedure TMyApplication.ShowHelp;
begin
  writeln('');
	writeln(' <-. (`-'')_            <-. (`-'')  ');
  writeln('    \( OO) )     .->      \(OO )_ ');
  writeln(' ,--./ ,--/ (`-'')----. ,--./  ,-.)');
  writeln(' |   \ |  | ( OO).-.  ''|   `.''   |');
  writeln(' |  . ''|  |)( _) | |  ||  |''.''|  |');
  writeln(' |  |\    |  \|  |)|  ||  |   |  |');
  writeln(' |  | \   |   ''  ''-''  ''|  |   |  |  Version ' + CurrentVersion);
  writeln(' `--''  `--''    `-----'' `--''   `--''');
  writeln(' ');
  writeln('nom -c <project name>         Create a new OpenBD project');
  writeln('nom --create <project name>   Creates a folder and installs the latest OpenBD version');
  writeln(' ');
  writeln('nom -r                        Runs the project with Jetty');
  writeln('nom --run');
  writeln(' ');
  writeln('nom --open                    Used with -r/--run to open the browser when the server is ready');
  //writeln(' ');
  //writeln('nom -u                        Update the projects version of OpenBD to the current Nightly');
  //writeln('nom --update');
  writeln(' ');
  writeln('nom --deploy                  Deploys application with target, only Heroku implemented at the moment');
  writeln('nom --heroku                  Deployment target - Requires you to be logged into Heroku CLI tools');
  writeln('                              and have a [Heroku] section with a ProjectName=appname in the Nomolicious file');
  writeln(' ');
  writeln('nom -h                        Shows this wonderful help');
  writeln('nom --help');
  writeln(' ');
  writeln('nom -i <UDF name>             Downloads and installs a CFLib UDF to WEB-INF/customtags/cflib/<udfname>.cfc with the same function name');
  writeln('nom --install <UDF name>      Example: nom -i IsWeekend. It''s then available as a cfc from CFML');
  writeln(' ');
  writeln('nom -s                        Creates nomolicious.ini file for the current project');
  writeln('nom --setup');
  writeln(' ');
  writeln('nom -p                        Show information about the current project');
  writeln('nom --project');
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

