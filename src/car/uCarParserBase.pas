unit uCarParserBase;

interface

uses SysUtils, classes, uMyTextFile, Generics.Collections, uCommEvents;

type
  TCarParserBase = class(TObject)
  private
  protected
    FFileText: TMyTextFile;
    FStopFunc: TBooleanFunc;
    FDataFullPath: string;
    function isStop(): boolean;
  public
    constructor Create(const fileName: string);
    destructor Destroy; override;
    class procedure loadStand(strs: TStrings; Dic: TDictionary<String, String>;
      const c: char=#9); static;
    //
    procedure Rewrite_(const bWrite: boolean; const S: string);
    procedure CloseFile_(const S: string);

    function getSubDataDir(const s: string): string;
    function get(const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): String;
    function getGBK(const url, fname: string;
      const force: boolean=false;
        const cb: TGetStrProc=nil): String;
  public
    //property FileText: TMyTextFile read FFileText;
    property StopFunc: TBooleanFunc write FStopFunc;
    property DataFullPath: string write FDataFullPath;
  end;

implementation

//uses uCarBrand, System.json, uCharSplit;
uses uCharSplit, System.Net.HttpClientComponent, uNetHttpClt;

{ TCarParserBase }

procedure TCarParserBase.CloseFile_(const S: string);
begin
  FFileText.writeLn_(S);
  FFileText.CloseFile_;
end;

constructor TCarParserBase.Create(const fileName: string);
begin
  inherited create;
  FFileText := TMyTextFile.Create(fileName);
end;

destructor TCarParserBase.Destroy;
begin
  FFileText.free;
end;

function TCarParserBase.get(const url, fname: string; const encode: TEncoding;
  const force: boolean; const cb: TGetStrProc): String;
begin
  Result := g_NetHttpClt.get(url, fname, encode, force, cb);
end;

{  function get(httpClt: TNetHttpClient): string;
  var ss: TStringStream;
  begin
    ss := TStringStream.Create('', encode);
    try
      if Assigned(cb) then begin
        cb('get' + #9 + url);
      end;
      try
        httpClt.Get(url, ss);
        Result := ss.DataString;
        //
        //ss.SaveToFile(fname);
        //WriteToFile(Result, fname, TEncoding.UTF8);
      except
        on e: Exception do begin
          //WriteToFile(e.Message, 'c:/1.log', TEncoding.UTF8);
          Result := '';
        end;
      end;
    finally
      ss.Free;
    end;
  end;

var httpClt: TNetHttpClient;
begin
  httpClt := TNetHttpClient.Create(nil);
  try
    Result := get(httpClt);
  finally
    httpClt.Free;
  end;
end;}

function TCarParserBase.getGBK(const url, fname: string; const force: boolean;
  const cb: TGetStrProc): String;
begin
  Result := get(url, fname, TEncoding.GetEncoding(936), force, cb);
end;

function TCarParserBase.getSubDataDir(const s: string): string;
begin
  Result := self.FDataFullPath + S;
end;

function TCarParserBase.isStop: boolean;
begin
  if Assigned(FStopFunc) then begin
    Result := FStopFunc;
  end else begin
    Result := false;
  end;
end;

class procedure TCarParserBase.loadStand(strs: TStrings;
    Dic: TDictionary<String, String>; const c: char);
var i: integer;
  S, k, v: string;
begin
  for I := 1 to strs.Count - 1 do begin
    S := strs[I];
    k := TCharSplit.getSplitFirst(S, c);
    v := TCharSplit.getSplitIdx(S, c, 1);
    Dic.Add(k, v);
  end;
end;

procedure TCarParserBase.Rewrite_(const bWrite: boolean; const S: string);
begin
  FFileText.Rewrite_(true);
  FFileText.WriteLn_(S);
end;

end.

