unit MxUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  fphttpclient, Zipper, HTMLTools;

function InstallMxunit( Path: String ): boolean;

implementation

function InstallMxunit( Path: String ): boolean;
var
  mxurl: String;
  UnZipper: TUnZipper;
begin
  mxurl := 'https://github.com/mxunit/mxunit/archive/master.zip';
  WriteLn('Downloading MXUnit from GitHub');

  // Create http client and unzipper
  downloadFromGitHub('mxunit-latest.zip', mxurl);

  UnZipper := TUnZipper.Create;
  try
    try
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
    UnZipper.Free;
    DeleteFile( 'mxunit-latest.zip' );
  end;
end;

end.

