unit Udf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  fphttpclient, HTMLTools;

function GetUdf( name : String ): Boolean;
function IsUdfTag( udf : TStringList ): Boolean;

implementation

function GetUdf( name : String ): Boolean;
var
  TS, Tmp : String;
  Str, RetData: TStringList;
  K: Integer;
  SaveCurrent, SecondBlock : Boolean;
begin
  try
    RetData := TStringList.Create;
    RetData.add('<cfcomponent>');
    Str := TStringList.Create;
    SaveCurrent := false;
    SecondBlock := false;

    WriteLn('Checking CFLib for UDF ' + name);

    try
      TS := TFPHTTPClient.SimpleGet('https://cflib.org/udf/' + name);
      Str.Text:= TS;

      for K:=0 to pred(Str.Count) do
      begin
        if (SaveCurrent = true) and (Str[K] = '</code></pre>') then
          SecondBlock := true;

        if LeftStr(Str[K], 10) = '<pre><code' then
          SaveCurrent := true;

        if (Str[K] = '</code></pre>') and (SecondBlock = true) then
          SaveCurrent := false;

        if (SaveCurrent = true) and (SecondBlock = true) then
        begin
          Tmp := Str[K];
          Tmp := StringReplace( Tmp, '<pre><code class="language-javascript">', '', [rfIgnoreCase] );
          Tmp := StringReplace( Tmp, '<pre><code class="language-markup">', '', [rfIgnoreCase] );
          RetData.Add(UnescapeHTML(Tmp));
        end;
      end;

      if Not DirectoryExists('WEB-INF/') then
        WriteLn('Can''t find WEB-INF, are you in the root of the project?')
      else
      begin
        if Not DirectoryExists('WEB-INF/customtags/') then
          CreateDir('WEB-INF/customtags/');

        if Not DirectoryExists('WEB-INF/customtags/cflib/') then
          CreateDir('WEB-INF/customtags/cflib/');

        if Not IsUdfTag( RetData ) then
        begin
          RetData.Insert(1, '<cfscript>');
          RetData.Add('</cfscript>');
        end;

        RetData.Add('</cfcomponent>');

        WriteLn('Saving UDF to WEB-INF/customtags/cflib/' + name + '.cfc');
        RetData.SaveToFile('WEB-INF/customtags/cflib/' + name + '.cfc');
        WriteLn(name + ' is now available.');
        GetUdf := true;
      end;
    except
      on E: Exception do
      begin
        if E.Message = 'Unexpected response status code: 404' then
          WriteLn('Couldn''t find UDF "' + name + '", did you typo?')
        else
          WriteLn('Couldn''t install UDF "' + name + '", details: ' + E.Message);

        GetUdf := false;
      end;
    end;

  finally
    FreeAndNil(Str);
    FreeAndNil(RetData);
  end;
end;

function IsUdfTag(udf: TStringList): Boolean;
var
  TmpLine: String;
begin
  IsUdfTag := False;
  for TmpLine in udf do
  begin
    if pos('<cffunction', TmpLine) > 0 then
    begin
      IsUdfTag := True;
      break;
    end;
  end;
end;

end .
