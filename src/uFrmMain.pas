unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ToolWin, Menus, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Generics.Collections,
  Vcl.Samples.Spin, uCarType, uCarSys, uCarBrand, uFrmSetting;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    ToolButton10: TToolButton;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    cbxStop: TCheckBox;
    ToolButton12: TToolButton;
    memoCtx: TMemo;
    Panel1: TPanel;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    memoLog: TMemo;
    memoCarSys: TMemo;
    memoBrand: TMemo;
    memoCarType: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    nGoto: TMenuItem;
    nBrand: TMenuItem;
    N2: TMenuItem;
    nExit: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    StatusBar1: TStatusBar;
    IdHTTP1: TIdHTTP;
    Splitter1: TSplitter;
    Splitter4: TSplitter;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    memoFactRepl: TMemo;
    Splitter5: TSplitter;
    Panel2: TPanel;
    Splitter6: TSplitter;
    Splitter7: TSplitter;
    memoVehType: TMemo;
    carTypeSql1: TMenuItem;
    cfgSql1: TMenuItem;
    N3: TMenuItem;
    Splitter8: TSplitter;
    memoVehTypeId: TMemo;
    cbxPar: TCheckBox;
    cbxURL: TComboBox;
    cbxCarType: TCheckBox;
    cbxTestCar: TCheckBox;
    carUpdateSql1: TMenuItem;
    Splitter9: TSplitter;
    memoCarSysRmBrd: TMemo;
    cbxCfg: TCheckBox;
    Splitter10: TSplitter;
    spedTimeout: TSpinEdit;
    Label1: TLabel;
    ToolButton4: TToolButton;
    setting1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure nGotoClick(Sender: TObject);
    procedure nBrandClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure carTypeSql1Click(Sender: TObject);
    procedure carUpdateSql1Click(Sender: TObject);
    procedure setting1Click(Sender: TObject);
  private
    { Private declarations }
    FFileConfig, FFileParam, FFileCarType: Text;
    frmSetting: TfrmSetting;
    FHost, FDataDir: string;
    //FBrandF, FFactoryF, FCarSysN, FCarT_Id: string;
    FDicNewFactory: TDictionary<String, String>;
    FDicVehType: TDictionary<String, String>;
    FDicVehTypeId: TDictionary<String, String>;
    FCarSysRmBrd: TDictionary<String, String>;
    FMapCarTypeRaw: TDictionary<Integer, String>;
    //FLogStrs: TStrings;
    // FCtxStrs: TStrings;
    procedure setStatus(const S: string; const setCap: boolean=false;
      const tmSleep: integer=0);
    // brand
    procedure doBrand();
    procedure doReqBrand(const url: string);
    // carsystem
    procedure doReqCarSys(carBrand: TCarBrand);
    procedure doParserCarSys(const S: string; carBrand: TCarBrand);
    // cartype
    procedure doReqCarType(carBrand: TCarBrand; carSys: TCarSys);
    procedure doParserCarType(const S: string; carSys: TCarSys);
    // detail
    procedure doReqCarDetail(const carTypeRawId, carTypeName, year: string;
        carSys: TCarSys);
    procedure doParserCarDetail(const S: string; const carTypeId, carTypeName: string;
      year: string; const opt: string; strs_: TStrings; const checked: boolean;
          var carType: TCarType);
    // tools
    function getSubDataDir(const S: string): string;
    procedure doUrlEvent(const S, S2: string);
    procedure addLog(const S: string);
    class function getAppFileName(const S: string): string;
    procedure addLogMod(const S: string; const nmod: integer);
    function isDoNew(): boolean;
    class function getAppSubFile(const dir, S: string): string; static;
    procedure loadFactReplIt;
    function  doStopSql(const S: string): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses StrUtils, uPaserUtils, uCharSplit, System.json, Generics.Defaults, uCarConfig, uCarParam;

{$R *.dfm}

procedure TfrmMain.setStatus(const S: string; const setCap: boolean; const tmSleep: integer);
begin
  StatusBar1.Tag := StatusBar1.Tag + 1;
  StatusBar1.Panels[0].Text := S;
  if setCap then begin
    caption := S;
  end;
  sleep(tmSleep);
  if (StatusBar1.Tag mod 10 = 0) then begin
    Application.ProcessMessages;
  end;
end;

procedure TfrmMain.setting1Click(Sender: TObject);
begin
  frmSetting.ShowModal;
end;

procedure TfrmMain.ToolButton1Click(Sender: TObject);
begin
  //DoParserCarSys(memoCtx.Lines.Text, '1', 'audi');
end;

procedure TfrmMain.ToolButton3Click(Sender: TObject);
begin
//  memoCarType.Lines.LoadFromFile(
//    getSubDataDir('cartype2015-12-25 18-46-34.txt'), TEncoding.UTF8);
end;

procedure TfrmMain.ToolButton7Click(Sender: TObject);
begin
  //D:\working\test\parser-che168\delphi-html-parser\dxe-demo\ul_data\奥迪\奥迪100
  //memoCarType.Lines.LoadFromFile(
  //  getSubDataDir('cartype2015-12-22 13-41-05.txt'), TEncoding.UTF8);
  //doParserCarDetail(memoCarType.Lines.Text, '1', 'audi', '一汽奥迪', '2', 'audi A8',
  //  '4', 'A4', '2014', 'param', memoCarType.Lines, true);
end;

class function TfrmMain.getAppFileName(const S: string): string;
begin
  Result := ExtractFilePath(Application.exeName) + S;
end;

