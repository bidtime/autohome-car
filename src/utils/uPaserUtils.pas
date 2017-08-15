unit uPaserUtils;

interface

uses classes, Windows, SysUtils, IdHttp, HtmlParser_XE3UP,
  Generics.Collections, Generics.Defaults;

type

  TGetStrProc2 = procedure(const S, S2: string) of object;
  TBoolOfStrProc = function(const S: string):boolean of object;
  TGetStrProc4 = procedure(const S, S2, S3: string; const strs: TStrings;
     const S4: string) of object;
  TElementEvent = procedure(Sender: IHtmlElement) of object;
  TElementStrsEvent = procedure(Sender: IHtmlElement; const attr: string; strs: TStrings) of object;
  TElementBrandEvent = procedure(Sender: IHtmlElement;
    const brand: string) of object;
  TElementCodeEvent = procedure(Sender: IHtmlElement;
    const code, codeDtl: string) of object;

  TPaserUtils = class
  public
    class function correctPath(const S: string): string; static;
    class function datetimeToLong(const dt: TDateTime): long; static;
    class function eleToStr(e: IHtmlElement): string; static;
    class function eleToStrRaw(e: IHtmlElement; const ori: boolean): string; static;
    class function ExtractFileOnly(const fName: string): string; static;
    class procedure forceDirs(const fName: string); static;
  public
    class procedure getCssOfTag(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const clear: boolean=false); static;
    class function getCssFirst(const node: IHtmlElement;
      const cssSel: string): string; static;
    class function getCssLast(const node: IHtmlElement;
      const cssSel: string): string; static;
    class function getCssIdx(const node: IHtmlElement;
      const cssSel: string; const idx: integer): string; static;

    class function getEleCSSIdx(const node: IHtmlElement;
      const cssSel: string; const idx: integer=0): IHtmlElement;

    class function getEleCSSIdxLast(const node: IHtmlElement;
      const cssSel: string): IHtmlElement;

    class function getCtxOfEncode(const f: string; const en: TEncoding): string; static;
    class function getCtxOfFileUTF8(const f: string): string; static;

    class procedure MakeFileList(dir, ext: string; strs: TStrings); static;
    class function nowToLong: long; static;
    class function getCssRevIdx(const node: IHtmlElement; const cssSel: string;
      const n: integer): string; static;
  public
    class procedure SimpleCSSSelAttr(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const attr: string; const doStrsEv: TElementStrsEvent;
        const addStrs: boolean=false); overload; static;
    class procedure SimpleCSSSelAttr(const S: String; const cssSel: string;
      strs: TStrings; const attr: string; const doStrsEv: TElementStrsEvent;
        const addStrs: boolean=false); overload; static;
    //
    class procedure SimpleCSSSelAttr(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const attr: string);
        overload; static;
    class procedure SimpleCSSSelAttr(const S: String; const cssSel: string;
      strs: TStrings; const attr: string); overload;
    //
    {class procedure SimpleCSSSel(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const doStrsEv: TElementStrsEvent=nil); overload;
    class procedure SimpleCSSSel(const S: String; const cssSel: string;
      strs: TStrings; const doStrsEv: TElementStrsEvent=nil); overload;}
    //
    class procedure SimpleCSSSel(const node: IHtmlElement; const cssSel: string;
      const doIt: TElementEvent=nil); overload;
    class procedure SimpleCSSSel(const S: String; const cssSel: string;
      const doIt: TElementEvent=nil); overload;
    //
    class procedure SimpleCSSSel2(const node: IHtmlElement; const cssSel, code,
      dtlCode: string; const doIt: TElementCodeEvent); static;
  public
    class function readText(const fname: string; const encode: TEncoding=nil): string;

