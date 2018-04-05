inherited fmSchedule: TfmSchedule
  Left = 161
  Top = 101
  Width = 943
  Height = 631
  Caption = #49828#52992#51460#44288#47532
  Font.Charset = HANGEUL_CHARSET
  Font.Height = -12
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel12: TPanel [0]
    Left = 0
    Top = 0
    Width = 935
    Height = 33
    Align = alTop
    Caption = #49828#52992#51460#44288#47532
    Color = 15387318
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentBackground = True
    ParentFont = False
    TabOrder = 0
  end
  object GroupBox1: TGroupBox [1]
    Left = 0
    Top = 33
    Width = 935
    Height = 334
    Align = alClient
    TabOrder = 1
    object PlannerCalendar1: TPlannerCalendar
      Left = 2
      Top = 14
      Width = 931
      Height = 318
      EventDayColor = clBlack
      EventMarkerColor = clYellow
      EventMarkerShape = evsCircle
      Align = alClient
      BackgroundPosition = bpTiled
      BevelOuter = bvNone
      BorderWidth = 1
      BorderXP = True
      Caption3D = False
      InActiveDays.Sat = True
      InActiveDays.Sun = True
      InActiveDays.Mon = False
      InActiveDays.Tue = False
      InActiveDays.Wed = False
      InActiveDays.Thu = False
      InActiveDays.Fri = False
      Look = lookFlat
      DateDownColor = clNone
      DateHoverColor = clNone
      DateSelectColor = clTeal
      MultiSelect = False
      DayFont.Charset = DEFAULT_CHARSET
      DayFont.Color = clWindowText
      DayFont.Height = -11
      DayFont.Name = 'MS Sans Serif'
      DayFont.Style = []
      WeekFont.Charset = DEFAULT_CHARSET
      WeekFont.Color = clWindowText
      WeekFont.Height = -11
      WeekFont.Name = 'MS Sans Serif'
      WeekFont.Style = []
      WeekName = 'Wk'
      TextColor = clBlack
      SelectColor = clTeal
      SelectFontColor = clWhite
      InActiveColor = clGray
      HeaderColor = clNone
      FocusColor = clHighlight
      InversColor = clTeal
      WeekendColor = clRed
      NameOfDays.Monday = #50900
      NameOfDays.Tuesday = #54868
      NameOfDays.Wednesday = #49688
      NameOfDays.Thursday = #47785
      NameOfDays.Friday = #44552
      NameOfDays.Saturday = #53664
      NameOfDays.Sunday = #51068
      NameOfDays.UseIntlNames = True
      NameOfMonths.January = '1'
      NameOfMonths.February = '2'
      NameOfMonths.March = '3'
      NameOfMonths.April = '4'
      NameOfMonths.May = '5'
      NameOfMonths.June = '6'
      NameOfMonths.July = '7'
      NameOfMonths.August = '8'
      NameOfMonths.September = '9'
      NameOfMonths.October = '10'
      NameOfMonths.November = '11'
      NameOfMonths.December = '12'
      NameOfMonths.UseIntlNames = True
      MaxDate.Day = 0
      MaxDate.Month = 0
      MaxDate.Year = 0
      MaxDate.Use = False
      MinDate.Day = 0
      MinDate.Month = 0
      MinDate.Year = 0
      MinDate.Use = False
      ReturnIsSelect = False
      ShowGotoToday = False
      ShowToday = False
      ShowWeeks = False
      StartDay = 7
      TodayFormat = '"Today" DDD/mm, YYYY'
      TodayStyle = tsSunken
      YearStartAt.ISOWeekNumber = False
      YearStartAt.StartDay = 1
      YearStartAt.StartMonth = 1
      YearStartAt.PrevYearStartDay = 1
      YearStartAt.PrevYearStartMonth = 1
      YearStartAt.NextYearStartDay = 1
      YearStartAt.NextYearStartMonth = 1
      Day = 25
      Month = 9
      Year = 2009
      ShowHint = True
      ParentShowHint = False
      TabOrder = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      EventHints = False
      CaptionColor = clNone
      CaptionTextColor = clBlack
      OnDaySelect = PlannerCalendar1DaySelect
      OnMouseUp = PlannerCalendar1MouseUp
      LineColor = clGray
      Line3D = True
      GradientStartColor = clWhite
      GradientEndColor = clBtnFace
      GradientDirection = gdHorizontal
      MonthGradientStartColor = clNone
      MonthGradientEndColor = clNone
      MonthGradientDirection = gdHorizontal
      HintPrevYear = 'Previous Year'
      HintPrevMonth = 'Previous Month'
      HintNextMonth = 'Next Month'
      HintNextYear = 'Next Year'
      Version = '1.6.6.1'
    end
  end
  object GroupBox2: TGroupBox [2]
    Left = 0
    Top = 367
    Width = 935
    Height = 180
    Align = alBottom
    Caption = #51068#51221#51312#54924
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 353
      Top = 14
      Height = 164
    end
    object Panel1: TPanel
      Left = 2
      Top = 14
      Width = 351
      Height = 164
      Align = alLeft
      TabOrder = 0
      object GroupBox3: TGroupBox
        Left = 1
        Top = 1
        Width = 349
        Height = 48
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 22
          Width = 24
          Height = 12
          Caption = #45216#51676
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
      end
      object sg_memo: TAdvStringGrid
        Left = 1
        Top = 49
        Width = 349
        Height = 114
        Cursor = crDefault
        Align = alClient
        ColCount = 1
        DefaultRowHeight = 21
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing, goRowMoving, goRowSelect]
        ScrollBars = ssBoth
        TabOrder = 1
        OnClick = sg_memoClick
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        SearchFooter.FindNextCaption = 'Find next'
        SearchFooter.FindPrevCaption = 'Find previous'
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'MS Sans Serif'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        FixedColWidth = 330
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        ColumnHeaders.Strings = (
          #51228#47785)
        Filter = <>
        Version = '3.3.0.1'
        ColWidths = (
          330)
      end
    end
    object Panel2: TPanel
      Left = 356
      Top = 14
      Width = 577
      Height = 164
      Align = alClient
      TabOrder = 1
      object GroupBox4: TGroupBox
        Left = 1
        Top = 1
        Width = 320
        Height = 162
        Align = alLeft
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 14
          Width = 24
          Height = 12
          Caption = #49884#44036
        end
        object Label3: TLabel
          Left = 168
          Top = 14
          Width = 6
          Height = 12
          Caption = '~'
        end
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
        object dt_StartTime: TDateTimePicker
          Left = 48
          Top = 10
          Width = 113
          Height = 20
          Date = 39386.701198460650000000
          Time = 39386.701198460650000000
          Enabled = False
          ImeName = 'Microsoft IME 2003'
          Kind = dtkTime
          TabOrder = 0
        end
        object dt_EndTime: TDateTimePicker
          Left = 184
          Top = 10
          Width = 113
          Height = 20
          Date = 39386.701198460650000000
          Time = 39386.701198460650000000
          Enabled = False
          ImeName = 'Microsoft IME 2003'
          Kind = dtkTime
          TabOrder = 1
        end
        object ed_SCSubject: TEdit
          Left = 48
          Top = 32
          Width = 249
          Height = 20
          ImeName = 'Microsoft IME 2003'
          TabOrder = 2
          Text = 'ed_SCSubject'
        end
        object mem_Memo: TMemo
          Left = 48
          Top = 60
          Width = 249
          Height = 89
          ImeName = 'Microsoft IME 2003'
          Lines.Strings = (
            'Memo1')
          TabOrder = 3
        end
        object ed_scheduleID: TEdit
          Left = 8
          Top = 96
          Width = 33
          Height = 20
          ImeName = 'Microsoft IME 2003'
          TabOrder = 4
          Visible = False
        end
      end
      object GroupBox5: TGroupBox
        Left = 321
        Top = 1
        Width = 255
        Height = 162
        Align = alClient
        Caption = #50508#46988
        TabOrder = 1
        object rg_AlarmType: TRadioGroup
          Left = 2
          Top = 14
          Width = 251
          Height = 43
          Align = alTop
          Columns = 2
          Items.Strings = (
            '1'#54924#50508#46988
            #48152#48373#50508#46988)
          TabOrder = 0
        end
        object GroupBox6: TGroupBox
          Left = 2
          Top = 57
          Width = 251
          Height = 48
          Align = alTop
          Caption = #50508#46988#49884#51089#49884#44036
          TabOrder = 1
          object Label6: TLabel
            Left = 56
            Top = 24
            Width = 12
            Height = 12
            Caption = #51068
          end
          object Label7: TLabel
            Left = 128
            Top = 24
            Width = 42
            Height = 12
            Caption = #49884#44036' '#51204
          end
          object ed_StartDay: TEdit
            Left = 8
            Top = 20
            Width = 41
            Height = 20
            ImeName = 'Microsoft IME 2003'
            TabOrder = 0
          end
          object ed_StartTime: TEdit
            Left = 80
            Top = 20
            Width = 41
            Height = 20
            ImeName = 'Microsoft IME 2003'
            TabOrder = 1
          end
        end
        object GroupBox7: TGroupBox
          Left = 2
          Top = 105
          Width = 251
          Height = 48
          Align = alTop
          Caption = #50508#46988#48152#48373#44396#44036
          TabOrder = 2
          object Label8: TLabel
            Left = 56
            Top = 24
            Width = 54
            Height = 12
            Caption = #49884#44036' '#47560#45796
          end
          object ed_RepeatTime: TEdit
            Left = 8
            Top = 20
            Width = 41
            Height = 20
            ImeName = 'Microsoft IME 2003'
            TabOrder = 0
          end
        end
      end
    end
  end
  object Panel3: TPanel [3]
    Left = 0
    Top = 547
    Width = 935
    Height = 50
    Align = alBottom
    TabOrder = 3
    object btn_Insert: TSpeedButton
      Left = 208
      Top = 17
      Width = 81
      Height = 25
      Caption = #52628#44032
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333FF33333333FF333993333333300033377F3333333777333993333333
        300033F77FFF3333377739999993333333333777777F3333333F399999933333
        33003777777333333377333993333333330033377F3333333377333993333333
        3333333773333333333F333333333333330033333333F33333773333333C3333
        330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
        993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
        333333333337733333FF3333333C333330003333333733333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = btn_InsertClick
    end
    object btn_Update: TSpeedButton
      Left = 294
      Top = 17
      Width = 81
      Height = 25
      Caption = #49688#51221
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
        000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
        00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
        F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
        0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
        FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
        FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
        0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
        00333377737FFFFF773333303300000003333337337777777333}
      NumGlyphs = 2
      OnClick = btn_UpdateClick
    end
    object btn_Save: TSpeedButton
      Left = 380
      Top = 17
      Width = 81
      Height = 25
      Caption = #51200#51109
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      OnClick = btn_SaveClick
    end
    object btn_Delete: TSpeedButton
      Left = 467
      Top = 17
      Width = 81
      Height = 25
      Caption = #49325#51228
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      OnClick = btn_DeleteClick
    end
    object btn_Cancel: TSpeedButton
      Left = 553
      Top = 16
      Width = 81
      Height = 25
      Caption = #52712#49548
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
        3333333777333777FF3333993333339993333377FF3333377FF3399993333339
        993337777FF3333377F3393999333333993337F777FF333337FF993399933333
        399377F3777FF333377F993339993333399377F33777FF33377F993333999333
        399377F333777FF3377F993333399933399377F3333777FF377F993333339993
        399377FF3333777FF7733993333339993933373FF3333777F7F3399933333399
        99333773FF3333777733339993333339933333773FFFFFF77333333999999999
        3333333777333777333333333999993333333333377777333333}
      NumGlyphs = 2
      OnClick = btn_CancelClick
    end
    object btn_Close: TSpeedButton
      Left = 640
      Top = 17
      Width = 81
      Height = 25
      Caption = #45803#44592
      Glyph.Data = {
        36060000424D3606000000000000360400002800000020000000100000000100
        08000000000000020000730B0000730B00000001000000000000000000003300
        00006600000099000000CC000000FF0000000033000033330000663300009933
        0000CC330000FF33000000660000336600006666000099660000CC660000FF66
        000000990000339900006699000099990000CC990000FF99000000CC000033CC
        000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
        0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
        330000333300333333006633330099333300CC333300FF333300006633003366
        33006666330099663300CC663300FF6633000099330033993300669933009999
        3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
        330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
        66006600660099006600CC006600FF0066000033660033336600663366009933
        6600CC336600FF33660000666600336666006666660099666600CC666600FF66
        660000996600339966006699660099996600CC996600FF99660000CC660033CC
        660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
        6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
        990000339900333399006633990099339900CC339900FF339900006699003366
        99006666990099669900CC669900FF6699000099990033999900669999009999
        9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
        990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
        CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
        CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
        CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
        CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
        CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
        FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
        FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
        FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
        FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
        000000808000800000008000800080800000C0C0C00080808000191919004C4C
        4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
        6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
        EEE8E8E8E8E8E8E8E8E8E8E8E8E8E8E8EEE8E8E8E8E8E8E8E8E8E8E8E8EEE3AC
        E3EEE8E8E8E8E8E8E8E8E8E8E8EEE8ACE3EEE8E8E8E8E8E8E8E8E8EEE3E28257
        57E2ACE3EEE8E8E8E8E8E8EEE8E2818181E2ACE8EEE8E8E8E8E8E382578282D7
        578181E2E3E8E8E8E8E8E881818181D7818181E2E8E8E8E8E8E857828989ADD7
        57797979EEE8E8E8E8E88181DEDEACD781818181EEE8E8E8E8E857898989ADD7
        57AAAAA2D7ADE8E8E8E881DEDEDEACD781DEDE81D7ACE8E8E8E857898989ADD7
        57AACEA3AD10E8E8E8E881DEDEDEACD781DEAC81AC81E8E8E8E85789825EADD7
        57ABCFE21110E8E8E8E881DE8181ACD781ACACE28181E8E8E8E8578957D7ADD7
        57ABDE101010101010E881DE56D7ACD781ACDE818181818181E857898257ADD7
        57E810101010101010E881DE8156ACD781E381818181818181E857898989ADD7
        57E882101010101010E881DEDEDEACD781E381818181818181E857898989ADD7
        57ACEE821110E8E8E8E881DEDEDEACD781ACEE818181E8E8E8E857898989ADD7
        57ABE8AB8910E8E8E8E881DEDEDEACD781ACE3ACDE81E8E8E8E857828989ADD7
        57ACE8A3E889E8E8E8E88181DEDEACD781ACE381E8DEE8E8E8E8E8DE5E8288D7
        57A2A2A2E8E8E8E8E8E8E8DE8181DED781818181E8E8E8E8E8E8E8E8E8AC8257
        57E8E8E8E8E8E8E8E8E8E8E8E8AC818181E8E8E8E8E8E8E8E8E8}
      NumGlyphs = 2
      OnClick = btn_CloseClick
    end
  end
  object TempQuery: TADOQuery
    Connection = DataModule1.ADOConnection1
    Parameters = <>
    Left = 8
    Top = 8
  end
end
