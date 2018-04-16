unit uCarParserBase;

interface

uses SysUtils, classes, uMyTextFile, Generics.Collections, uCommEvents;

type
  TCarParserBase = class(TObject)
  private
  protected
    FFileName: string;
    FFileText: TMyTextFile;
    FStopFunc: TBooleanFunc;
    FDataSubDir: string;
    FForceDownload: boolean;
    function isStop(): boolean;
    procedure SetDataSubDir(const subdir: string);
  public
    constructor Create();
    destructor Destroy; override;
    class procedure loadStand(strs: TStrings; Dic: TDictionary<String, String>;
      const c: char=#9); static;
    //
    //procedure Rewrite_(const bWrite: boolean; const S: string);
    procedure CreateFile(const bWrite: boolean; const ctx: string);
    procedure CloseFile(const S: string);

    function getSubDataDir(const s: string): string;
    function get(const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): String;
    function getGBK(const url, fname: string;
      const cb: TGetStrProc=nil): String;
    function isNew(const url: string): boolean;
  public
    property StopFunc: TBooleanFunc write FStopFunc;
    property DataSubDir: string write SetDataSubDir;
    property ForceDownload: boolean write FForceDownload;
  end;

implementation

uses uCharSplit, uNetHttpClt;

{ TCarParserBase }

constructor TCarParserBase.Create();
begin
  inherited create;
  // force download
  FForceDownload := false;
  FFileText := TMyTextFile.Create();
end;

procedure TCarParserBase.CreateFile(const bWrite: boolean; const ctx: string);
begin
  FFileText.createFile(getSubDataDir(FFileName), bWrite);
  FFileText.writeline(ctx);
end;

destructor TCarParserBase.Destroy;
begin
  if Assigned(FFileText) then begin
    FFileText.free;
  end;
end;

function TCarParserBase.get(const url, fname: string; const encode: TEncoding;
  const force: boolean; const cb: TGetStrProc): String;
begin
  Result := g_NetHttpClt.get(url, fname, encode, force, cb);
end;

function TCarParserBase.getGBK(const url, fname: string;
  const cb: TGetStrProc): String;
begin
  Result := get(url, fname, TEncoding.GetEncoding(936), FForceDownload, cb);
end;

{function TCarParserBase.getGBK(const url, fname: string; const force: boolean;
  const cb: TGetStrProc): String;
begin
  Result := get(url, fname, TEncoding.GetEncoding(936), force, cb);
end;}

function TCarParserBase.getSubDataDir(const s: string): string;
begin
  Result := FDataSubDir + '\' + S;
end;

procedure TCarParserBase.SetDataSubDir(const subdir: string);
begin
  FDataSubDir := subdir;
end;

function TCarParserBase.isNew(const url: string): boolean;
var n: integer;
begin
  // http://www.che168.com/handler/usedcarlistv5.ashx?action=brandlist
  n := url.indexof('usedcarlistv5.ashx');
  if n>0 then begin
    Result := true;
  end else begin  // http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?needData=1
    Result := false;
  end;
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

{procedure TCarParserBase.Rewrite_(const bWrite: boolean; const S: string);
begin
  FFileText.Rewrite_(true);
  FFileText.WriteLn_(S);
end;}

procedure TCarParserBase.CloseFile(const S: string);
begin
  FFileText.writeLine(S);
  FFileText.CloseFile;
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

end.

