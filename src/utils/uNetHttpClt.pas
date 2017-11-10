unit uNetHttpClt;

interface

uses classes, Windows, SysUtils, System.Net.HttpClientComponent;

type
  TNetHttpClt = class

  private
    class procedure forceDirs(const fName: string); static;

    class function WriteToFile(const s, fname: string;
      const encode: TEncoding): boolean;
    class function readFromFile(const fname: string;
      const encode: TEncoding): string; static;

  public
    class function get(netHttp: TNetHttpClient; const url: String;
      encode: TEncoding; const cb: TGetStrProc=nil): String; overload; static;

    class function get(netHttp: TNetHttpClient; const url, fname: String;
      encode: TEncoding; const cb: TGetStrProc=nil): String; overload; static;

    class function get(netHttp: TNetHttpClient; const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): string; overload;

    class function post(netHttp: TNetHttpClient; const url: String;
      const strs: TStrings; const encode: TEncoding;
        const cb: TGetStrProc=nil): String; overload; static;

    class function post(netHttp: TNetHttpClient; const url, fname: String;
      const strs: TStrings; const encode: TEncoding;
        const cb: TGetStrProc=nil): String; overload; static;

    class function post(netHttp: TNetHttpClient; const url, fname: String;
      const strs: TStrings; const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): String; overload; static;

  public
    function get(const url: String;
      encode: TEncoding; const cb: TGetStrProc=nil): String; overload;

    function get(const url, fname: String;
      encode: TEncoding; const cb: TGetStrProc=nil): String; overload;

    function get(const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): string; overload;

    function post(const url: String;
      const strs: TStrings; const encode: TEncoding;
        const cb: TGetStrProc=nil): String; overload;

    function post(const url, fname: String;
      const strs: TStrings; const encode: TEncoding;
        const cb: TGetStrProc=nil): String; overload;

    function post(const url, fname: String;
      const strs: TStrings; const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): String; overload;

  public
    function get(const url: String; const cb: TGetStrProc=nil): String; overload;

    function get(const url, fname: String; const cb: TGetStrProc=nil): String; overload;

    function get(const url, fname: string; const force: boolean=false;
        const cb: TGetStrProc=nil): string; overload;

    function post(const url: String; const strs: TStrings;
        const cb: TGetStrProc=nil): String; overload;

    function post(const url, fname: String;
      const strs: TStrings; const cb: TGetStrProc=nil): String; overload;

    function post(const url, fname: String;
      const strs: TStrings; const force: boolean=false;
        const cb: TGetStrProc=nil): String; overload;

  protected
    FNetHttpClient: TNetHttpClient;
    FEncode: TEncoding;
    FSelfHttp: boolean;
  public
    constructor Create(); overload;
    constructor Create(encode: TEncoding); overload;
    //constructor Create(NetHttpClient: TNetHttpClient); overload;
    //constructor Create(NetHttpClient: TNetHttpClient; encode: TEncoding); overload;
    destructor Destroy; override;
  end;

implementation

uses StrUtils, Forms;

constructor TNetHttpClt.Create();
begin
  self.Create(TEncoding.UTF8);
end;

constructor TNetHttpClt.Create(encode: TEncoding);
begin
  FSelfHttp := true;
  FNetHttpClient := TNetHttpClient.Create(nil);
  FEncode := encode;
end;

{constructor TNetHttpClt.Create(NetHttpClient: TNetHttpClient);
begin
  self.Create(NetHttpClient, TEncoding.UTF8);
end;

constructor TNetHttpClt.Create(NetHttpClient: TNetHttpClient; encode: TEncoding);
begin
  FSelfHttp := false;
  self.FNetHttpClient := NetHttpClient;
  FEncode := encode;
end;}

destructor TNetHttpClt.Destroy;
begin
  if Assigned(FNetHttpClient) then begin
    FNetHttpClient.Free;
  end;
end;

