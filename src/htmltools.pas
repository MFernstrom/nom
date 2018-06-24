unit HTMLTools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient {$IFDEF Darwin},ns_url_request{$ENDIF};

function UnescapeHTML( untidy : String ): String;
function downloadFromGitHub( location, url: String ): Boolean;

implementation

function UnescapeHTML( untidy : String ): String;
var
  TS : String;
begin
  TS := untidy;
  TS := StringReplace( TS, '&lt;', '<', [rfReplaceAll, rfIgnoreCase] );
  TS := StringReplace( TS, '&gt;', '>', [rfReplaceAll, rfIgnoreCase] );
  TS := StringReplace( TS, '&quot;', '"', [rfReplaceAll, rfIgnoreCase] );
  TS := StringReplace( TS, '&amp;', '&', [rfReplaceAll, rfIgnoreCase] );
  UnescapeHTML := TS;
end;

function downloadWindows( location, gitUrl: String ): Boolean;
var
  HTTPClient: TFPHTTPClient;
begin
  result := false;
  try
    HTTPClient := TFPHTTPClient.Create(nil);
    try
      HTTPClient.AllowRedirect := true;
      HTTPClient.AddHeader('User-Agent', 'Nom'); // GitHub requires a user agent
      HTTPClient.Get( gitUrl, location );

    finally
      HTTPClient.free;
    end;

  except
    on E: Exception do
      result := true;
  end;
end;

{$IFDEF Darwin}
function downloadOsx( location, gitUrl: String ): Boolean;
var
  OutStream:TFilestream;
  HTTPClient: TNSHTTPSendAndReceive;
  Headers: TStringList;
  Ms: TMemoryStream;
begin
  result := false;
  Ms := TMemoryStream.Create;
  HTTPClient := TNSHTTPSendAndReceive.Create;

  try
    HTTPClient.Address := gitUrl;
    Headers := TStringList.Create;
    Headers.Add('User-Agent=Mozilla/5.0 (compatible; fpweb)');
    if HTTPClient.SendAndReceive(nil, Ms, Headers) then
    begin
      outstream := TFilestream.Create(location, fmCreate);
      outstream.position := 0;
      outstream.copyfrom(Ms, 0);
    end;

  finally
    outstream.free;
    HTTPClient.Free;
  end;
  result := true;
end;
{$ENDIF}

function downloadFromGitHub( location, url: String ): Boolean;
begin
  {$IFDEF UNIX}
    downloadOsx( location, url );
  {$ENDIF}

  {$IFDEF WINDOWS}
    downloadWindows( location, url );
  {$ENDIF}
end;

end .

