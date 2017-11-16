object frmMain: TfrmMain
  Left = 192
  Top = 103
  Caption = 'frmMain'
  ClientHeight = 594
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter4: TSplitter
    Left = 0
    Top = 219
    Width = 1028
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 22
    ExplicitWidth = 336
  end
  object Splitter6: TSplitter
    Left = 0
    Top = 517
    Width = 1028
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 8
    ExplicitTop = 539
    ExplicitWidth = 862
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1028
    Height = 22
    ButtonHeight = 21
    ButtonWidth = 53
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 0
    object ToolButton10: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = '10'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object cbxURL: TComboBox
      Left = 8
      Top = 0
      Width = 460
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = 'https://www.che168.com/Handler/ScriptCarList_V1.ashx?needData=1'
      Items.Strings = (
        'https://www.che168.com/Handler/ScriptCarList_V1.ashx?needData=1'
        
          'http://www.che168.com/handler/usedcarlistv5.ashx?action=brandlis' +
          't')
    end
    object ToolButton2: TToolButton
      Left = 468
      Top = 0
      Caption = 'go'
      ImageIndex = 1
      OnClick = nGotoClick
    end
    object ToolButton1: TToolButton
      Left = 521
      Top = 0
      Caption = 'do_brand'
      ImageIndex = 6
      OnClick = ToolButton1Click
    end
    object ToolButton8: TToolButton
      Left = 574
      Top = 0
      Width = 8
      Caption = 'ToolButton8'
      ImageIndex = 7
      Style = tbsSeparator
    end
    object cbxStop: TCheckBox
      Left = 582
      Top = 0
      Width = 44
      Height = 21
      Caption = #20572#27490
      TabOrder = 0
    end
    object ToolButton12: TToolButton
      Left = 626
      Top = 0
      Width = 8
      Caption = '12'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object cbxBrand: TCheckBox
      Left = 634
      Top = 0
      Width = 52
      Height = 21
      Caption = 'brand'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cbxSerie: TCheckBox
      Left = 686
      Top = 0
      Width = 47
      Height = 21
      Caption = 'serie'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object cbxCarType: TCheckBox
      Left = 733
      Top = 0
      Width = 42
      Height = 21
      Caption = 'car'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cbxPar: TCheckBox
      Left = 775
      Top = 0
      Width = 42
      Height = 21
      Caption = 'par'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cbxCfg: TCheckBox
      Left = 817
      Top = 0
      Width = 42
      Height = 21
      Caption = 'cfg'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object ToolButton4: TToolButton
      Left = 859
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 7
      Style = tbsSeparator
    end
    object Label1: TLabel
      Left = 867
      Top = 0
      Width = 36
      Height = 21
      Caption = 'timeout'
    end
    object spedTimeout: TSpinEdit
      Left = 903
      Top = 0
      Width = 51
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 6
      Value = 200
    end
  end
  object memoCtx: TMemo
    Left = 0
    Top = 22
    Width = 1028
    Height = 197
    Align = alClient
    Lines.Strings = (
      
        'var br=new Array();br['#39'33'#39']='#39'3170,'#19968#27773'-'#22823#20247#22885#36842' '#22885#36842'A3,692,'#19968#27773'-'#22823#20247#22885#36842' '#22885#36842'A4L' +
        ',18,'#19968#27773'-'#22823#20247#22885#36842' '#22885#36842'A6L,2951,'#19968#27773'-'#22823#20247#22885#36842' '#22885#36842'Q3,812,'#19968#27773'-'#22823#20247#22885#36842' '#22885#36842'Q5,19,'#19968#27773'-'#22823#20247#22885#36842' ' +
        #22885#36842'A4,509,'#19968#27773'-'#22823#20247#22885#36842' '#22885#36842'A6,650,'#22885#36842'('#36827#21475') '#22885#36842'A1,370,'#22885#36842'('#36827#21475') '#22885#36842'A3('#36827#21475'),2730,'#22885 +
        #36842'('#36827#21475') '#22885#36842'S3,471,'#22885#36842'('#36827#21475') '#22885#36842'A4('#36827#21475'),538,'#22885#36842'('#36827#21475') '#22885#36842'A5,2734,'#22885#36842'('#36827#21475') '#22885#36842'S5,' +
        '472,'#22885#36842'('#36827#21475') '#22885#36842'A6('#36827#21475'),2736,'#22885#36842'('#36827#21475') '#22885#36842'S6,740,'#22885#36842'('#36827#21475') '#22885#36842'A7,2738,'#22885#36842'('#36827#21475')' +
        ' '#22885#36842'S7,146,'#22885#36842'('#36827#21475') '#22885#36842'A8,2739,'#22885#36842'('#36827#21475') '#22885#36842'S8,2264,'#22885#36842'('#36827#21475') '#22885#36842'Q3('#36827#21475'),593,' +
        #22885#36842'('#36827#21475') '#22885#36842'Q5('#36827#21475'),2841,'#22885#36842'('#36827#21475') '#22885#36842'SQ5,412,'#22885#36842'('#36827#21475') '#22885#36842'Q7,148,'#22885#36842'('#36827#21475') '#22885#36842'T' +
        'T,2740,'#22885#36842'('#36827#21475') '#22885#36842'TTS,511,'#22885#36842'('#36827#21475') '#22885#36842'R8,2735,'#22885#36842'RS '#22885#36842'RS 5,2994,'#22885#36842'RS '#22885 +
        #36842'RS 7,100006,'#20854#20182' '#22885#36842'200,100007,'#20854#20182' '#22885#36842'100,100014,'#20854#20182' Allroad'#39';')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 222
    Width = 1028
    Height = 295
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 93
      Top = 1
      Height = 293
      Align = alRight
      ExplicitLeft = 332
      ExplicitHeight = 215
    end
    object Splitter3: TSplitter
      Left = 1024
      Top = 1
      Height = 293
      Align = alRight
      ExplicitLeft = 765
      ExplicitTop = 3
    end
    object Splitter1: TSplitter
      Left = 632
      Top = 1
      Height = 293
      Align = alRight
      ExplicitLeft = 682
      ExplicitTop = -15
    end
    object Splitter5: TSplitter
      Left = 855
      Top = 1
      Height = 293
      Align = alRight
      ExplicitLeft = 735
      ExplicitTop = 3
    end
    object memoLog: TMemo
      Left = 1
      Top = 1
      Width = 92
      Height = 293
      Align = alClient
      ScrollBars = ssHorizontal
      TabOrder = 0
    end
    object memoCarSys: TMemo
      Left = 635
      Top = 1
      Width = 220
      Height = 293
      Align = alRight
      ScrollBars = ssHorizontal
      TabOrder = 1
    end
    object memoBrand: TMemo
      Left = 96
      Top = 1
      Width = 536
      Height = 293
      Align = alRight
      ScrollBars = ssHorizontal
      TabOrder = 2
    end
    object memoCarType: TMemo
      Left = 858
      Top = 1
      Width = 166
      Height = 293
      Align = alRight
      ScrollBars = ssHorizontal
      TabOrder = 3
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 575
    Width = 1028
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 520
    Width = 1028
    Height = 55
    Align = alBottom
    TabOrder = 4
    object Splitter7: TSplitter
      Left = 875
      Top = 1
      Height = 53
      Align = alRight
      ExplicitLeft = 673
      ExplicitTop = 6
    end
    object Splitter8: TSplitter
      Left = 738
      Top = 1
      Height = 53
      Align = alRight
      ExplicitLeft = 488
      ExplicitTop = 6
    end
    object Splitter9: TSplitter
      Left = 632
      Top = 1
      Height = 53
      Align = alRight
      ExplicitLeft = 290
      ExplicitTop = -4
    end
    object Splitter10: TSplitter
      Left = 518
      Top = 1
      Height = 53
      Align = alRight
      ExplicitLeft = 407
      ExplicitTop = 2
    end
    object memoFactRepl: TMemo
      Left = 878
      Top = 1
      Width = 149
      Height = 53
      Align = alRight
      Lines.Strings = (
        'brandName'#9'Manufactor'#9'CarSysName'#9#26367#25442#26032#20027#26426#21378
        #22885#36842#9#22885#36842'RS'#9#22885#36842'RS 5'#9#22885#36842'('#36827#21475')'
        #22885#36842#9#22885#36842'RS'#9#22885#36842'RS 7'#9#22885#36842'('#36827#21475')'
        #22885#36842#9#20854#20182#9#22885#36842'200'#9#22885#36842'('#36827#21475')'
        #22885#36842#9#20854#20182#9#22885#36842'100'#9#22885#36842'('#36827#21475')'
        #22885#36842#9#20854#20182#9'Allroad'#9#22885#36842'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'M3'#9#23453#39532'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'M4'#9#23453#39532'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'M5'#9#23453#39532'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'M6'#9#23453#39532'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'X5 M'#9#23453#39532'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'X6 M'#9#23453#39532'('#36827#21475')'
        #23453#39532#9#23453#39532'M'#9#23453#39532'1'#31995'M'#9#23453#39532'('#36827#21475')'
        #21035#20811#9#20854#20182#9#21035#20811#26032#19990#32426#9#19978#27773#36890#29992#21035#20811
        #22823#20247#9#19978#27773#22823#20247#9'POLO'#9#19978#27773#22823#20247
        #22823#20247#9#19968#27773'-'#22823#20247#9#25463#36798#9#19968#27773#22823#20247
        #22823#20247#9#20854#20182#9#24085#33832#29305'B4'#9#22823#20247'('#36827#21475')'
        #22823#20247#9#20854#20182#9#37117#24066#39640#23572#22827#9#22823#20247'('#36827#21475')'
        #22823#20247#9#20854#20182#9#26705#22612#32435'2000'#9#19978#27773#22823#20247
        #22823#20247#9#20854#20182#9'T5'#9#22823#20247'('#36827#21475')'
        #36947#22855#9#20854#20182#9'Charger'#9#36947#22855'('#36827#21475')'
        #19996#39118#9#20854#20182#9#39118#34892#9#19996#39118#39118#34892
        #33778#20122#29305#9#24191#27773#33778#20811#33778#20122#29305#9#33778#32724#9#24191#27773#33778#20122#29305
        #33778#20122#29305#9#24191#27773#33778#20811#33778#20122#29305#9#33268#24742#9#24191#27773#33778#20122#29305
        #33778#20122#29305#9#20854#20182#9#20044#35834#9#33778#20122#29305'('#36827#21475')'
        #20016#30000#9#20854#20182#9#20016#30000#20339#32654#9#20016#30000'('#36827#21475')'
        #21704#39134#9#20854#20182#9#20013#24847#9#21704#39134#27773#36710
        #32418#26071#9#20854#20182#9#32418#26071#9#19968#27773#32418#26071
        #26085#20135#9#20854#20182#9#20844#29237#29579#9#26085#20135'('#36827#21475')'
        #26031#26607#36798#9#20854#20182#9#26122#38160'('#36827#21475')'#9#26031#26607#36798'('#36827#21475')'
        #38634#20315#20848#9#20854#20182#9#23376#24377#22836#9#38634#20315#20848'('#36827#21475')'
        #19968#27773#9#20854#20182#9#38597#37239#9#22825#27941#19968#27773
        #19968#27773#9#20854#20182#9#22799#21033'2000'#9#22825#27941#19968#27773
        #20016#30000#9#20854#20182#9#20339#32654#9#20016#30000'('#36827#21475')')
      ScrollBars = ssHorizontal
      TabOrder = 0
    end
    object memoVehType: TMemo
      Left = 741
      Top = 1
      Width = 134
      Height = 53
      Align = alRight
      Lines.Strings = (
        #28304#32423#21035#9#26032#32423#21035
        #32039#20945#22411#36710#9#32039#20945#22411#36710
        #20013#22411#36710#9#20013#22411#36710
        #20013#22823#22411#36710#9#20013#22823#22411#36710
        #32039#20945#22411'SUV'#9'SUV'
        #20013#22411'SUV'#9'SUV'
        #23567#22411#36710#9#23567#24494#22411
        #22823#22411#36710#9#22823#22411#36710
        #20013#22823#22411'SUV'#9'SUV'
        #36305#36710#9#36305#36710
        #36731#23458#9#22823#22411#36710
        #23567#22411'SUV'#9'SUV'
        'MPV'#9'MPV'
        #24494#38754#9#20854#20182
        #24494#22411#36710#9#23567#24494#22411
        #24494#21345#9#20854#20182
        #20302#31471#30382#21345#9#20854#20182
        #22823#22411'SUV'#9'SUV'
        #39640#31471#30382#21345#9#20854#20182
        #9#20854#23427)
      ScrollBars = ssHorizontal
      TabOrder = 1
    end
    object memoVehTypeId: TMemo
      Left = 635
      Top = 1
      Width = 103
      Height = 53
      Align = alRight
      Lines.Strings = (
        'SUV'#9'1'
        'MPV'#9'2'
        #36305#36710#9'3'
        #23567#24494#22411#9'4'
        #32039#20945#22411#36710#9'5'
        #20013#22411#36710#9'6'
        #20013#22823#22411#36710#9'7'
        #22823#22411#36710#9'8'
        #20854#20182#9'9')
      ScrollBars = ssHorizontal
      TabOrder = 2
    end
    object memoCarSysRmBrd: TMemo
      Left = 521
      Top = 1
      Width = 111
      Height = 53
      Align = alRight
      Lines.Strings = (
        #36710#31995#9#21697#29260
        #21271#20140'40'#9#21271#20140)
      ScrollBars = ssHorizontal
      TabOrder = 3
    end
  end
  object MainMenu1: TMainMenu
    Left = 86
    Top = 41
    object N1: TMenuItem
      Caption = #25991#20214'(&F)'
      object nGoto: TMenuItem
        Caption = 'goto'
        OnClick = nGotoClick
      end
      object nBrand: TMenuItem
        Caption = 'brand'
      end
      object setting1: TMenuItem
        Caption = 'setting'
        OnClick = setting1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object carTypeSql1: TMenuItem
        Caption = 'carInsSql'
      end
      object carUpdateSql1: TMenuItem
        Caption = 'carUpdateSql'
      end
      object cfgSql1: TMenuItem
        Caption = 'cfgSql'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object nExit: TMenuItem
        Caption = 'exit'
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object A1: TMenuItem
        Caption = #20851#20110'(A)'
      end
    end
  end
end
