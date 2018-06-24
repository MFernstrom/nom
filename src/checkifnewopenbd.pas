unit CheckIfNewOpenBD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser, FileUtil{$IFDEF Darwin}, ns_url_request{$ENDIF}, HTMLTools;

CONST
  GitHubLatestOpenBD = 'https://api.github.com/repos/OpenBD/openbd-core/releases/latest';

function updateOpenBDIfPossible:String;

implementation

function GetJSONWindows(const AURL: String; out AJSON: TJSONStringType): Boolean;
var
  Ms: TMemoryStream;
  HTTPClient: TFPHTTPClient;
begin
  Result := False;
  Ms := TMemoryStream.Create;
  try
    HTTPClient := TFPHTTPClient.Create(nil);
    try
      HTTPClient.AllowRedirect := True;
      HTTPClient.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; fpweb)');
      HTTPClient.AddHeader('Content-Type', 'application/json');
      HTTPClient.HTTPMethod('GET', AURL, MS, []);
      if HTTPClient.ResponseStatusCode = 200 then
      begin
        if Ms.Size > 0 then
        begin
          MS.Position := 0;
          SetLength(AJSON, MS.Size);
          MS.Read(Pointer(AJSON)^, Length(AJSON));
          Result := Length(AJSON) > 0;
        end;
      end;
    except
      Result := False;
    end;
  finally
    Ms.Free;
  end;
end;

{$IFDEF Darwin}
function GetJSONOsx(const AURL: String; out AJSON: TJSONStringType): Boolean;
var
  HTTPClient: TNSHTTPSendAndReceive;
  Headers: TStringList;
  Ms: TMemoryStream;
begin
  Result := False;
  Ms := TMemoryStream.Create;
  try
    HTTPClient := TNSHTTPSendAndReceive.Create;
        try
          HTTPClient.Address := AURL;
          Headers := TStringList.Create;
          Headers.Add('User-Agent=Mozilla/5.0 (compatible; fpweb)');
          Headers.Add('Content-Type=application/json');
          if HTTPClient.SendAndReceive(nil, Ms, Headers) then
      begin
        if Ms.Size > 0 then
        begin
          MS.Position := 0;
          SetLength(AJSON, MS.Size);
          MS.Read(Pointer(AJSON)^, Length(AJSON));
          Result := Length(AJSON) > 0;
        end;
      end;
    except
      Result := False;
    end;
  finally
    Ms.Free;
  end;
end;
{$ENDIF}



function updateOpenBDIfPossible: String;
var
  FHTTPClient: TFPHTTPClient;
  jData : TJSONData;
  jObject, tObject : TJSONObject;
  jArray : TJSONArray;
  i: Integer;
  outPath, corePath, tagName: String;
  gitUrl: String;
  JSON: TJSonStringType;
begin
  gitUrl := 'http://api.github.com/repos/OpenBD/openbd-core/releases/latest';

  // Get json data from GitHub.
  {$IFDEF UNIX}
    if getJSONOsx(gitUrl, JSON) then
        jData := GetJSON(JSON);
  {$ENDIF}

  {$IFDEF WINDOWS}
    if getJSONWindows(gitUrl, JSON) then
        jData := GetJSON(JSON);
  {$ENDIF}

  FHTTPClient := TFPHTTPClient.Create(nil);
  FHTTPClient.AllowRedirect:=true;
  FHTTPClient.AddHeader('User-Agent', 'Nom');

  try
    jObject := TJSONObject(jData);
    jArray := TJSONArray.Create;
    jArray := jObject.Arrays['assets'];

    // Loop all assets, looking for the war file
    for i := 0 to jArray.Count - 1 do
    begin
      tObject := TJSONObject(jArray.Objects[i]);

      if tObject.Find('name').AsString = 'openbd.war' then
      begin
        tagName := jObject.Find('tag_name').AsString;

        // Check if we already have this version
        corePath := GetUserDir() + 'nom' + PathDelim + 'engines';
        outPath := corePath + PathDelim + tagName + '.zip';

        if not FileExists( outPath ) then
        begin
          WriteLn( 'Deleting old engines' );
          DeleteDirectory(corePath, true);
          DeleteDirectory(corePath, false);

          WriteLn( 'Creating directory' );
          if not DirectoryExists( corePath ) then
            CreateDir( corePath );

          WriteLn( 'Downloading OpenBD' );

          downloadFromGitHub( corePath + PathDelim + tagName + '.zip', tObject.Find('browser_download_url').AsString );
        end;

      end;
    end;

  finally
    FHTTPClient.Free;
  end;
end;

end.