class function TNetHttpClt.get(netHttp: TNetHttpClient; const url, fname: String;
  encode: TEncoding; const cb: TGetStrProc): String;
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    if Assigned(cb) then begin
      cb('get' + #9 + url);
    end;
    try
      netHttp.Get(url, ss);
      Result := ss.DataString;
      //
      TNetHttpClt.forceDirs(fname);
      //ss.SaveToFile(fname);
      WriteToFile(Result, fname, TEncoding.UTF8);
    except
      on e: Exception do begin
        Result := '';
      end;
    end;
  finally
    ss.Free;
  end;
end;

class function TNetHttpClt.get(netHttp: TNetHttpClient; const url: string;
  const fname: string; const encode: TEncoding; const force: boolean;
    const cb: TGetStrProc): string;
begin
  if (force) or (not FileExists(fname)) then begin
    Result := Get(netHttp, url, fname, encode, cb);
  end else begin
    if assigned(cb) then begin
      cb('loc' + #9 + fname);
    end;
    Result := readFromFile(fname, TEncoding.UTF8);
  end;
  Sleep(0);
  Sleep(0);
end;

class function TNetHttpClt.get(netHttp: TNetHttpClient; const url: String;
  encode: TEncoding; const cb: TGetStrProc): String;
{begin
  Result := netHttp.Get(url);
end;}
{var ms: TMemoryStream;
     Resp: IHTTPResponse;
begin
  ms := TMemoryStream.Create();
  try
    if Assigned(cb) then begin
      cb('get', url);
    end;
    Resp := netHttp.Get(url, ms);
    Result := Resp.ContentAsString(encode);
    //Result := streamToString(ms, encode);
  finally
    ms.Free;
  end;
end;}
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    if Assigned(cb) then begin
      cb('get' + #9 + url);
    end;
    try
      netHttp.Get(url, ss);
      Result := ss.DataString;
    except
      on e: Exception do begin
        Result := '';
      end;
    end;
  finally
    ss.Free;
  end;
end;

class procedure TNetHttpClt.forceDirs(const fName: string);
var path: string;
begin
  path := ExtractFilePath(fName);
  if not (Directoryexists(path)) then begin
    ForceDirectories(path);
  end;
end;

class function TNetHttpClt.post(netHttp: TNetHttpClient; const url: String;
  const strs: TStrings; const encode: TEncoding;
  const cb: TGetStrProc): String;
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    netHttp.post(url, strs, ss);
    Result := ss.DataString;
  finally
    ss.Free;
  end;
end;

class function TNetHttpClt.post(netHttp: TNetHttpClient; const url, fname: String;
  const strs: TStrings; const encode: TEncoding; const force: boolean;
    const cb: TGetStrProc): String;
begin
  if (force) or (not FileExists(fname)) then begin
    Result := Post(netHttp, url, fname, strs, encode, cb);
  end else begin
    if assigned(cb) then begin
      cb('loc' + #9 + fname);
    end;
    Result := readFromFile(fname, TEncoding.UTF8);
  end;
  Sleep(0);
  Sleep(0);
end;

class function TNetHttpClt.post(netHttp: TNetHttpClient; const url, fname: String;
  const strs: TStrings; const encode: TEncoding;
  const cb: TGetStrProc): String;

var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    if Assigned(cb) then begin
      cb('post' + #9 + url);
    end;
    try
      netHttp.post(url, strs, ss);
      Result := ss.DataString;
      //
      TNetHttpClt.forceDirs(fname);
      //ss.SaveToFile(fname);
      WriteToFile(Result, fname, TEncoding.UTF8);
    except
      on e: Exception do begin
        Result := '';
      end;
    end;
  finally
    ss.Free;
  end;
end;

{
  function readIt(const fname: string; const encode: TEncoding): string;
  var stream: TStringStream;
  begin
    stream := TStringStream.Create('', encode);
    try
      stream.LoadFromFile( fname );
      Result := stream.DataString;
    finally
      stream.Free;
    end;
  end;
}

class function TNetHttpClt.readFromFile(const fname: string; const encode: TEncoding): string;
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    if FileExists(fname) then begin
      {if encode=nil then begin
        strs.LoadFromFile( fname, TEncoding.Default);
      end else begin}
        strs.LoadFromFile( fname, encode );
      //end;
      Result := strs.Text;
    end else begin
      Result := '';
    end;
  finally
    strs.Free;
  end;
  Sleep(0);
  Sleep(0);
end;

class function TNetHttpClt.WriteToFile(const s, fname: string; const encode: TEncoding): boolean;
var
  strs: TStrings;
begin
  strs := TStringList.Create();
  try
    strs.Text := s;
    strs.SaveToFile( fname, encode );
    Result := true;
  finally
    strs.Free;
  end;
end;

{class function TNetHttpClt.getAppFileName(const S: string): string;
begin
  Result := ExtractFilePath(Application.exeName) + S;
end;

class function TNetHttpClt.strsToMerge(strs: TStrings; const c: char): string;
var i: integer;
begin
  Result := '';
  for I := 0 to strs.count - 1 do begin
    if SameText(Result,'') then begin
      Result := strs[i];
    end else begin
      Result := Result + c + strs[i];
    end;
  end;
end;

class function TNetHttpClt.strsToParams(strs: TStrings): string;
begin
  Result := strsToMerge(strs, '&');
end;}

// self get

function TNetHttpClt.get(const url, fname: string; const encode: TEncoding;
  const force: boolean; const cb: TGetStrProc): string;
begin
  Result := get(FNetHttpClient, url, fname, encode, force, cb);
end;

function TNetHttpClt.get(const url, fname: String; encode: TEncoding;
  const cb: TGetStrProc): String;
begin
  Result := get(FNetHttpClient, url, fname, encode, cb);
end;

function TNetHttpClt.get(const url: String; encode: TEncoding;
  const cb: TGetStrProc): String;
begin
  Result := get(FNetHttpClient, url, encode, cb);
end;

function TNetHttpClt.post(const url, fname: String; const strs: TStrings;
  const encode: TEncoding; const force: boolean;
  const cb: TGetStrProc): String;
begin
  Result := post(FNetHttpClient, url, fname, strs, encode, force, cb);
end;

function TNetHttpClt.post(const url, fname: String; const strs: TStrings;
  const encode: TEncoding; const cb: TGetStrProc): String;
begin
  Result := post(FNetHttpClient, url, fname, strs, encode, cb);
end;

function TNetHttpClt.post(const url: String; const strs: TStrings;
  const encode: TEncoding; const cb: TGetStrProc): String;
begin
  Result := post(FNetHttpClient, url, strs, encode, cb);
end;

function TNetHttpClt.get(const url, fname: string; const force: boolean;
  const cb: TGetStrProc): string;
begin
  Result := get(FNetHttpClient, url, fname, FEncode, force, cb);
end;

function TNetHttpClt.get(const url, fname: String; const cb: TGetStrProc): String;
begin
  Result := get(FNetHttpClient, url, fname, FEncode, cb);
end;

function TNetHttpClt.get(const url: String; const cb: TGetStrProc): String;
begin
  Result := get(FNetHttpClient, url, FEncode, cb);
end;

function TNetHttpClt.post(const url, fname: String; const strs: TStrings;
  const force: boolean; const cb: TGetStrProc): String;
begin
  Result := post(FNetHttpClient, url, fname, strs, FEncode, force, cb);
end;

function TNetHttpClt.post(const url, fname: String; const strs: TStrings;
  const cb: TGetStrProc): String;
begin
  Result := post(FNetHttpClient, url, fname, strs, FEncode, cb);
end;

function TNetHttpClt.post(const url: String; const strs: TStrings;
  const cb: TGetStrProc): String;
begin
  Result := post(FNetHttpClient, url, strs, FEncode, cb);
end;

end.
