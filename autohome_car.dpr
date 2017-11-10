program autohome_car;

uses
  Vcl.Forms,
  uStrUtils in 'src\utils\uStrUtils.pas',
  uCharSplit in 'src\utils\uCharSplit.pas',
  uCommEvents in 'src\car\uCommEvents.pas',
  uCarBase in 'src\car\uCarBase.pas',
  uCarData in 'src\car\uCarData.pas',
  uCarBrand in 'src\uCarBrand.pas',
  uCarSys in 'src\uCarSys.pas',
  uCarType in 'src\uCarType.pas',
  uCarConfig in 'src\uCarConfig.pas',
  uCarParam in 'src\uCarParam.pas',
  uMyTextFile in 'src\car\uMyTextFile.pas',
  uNetHttpClt in 'src\utils\uNetHttpClt.pas',
  uNetUtils in 'src\utils\uNetUtils.pas',
  uCarParserBase in 'src\car\uCarParserBase.pas',
  uCarBrandParser in 'src\car\uCarBrandParser.pas',
  uCarSysParser in 'src\car\uCarSysParser.pas',
  uCarTypeParser in 'src\car\uCarTypeParser.pas',
  uCarParParser in 'src\car\uCarParParser.pas',
  uCarCfgParser in 'src\car\uCarCfgParser.pas',
  uFrmMain in 'src\uFrmMain.pas' {frmMain},
  uFrmSetting in 'src\uFrmSetting.pas' {frmSetting},
  uFileUtils in 'src\utils\uFileUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
