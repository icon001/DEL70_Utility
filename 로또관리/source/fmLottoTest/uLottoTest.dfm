object fmLottoTest: TfmLottoTest
  Left = 348
  Top = 193
  Width = 778
  Height = 441
  Caption = 'fmLottoTest'
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548#52404
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 89
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 36
      Width = 49
      Height = 17
      AutoSize = False
      Caption = #48708#44368#54924#52264
    end
    object Gauge1: TGauge
      Left = 8
      Top = 64
      Width = 361
      Height = 17
      ForeColor = clBlue
      Progress = 0
      Visible = False
    end
    object btn_Extract: TButton
      Left = 392
      Top = 24
      Width = 129
      Height = 41
      Caption = #52628#52636
      TabOrder = 0
      OnClick = btn_ExtractClick
    end
    object btn_Close: TButton
      Left = 600
      Top = 24
      Width = 129
      Height = 41
      Caption = #45803#44592
      TabOrder = 1
      OnClick = btn_CloseClick
    end
    object cmb_FromSeq: TComboBox
      Left = 80
      Top = 34
      Width = 65
      Height = 20
      ImeName = 'Microsoft Office IME 2007'
      ItemHeight = 12
      TabOrder = 2
      Text = 'cmb_FromSeq'
    end
    object cmb_ToSeq: TComboBox
      Left = 168
      Top = 34
      Width = 65
      Height = 20
      ImeName = 'Microsoft Office IME 2007'
      ItemHeight = 12
      TabOrder = 3
      Text = 'ComboBox1'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 89
    Width = 770
    Height = 104
    Align = alTop
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 768
      Height = 102
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 193
    Width = 770
    Height = 104
    Align = alTop
    TabOrder = 2
    object Memo2: TMemo
      Left = 1
      Top = 1
      Width = 768
      Height = 102
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 297
    Width = 770
    Height = 110
    Align = alClient
    TabOrder = 3
    object Memo3: TMemo
      Left = 1
      Top = 1
      Width = 768
      Height = 108
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
    end
  end
  object TempQuery: TZQuery
    Connection = dmDB.ZConnection1
    Params = <>
    Left = 544
    Top = 16
  end
end
