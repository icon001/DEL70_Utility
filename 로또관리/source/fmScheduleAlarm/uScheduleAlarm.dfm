object fmScheduleAlarm: TfmScheduleAlarm
  Left = 814
  Top = 370
  Width = 335
  Height = 340
  BorderIcons = [biSystemMenu]
  Caption = #49828#52992#51460#50508#46988
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548#52404
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object btn_Close: TSpeedButton
    Left = 104
    Top = 248
    Width = 129
    Height = 41
    Caption = #54869#51064
    OnClick = btn_CloseClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 327
    Height = 73
    Align = alTop
    Caption = #49828#52992#51460#51068#51221
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 22
      Width = 24
      Height = 12
      Caption = #45216#51676
    end
    object Label2: TLabel
      Left = 24
      Top = 46
      Width = 24
      Height = 12
      Caption = #49884#44036
    end
    object Label3: TLabel
      Left = 176
      Top = 46
      Width = 6
      Height = 12
      Caption = '~'
    end
    object dt_Date: TDateTimePicker
      Left = 56
      Top = 18
      Width = 121
      Height = 20
      Date = 39386.701198460650000000
      Time = 39386.701198460650000000
      Enabled = False
      ImeName = 'Microsoft IME 2003'
      TabOrder = 0
    end
    object dt_StartTime: TDateTimePicker
      Left = 56
      Top = 42
      Width = 113
      Height = 20
      Date = 39386.701198460650000000
      Time = 39386.701198460650000000
      Enabled = False
      ImeName = 'Microsoft IME 2003'
      Kind = dtkTime
      TabOrder = 1
    end
    object dt_EndTime: TDateTimePicker
      Left = 192
      Top = 42
      Width = 113
      Height = 20
      Date = 39386.701198460650000000
      Time = 39386.701198460650000000
      Enabled = False
      ImeName = 'Microsoft IME 2003'
      Kind = dtkTime
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 73
    Width = 327
    Height = 160
    Align = alTop
    Caption = #49828#52992#51460#45236#50857
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 36
      Width = 24
      Height = 12
      Caption = #51228#47785
    end
    object Label5: TLabel
      Left = 16
      Top = 60
      Width = 24
      Height = 12
      Caption = #45236#50857
    end
    object ed_SCSubject: TEdit
      Left = 56
      Top = 32
      Width = 249
      Height = 20
      ImeName = 'Microsoft IME 2003'
      TabOrder = 0
      Text = 'ed_SCSubject'
    end
    object mem_Memo: TMemo
      Left = 56
      Top = 60
      Width = 249
      Height = 89
      ImeName = 'Microsoft IME 2003'
      Lines.Strings = (
        'Memo1')
      TabOrder = 1
    end
  end
end
