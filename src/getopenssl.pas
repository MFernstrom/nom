unit GetOpenSSL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, zipper, fphttpclient;

function InstallOpenSSL( ParamPath: String ): Boolean;

implementation

function InstallOpenSSL( ParamPath: String ): Boolean;
var
  LibeayDLL, SsleayDLL, cOpenSSLURL, ZipFile: String;
  UnZipper: TUnZipper;
  FHTTPClient: TFPHTTPClient;
begin
  LibeayDLL := ParamPath + 'libeay32.dll';
  SsleayDLL := ParamPath + 'ssleay32.dll';

  if not FileExists(Libeaydll) or not FileExists(Ssleaydll) then
    begin
      {$IFDEF WIN64}
        WriteLn('Downloading portable OpenSSL for x64_86 (This can take a minute)');
        cOpenSSLURL := 'http://packages.lazarus-ide.org/openssl-1.0.2j-x64_86-win64.zip';
      {$ENDIF}
      {$IFDEF WIN32}
        WriteLn('Downloading portable OpenSSL for i386 (This can take a minute)');
        cOpenSSLURL := 'http://packages.lazarus-ide.org/openssl-1.0.2j-i386-win32.zip';
      {$ENDIF}

      ZipFile := ParamPath + ExtractFileName(cOpenSSLURL);
      if FileExists(ZipFile) then
        DeleteFile( ZipFile );

      WriteLn( ZipFile );
      FHTTPClient := TFPHTTPClient.Create(nil);
      try
        try
          FHTTPClient.Get(cOpenSSLURL, ZipFile);
         except
         end;
      finally
        FHTTPClient.Free;
      end;
      if FileExists(ZipFile) then
      begin
        WriteLn('Unpacking OpenSSL');
        UnZipper := TUnZipper.Create;
        try
          try
            UnZipper.FileName := ZipFile;
            UnZipper.Examine;
            UnZipper.OutputPath := ParamPath;
            UnZipper.UnZipAllFiles;
          except
            on E: Exception do
              WriteLn('Could not unzip files because ' + E.Message);
          end;
        finally
          UnZipper.Free;
        end;
        DeleteFile(ZipFile);
      end;
      WriteLn('All set');
    end;
end;

end.

