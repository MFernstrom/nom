unit HTMLTools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function UnescapeHTML( untidy : String ): String;

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

end .

