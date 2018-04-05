object Form1: TForm1
  Left = 378
  Top = 307
  Width = 601
  Height = 344
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 24
    Top = 16
    Width = 185
    Height = 25
    Caption = #48320#44221
    OnClick = SpeedButton1Click
  end
  object chk_AUTHCOMPANY: TCheckBox
    Left = 232
    Top = 16
    Width = 129
    Height = 25
    Caption = 'TB_AUTHCOMPANY'
    TabOrder = 0
  end
  object chk_AUTHManager: TCheckBox
    Left = 232
    Top = 40
    Width = 129
    Height = 25
    Caption = 'TB_AUTHManager'
    TabOrder = 1
  end
  object chkTB_AUTHMANAGELIST: TCheckBox
    Left = 232
    Top = 64
    Width = 129
    Height = 25
    Caption = 'TB_AUTHMANAGELIST'
    TabOrder = 2
  end
  object ChkTB_TELLIST: TCheckBox
    Left = 232
    Top = 88
    Width = 129
    Height = 25
    Caption = 'TB_TELLIST'
    TabOrder = 3
  end
  object chkTB_GOODSINOUTLIST: TCheckBox
    Left = 232
    Top = 112
    Width = 129
    Height = 25
    Caption = 'TB_GOODSINOUTLIST'
    TabOrder = 4
  end
  object ZConnection1: TZConnection
    Left = 32
    Top = 80
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 96
    Top = 80
  end
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=PostgreSQL.1;Password=1;User ID=postgres;Data Source=12' +
      '7.0.0.1;Location="";Extended Properties=""'
    Provider = 'PostgreSQL.1'
    Left = 32
    Top = 32
  end
  object ADOTmpQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 72
    Top = 32
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 112
    Top = 32
  end
  object ZQuery2: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 128
    Top = 80
  end
  object ZQuerySearch: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 32
    Top = 128
  end
end