//    class function get(idHttp1: TIdHttp; const url: String;
//      const callbak: TGetStrProc2=nil): String; overload; static;

    class function get(idHttp1: TIdHttp; const url: String;
      encode: TEncoding; const callbak: TGetStrProc2=nil): String; overload; static;

    class function get(idHttp1: TIdHttp; const url, fname: String;
      encode: TEncoding; const callbak: TGetStrProc2=nil): String; overload; static;

    class procedure get(idHttp1: TIdHttp; const url, fname: string;
      const callbak: TGetStrProc2=nil); overload; static;

    class procedure get(idHttp1: TIdHttp; const url, fname: string;
      const force: boolean; const callbak: TGetStrProc2=nil); overload; static;

    class function getCtxOfUrlDef(idHttp1: TIdHttp; const url, fname: string;
      const force: boolean=false; const callbak: TGetStrProc2=nil): string; overload;

    class function getCtxOfUrl(idHttp1: TIdHttp; const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const callbak: TGetStrProc2=nil): string; overload;
    class function post(idHttp1: TIdHttp; const url: String;
      const strs: TStrings; const encode: TEncoding;
        const callbak: TGetStrProc2=nil): String; overload; static;

    class function post(idHttp1: TIdHttp; const url: String;
      const strs: TStrings; const callbak: TGetStrProc2=nil): String; overload; static;
    class function streamToString(const Stream: TStream; encode: TEncoding): string;

  public

    class procedure AppendLog(const fileName, context: string; const addTime: boolean=true); static;
    class procedure AppendText(const fileName, context: string); static;

    class function strsToParams(strs: TStrings): string; static;
    class function strsToMerge(strs: TStrings; const c: char): string; static;

  public
    class procedure parseProductTemplate(const S: string; strs: TStrings); static;
    class procedure parsePartsOfFile(const fName: string; strs: TStrings;
      const json_cb, htmlParse_cb: TGetStrProc; const strsF: TStrings); static;

    class procedure parsePartsCode(const ctx: string; strs: TStrings;
        const json_cb: TGetStrProc; const htmlParse_cb: TGetStrProc;
          const strsF: TStrings=nil;
            const ch: string='/'); overload;

    class procedure parsePartsCode(const ctx: string; strs: TStrings;
        const json_cb: TGetStrProc; const htmlParse_cb: TGetStrProc;
          const dict: TDictionary<String, string>;
            const ch: string='/'); overload;

    class function getParsePartsOfFile(const fileName: string;
        const json_cb: TGetStrProc=nil;
          const htmlParse_cb: TGetStrProc=nil;
            const strsF: TStrings=nil): string; static;
  public
    class procedure saveContext2FileName(strs: TStrings; const fileName: string);
    class procedure saveTextTo(const fileName: string; const S: string;
        const addTime: boolean=false);
    class function getCtxOfAppUTF8(const fileName: string): string;
    class function getCtxOfPathFileUTF8(const path, fileName: string): string;
    class function getAppFileName(const S: string): string;
    //
    class procedure getInsertSqlOfStrs(const strs: TStrings; const tName: string;
      strsRst: TStrings; const blEvent:TBoolOfStrProc=nil);
    class procedure getUpdateSqlOfStrs(const strs: TStrings; const tName, whereCols: string;
      strsRst: TStrings; const hideCols: string=''; const blEvent:TBoolOfStrProc=nil);
        overload;
    class procedure getUpdateSqlOfStrs(const strs: TStrings; const tName, whereCols: string;
      strsRst: TStrings; const showCols: string=''; const hideCols: string=''; const blEvent:TBoolOfStrProc=nil);
        overload;
  end;

implementation

uses StrUtils, System.json, uCharSplit, Forms;

class function TPaserUtils.getCssIdx(const node: IHtmlElement;
  const cssSel: string; const idx: integer): string;
var
  l: IHtmlElementList;
  ele: IHtmlElement;
begin
  Result := '';
  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    if (idx >= 0) and (idx < l.Count) then begin
      ele := l[idx];
      Result := ele.InnerText;
    end;
  end;
end;

class function TPaserUtils.getEleCSSIdx(const node: IHtmlElement;
  const cssSel: string; const idx: integer): IHtmlElement;
var
  l: IHtmlElementList;
begin
  Result := nil;
  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    if (idx >= 0) and (idx < l.Count) then begin
      Result := l[idx];
    end else if (idx=-1) then begin
      Result := l[l.Count - 1];
    end;
  end;
end;

class function TPaserUtils.getEleCSSIdxLast(const node: IHtmlElement;
  const cssSel: string): IHtmlElement;
begin
  Result := getEleCSSIdx(node, cssSel, -1);
end;

class function TPaserUtils.getCssLast(const node: IHtmlElement;
  const cssSel: string): string;
begin
  Result := getCssRevIdx(node, cssSel, 0);
end;

class function TPaserUtils.getCssRevIdx(const node: IHtmlElement;
  const cssSel: string; const n: integer): string;
var
  l: IHtmlElementList;
  ele: IHtmlElement;
  idx: integer;
begin
  Result := '';
  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    idx := l.Count - n - 1;
    if (idx >= 0) and (idx < l.Count) then begin
      ele := l[idx];
      Result := ele.InnerText;
    end;
  end;
end;

class procedure TPaserUtils.getCssOfTag(const node: IHtmlElement; const cssSel: string;
  strs: TStrings; const clear: boolean);
var
  l: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if clear then strs.Clear;

  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    for i := 0 to l.Count - 1 do begin
      ele := l[i];
      if strs <> nil then begin
        strs.Add(ele.InnerText);
      end;
    end;
  end;
end;

class function TPaserUtils.getCssFirst(const node: IHtmlElement; const cssSel: string): string;
begin
  Result := getCssIdx(node, cssSel, 0);
end;

class function TPaserUtils.datetimeToLong(const dt: TDateTime): long;
const
  cUnixStartDate: TDateTime = 25569.0; // 1970/01/01
begin
  Result := Round((dt - cUnixStartDate) * 86400);
end;

