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
    cbxBrand: TCheckBox;
    carUpdateSql1: TMenuItem;
    Splitter9: TSplitter;
    memoCarSysRmBrd: TMemo;
    cbxCfg: TCheckBox;
    Splitter10: TSplitter;
    spedTimeout: TSpinEdit;
    Label1: TLabel;
    ToolButton4: TToolButton;
    setting1: TMenuItem;
    cbxSerie: TCheckBox;
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
    FCarBrandPaser: TCarBrandParser;
    FCarSysPaser: TCarSysParser;
    FCarTypePaser: TCarTypeParser;
    //
    FCarParParser: TCarParParser;
    FCarCfgParser: TCarCfgParser;
    procedure setStatus(const S: string; const setCap: boolean=false;
      const tmSleep: integer=0);
    procedure doUrlEvent(const S: string);
    procedure addLog(const S: string);
    procedure addLogMod(const S: string; const nmod: integer);
    function getStopFlag(): boolean;
    // brand
    procedure doReqBrand(const url: string; const brandOnly: boolean);
    // cartype
    function doReqCarType(const carBrand: TCarBrand; var carSys: TCarSys): boolean;
    // detail
    function doReqCarDetail(const carBrand: TCarBrand; const carSys: TCarSys;
      var carType: TCarType): boolean;
    function doOneBrand(const brand: TCarBrand): boolean;
    function doOneBrandTest(const brand: TCarBrand): boolean;
    function reqCarSysdRaw(const brand: TCarBrand;
      const brandOnly: boolean): boolean;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses StrUtils, uCharSplit, System.json, Generics.Defaults, uCarConfig,
  uCarParam, uStrUtils, uFileUtils;

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

function TfrmMain.getStopFlag: boolean;
begin
  Result := self.cbxStop.Checked;
end;

procedure TfrmMain.addLogMod(const S: string; const nmod: integer);
begin
  memoLog.Lines.Add(IntToStr(memoLog.lines.count) + '.' + '  ' + s);
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
  self.setStatus(str);
  //
  FCarParParser.reqParerToList(carBrand, carSys, carType,
    cbxPar.checked, doUrlEvent);
  FCarCfgParser.reqParerToList(carBrand, carSys, carType,
    cbxCfg.checked, doUrlEvent);
  Result := true;
end;

function TfrmMain.doReqCarType(const carBrand: TCarBrand; var carSys: TCarSys): boolean;
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
    if self.cbxCarType.Checked then begin
      FCarSysPaser.parerToList(S, carBrand, doReqCarType, FUrlNew);
    end else begin
      FCarSysPaser.parerToList(S, carBrand, nil, FUrlNew);
    end;
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
      if cbxSerie.Checked then begin
        doReqCarSys(brand);
      end;
    end;
  end;
  memoBrand.Lines.add(brand.getRow());
  Result := true;
end;

procedure TfrmMain.doReqBrand(const url: string; const brandOnly: boolean);

  function getSubDir(const bNew: boolean): string;
  begin
    if bNew then begin
      Result := 'ul_data';
    end else begin
      Result := 'ul_data';
    end;
  end;

  procedure setDataSubDir(const S: string);
  begin
    FCarBrandPaser.DataSubDir := S;
    FCarSysPaser.DataSubDir := S;
    //
    FCarTypePaser.DataSubDir := S;
    FCarCfgParser.DataSubDir := S;
    FCarParParser.DataSubDir := S;
  end;

  function isNewUrl(): boolean;
  var url: string;
    n: integer;
  begin
    url := self.cbxURL.Text;
    // http://www.che168.com/handler/usedcarlistv5.ashx?action=brandlist
    n := url.indexof('usedcarlistv5.ashx');
    if n>0 then begin
      Result := true;
    end else begin  // http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?needData=1
      Result := false;
    end;
  end;
var S: string;
  DataDir: string;
begin
  FUrlNew := isNewUrl();
  DataDir := getSubDir(FUrlNew);
  setDataSubDir(TFileUtils.mergeAppPath(DataDir));
  //
  memoBrand.clear;
  memoBrand.Lines.add(TCarBrand.getColumn());
  //
  FCarBrandPaser.CreateFile(cbxBrand.Checked, TCarBrand.startTrans);
  FCarSysPaser.CreateFile(cbxSerie.Checked, TCarSys.startTrans);
  FCarTypePaser.CreateFile(cbxCarType.Checked, TCarType.startTrans);
  //
  FCarParParser.CreateFile(cbxPar.Checked, TCarParam.startTrans);
  FCarCfgParser.CreateFile(cbxCfg.Checked, TCarConfig.startTrans);
  //
  FCarTypePaser.MapCarTypeRaw.Clear;
  try
    FCarSysPaser.loadFactReplIt(memoFactRepl.Lines, FUrlNew);
    S := FCarBrandPaser.reqParerToList(url, FUrlNew, doUrlEvent);
    if self.cbxBrand.Checked then begin
      if brandOnly then begin
        FCarBrandPaser.parerToList(S, doOneBrandTest, FUrlNew);
      end else begin
        FCarBrandPaser.parerToList(S, doOneBrand, FUrlNew);
      end;
    end else begin
      FCarBrandPaser.parerToList(S, nil, FUrlNew);
    end;
  finally
    FCarBrandPaser.CloseFile(TCarBrand.commit);
    FCarSysPaser.CloseFile(TCarSys.commit);
    FCarTypePaser.CloseFile(TCarType.commit);
    //
    FCarParParser.CloseFile(TCarParam.commit);
    FCarCfgParser.CloseFile(TCarConfig.commit);
    //
    self.memoCtx.Lines.Add(IntToStr(memoCtx.lines.count)+ ', ' + 'all brand' + ', finish.');
  end;
end;

procedure TfrmMain.doUrlEvent(const S: string);
begin
  addLog(S);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //
  frmSetting := TfrmSetting.Create(self);
  frmSetting.setFPath(TFileUtils.getAppPath());
  //
  FCarBrandPaser := TCarBrandParser.Create();
  FCarBrandPaser.StopFunc := getStopFlag;
  //
  FCarSysPaser := TCarSysParser.Create();
  FCarSysPaser.StopFunc := getStopFlag;
  FCarSysPaser.loadCarSysRmBrd(memoCarSysRmBrd.Lines);
  //
  FCarTypePaser := TCarTypeParser.Create();
  FCarTypePaser.StopFunc := getStopFlag;
  FCarTypePaser.loadDicVehType(memoVehType.Lines);
  FCarTypePaser.loadDicVehTypeId(memoVehTypeId.Lines);
  //
  FCarCfgParser := TCarCfgParser.Create();
  FCarParParser := TCarParParser.Create();
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

