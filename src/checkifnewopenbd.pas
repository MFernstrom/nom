unit CheckIfNewOpenBD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser, FileUtil, Zipper;

CONST
  GitHubLatestOpenBD = 'https://api.github.com/repos/OpenBD/openbd-core/releases/latest';

function checkOpenBDGitHubVersion:String;

implementation

function checkOpenBDGitHubVersion: String;
var
  FHTTPClient: TFPHTTPClient;
  jData : TJSONData;
  jObject, tObject : TJSONObject;
  jArray : TJSONArray;
  i: Integer;
  outPath, corePath, tagName: String;
  UnZipper: TUnZipper;
begin
  FHTTPClient := TFPHTTPClient.Create(nil);
  try
    FHTTPClient.AllowRedirect:=true;
    FHTTPClient.AddHeader('User-Agent', 'Nom');
    jData := GetJSON(FHTTPClient.Get( 'http://api.github.com/repos/OpenBD/openbd-core/releases/latest' ));
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

          //CreateDir( outPath );

          WriteLn( 'Downloading OpenBD' );
          FHTTPClient.Get( tObject.Find('browser_download_url').AsString, corePath + PathDelim + tagName + '.zip' );

        end
        else
        begin
          WriteLn( 'Using the latest engine' );
        end;

      end;
    end;

  finally
    FHTTPClient.Free;
  end;
end;

end.

