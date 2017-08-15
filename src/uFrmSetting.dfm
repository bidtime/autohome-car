object frmSetting: TfrmSetting
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmSetting'
  ClientHeight = 342
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 24
    Top = 11
    Width = 433
    Height = 270
    Caption = 'setting'
    TabOrder = 0
    object Memo1: TMemo
      Left = 24
      Top = 24
      Width = 385
      Height = 225
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 280
    Top = 295
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 382
    Top = 295
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
end