class function TPaserUtils.nowToLong(): long;
begin
  Result := datetimeToLong(now());
end;

//  ExtractFileOnly('D:\TDDownload\cartype\code-\D001001.html');

class function TPaserUtils.ExtractFileOnly(const fName: string): string;
var
  I, J: Integer;
begin
  I := fName.LastIndexOf('.');
  J := fName.LastIndexOf('\');
  Result := fName.SubString(J+1, I-j-1);
end;

{function ld(const s: string; const Delims: string): Integer;
var
  I, J, nPos: Integer;
begin
  I := High(s);
  if (Delims.Length>1) then begin
    while I >= Low(string) do begin
      for J := Low(string) to High(Delims) do begin
        if s.Chars[I] = Delims.Chars[J] then
          Exit(I);
      end;
      Dec(I);
    end;
  end else begin
    while I >= Low(string) do begin
      for J := Low(string) to High(Delims) do begin
        if s.Chars[I] = Delims.Chars[J] then begin
          if nPos < 0 then begin
          Exit(I);
          end;
        end;
      end;
      Dec(I);
    end;
  end;
  Result := -1;
end;}

class procedure TPaserUtils.MakeFileList(dir, ext: string; strs: TStrings);
var
  sch: TSearchrec;
begin
  if rightStr(dir, 1) <> '\' then begin
    dir := dir + '\'
  end;

  if not DirectoryExists(dir) then begin
    exit;
  end;

  if FindFirst(dir + '*', faAnyfile, sch) = 0 then begin
    repeat
      if ((sch.Name = '.') or (sch.Name = '..')) then Continue;

      if DirectoryExists(dir + sch.Name) then begin  // 这个地方加上一个判断，可以区别子文件夹河当前文件夹的操作
        MakeFileList(dir + sch.Name, ext, strs);
      end else begin
        if SameText(ExtractFileExt(dir + sch.Name), ext) or (ext = '.*') then begin
          strs.Add(dir + sch.Name);
        end;
      end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

class procedure TPaserUtils.SimpleCSSSel(const node: IHtmlElement; const cssSel: string;
  const doIt: TElementEvent);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(doIt) then begin
        doIt(ele);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TPaserUtils.SimpleCSSSel(const S, cssSel: string;
  const doIt: TElementEvent);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSel(node, cssSel, doIt);
end;

class procedure TPaserUtils.SimpleCSSSelAttr(const S, cssSel: string;
  strs: TStrings; const attr: string; const doStrsEv: TElementStrsEvent;
    const addStrs: boolean);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSelAttr(node, cssSel, strs, attr, doStrsEv, addStrs);
end;

class procedure TPaserUtils.SimpleCSSSelAttr(const node: IHtmlElement;
  const cssSel: string; strs: TStrings; const attr: string;
    const doStrsEv: TElementStrsEvent; const addStrs: boolean);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(strs) and (addStrs) then begin
        strs.add(ele.Attributes[attr]);
      end;
      if Assigned(doStrsEv) then begin
        doStrsEv(ele, attr, strs);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TPaserUtils.SimpleCSSSelAttr(const S, cssSel: string;
  strs: TStrings; const attr: string);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSelAttr(node, cssSel, strs, attr);
end;

class procedure TPaserUtils.SimpleCSSSelAttr(const node: IHtmlElement;
  const cssSel: string; strs: TStrings; const attr: string);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(strs) then begin
        strs.add(ele.Attributes[attr]);
      end;
    end;
  except
    hl := nil;
  end;
end;

{class procedure TPaserUtils.SimpleCSSSel(const S, cssSel: string;
  strs: TStrings; const doStrsEv: TElementStrsEvent);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSel(node, cssSel, strs, doStrsEv);
end;

class procedure TPaserUtils.SimpleCSSSel(const node: IHtmlElement;
  const cssSel: string; strs: TStrings; const doStrsEv: TElementStrsEvent);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(strs) then begin
        strs.add(ele.innerText);
      end;
      if Assigned(doStrsEv) then begin
        doStrsEv(ele, strs);
      end;
    end;
  except
    hl := nil;
  end;
end;}

class procedure TPaserUtils.SimpleCSSSel2(const node: IHtmlElement; const cssSel, code,
  dtlCode: string; const doIt: TElementCodeEvent);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if node = nil then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(doIt) then begin
        doIt(ele, code, dtlCode);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TPaserUtils.forceDirs(const fName: string);
var path: string;
begin
  path := ExtractFilePath(fName);
  if not (Directoryexists(path)) then begin
    ForceDirectories(path);
  end;
end;

class function TPaserUtils.correctPath(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
end;

{class function TPaserUtils.getEncode(const S: string): TEncoding;
begin
  if SameText(S, 'ANSI') then begin
    Result := TEncoding.ANSI;
  end else if SameText(S, 'ANSI2') then begin
    Result := TEncoding.ASCII;
  end else if SameText(S, 'UTF7') then begin
    Result := TEncoding.UTF7;
  end else if SameText(S, 'UTF8') then begin
    Result := TEncoding.UTF8;
  end else if SameText(S, 'BigEndianUnicode') then begin
    Result := TEncoding.BigEndianUnicode;
  end else begin
    Result := TEncoding.Default;
  end;
end;}

class function TPaserUtils.getCtxOfEncode(const f: string; const en: TEncoding): string;
var strs: TStrings;
  content: string;
begin
  content := '';
  strs := TStringList.Create;
  try
    if FileExists(f) then begin
      strs.LoadFromFile( f, en );
      content := strs.Text;
    end;
  finally
    strs.Free;
  end;
  Result := content;
end;

class function TPaserUtils.getCtxOfFileUTF8(const f: string): string;
begin
  Result := getCtxOfEncode(f, TEncoding.UTF8);
end;

class function TPaserUtils.eleToStrRaw(e: IHtmlElement; const ori: boolean): string;
begin
  if ori then begin
    Result := e.Orignal + #9 + e.InnerText;
  end else begin
    Result := 'tag:' + e.TagName
      + #9 + 'clz:' + e.Attributes['class']
      + #9 + 'txt:' + e.InnerText;
  end;
end;

class function TPaserUtils.eleToStr(e: IHtmlElement): string;
begin
  eleToStrRaw(e, false);
end;

{class function TPaserUtils.get(idHttp1: TIdHttp; const url: String;
  const callbak: TGetStrProc2): String;
begin
  Result := get(idHttp1, url, TEncoding.Default, callbak);
end;}

class function TPaserUtils.streamToString(const Stream: TStream; encode: TEncoding): string;
var
  Size: Integer;
  Buffer: TBytes;
  encd: TEncoding;
begin
  Stream.Position := 0;
  encd := nil;
  try
    Size := Stream.Size - Stream.Position;
    SetLength(Buffer, Size);
    Stream.Read(Buffer, 0, Size);
    if encode=nil then begin
      encd := TEncoding.Create;
      encd := TEncoding.Default;
      Size := TEncoding.GetBufferEncoding(Buffer, encd, TEncoding.Default);
    end else begin
      Size := TEncoding.GetBufferEncoding(Buffer, encode, TEncoding.Default);
    end;
    Result := (encode.GetString(Buffer, Size, Length(Buffer) - Size));
  finally
    if Assigned(encd) then begin
      encd.Free;
    end;
  end;
end;

class function TPaserUtils.get(idHttp1: TIdHttp; const url, fname: String;
  encode: TEncoding; const callbak: TGetStrProc2): String;
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    if Assigned(callbak) then begin
      callbak('get', url);
    end;
    try
      IdHTTP1.Get(url, ss);
      Result := ss.DataString;
      //
      TPaserUtils.forceDirs(fname);
      ss.SaveToFile(fname);
    except
      on e: Exception do begin
        Result := '';
      end;
    end;
  finally
    ss.Free;
  end;
end;

class function TPaserUtils.get(idHttp1: TIdHttp; const url: String;
  encode: TEncoding; const callbak: TGetStrProc2): String;
{begin
  Result := IdHTTP1.Get(url);
end;}
{var ms: TMemoryStream;
begin
  ms := TMemoryStream.Create();
  try
    if Assigned(callbak) then begin
      callbak('get', url);
    end;
    IdHTTP1.Get(url, ms);
    Result := streamToString(ms, encode);
  finally
    ms.Free;
  end;
end;}
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    if Assigned(callbak) then begin
      callbak('get', url);
    end;
    try
      IdHTTP1.Get(url, ss);
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

class procedure TPaserUtils.get(idHttp1: TIdHttp; const url: string;
  const fname: string; const callbak: TGetStrProc2);
var
  ms: TMemoryStream;
  //ext: string;
begin
  //ext := ExtractFileExt(url);
  ms := TMemoryStream.Create;
  try
    try
      if Assigned(callbak) then begin
        callbak('get', url);
      end;
      idHttp1.Get(url, ms);
    except
      on e: Exception do begin
      end;
    end;
    forceDirs(fname);
    ms.SaveToFile(fname);
  finally
    ms.Free;
  end;
end;

class procedure TPaserUtils.get(idHttp1: TIdHttp; const url, fname: string;
  const force: boolean; const callbak: TGetStrProc2);
begin
  if (force) or (not FileExists(fname)) then begin
    get(idHttp1, url, fname, callbak);
  end else begin
    if assigned(callbak) then begin
      callbak('loc', fname);
    end;
  end;
  Sleep(0);
end;

class function TPaserUtils.getAppFileName(const S: string): string;
begin
  Result := ExtractFilePath(Application.exeName) + S;
end;

class function TPaserUtils.strsToMerge(strs: TStrings; const c: char): string;
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

class function TPaserUtils.strsToParams(strs: TStrings): string;
begin
  Result := strsToMerge(strs, '&');
end;

class function TPaserUtils.post(idHttp1: TIdHttp; const url: String;
    const strs: TStrings;const callbak: TGetStrProc2): String;
begin
  Result := post(idHttp1, url, strs, TEncoding.UTF8, callbak);
end;

class function TPaserUtils.post(idHttp1: TIdHttp; const url: String;
    const strs: TStrings; const encode: TEncoding; const callbak: TGetStrProc2): String;
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    IdHTTP1.post(url, strs, ss);
    Result := ss.DataString;
    if Assigned(callbak) then begin
      if pos('?', url) > 0 then begin
        callbak('post', url + '&' + strsToParams(strs));
      end else begin
        callbak('post', url + '?' + strsToParams(strs));
      end;
    end;
  finally
    ss.Free;
  end;
end;

class function TPaserUtils.getCtxOfUrlDef(idHttp1: TIdHttp;
  const url, fname: string; const force: boolean;
      const callbak: TGetStrProc2): string;
begin
  Result := getCtxOfUrl(idHttp1, url, fname, TEncoding.Default,
    force, callbak);
end;

class procedure TPaserUtils.getInsertSqlOfStrs(const strs: TStrings; const tName: string;
    strsRst: TStrings; const blEvent:TBoolOfStrProc);

  function doInsertRow(const sqlCols: string; const S: string): string;
  var sql: string;
    sval, tmp: string;
    strsRow: TStrings;
    I: integer;
  begin
    sql := '';
    strsRow := TStringList.Create;
    try
      TCharSplit.SplitChar(S, #9, strsRow);
      if (strsRow.Count>0) then begin
        sql := 'insert into ' + tName + '(' + sqlCols + ') values(';
        for I := 0 to strsRow.Count - 1 do begin
          tmp := QuotedStr(trim(strsRow[I]));
          if i=0 then begin
            sval := tmp;
          end else begin
            sval := sval + ',' + tmp;
          end;
        end;
        sql := sql + sval + ');';
      end;
    finally
      strsRow.Free;
    end;
    Result := sql;
  end;
var i: integer;
  s, sql: string;
  strsCol: TStrings;
  sqlCols: string;
begin
  strsRst.Clear;
  strsRst.Add('start transaction;');
  if strs.Count < 0 then exit;

  strsCol := TStringList.Create;
  try
    for I := 0 to strs.Count - 1 do begin
      S := strs[i];
      if (I=0) then begin
        TCharSplit.SplitChar(S, #9, strsCol);
        if (strscol.Count <=0 ) then begin
          strsRst.Add('error: 列数不能少于0列,请检查.');
          break;
        end;
        sqlCols := TCharSplit.replaceSplitChar(S, #9, #44);
      end else begin
        sql := doInsertRow(sqlCols, S);
        strsRst.Add(sql);
        //if stop
        if Assigned(blEvent) and (blEvent(sql)) then begin
          break;
        end;
      end;
    end;
  finally
    strsCol.Free;
  end;
  strsRst.Add('commit;');
end;

class function TPaserUtils.getCtxOfUrl(idHttp1: TIdHttp; const url: string;
  const fname: string; const encode: TEncoding; const force: boolean;
    const callbak: TGetStrProc2): string;
  function readIt(const fname: string; const encode: TEncoding): string;
  var
    strs: TStrings;
  begin
    strs := TStringList.Create;
    try
      if assigned(callbak) then begin
        callbak('loc', fname);
      end;
      strs.LoadFromFile( fname, encode );
      Result := strs.Text;
    finally
      strs.Free;
    end;
  end;
begin
  if (force) or (not FileExists(fname)) then begin
    Result := Get(idHttp1, url, fname, encode, callbak);
  end else begin
    Result := readIt(fname, encode);
  end;
  Sleep(0);
  Sleep(0);
end;

class function TPaserUtils.readText(const fname: string; const encode: TEncoding): string;
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    if FileExists(fname) then begin
      if encode=nil then begin
        strs.LoadFromFile( fname, TEncoding.Default);
      end else begin
        strs.LoadFromFile( fname, encode );
      end;
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

class procedure TPaserUtils.parseProductTemplate(const S: string; strs: TStrings);

  procedure processOne(const jsonVal: TJSONValue; strs: TStrings);
  var
    S: string;
  begin
    if jsonVal.TryGetValue<String>('productTemplate', S) then begin
      strs.Add(S);
    end;
  end;

  procedure processList(const jsonArray: TJSONArray; strs: TStrings);
  var
    jsonVal : TJSONValue;
  begin
    for jsonVal in jsonArray do begin
      processOne(jsonVal, strs);
    end;
  end;

  procedure processValue(const jsonVal: TJSONValue; strs: TStrings);
  begin
    if (jsonVal.ClassType = TJSONArray) then begin
      processList(jsonVal as TJSONArray, strs);
    end else if (jsonVal.ClassType = TJSONObject) then begin
      processOne(jsonVal, strs);
    end;
  end;
var
  JSONObject: TJSONObject; // JSON类
  jsonVal: TJSONValue;
begin
  if Trim(S) = '' then begin
    exit;
  end;
  JSONObject := nil;
  try
    { 从字符串生成JSON } //TEncoding.UTF8.GetBytes(StrJson)
    jsonVal := TJSONObject.ParseJSONValue(Trim(S));
    processValue(jsonVal, strs);
  finally
    JSONObject.Free;
  end;
end;

class procedure TPaserUtils.parsePartsOfFile(const fName: string; strs: TStrings;
  const json_cb: TGetStrProc; const htmlParse_cb: TGetStrProc;
    const strsF: TStrings);
var content: string;
begin
  content := TPaserUtils.getCtxOfFileUTF8(fName);
  parsePartsCode(content, strs, json_cb, htmlParse_cb, strsF);
end;

class function TPaserUtils.getParsePartsOfFile(const fileName: string;
  const json_cb: TGetStrProc; const htmlParse_cb: TGetStrProc;
     const strsF: TStrings): string;
var content: string;
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    parsePartsOfFile(fileName, strs, json_cb, htmlParse_cb, strsF);
    content := strs.Text;
  finally
    strs.Free;
  end;
  Result := content;
end;


class procedure TPaserUtils.getUpdateSqlOfStrs(const strs: TStrings; const tName,
  whereCols: string; strsRst: TStrings; const hideCols: string;
  const blEvent: TBoolOfStrProc);
begin
  getUpdateSqlOfStrs(strs, tName, whereCols, strsRst, '', hideCols, blEvent);
end;

class procedure TPaserUtils.getUpdateSqlOfStrs(const strs: TStrings; const tName,
  whereCols: string; strsRst: TStrings; const showCols, hideCols: string;
  const blEvent: TBoolOfStrProc);

  function doUpdateRow(const strsCols: TStrings; const S: string;
    const dicWhere, dicShowCol, dicHideCol: TDictionary<String, Boolean>): string;
  var sql: string;
    subSql, whereSql: string;
    colName, rowVal: string;
    strsRow: TStrings;
    I: integer;
  begin
    sql := '';
    strsRow := TStringList.Create;
    try
      TCharSplit.SplitChar(S, #9, strsRow);
      if (strsRow.Count>0) then begin
        sql := 'update ' + tName + ' set ';
        for I := 0 to strsCols.Count - 1 do begin
          colName := strsCols[I];
          if (dicHideCol.ContainsKey(colName)) then begin  //需要隐藏的列
            continue;
          end;
          if (dicShowCol.Count > 0) and (not dicShowCol.ContainsKey(colName)) then begin  //需要隐藏的列
            continue;
          end;
          //
          if I < strsRow.Count then begin
            rowVal := QuotedStr(trim(strsRow[I]));
          end else begin
            rowVal := 'null';
          end;
          if (dicWhere.ContainsKey(colName)) then begin
            if SameText(whereSql, '') then begin
              whereSql := colName + '=' + rowVal;
            end else begin
              whereSql := whereSql + ',' + colName + '=' + rowVal;
            end;
          end else begin
            if SameText(subSql, '') then begin
              subSql := colName + '=' + rowVal;
            end else begin
              subSql := subSql + ',' + colName + '=' + rowVal;
            end;
          end;
        end;
        sql := 'update ' + tName + ' set ' + subSql + ' where ' + whereSql + ';';
      end;
    finally
      strsRow.Free;
    end;
    Result := sql;
  end;

  procedure loadDicOfStr(const pks: string; dic: TDictionary<String, Boolean>);
  var strs: TStrings;
    i: integer;
    s: string;
  begin
    strs := TStringList.Create;
    try
      TCharSplit.SplitChar(pks, #59, strs);
      for I := 0 to strs.Count - 1 do begin
        s := strs[i].Trim;
        if not sameText(s, '') then begin
          dic.Add(strs[i], true);
        end;
      end;
    finally
      strs.Free;
    end;
  end;

var i: integer;
  s, sql: string;
  strsCol: TStrings;
  dicWhere, dicShowCol, dicHideCol: TDictionary<String, Boolean>;
  EquComparer: IEqualityComparer<string>; {相等对比器}
begin
  strsRst.Clear;
  strsRst.Add('start transaction;');
  if strs.Count <= 0 then exit;

  {通过 IEqualityComparer 让 TDictionary 的 Key 忽略大小写}
  EquComparer := TEqualityComparer<string>.Construct(
     function(const Left, Right: string): Boolean begin
       Result := LowerCase(Left) = LowerCase(Right);
     end,
     function(const Value: string): Integer begin
       Result := StrToIntDef(Value, 0); {我暂时不知道这个函数的作用, 随便写的}
     end
  );

  dicWhere := TDictionary<String, Boolean>.Create(EquComparer);
  dicHideCol := TDictionary<String, Boolean>.Create(EquComparer);
  dicShowCol := TDictionary<String, Boolean>.Create(EquComparer);
  strsCol := TStringList.Create;
  try
    loadDicOfStr(hideCols, dicHideCol);
    loadDicOfStr(showCols, dicShowCol);
    for I := 0 to strs.Count - 1 do begin
      S := strs[i];
      if (I=0) then begin
        TCharSplit.SplitChar(S, #9, strsCol);
        if (strscol.Count <=1 ) then begin
          strsRst.Add('error: 列数不能少于2列,请检查.');
          break;
        end;
        //
        if SameText(whereCols, '') then begin
          loadDicOfStr(strsCol[strs.Count-1], dicWhere);
        end else begin
          loadDicOfStr(whereCols, dicWhere);
        end;
        if (dicWhere.Count<=0) then begin
          strsRst.Add('error: where条件没有字段,请检查.');
          break;
        end;
      end else begin
        sql := doUpdateRow(strsCol, S, dicWhere, dicShowCol, dicHideCol);
        strsRst.Add(sql);
        //if stop
        if Assigned(blEvent) and (blEvent(sql)) then begin
          break;
        end;
      end;
    end;
  finally
    strsCol.Free;
    dicWhere.Free;
    dicHideCol.Free;
  end;
  strsRst.Add('commit;');
end;

class procedure TPaserUtils.parsePartsCode(const ctx: string; strs: TStrings;
    const json_cb: TGetStrProc; const htmlParse_cb: TGetStrProc;
    const strsF: TStrings; const ch: string);

  procedure strsToDict(strsF: TStrings; dict: TDictionary<string,String>);
  var i: integer;
    s: string;
  begin
    if strsF = nil then exit;
    
    for I := 0 to strsF.Count - 1 do begin
      s := strsF[i];
      if not SameText(s, '') then begin
        dict.Add(s, s);
      end;
    end;
  end;
var
  dict: TDictionary<string,String>;
  EqualityComparer: IEqualityComparer<string>; {相等对比器}
begin
  {通过 IEqualityComparer 让 TDictionary 的 Key 忽略大小写}
  EqualityComparer := TEqualityComparer<string>.Construct(
     function(const Left, Right: string): Boolean begin
       Result := LowerCase(Left) = LowerCase(Right);
     end,
     function(const Value: string): Integer begin
       Result := StrToIntDef(Value, 0); {我暂时不知道这个函数的作用, 随便写的}
     end
  );

  dict := TDictionary<string,String>.Create(EqualityComparer);
  try
    strsToDict(strsF, dict);
    parsePartsCode(ctx, strs, json_cb, htmlParse_cb, dict, ch);
  finally
    dict.Free;
  end;
end;

class procedure TPaserUtils.parsePartsCode(const ctx: string; strs: TStrings;
    const json_cb: TGetStrProc; const htmlParse_cb: TGetStrProc;
    const dict: TDictionary<String, String>; const ch: string);

  function isOK(const origin: string): boolean;
  begin
    if dict.Count <=0 then begin
      Result := true;
    end else begin
      Result := dict.ContainsKey(origin);
    end;
  end;

  procedure doParserCtx(const S: string; const id, nqty, origin, partName,
       partNo: string);
    function parseIt(const node: IHtmlElement): boolean;
    var
      e, t: IHtmlElement;
      i, k: integer;
      data_pcode, data_code: string;
      inrTxt, price: string;
      retStr: string;
    begin
      Result := false;
      if node = nil then exit;

      //memo3.Lines.Add(TPaserUtils.eleToStrRaw(node, true));
      data_pcode := node.Attributes['data-pcode'];
      if not isOK(data_pcode) then begin
        exit;
      end;
      data_code := node.Attributes['data-code'];
      for I := 0 to node.ChildrenCount - 1 do begin
        e := node.Children[I];
        if SameText(e.TagName, 'span')
              and SameText(e.Attributes['class'], 'col col-10') then begin
          //memo3.Lines.Add(TPaserUtils.eleToStrRaw(e, true));
          for k := 0 to e.ChildrenCount - 1 do begin
            t := e[k];
            //memo3.Lines.Add(TPaserUtils.eleToStrRaw(t, true));
            {if SameText(t.TagName, 'a') then begin
              //<a href="/pcIndexAction.action?
              if StartsText('/pcIndexAction.action?', t.Attributes['href']) then begin
                product := TPaserUtils.getCssFirst(t, 'em');
                // 机油滤芯 MAHLE_ORIG OC 608
                //取第一个
                part := product;//TCharSplit.getSplitFirst(product, ' ');
                Result := true;
              end;
            end else }if SameText(t.TagName, 'span')
                and SameText(t.Attributes['class'], 'fr p_price') then begin
              //<span class="fr p_price">市场参考价: ￥40.00</span>
              Result := true;
              inrTxt := t.InnerText;
              price := TCharSplit.getSplitLast(inrTxt, ': ');
              break;
            end;
          end;
        end;
        if Result then begin
          retStr := partName + ch + partNo + ch + data_pcode + ch + data_code + ch + price;
          strs.Add(retStr);
          if Assigned(htmlParse_cb) then begin
            htmlParse_cb(retStr);
          end;
        end;
      end;
    end;

    function parseList(const l: IHtmlElementList): boolean;
    var
      em: IHtmlElement;
      i: integer;
    begin
      Result := false;
      if l = nil then exit;
      for I := 0 to l.Count - 1 do begin
        em := l[I];
        Result := parseIt(em);
      end;
    end;

  var
    e: IHtmlElement;
  begin
    e := parserHtml(S);
    if (e <> nil) then begin
      parseList(e.SimpleCSSSelector('p.pl-g-list'));
    end;
  end;

  procedure processOne(const jsonVal: TJSONValue);
  var
    S: string;
    id, nqty, origin, partName, partNo: string;
  begin
//    "id":"D00200200812587108",
//    "nqty":"1",
//    "num":0,
//    "origin":"PART_ORIGIN",
//    "partName":"机油滤芯",
//    "partNo":"11421730389",
    jsonVal.TryGetValue<String>('id', id);
    jsonVal.TryGetValue<String>('nqty', nqty);
    jsonVal.TryGetValue<String>('origin', origin);
    jsonVal.TryGetValue<String>('partName', partName);
    jsonVal.TryGetValue<String>('partNo', partNo);
    if jsonVal.TryGetValue<String>('productTemplate', S) then begin
      if (Assigned(json_cb)) then begin
        json_cb(S);
      end;
      doParserCtx(S, id, nqty, origin, partName, partNo);
    end;
  end;

  procedure processList(const jsonArray: TJSONArray);
  var
    jsonVal : TJSONValue;
  begin
    for jsonVal in jsonArray do begin
      processOne(jsonVal);
    end;
  end;

  procedure processValue(const jsonVal: TJSONValue);
  begin
    if (jsonVal.ClassType = TJSONArray) then begin
      processList(jsonVal as TJSONArray);
    end else if (jsonVal.ClassType = TJSONObject) then begin
      processOne(jsonVal);
    end;
  end;

var
  //JSONObject: TJSONObject; // JSON类
  jsonVal: TJSONValue;
begin
  if Trim(ctx) = '' then begin
    exit;
  end;
  jsonVal := nil;
  try
    { 从字符串生成JSON } //TEncoding.UTF8.GetBytes(StrJson)
    jsonVal := TJSONObject.ParseJSONValue(Trim(ctx));
    processValue(jsonVal);
  finally
    jsonVal.Free;
  end;
end;

class procedure TPaserUtils.saveContext2FileName(strs: TStrings; const fileName: string);
begin
  TPaserUtils.forceDirs(fileName);
  strs.SaveToFile(fileName, TEncoding.UTF8 );
end;

class procedure TPaserUtils.saveTextTo(const fileName: string; const S: string;
  const addTime: boolean);
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    if addTime then begin
      strs.Add( FormatDateTime('yyyy-mm-dd hh:nn:ss -> ', now() ));
    end;
    strs.Add( S );
    saveContext2FileName(strs, fileName);
  finally
    strs.Free;
  end;
end;

class function TPaserUtils.getCtxOfAppUTF8(const fileName: string): string;
begin
  Result := getCtxOfFileUTF8(getAppFileName(fileName));
end;

class function TPaserUtils.getCtxOfPathFileUTF8(const path, fileName: string): string;
begin
  Result := getCtxOfFileUTF8(path + fileName);
end;

class procedure TPaserUtils.AppendLog(const fileName:string; const context:string;
  const addTime: boolean);
var
  txtF: TextFile;
begin
  Assignfile(txtF, fileName);
  try
    if FileExists(fileName) then
      Append(txtF)
    else
      ReWrite(txtF);
    if addTime then begin
      Writeln(txtF, FormatDateTime('hh:nn:ss.zzz', Now) + ' ' + context);
    end else begin
      Writeln(txtF, context);
    end;
  finally
    CloseFile(txtF);
  end;
end;

class procedure TPaserUtils.AppendText(const fileName, context: string);
begin
  AppendLog(fileName, context, false);
end;

{
procedure doIt.btnParserClick(Sender: TObject);
var
  ss: TStrings;
begin
  ss := TStringList.Create;
  try
    memo4.Clear;
    TPaserUtils.parsePartsCode('奥迪A4', 'D001', 'D000001', ss, self.Memo1.Lines.Text);
    memo4.Lines.AddStrings(ss);
  finally
    ss.Free;
  end;
end;
}

end.
