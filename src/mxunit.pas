unit MxUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Zipper, HTMLTools;

function InstallMxunit( Path: String ): boolean;

implementation

function InstallMxunit( Path: String ): boolean;
var
  mxurl: String;
  UnZipper: TUnZipper;
begin
  mxurl := 'https://github.com/MFernstrom/mxunit-lite/archive/0.1.zip';

  WriteLn('Downloading MXUnit');

  // Download file
  downloadFromGitHub('mxunit-latest.zip', mxurl);

  WriteLn('Unpacking MXUnit into project');

  UnZipper := TUnZipper.Create;
  try
    try
      // Unzip the whole mess
      UnZipper.FileName := 'mxunit-latest.zip';
      UnZipper.OutputPath := Path;
      UnZipper.Examine;
      UnZipper.UnZipAllFiles;

      // Rename the output folder to mxunit
      RenameFile( Path + 'mxunit-lite-0.1', Path + 'mxunit' );

    except
      on E: Exception do
        writeln( E.Message );
    end;
  finally
    UnZipper.Free;
    DeleteFile( 'mxunit-latest.zip' );
  end;
  WriteLn('MXUnit done');
end;

end.

