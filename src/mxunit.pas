unit MxUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  fphttpclient, Zipper;

function InstallMxunit( Path: String ): boolean;

implementation

function InstallMxunit( Path: String ): boolean;
var
  mxurl: String;
  cli: TFPHTTPClient;
  UnZipper: TUnZipper;
begin
  mxurl := 'https://github.com/mxunit/mxunit/archive/master.zip';
  WriteLn('Fetching MXUnit from GitHub');

  // Create http client and unzipper
  cli := TFPHTTPClient.Create(nil);
  UnZipper := TUnZipper.Create;
  cli.AllowRedirect:=true;
  try
    try
      // Get the file
      Cli.Get(mxurl, 'mxunit-latest.zip');

      // Unzip the whole mess
      UnZipper.FileName := 'mxunit-latest.zip';
      UnZipper.OutputPath := Path;
      UnZipper.Examine;
      UnZipper.UnZipAllFiles;

      // Rename the output folder to mxunit
      RenameFile( Path + 'mxunit-master', Path + 'mxunit' );

    except
      on E: Exception do
        writeln( E.Message );
    end;
  finally
    Cli.Free;
    UnZipper.Free;
    DeleteFile( 'mxunit-latest.zip' );
  end;
end;

end.

