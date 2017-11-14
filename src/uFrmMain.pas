unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ToolWin, Menus, Generics.Collections,
  Vcl.Samples.Spin, uCarType, uCarSys, uCarBrand, uFrmSetting,
  uMyTextFile, uCarBrandParser, uCarSysParser, uCarTypeParser,
  uCarParParser, uCarCfgParser;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    ToolButton10: TToolButton;
    ToolButton2: TToolButton;
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
    Splitter1: TSplitter;
    Splitter4: TSplitter;
    ToolButton1: TToolButton;
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
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure setting1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    frmSetting: TfrmSetting;
    FUrlNew: boolean;
    FDataDir: string;
    FCarBrandPaser: TCarBrandParser;
    FCarSysPaser: TCarSysParser;
    FCarTypePaser: TCarTypeParser;
    //
    FCarParParser: TCarParParser;
    FCarCfgParser: TCarCfgParser;
    procedure setStatus(const S: string; const setCap: boolean=false;
      const tmSleep: integer=0);
    procedure doUrlEvent(const S: string);
    procedure doUrlEvent2(const S: string);
    procedure addLog(const S: string);
    class function getAppFileName(const S: string): string;
    procedure addLogMod(const S: string; const nmod: integer);
    function getStopFlag(): boolean;
    class function getAppSubFile(const dir, S: string): string; static;
    function getSubDataDir(const S: string): string;
    // brand
    procedure doReqBrand(const url: string; const brandOnly: boolean);
    // cartype
    function doReqCarType(const carBrand: TCarBrand; const carSys: TCarSys): boolean;
    // detail
    function doReqCarDetail(const carBrand: TCarBrand; const carSys: TCarSys;
      var carType: TCarType): boolean;
    function doOneBrand(const brand: TCarBrand): boolean;
    function doOneBrandTest(const brand: TCarBrand): boolean;
    function reqCarSysdRaw(const brand: TCarBrand;
      const brandOnly: boolean): boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses StrUtils, uCharSplit, System.json, Generics.Defaults, uCarConfig, uCarParam, uStrUtils;

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
var url: string;
begin
  url := self.cbxURL.Text;
  {if LowerCase(copy(url, 1, length('http://'))) <> 'http://' then begin
    url := FHost + url;
  end;}
  //
  doReqBrand(url, false);
end;

class function TfrmMain.getAppFileName(const S: string): string;
begin
  Result := ExtractFilePath(Application.exeName) + S;
end;

