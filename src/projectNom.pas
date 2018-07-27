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
  FileUtil, zipper, GetOpenSSL, CheckIfNewOpenBD, AskHeroku, LCLIntf;

CONST
  CurrentVersion = '0.2.0';
  CurrentVersionInt = 20;

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
  // Random ad, should only show 10% of the time
  Randomize;
  if Random > 0.9 then
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
  ErrorMsg := CheckOptions('huxi:arspcvx', 'nom run version deploy heroku open website');
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

  if HasOption('website') then begin
    OpenURL('https://github.com/MFernstrom/nom/');
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
      AskIfHeroku( GetOptionValue('c') + '/' );
      addNom(GetOptionValue('c') + '/');
      InstallMxunit( GetOptionValue('c') + '/' );

      WriteLn(' ');
      WriteLn('Project ready! CD into ' + GetOptionValue('c') + ' and type ''nom -r --open'' to run it and open your browser once it''s loaded');

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
  writeln(' -c <project name>         Creates a new project with the latest release of OpenBD');
  writeln('--create <project name>');
  writeln(' ');
  writeln(' -r                        Runs the project');
  writeln('--run');
  writeln('');
  writeln('--open                    Used with -r/--run to open the browser when the server is ready');
  writeln(' ');
  writeln('--website                 Opens the projects Git repo');
  //writeln(' ');
  //writeln('nom -u                        Update the projects version of OpenBD to the current Nightly');
  //writeln('nom --update');
  writeln(' ');
  writeln('--deploy                  Deploys application with target, only Heroku implemented at the moment');
  writeln('--heroku                  Deployment target - Requires you to be logged into Heroku CLI tools');
  writeln('                              and have a [Heroku] section with a ProjectName=appname in the Nomolicious file');
  writeln(' ');
  writeln(' -h                        Shows this wonderful help');
  writeln('--help');
  writeln(' ');
  writeln(' -i <UDF name>             Downloads and installs a CFLib UDF to WEB-INF/customtags/cflib/<udfname>.cfc with the same function name');
  writeln('--install <UDF name>      Example: nom -i IsWeekend. It''s then available as a cfc from CFML');
  writeln(' ');
  writeln(' -s                        Creates nomolicious.ini file for the current project');
  writeln('--setup');
  writeln(' ');
  writeln(' -p                        Show information about the current project');
  writeln('--project');
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