class function TfrmMain.getAppSubFile(const dir, S: string): string;
begin
  Result := getAppFilename( dir + '\' + S);
end;

function TfrmMain.getSubDataDir(const S: string): string;
begin
  Result := getAppSubFile( FDataDir, S);
end;

procedure TfrmMain.addLogMod(const S: string; const nmod: integer);
begin
//  if memoLog.Lines.Count > 100 then begin
//    memoLog.clear;
//  end;
  memoLog.Lines.Add(s);
  self.setStatus(IntToStr(memoLog.Tag)+'/'+s);
  {memoLog.Tag := memoLog.Tag + 1;
  if (memoLog.Tag mod 100 = 0) then begin
    Application.ProcessMessages;
  end;
  if (memoLog.Tag mod nmod = 0) then begin
    self.setStatus(IntToStr(memoLog.Tag)+'/'+s);
  //end else if (memoLog.Tag mod 1000 = 0) then begin
    memoLog.Lines.AddStrings(FLogStrs);
    FLogStrs.Clear;
  end else begin
    FLogStrs.Add(S);
  end;}
end;

procedure TfrmMain.addLog(const S: string);
begin
  addLogMod(s, 0);
end;

procedure TfrmMain.carTypeSql1Click(Sender: TObject);
begin
//  Screen.Cursor := crHourGlass;
//  memoCarSys.lines.beginUpdate;
//  TPaserUtils.getInsertSqlOfStrs(memoCarType.Lines, 'a_cartype',
//    memoCarSys.Lines, doStopSql);
//  memoCarSys.lines.endUpdate;
//  Screen.Cursor := crDefault;
end;

procedure TfrmMain.carUpdateSql1Click(Sender: TObject);
begin
//  Screen.Cursor := crHourGlass;
//  memoCarSys.lines.beginUpdate;
//  TPaserUtils.getUpdateSqlOfStrs(memoCarType.Lines, 'a_cartype', 'rawid',
//    memoCarSys.Lines, 'carTypeId', doStopSql);
//  memoCarSys.lines.endUpdate;
//  Screen.Cursor := crDefault;
end;

function TFrmMain.isDoNew(): boolean;
var url: string;
begin
  url := self.cbxURL.Text;
  // http://www.che168.com/handler/usedcarlistv5.ashx?action=brandlist
  if url.indexof('usedcarlistv5.ashx')>0 then begin
    Result := true;
  end else begin  // http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?needData=1
    Result := false;
  end;
end;

procedure TfrmMain.doBrand;

  procedure splitBrand(strs: TStrings);
    procedure doItBrand(const S: string);
    var
      brand: TCarBrand;
      str: String;
      bHit: boolean;
    begin
      brand := TCarBrand.Create;
      try
        brand.setRow(S);
        setStatus(brand.getRow());
        //doReqCarSys
        //if (SameText(FBrandF, '')) or SameText(FBrandF, brand.brand_name) then begin
        bHit := (frmSetting.hit(brand.car_brand_name));
        if bHit then begin
          str := 'hit...';
        end else begin
          str := 'pass.';
        end;
        self.memoCtx.Lines.Add(IntToStr(memoCtx.lines.count)+ ', ' + brand.car_brand_name + ', ' + str);
        if bHit then begin
          doReqCarSys(brand);
        end;
      finally
        brand.Free;
      end;
    end;
  var i: integer;
    S: string;
  begin
    for I := 1 to strs.Count - 1 do begin    //0为列头
      if self.cbxStop.checked then begin
        break;
      end;
      S := strs[I];
      doItBrand(S);
    end;
    self.memoCtx.Lines.Add(IntToStr(memoCtx.lines.count)+ ', ' + 'all brand' + ', finish.');
  end;
var dtNow: TDateTime;
  dtFmt,
  tmpFName: string;
begin
  Screen.cursor := crHourGlass;
  dtNow := now;
  dtFmt := FormatDateTime('yyyy-mm-dd hh-nn-ss', now);
  memoLog.Tag := 0;
  memoLog.clear;
  addLog('开始计算...');// + dtFmt);
  StatusBar1.Tag := 0;
  memoCtx.Tag := 0;

  memoCarSys.Clear;
  memoCtx.Clear;
  //
//  memoCarType.Clear;
//  memoCarType.Lines.BeginUpdate;

  if (self.cbxCarType.Checked) then begin
    tmpFName := self.getSubDataDir('cartype-all.txt');
    //if (not FileExists(tmpFName)) then begin
      AssignFile(FFileCarType, tmpFName);
      Rewrite(FFileCarType);
      // WriteLn(FFileCarType, TCarType.getColumn());
      WriteLn(FFileCarType, TCarType.getBegin());
    //end else begin
    //  AssignFile(FFileCarType, tmpFName);
    //  Append(FFileCarType);
    //end;
  end;

  if (self.cbxPar.Checked) then begin
    tmpFName := self.getSubDataDir('cartype-par_all.txt');
    //if (not FileExists(tmpFName)) then begin
      AssignFile(FFileParam, tmpFName);
      Rewrite(FFileParam);
      WriteLn(FFileParam, TCarParam.getBegin());
    //end else begin
    //  AssignFile(FFileParam, tmpFName);
    //  Append(FFileParam);
    //end;
  end;

  if (self.cbxCfg.Checked) then begin
    tmpFName := self.getSubDataDir('cartype-cfg_all.txt');
    //if (not FileExists(tmpFName)) then begin
      AssignFile(FFileConfig, tmpFName);
      Rewrite(FFileConfig);
      WriteLn(FFileConfig, TCarConfig.getBegin());
    //end else begin
    //  AssignFile(FFileConfig, tmpFName);
    //  Append(FFileConfig);
    //end;
  end;

  try
    splitBrand(memoBrand.Lines);
  finally
    self.addLog('结束计算，耗时：' + FormatDateTime('hh:nn:ss', now - dtNow));
    //memoCarType.Lines.EndUpdate;
    //
    memoBrand.Lines.SaveToFile(self.getSubDataDir('carbrand_all.txt'),
      TEncoding.UTF8);
    memoCarSys.Lines.SaveToFile(self.getSubDataDir('carsys_all.txt'),
      TEncoding.UTF8);
    {memoCarType.Lines.SaveToFile(self.getSubDataDir('cartype_'+dtFmt+'.txt'),
      TEncoding.UTF8);}
    memoLog.Lines.SaveToFile(self.getSubDataDir('log_'+dtFmt+'.log'),
      TEncoding.UTF8);
    //
    if (self.cbxCarType.Checked) then begin
      //WriteLn(FFileConfig, TCarParam.getEnd());
      WriteLn(FFileCarType, TCarType.getEnd());
      CloseFile(FFileCarType);
    end;
    if (self.cbxPar.Checked) then begin
      WriteLn(FFileParam, TCarConfig.getEnd());
      CloseFile(FFileParam);
    end;
    if (self.cbxCfg.Checked) then begin
      WriteLn(FFileConfig, TCarConfig.getEnd());
      CloseFile(FFileConfig);
    end;
    //
    Screen.cursor := crDefault;
  end;
end;

function TfrmMain.doStopSql(const S: string): Boolean;
begin
  addLogMod(S, 100);
  if cbxStop.checked then begin
    Result := true;
  end else begin
    Result := false;
  end;
end;

procedure TfrmMain.nBrandClick(Sender: TObject);
begin
  doBrand;
end;

procedure TfrmMain.nGotoClick(Sender: TObject);
var url: string;
begin
  url := self.cbxURL.Text;
  if LowerCase(copy(url, 1, length('http://'))) <> 'http://' then begin
    url := FHost + url;
  end;
  //
  doReqBrand(url);
end;

procedure TfrmMain.doReqBrand(const url: string);

  procedure parserBrandCtx(const S: string; strsRst: TStrings);

    function doTrimSpace(const S: string): string;
    begin
      if s.IndexOf(#32)>0 then begin
        Result := TCharSplit.replaceSplitChar(s, #32, #32);
      end else begin
        Result := S;
      end;
    end;

    procedure splitBrand(strs, strsRst: TStrings);
    var i, npos: integer;
      tmp, sleft, sright: string;
      carBrand: TCarBrand;
    begin
      carBrand := TCarBrand.Create;
      try
      if strsRst.count<=0 then begin
        strsRst.Add(TCarBrand.getColumn());
      end;

      for I := 0 to strs.Count - 1 do begin
        tmp := strs[I];
        npos := tmp.IndexOf(#32);
        if (npos>0) then begin
          sleft:= tmp.Substring(0, npos);
          sright := tmp.Substring(npos+1, tmp.Length);
          //
          carBrand.car_brand_name := doTrimSpace(sright);
          carBrand.setRawId( TCharSplit.getSplitFirst(sleft, #9) );
          carBrand.short_code := TCharSplit.getSplitLast(sleft, #9);
          carBrand.car_brand_code := carBrand.short_code;
          carBrand.letter := carBrand.short_code;
        end;
        strsRst.Add( carBrand.getRow() );
      end;
      finally
        carBrand.Free;
      end;
    end;

    function toDoit(const S: string): string;
    var str: string;
    begin
      str := TCharSplit.getSplitIdx(s, #59, 1); // ;
      str := TCharSplit.getSplitLast(str, #61); // =
      str := TCharSplit.getSplitMid(str, #39);  // '
      //再按 , 进行分组，两个一组
      Result := TCharSplit.getSplitCharG(str, #44, 1); // ,
    end;

  var strs: TStrings;
  begin
    strs := TStringList.Create;
    try
      strs.Text := toDoIt(S);
      splitBrand(strs, strsRst);
    finally
      strs.Free;
    end;
  end;

  function parserBrandCtx2(const S: string; strs: TStrings): string;

    procedure processOne(const jsonVal: TJSONValue; strs: TStrings);
    var id, name, letter, spell: string;
    begin
      //"id":33,"name":"奥迪","pinyin":"aodi","letters":"A"
      if jsonVal.TryGetValue<String>('id', id) then begin
        jsonVal.TryGetValue<String>('id', id);
        jsonVal.TryGetValue<String>('name', name);
        jsonVal.TryGetValue<String>('pinyin', spell);
        jsonVal.TryGetValue<String>('letters', letter);
        if strs.count<=0 then begin
          strs.add('rawid' + #9 + 'letter' + #9 + 'BrandName' + #9 + 'spell');
        end;
        strs.add(id + #9 + letter + #9 + name + #9 + spell);
      end;
    end;

    procedure processList(const jsonArray: TJsonArray; strs: TStrings);
    var i: integer;
    begin
      for i := 0 to jsonArray.Count - 1 do begin
        processOne(jsonArray.Items[i], strs);
      end;
    end;

  var
    jsonVal: TJSONValue;
  begin
    if Trim(S) = '' then begin
      exit;
    end;
    jsonVal := TJSONObject.ParseJSONValue(S);
    try
      processList(jsonVal as TJsonArray, strs);
    finally
      jsonVal.Free;
    end;
  end;

var S: string;
  //dtNow: TDateTime;
  //dtFmt: string;
begin
  memoBrand.clear;
  FMapCarTypeRaw.Clear;
  //dtNow := now;
  //dtFmt := FormatDateTime('yyyy-mm-dd hh-nn-ss', dtNow);
  S := TPaserUtils.getCtxOfUrlDef(idhttp1, url,
      getSubDataDir('allbrand_' + 'get' + '.txt'), false, doUrlEvent);
  if isDoNew() then begin
    memoFactRepl.Lines.Text := memoFactRepl.Lines.Text.Replace('其他', '其它');
    loadFactReplIt();
    parserBrandCtx2(S, memoBrand.Lines);
  end else begin
    memoFactRepl.Lines.Text := memoFactRepl.Lines.Text.Replace('其它', '其他');
    loadFactReplIt();
    parserBrandCtx(S, memoBrand.Lines);
  end;
end;

procedure TfrmMain.doUrlEvent(const S, S2: string);
begin
  addLog(S + #9 + S2);
end;

  function getRightChar(const S: string; const c: char; const incl: boolean=false): string;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if incl then
      Result := s.Substring(n, s.Length)
    else
      Result := s.Substring(n+1, s.Length)
  end;

  function getLeftChar(const S: string; const c: char; const incl: boolean=false): string;
  var n: integer;
  begin
    n := S.LastIndexOf(c);
    if incl then
      Result := s.Substring(0, n+1)
    else
      Result := s.Substring(0, n)
  end;

  function getLeftLeftChar(const S: string; const c: char; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if (n>0) then begin
      if incl then begin
        str := s.Substring(0, n+1);
      end else begin
        str := s.Substring(0, n);
      end;
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  function getLeftLeftStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if (n>0) then begin
      if incl then begin
        str := s.Substring(0, n+1);
      end else begin
        str := s.Substring(0, n);
      end;
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  function getRightStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if (n>0) then begin
      if incl then
        str := s.Substring(n, s.Length)
      else
        str := s.Substring(n+1, s.Length);
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  function getRightRightStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.LastIndexOf(c);
    if (n>0) then begin
      if incl then
        str := s.Substring(n, s.Length)
      else
        str := s.Substring(n+1, s.Length);
      Result := true;
    end else begin
      Result := false;
    end;
  end;

procedure TfrmMain.doReqCarDetail(const carTypeRawId, carTypeName, year: string;
    carSys: TCarSys);

  function geUrlOfCarTypeId(const carTypeId: string; const opt: string): string;
  var sReqUrl: string;
  begin
    //http://www.interface.che168.com/CarProduct/GetParam.ashx?specid=3906&_callback=param
    sReqUrl := 'http://www.interface.che168.com/CarProduct/';
    if (SameText(opt, 'param')) then begin
      result := sReqUrl + 'GetParam.ashx?_callback=param&specid='+carTypeId;
    end else if (SameText(opt, 'config')) then begin
      result := sReqUrl + 'GetConfig.ashx?_callback=config&specid='+carTypeId;
    end else begin
      Result := '';
    end;
  end;

  function getFNameOfCarTypeId(const carTypeId: string; const opt: string): string;
  begin
    result := getSubDataDir(carSys.car_brand_name + '\' + carSys.car_serie_name + '\carconfig_'
      + carTypeId + '_' + opt + '.json');
  end;

  function preProcessA(const str: string; const opt: string): string;
  var S: string;
  begin
    S := str;
    {S := StringReplace(str, '&nbsp;', '', [rfReplaceAll]);
    if (SameText(opt, 'param')) then begin
      //S := StringReplace(S, '"paramtypeitems":', '"par":', [rfReplaceAll]);
      S := StringReplace(S, '"paramitems":', '"g":', [rfReplaceAll]);
      S := StringReplace(S, '"name":', '"k":', [rfReplaceAll]);
      S := StringReplace(S, '"value":', '"v":', [rfReplaceAll]);
    end else if (SameText(opt, 'config')) then begin
      //S := StringReplace(S, '"configtypeitems":', '"cfg":', [rfReplaceAll]);
      S := StringReplace(S, '"configitems":', '"g":', [rfReplaceAll]);
      S := StringReplace(S, '"name":', '"k":', [rfReplaceAll]);
      S := StringReplace(S, '"value":', '"v":', [rfReplaceAll]);
    end;}
    S := getRightChar(S, #40);
    S := getLeftChar(S, #41);
    Result := S;
  end;

  procedure processIt(const carTypeId: string; const opt: string;
    strs: TStrings; const checked: boolean; var carType: TCarType);
  var url, fname, S, str: string;
  begin
    url := geUrlOfCarTypeId(carTypeId, opt);
    if not SameText(url, '') then begin
      fname := getFNameOfCarTypeId(carTypeId, opt);
      S := TPaserUtils.getCtxOfUrlDef(idhttp1, url, fname, false, doUrlEvent);
      str := preProcessA(S, opt);
      doParserCarDetail(str, carTypeId, carTypeName, year, opt, strs, checked, carType);
    end;
  end;
var
  carType: TCarType;
begin
  carType := TCarType.Create;
  try
    //carType.car_type_id := IntToStr(memoCarType.Lines.Count);
    carType.car_brand_id := carSys.car_brand_id;
    carType.car_brand_name := carSys.car_brand_name;
    carType.car_oem_name := carSys.car_oem_name;
    carType.car_serie_id := carSys.car_serie_id;
    carType.car_serie_name := carSys.car_serie_name;
    carType.year_model := year;
    carType.setRawId(carTypeRawId);
    carType.car_type_name := carTypeName;
    //
    processIt(carTypeRawId, 'param', nil, cbxPar.Checked, carType);
    processIt(carTypeRawId, 'config', nil, cbxCfg.Checked, carType);
    //
    //WriteLn(FFileCarType, carType.getRow());
    WriteLn(FFileCarType, carType.updateGearSql());
  finally
    carType.Free;
  end;
end;

procedure TfrmMain.doParserCarDetail(const S: string; const carTypeId, carTypeName: string;
      year: string; const opt: string; strs_: TStrings; const checked: boolean;
          var carType: TCarType);

  procedure doCarParam(const S: string; strs: TStrings; var carType: TCarType);
    procedure doParamTypeItems(JsonResult: TJSONObject; strs: TStrings);
    var
      typeItem: TJSONObject;
      paramTypeItems: TJSONArray;
      I: Integer;
      typeName: string;
      //carPar: TCarParam;

      procedure doParamItems_CarType(const itemName: string;
        const k, v: string);
      var str: string;
      begin
        if itemName.Equals('基本参数') then begin
          if k.Equals('厂商指导价(元)') then begin
            carType.sug_price := v;
          end else if k.Equals('级别') then begin
          end else if k.Equals('上市时间') then begin
            str := v+'.1';
            carType.sale_date := str.Replace('.', '-');
          //end else if k.Equals('发动机') then begin
          //  carType.engine := v;
          //end else if k.Equals('变速箱') then begin
          //  carType.gear := v;
          end else if k.Equals('车身结构') then begin
          end else if k.Equals('整车质保') then begin
          end;
        end else if itemName.Equals('车身') then begin
          if k.Equals('车身结构') then begin
          end;
        end else if itemName.Equals('发动机') then begin
          if k.Equals('发动机型号') then begin
            carType.engine := v;
          end else if k.Equals('排量(L)') then begin
            carType.display := v;
          end else if k.Equals('进气形式') then begin
            if v.Contains('涡轮增压') then begin
              carType.dispunit := 'T';
            end;
          end;
        end else if itemName.Equals('变速箱') then begin
          //if k.Equals('简称') then begin
          //end else
          if k.Equals('变速箱类型') then begin
            carType.gear := v;
          end;
        end;
      end;

      procedure jsonItemToBean(const car_param_type_name: string; k,v: string);
      var carPar: TCarParam;
      begin
        carPar := TCarParam.create;
        try
          //carPar.car_param_id:= IntToStr(strs.Count);
          carPar.car_type_id := carType.car_type_id;
          carPar.car_param_type_name := car_param_type_name;
          carPar.car_param_name := k;
          carPar.car_param_value := v;
          if (checked) then begin
            WriteLn(FFileParam, carPar.getRow());
          end;
        finally
          carPar.Free;
        end;
      end;

      procedure doParamItems(const car_param_type_name: string;
        paramItems: TJSONArray; strs: TStrings);
      var
        I: Integer;
        item: TJSONObject;
        k,v: string;
      begin
       for I := 0 to paramItems.Count-1 do begin
          item := paramItems.Items[I] as TJSONObject;
          k := item.GetValue<String>('name');
          v := item.GetValue<String>('value');
          jsonItemToBean(car_param_type_name, k, v);
          //
          doParamItems_CarType(car_param_type_name, k, v);
        end;
      end;
    begin
      paramTypeItems := JsonResult.GetValue('paramtypeitems') as TJSONArray;
      if Assigned(paramTypeItems) then begin
        for I := 0 to paramTypeItems.Count-1 do begin
          typeItem := paramTypeItems.Items[I] as TJSONObject;
          typeName := typeItem.GetValue<String>('name');
          doParamItems(typeName, typeItem.GetValue<TJSONArray>('paramitems'), strs);
        end;
      end;
    end;

  var
    JsonRoot, JsonResult: TJSONObject;
  begin
    JsonRoot := TJSONObject.ParseJSONValue(S) as TJSONObject ;
    try
      JsonResult := JsonRoot.GetValue('result') as TJsonObject;
      doParamTypeItems(JsonResult, strs);
    finally
      JsonRoot.Free;
    end;
  end;

  procedure doCarConfig(const S: string; strs: TStrings; var carType: TCarType);

    procedure doConfigTypeItems(JsonResult: TJSONObject; strs: TStrings);
    var
      typeItem: TJSONObject;
      configTypeItems: TJSONArray;
      I: Integer;
      typeName: string;

      procedure jsonItemToBean(const car_cfg_type_name: string; k,v: string);
      var carCfg: TCarConfig;
      begin
        carCfg := TCarConfig.create;
        try
          carCfg.car_type_id := carType.car_type_id;
          carCfg.car_cfg_type_name := car_cfg_type_name;
          carCfg.car_cfg_name := k;
          carCfg.car_cfg_value := v;
          //
          if (checked) then begin
            WriteLn(FFileConfig, carCfg.getRow());
          end;
        finally
          carCfg.Free;
        end;
      end;

      procedure doConfigItems(const car_cfg_type_name: string;
        paramItems: TJSONArray; strs: TStrings);
      var
        I: Integer;
        item: TJSONObject;
        k, v: string;
      begin
        for I := 0 to paramItems.Count-1 do begin
          item := paramItems.Items[I] as TJSONObject;
          //
          k := item.GetValue<String>('name');
          v := item.GetValue<String>('value');
          jsonItemToBean(car_cfg_type_name, k, v);
        end;
      end;

    begin
      configTypeItems := JsonResult.GetValue('configtypeitems') as TJSONArray;
      if Assigned(configTypeItems) then begin
        for I := 0 to configTypeItems.Count-1 do begin
          typeItem := configTypeItems.Items[I] as TJSONObject;
          typeName := typeItem.GetValue<String>('name');
          doConfigItems(typeName, typeItem.GetValue<TJSONArray>('configitems'), strs);
        end;
      end;
    end;

  var
    JsonRoot, JsonResult: TJSONObject;
  begin
    JsonRoot := TJSONObject.ParseJSONValue(S) as TJSONObject ;
    try
      JsonResult := JsonRoot.GetValue('result') as TJsonObject;
      doConfigTypeItems(JsonResult, strs);
    finally
      JsonRoot.Free;
    end;
  end;

var str: string;
begin
  str := carType.car_brand_name + '/' + carType.car_oem_name + '/' +
    carType.car_serie_name + '/' +
    carTypeName + '/' +
    carTypeId + '/' + carTypeName + '/' + year;
  self.setStatus(str);
  if opt.Equals('param') then begin
    doCarParam(S, strs_, carType);
  end else if opt.Equals('config') then begin
    doCarConfig(S, strs_, carType);
  end;
end;

procedure TfrmMain.doReqCarSys(carBrand: TCarBrand);
var url, fname, S, carSysFName: string;
  brandIdRaw, brandName, brandSpell: string;
begin
  brandIdRaw := carBrand.getRawId();
  brandName := carBrand.car_brand_name;
  brandSpell := carBrand.getSpell;
  //
  if isDoNew() then begin
    //http://www.che168.com/handler/usedcarlistv5.ashx?action=serieslist&brand=aodi
    carSysFName := 'carsys_.txt';
    url := 'http://www.che168.com/handler/usedcarlistv5.ashx?'
      + 'action=serieslist&brand='+brandSpell;
  end else begin
    //http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?seriesGroupType=2&needData=2&bid=33
    carSysFName := 'carsys.txt';
    url := 'http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?'
      + 'seriesGroupType=2&needData=2&bid='+brandIdRaw;
  end;
  fname := getSubDataDir(brandName + '\' + carSysFName);
  S := TPaserUtils.getCtxOfUrlDef(idhttp1, url, fname, false, self.doUrlEvent);
  DoParserCarSys(S, carBrand);
end;

function rmSubStr(const S: string; const sub: string): string;
var
  n: integer;
begin
  n := S.IndexOf(sub);
  if n>=0 then begin
    Result := trim(S.Substring(n+sub.Length));
  end else begin
    Result := S;
  end;
end;

{function rmSubStr(const S: string; const sub: string): string;
var
  n: integer;
begin
  if S.StartsWith(sub) and (not SameText(S, Sub)) then begin
    n := S.IndexOf(sub);
    if n>=0 then begin
      Result := S.Substring(n+sub.Length);
    end else begin
      Result := S;
    end;
  end else begin
    Result := S;
  end;
end;}

procedure TfrmMain.doParserCarSys(const S: string; carBrand: TCarBrand);
  function doTrimSpace(const S: string): string;
  begin
    if s.IndexOf(#32)>0 then begin
      Result := TCharSplit.replaceSplitChar(s, #32, #32);
    end else begin
      Result := S;
    end;
  end;

  procedure splitCarSys(strs: TStrings);

    function getNewFactory(const brandName, factory, carSysName: string;
      var v: string): boolean;
    var
      k: string;
    begin
      k := brandName + '/' + factory + '/' + carSysName;
      Result := FDicNewFactory.TryGetValue(k, v);
    end;

    procedure doItCarSys(strs: TStrings);
    var i: integer;
      tmp, carSysSpell, brandName: string;
      rawId, factory, factoryNew, carSysName: string;
      carSys: TCarSys;
    begin
      brandName := carBrand.car_brand_name;
      carSysSpell := '';
      rawId := '';
      factory := '';
      factoryNew := '';
      carSysName := '';
      carSys := TCarSys.Create();
      try
        for I := 0 to strs.Count - 1 do begin
          //tmp := StringReplace(strs[I], #9, '', [rfReplaceAll]);
          tmp := strs[I];
          case I of
            0: begin
              rawId := tmp;
            end;
            1: begin
              factory := tmp;
            end;
            2: begin
               if not FCarSysRmBrd.ContainsKey(tmp)
                   or (FCarSysRmBrd.Count<=0) then begin
                 if tmp.StartsWith(brandName) and (not SameText(brandName, tmp)) then begin
                   carSysName := rmSubStr(tmp, brandName);
                   carSysName := rmSubStr(carSysName, '-');
                   if carSysname.Length<2 then begin
                     carSysName := tmp;
                   end;
                 end else begin
                   carSysName := tmp;
                 end;
               end else begin
                 carSysName := tmp;
               end;
            end;
            3: begin
              carSysSpell := tmp;
            end;
          end;
          setStatus(tmp);
        end;
        //doReqCarType
        //if (SameText(FFactoryF, '')) or SameText(FFactoryF, factory) then begin
        if True then begin        
          //if (SameText(FCarSysN, '')) or SameText(FCarSysN, carSysName) then begin
          if True then begin          
            if not getNewFactory(carBrand.car_brand_name, factory, carSysName, factoryNew) then begin
              factoryNew := factory;
            end;
            if memoCarSys.Lines.Count<=0 then begin
              memoCarSys.Lines.Add(TCarSys.getColumn());
            end;

            carSys.SetRawId(rawId);
            carSys.car_brand_id := carBrand.car_brand_id;
            carSys.car_brand_id_raw := carBrand.getRawId();
            carSys.car_brand_name := carBrand.car_brand_name;
            carSys.car_oem_name := factoryNew;
            carSys.car_serie_name := carSysName;
            carSys.car_serie_code := carSysSpell;
            carSys.short_code := carSysSpell;
            carSys.carSysSpell := carSysSpell;
            //
            memoCarSys.Lines.Add(carSys.getRow());
            if cbxCarType.Checked then begin
              doReqCarType(carBrand, carSys);
            end;
          end;
        end;
      finally
        carSys.Free;
      end;
    end;

  var i: integer;
    tmp: string;
    ss: TStrings;
  begin
    ss := TStringList.Create;
    try
      for I := 0 to strs.Count - 1 do begin
        tmp := strs[I];
        ss.Clear;
        TCharSplit.SplitChar(tmp, #9, ss);
        doItCarSys(ss);
        if self.cbxStop.checked then begin
          break;
        end;
      end;
    finally
      ss.Free;
    end;
  end;

  procedure parserCarSys(const S: string; strs: TStrings);
    procedure splitSpaceStr(strs: TStrings);
    var i, npos: integer;
      S, tmp, sleft, sright: string;
    begin
      for I := 0 to strs.Count - 1 do begin
        tmp := strs[I];
        npos := tmp.IndexOf(#32);
        if (npos>0) then begin
          sleft:= tmp.Substring(0, npos);
          sright := tmp.Substring(npos+1, tmp.Length);
          S := doTrimSpace(sright);
          S := sleft + #9 + S;
          strs[I] := S;
        end;
      end;
    end;
  var str: string;
  begin
    str := TCharSplit.getSplitIdx(s, #59, 1); // ;
    str := TCharSplit.getSplitLast(str, #61); // =
    str := TCharSplit.getSplitMid(str, #39);  // '
    //再按 , 进行分组，两个一组
    strs.Text := TCharSplit.getSplitCharG(str, #44, 1); // ,
    splitSpaceStr(strs);
  end;

  function parserCarSys2(const S: string; strs: TStrings): string;

    procedure processOne(const jsonVal: TJSONValue; strs: TStrings);
    var id, name, spell, fact: string;
    begin
      //"id":3170,"name":"奥迪A3","pinyin":"aodia3","fact":"一汽-大众奥迪"
      if jsonVal.TryGetValue<String>('id', id) then begin
        jsonVal.TryGetValue<String>('name', name);
        jsonVal.TryGetValue<String>('pinyin', spell);
        jsonVal.TryGetValue<String>('fact', fact);
        strs.add(id + #9 + fact + #9 + name + #9 + spell);
      end;
    end;

    procedure processList(const jsonArray: TJsonArray; strs: TStrings);
    var i: integer;
    begin
      for i := 0 to jsonArray.Count - 1 do begin
        processOne(jsonArray.Items[i], strs);
        if self.cbxStop.checked then begin
          break;
        end;
     end;
    end;

  var
    jsonVal: TJSONValue;
  begin
    if Trim(S) = '' then begin
      exit;
    end;
    jsonVal := TJSONObject.ParseJSONValue(S);
    try
      processList(jsonVal as TJsonArray, strs);
    finally
      jsonVal.Free;
    end;
  end;

var strs: TStrings;
  brandIdRaw, brandName, brandSpell: string;
begin
  brandIdRaw := carBrand.getRawId();
  brandName := carBrand.car_brand_name;
  brandSpell := carBrand.getSpell;
  strs := TStringList.Create;
  try
    if self.isDoNew then begin
      parserCarSys2(s, strs);
    end else begin
      parserCarSys(s, strs);
    end;
    splitCarSys(strs);
  finally
    strs.Free;
  end;
end;

procedure TfrmMain.doReqCarType(carBrand: TCarBrand; carSys: TCarSys);
var url, fname, S, carTypeFileName: string;
  brandSpell, carSysSpell, carsysId, brandName, carSysName: string;
begin
  brandSpell := carBrand.getSpell;
  carSysSpell := carSys.carSysSpell;
  carsysId := carSys.car_serie_id;
  brandName := carSys.car_brand_name;
  carSysName := carSys.car_serie_name;
  //
  if self.isDoNew then begin
    //列出年份
    //http://www.che168.com/handler/usedcarlistv5.ashx?action=seriesYearList&area=china&brand=aodi&ls=aodiq3
    //全部年份
    //http://www.che168.com/handler/UsedCarListV5.ashx?action=speclist&area=china&brand=aodi&ls=aodia3
    url := 'http://www.che168.com/handler/usedcarlistv5.ashx?' +
      'action=speclist&brand=' + brandSpell + '&ls=' + carSysSpell;
    carTypeFileName := 'cartype_';
  end else begin
    //http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?seriesGroupType=2&needData=3&seriesid=3170
    url := 'http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?' +
      'seriesGroupType=2&needData=3&seriesid=' + carsysId;
    carTypeFileName := 'cartype';
  end;
  fname := getSubDataDir(brandName + '\' + carSysName + '\' + carTypeFileName + '.txt');
  S := TPaserUtils.getCtxOfUrlDef(idhttp1, url, fname, false, self.doUrlEvent);
  doParserCarType(S, carSys);
end;

procedure TfrmMain.doParserCarType(const S: string; carSys: TCarSys);

  procedure adjustCar(var year, carTypeName: string);
  var  carTypeMini, carTypeNew, S: string;
        w: char;
  begin
    if getLeftLeftStr(carTypeName, '款', S) then begin
      carTypeMini := trim(getRightChar(carTypeName, #32));
      if (SameText(year, '')) then begin
        if s.Length>2 then begin
          carTypeNew := carTypeName;
        end else begin
          w := s[1];
          if (CharInSet(w, ['0', '1', '2', '3'])) then begin
            year := '20' + S;
            carTypeNew := year + '款 ' + carTypeMini;
          end else if (CharInSet(w, ['9', '8', '7', '6'])) then begin
            year := '19' + S;
            carTypeNew := year + '款 ' + carTypeMini;
          end else begin
            carTypeNew := carTypeName;
          end;
        end;
        carTypeName := carTypeNew;
      end else begin
        carTypeNew := year + '款 ' + carTypeMini;
        carTypeName := carTypeNew;
      end;
    end
  end;

  procedure processOne(const jsonVal: TJSONValue);
    procedure processA(var year: string; const jsonV: TJSONValue);
    var carTypeStrRawId, carName: string;
      carTypeIdRaw: integer;
    begin
      jsonV.TryGetValue<String>('id', carTypeStrRawId);
      carTypeStrRawId := StringReplace(carTypeStrRawId, #9, '', [rfReplaceAll]);
      carTypeIdRaw := StrToIntDef(carTypeStrRawId, 0);
      if not FMapCarTypeRaw.ContainsKey(carTypeIdRaw) then begin
        jsonV.TryGetValue<String>('name', carname);
        //do detail
        //if (SameText(FCarT_Id, '')) or SameText(FCarT_Id, carTypeRawId) then begin
        if True then begin
          carName := StringReplace(carName, #9, '', [rfReplaceAll]);
          if year.IsEmpty then begin
            adjustCar(year, carName);
          end;
          doReqCarDetail(carTypeStrRawId, carName, year, carSys);
        end;
        FMapCarTypeRaw.Add(carTypeIdRaw, carName);
      end;
   end;
  var
    year: string;
    i: integer;
    jsonArray: TJSONArray; // JSON数组变量
  begin
    jsonVal.TryGetValue<String>('year', year);
    year := StringReplace(year, '款', '', [rfReplaceAll]);
    //if StrToIntDef(year, 0)<2000 then begin    //去除 2000 以前的车型数据
    //  exit;
    //end;

    jsonVal.TryGetValue<TJSONArray>('spec', jsonArray);
    for i := 0 to jsonArray.Count - 1 do begin
      processA(year, jsonArray.Items[i]);
    end;
  end;

  procedure processOne2(const jsonVal: TJSONValue);

  var
    year, carTypeRawId, carName: string;
    carId: integer;
  begin
    carid := 0;
    if (jsonVal.TryGetValue<Integer>('id', carId)) and (carid>0) then begin
      if not FMapCarTypeRaw.ContainsKey(carId) then begin
        carTypeRawId := IntToStr(carid);
        if True then begin        
        //if (SameText(FCarT_Id, '')) or SameText(FCarT_Id, carTypeRawId) then begin
          jsonVal.TryGetValue<String>('year', year);
          year := StringReplace(year, '款', '', [rfReplaceAll]);
          jsonVal.TryGetValue<String>('name', carName);
          if year.IsEmpty then begin
            adjustCar(year, carName);
          end;
          doReqCarDetail(carTypeRawId, carName, year, carSys);
        end;
        FMapCarTypeRaw.Add(carId, carName);
      end else begin
        carName := FMapCarTypeRaw.Items[carId];
        self.addLog(IntToStr(carId) + '/' + carname + '，已经存在了。');
      end;
    end;
  end;

  procedure processList(const jsonArray: TJSONArray);
  var
    jsonVal : TJSONValue;
  begin
    for jsonVal in jsonArray do begin
      if self.cbxStop.checked then begin
        break;
      end;
      if self.isDoNew then begin
        processOne2(jsonVal);
      end else begin
        processOne(jsonVal);
      end;
    end;
  end;

  procedure processValue(const jsonVal: TJSONValue);
  begin
    if (jsonVal = nil) then begin
      exit;
    end else if (jsonVal.ClassType = TJSONArray) then begin
      processList(jsonVal as TJSONArray);
    end else if (jsonVal.ClassType = TJSONObject) then begin
      processOne(jsonVal);
    end;
  end;

  procedure parserItA(const S: string);
  var
    jsonVal: TJSONValue;
  begin
    if Trim(S) = '' then begin
      exit;
    end;
    jsonVal := TJSONObject.ParseJSONValue(S);
    try
      { 从字符串生成JSON } //TEncoding.UTF8.GetBytes(StrJson)
      processValue(jsonVal);
    finally
      jsonVal.Free;
    end;
  end;
var ss: string;
begin
  if self.isDoNew then begin
    parserItA(S);
  end else begin
    ss := StringReplace(S, 'spec:', '"spec":', [rfReplaceAll]);
    parserItA(ss);
  end;
end;

procedure TfrmMain.loadFactReplIt();
  function getKV(const S: string; var k, v: string): boolean;
  var strs: TStrings;
    i: integer;
    tmp: string;
  begin
    Result := false;
    strs := TStringList.Create();
    try
      TCharSplit.SplitChar(s, #9, strs);
      if (strs.Count>=4) then begin
        for I := 0 to strs.Count - 1 do begin
          tmp := StringReplace(strs[I], #9, '', [rfReplaceAll]);
          if i=0 then begin
            k := tmp;
          end else if i<3 then begin
            k := k + '/' + tmp;
          end else if (i=3) then begin
            v := tmp;
          end;
        end;
        Result := true;
      end;
    finally
      strs.Free;
    end;
  end;
var i: integer;
  S, k, v: string;
begin
  FDicNewFactory.Clear;
  for I := 1 to memoFactRepl.Lines.Count - 1 do begin
    S := memoFactRepl.Lines[I];
    if (getKV(S,k,v)) then begin
      FDicNewFactory.Add(k, v);
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);

  procedure loadStand(strs: TStrings;
    Dic: TDictionary<String, String>; const c: char=#9);
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

  {procedure filterBrandIt(const S: string);
  begin
    FBrandF := '';
    FFactoryF := '';
    FCarSysN := '';
    FCarT_Id := '';
    //
    FBrandF := TCharSplit.getSplitIdx(S, #9, 0);
    FFactoryF := TCharSplit.getSplitIdx(S, #9, 1);
    FCarSysN := TCharSplit.getSplitIdx(S, #9, 2);
    FCarT_Id := TCharSplit.getSplitIdx(S, #9, 3);
  end;}
begin
  FDataDir := 'ul_data';
  FHost := 'http://www.che168.com/china/';
  //
  frmSetting := TfrmSetting.Create(self);
  frmSetting.setFPath(self.getSubDataDir(''));
  //
  FCarSysRmBrd := TDictionary<String, String>.create();
  //FLogStrs := TStringList.Create;
  FDicNewFactory := TDictionary<String, String>.create();
  FDicVehType := TDictionary<String, String>.create();
  FDicVehTypeId:= TDictionary<String, String>.create();
  FMapCarTypeRaw:= TDictionary<Integer, String>.create();

  loadStand(memoVehType.Lines, FDicVehType);
  loadStand(memoVehTypeId.Lines, FDicVehTypeId);
  loadStand(memoCarSysRmBrd.Lines, FCarSysRmBrd);
  //filterBrandIt(self.edtBrand.text);
  {IdHTTP1.Request.Connection:='Keep-Alive';
  IdHTTP1.Request.UserAgent:='Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Maxthon)';
  //IdHTTP1.Request.ContentType:='application/x-www-form-urlencoded';
  IdHTTP1.Request.Referer:= FHost;//'http://www.xxx.com';
  IdHTTP1.Request.Host:= FHost;

  IdHTTP1.Request.Accept := 'application/json';
  IdHTTP1.Request.ContentType := 'application/json';

  //IdHTTP1.Request.Accept:='image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/msword, */*';
  IdHTTP1.Request.AcceptLanguage:='zh-CN,zh;q=0.8,en;q=0.6';
  IdHTTP1.Request.AcceptEncoding:='gzip, deflate';
  IdHTTP1.Request.CacheControl:='no-cache';
  IdHTTP1.ReadTimeout:=60000;
  IdHTTP1.HTTPOptions:=IdHTTP1.HTTPOptions + [hoKeepOrigProtocol];//关键这行
  IdHTTP1.ProtocolVersion:=pv1_1;
  //IdHTTP1.Request.CharSet := 'UTF-8';
  IdHTTP1.Request.AcceptEncoding := 'gb2312';}
  //
  //lblPath.Caption := TPaserUtils.correctPath(
  //    TPaserUtils.getCtxOfAppUTF8('data_path.txt'));
  //
  //IdHTTP1.Request.CustomHeaders.Text :=
  //    TPaserUtils.getCtxOfFileUTF8(lblPath.Caption + 'cookie.txt');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  //FLogStrs.Free;
  FDicNewFactory.Free;
  FDicVehType.Free;
  FCarSysRmBrd.Free;
  FMapCarTypeRaw.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  self.WindowState := wsMaximized;
end;

end.
