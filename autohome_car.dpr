program autohome_car;

uses
  Vcl.Forms,
  uCommEvents in 'src\car\uCommEvents.pas',
  uCarBase in 'src\car\uCarBase.pas',
  uCarData in 'src\car\uCarData.pas',
  uCarBrand in 'src\uCarBrand.pas',
  uCarSys in 'src\uCarSys.pas',
  uCarType in 'src\uCarType.pas',
  uCarConfig in 'src\uCarConfig.pas',
  uCarParam in 'src\uCarParam.pas',
  uCarParserBase in 'src\car\uCarParserBase.pas',
  uCarBrandParser in 'src\car\uCarBrandParser.pas',
  uCarSysParser in 'src\car\uCarSysParser.pas',
  uCarTypeParser in 'src\car\uCarTypeParser.pas',
  uCarParParser in 'src\car\uCarParParser.pas',
  uCarCfgParser in 'src\car\uCarCfgParser.pas',
  uFrmMain in 'src\uFrmMain.pas' {frmMain},
  uFrmSetting in 'src\uFrmSetting.pas' {frmSetting},
  uCharSplit in '..\..\..\git\bidtime\delphiutils\src\utils\uCharSplit.pas',
  uMyTextFile in '..\..\..\git\bidtime\delphiutils\src\utils\uMyTextFile.pas',
  uNetHttpClt in '..\..\..\git\bidtime\delphiutils\src\utils\uNetHttpClt.pas',
  uNetUtils in '..\..\..\git\bidtime\delphiutils\src\utils\uNetUtils.pas',
  uFileUtils in '..\..\..\git\bidtime\delphiutils\src\utils\uFileUtils.pas',
  uStrUtils in '..\..\..\git\bidtime\delphiutils\src\utils\uStrUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
