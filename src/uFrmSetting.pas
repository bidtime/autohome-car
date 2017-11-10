unit uFrmSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmSetting = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FPath, FBName, FFinishName: string;
  public
    { Public declarations }

    procedure setFPath(const S: string);
    function hit(const brandName: string): boolean;
    procedure finish(const brandName: string);
  end;

//var
//  frmSetting: TfrmSetting;

implementation

{$R *.dfm}

{ TfrmSetting }

procedure TfrmSetting.Button1Click(Sender: TObject);
begin
  self.Memo1.Lines.SaveToFile(FBName, TEncoding.UTF8);
  ModalResult := mrOK;
end;

function TfrmSetting.hit(const brandName: string): boolean;
var i: integer;
  S: string;
begin
  Result := false;
  if self.Memo1.Lines.Count<=0 then begin
    Result := true;
  end else begin
    for I := 0 to memo1.Lines.Count - 1 do begin
      S := memo1.Lines[I];
      if S.IsEmpty or S.Substring(2).equals('--') then begin
        break;
      end;
      if S.Equals(brandName) then begin
        Result := true;
        break;
      end;
    end;
  end;
end;

procedure TfrmSetting.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSetting.finish(const brandName: string);
  procedure saveEnd();
  var strs: TStrings;
  begin
    strs := TStringList.Create;
    try
      strs.Text := brandName;
      strs.SaveToFile(FFinishName, TEncoding.UTF8);
    finally
      strs.Free;
    end;
  end;
begin
  saveEnd();
end;

procedure TfrmSetting.setFPath(const S: string);
  procedure loadEnd();
  var strs: TStrings;
  begin
    strs := TStringList.Create;
    try
      strs.LoadFromFile(FFinishName);
    finally
      strs.Free;
    end;
  end;
begin
  FPath := S;
  FBName := S + '\' + 'setting-brand.txt';
  FFinishName := S + '\' + 'setting-brand-end.txt';
  if FileExists(FBName) then begin
    self.Memo1.Lines.LoadFromFile(FBName);
  end;
end;

end.