class function TfrmMain.getAppSubFile(const dir, S: string): string;
begin
  Result := getAppFilename( dir + '\' + S);
end;

function TfrmMain.getStopFlag: boolean;
begin
  Result := self.cbxStop.Checked;
end;

function TfrmMain.getSubDataDir(const S: string): string;
begin
  Result := getAppSubFile( FDataDir, S);
end;

procedure TfrmMain.addLogMod(const S: string; const nmod: integer);
begin
  memoLog.Lines.Add(IntToStr(memoLog.lines.count) + '.' + #9 + s);
  self.setStatus(IntToStr(memoLog.Tag)+'/'+s);
end;

procedure TfrmMain.addLog(const S: string);
begin
  addLogMod(s, 0);
end;

procedure TfrmMain.nGotoClick(Sender: TObject);
var url: string;
begin
  url := self.cbxURL.Text;
  {if (LowerCase(copy(url, 1, length('http://'))) <> 'http://') then begin
    url := FHost + url;
  end;}
  //
  doReqBrand(url, true);
end;

function TfrmMain.doOneBrand(const brand: TCarBrand): boolean;
begin
  Result := reqCarSysdRaw(brand, false);
end;

function TfrmMain.doOneBrandTest(const brand: TCarBrand): boolean;
begin
  Result := reqCarSysdRaw(brand, true);
end;

function TfrmMain.doReqCarDetail(const carBrand: TCarBrand; const carSys: TCarSys;
  var carType: TCarType):boolean;
var str: string;
begin
  str := carType.car_brand_name + '/' + carType.car_oem_name + '/' +
    carType.car_serie_name + '/' +
    carType.car_type_name + '/' +
    carType.RawId + '/' + carType.year_model;
  //self.setStatus(str);
  self.doUrlEvent2(str);
  //
  FCarParParser.reqParerToList(carBrand, carSys, carType,
    cbxPar.checked, doUrlEvent);
  FCarCfgParser.reqParerToList(carBrand, carSys, carType,
    cbxCfg.checked, doUrlEvent);
  Result := true;
end;

function TfrmMain.doReqCarType(const carBrand: TCarBrand; const carSys: TCarSys): boolean;
var S: string;
begin
  S := FCarTypePaser.preParerToList(carBrand, carSys, FUrlNew, doUrlEvent);
  FCarTypePaser.parerToList(S, carBrand, carSys, doReqCarDetail, FUrlNew);
  Result := true;
end;

function TfrmMain.reqCarSysdRaw(const brand: TCarBrand; const brandOnly: boolean): boolean;

  procedure doReqCarSys(const carBrand: TCarBrand);
  var S: string;
  begin
    S := FCarSysPaser.reqParerToList(carBrand, FUrlNew, doUrlEvent);
    // to parse car-system
    FCarSysPaser.parerToList(S, carBrand, doReqCarType, FUrlNew);
  end;

  function getHitInfo(const bHit: boolean): string;
  begin
    if bHit then begin
      Result := 'hit...';
    end else begin
      Result := 'pass.';
    end;
  end;

var
  bHit: boolean;
begin
  setStatus(brand.getRow());
  bHit := (frmSetting.hit(brand.car_brand_name));
  self.memoCtx.Lines.Add(IntToStr(memoCtx.lines.count)+ ', ' +
    brand.car_brand_name + ', ' + getHitInfo(bHit));
  if bHit then begin
    if not brandOnly then begin
      doReqCarSys(brand);
    end;
  end;
  memoBrand.Lines.add(brand.getRow());
  Result := true;
end;

procedure TfrmMain.doReqBrand(const url: string; const brandOnly: boolean);

  function isNewUrl(): boolean;
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
var S: string;
begin
  FUrlNew := isNewUrl();
  //
  memoBrand.clear;
  memoBrand.Lines.add(TCarBrand.getColumn());
  //
  FCarBrandPaser.FileText.Rewrite_(true);
  FCarSysPaser.FileText.Rewrite_(true);
  FCarTypePaser.FileText.Rewrite_(self.cbxCarType.Checked);
  //
  FCarParParser.FileText.Rewrite_(self.cbxPar.Checked);
  FCarCfgParser.FileText.Rewrite_(self.cbxCfg.Checked);
  //
  FCarTypePaser.MapCarTypeRaw.Clear;
  try
    FCarSysPaser.loadFactReplIt(memoFactRepl.Lines, FUrlNew);
    S := FCarBrandPaser.reqParerToList(url, FUrlNew, doUrlEvent);
    if brandOnly then begin
      FCarBrandPaser.parerToList(S, doOneBrandTest, FUrlNew);
    end else begin
      FCarBrandPaser.parerToList(S, doOneBrand, FUrlNew);
    end;
  finally
    FCarBrandPaser.FileText.CloseFile_;
    FCarSysPaser.FileText.CloseFile_;
    FCarTypePaser.FileText.CloseFile_;
    //
    FCarParParser.FileText.CloseFile_;
    FCarCfgParser.FileText.CloseFile_;
    //
    self.memoCtx.Lines.Add(IntToStr(memoCtx.lines.count)+ ', ' + 'all brand' + ', finish.');
  end;
end;

procedure TfrmMain.doUrlEvent(const S: string);
begin
  addLog(S);
end;

procedure TfrmMain.doUrlEvent2(const S: string);
begin
  //addLog(S);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDataDir := 'ul_data';
  //
  frmSetting := TfrmSetting.Create(self);
  frmSetting.setFPath(self.getSubDataDir(''));
  //
  FCarBrandPaser := TCarBrandParser.Create(self.getSubDataDir('car-brand-all.txt'));
  FCarBrandPaser.DataFullPath := self.getSubDataDir('');
  FCarBrandPaser.StopFunc := getStopFlag;
  //
  FCarSysPaser := TCarSysParser.Create(self.getSubDataDir('car-serie-all.txt'));
  FCarSysPaser.DataFullPath := self.getSubDataDir('');
  FCarSysPaser.StopFunc := getStopFlag;
  FCarSysPaser.loadCarSysRmBrd(memoCarSysRmBrd.Lines);
  //
  FCarTypePaser := TCarTypeParser.Create(self.getSubDataDir('car-type-all.txt'));
  FCarTypePaser.DataFullPath := self.getSubDataDir('');
  FCarTypePaser.StopFunc := getStopFlag;
  FCarTypePaser.loadDicVehType(memoVehType.Lines);
  FCarTypePaser.loadDicVehTypeId(memoVehTypeId.Lines);
  //
  FCarCfgParser := TCarCfgParser.Create(self.getSubDataDir('car-type-cfg-all.txt'));
  FCarCfgParser.DataFullPath := self.getSubDataDir('');
  FCarParParser := TCarParParser.Create(self.getSubDataDir('car-type-par-all.txt'));
  FCarParParser.DataFullPath := self.getSubDataDir('');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FCarBrandPaser.Free;
  FCarSysPaser.Free;
  FCarTypePaser.Free;
  //
  FCarCfgParser.Free;
  FCarParParser.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  self.WindowState := wsMaximized;
end;

end.

