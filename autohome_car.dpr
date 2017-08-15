program autohome_car;

uses
  Vcl.Forms,
  uCarBrand in 'src\uCarBrand.pas',
  uCarConfig in 'src\uCarConfig.pas',
  uCarParam in 'src\uCarParam.pas',
  uCarSys in 'src\uCarSys.pas',
  uCarType in 'src\uCarType.pas',
  uFrmMain in 'src\uFrmMain.pas' {frmMain},
  uFrmSetting in 'src\uFrmSetting.pas' {frmSetting},
  uCharSplit in 'src\utils\uCharSplit.pas',
  uPaserUtils in 'src\utils\uPaserUtils.pas',
  HtmlParser_XE3UP in 'src\utils\HtmlParser_XE3UP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
