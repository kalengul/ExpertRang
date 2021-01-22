object FMain: TFMain
  Left = 304
  Top = 117
  Width = 1324
  Height = 884
  Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1088#1072#1085#1078#1080#1088#1086#1074#1082#1080' '#1091#1095#1072#1089#1090#1085#1080#1082#1086#1074' '#1087#1086' '#1101#1082#1089#1087#1077#1088#1090#1085#1099#1084' '#1086#1094#1077#1085#1082#1072#1084
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 1308
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 97
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086' '#1091#1095#1072#1089#1090#1085#1080#1082#1086#1074
    end
    object Label2: TLabel
      Left = 120
      Top = 0
      Width = 90
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086' '#1101#1082#1089#1087#1077#1088#1090#1086#1074
    end
    object SeKolStudents: TSpinEdit
      Left = 0
      Top = 16
      Width = 105
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = SeKolStudentsChange
    end
    object SeKolExperts: TSpinEdit
      Left = 120
      Top = 16
      Width = 89
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = SeKolExpertsChange
    end
    object BtLoadStudentData: TButton
      Left = 224
      Top = 8
      Width = 185
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1091#1095#1072#1089#1090#1085#1080#1082#1072#1093
      TabOrder = 2
    end
    object BtLoadExpertData: TButton
      Left = 416
      Top = 8
      Width = 193
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086#1073' '#1101#1082#1089#1087#1077#1088#1090#1072#1093
      TabOrder = 3
    end
    object BtStart: TButton
      Left = 632
      Top = 8
      Width = 75
      Height = 25
      Caption = 'BtStart'
      TabOrder = 4
      OnClick = BtStartClick
    end
  end
  object Pn2: TPanel
    Left = 0
    Top = 41
    Width = 353
    Height = 437
    Align = alLeft
    TabOrder = 1
    object Pn5: TPanel
      Left = 1
      Top = 1
      Width = 351
      Height = 216
      Align = alTop
      TabOrder = 0
      object MeStudent: TMemo
        Left = 1
        Top = 1
        Width = 349
        Height = 214
        Align = alClient
        Lines.Strings = (
          'MeStudent')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object MeExperts: TMemo
      Left = 1
      Top = 217
      Width = 351
      Height = 219
      Align = alClient
      Lines.Strings = (
        'MeExperts')
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object Pn3: TPanel
    Left = 0
    Top = 478
    Width = 1308
    Height = 368
    Align = alBottom
    TabOrder = 2
    object Pn6: TPanel
      Left = 1
      Top = 1
      Width = 352
      Height = 366
      Align = alLeft
      TabOrder = 0
      object Pn7: TPanel
        Left = 1
        Top = 1
        Width = 350
        Height = 16
        Align = alTop
        TabOrder = 0
        object Label3: TLabel
          Left = 152
          Top = 0
          Width = 49
          Height = 13
          Caption = #1055#1088#1086#1090#1086#1082#1086#1083
        end
      end
      object MeProtocol: TMemo
        Left = 1
        Top = 17
        Width = 350
        Height = 348
        Align = alClient
        Lines.Strings = (
          'MeProtocol')
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object Pn8: TPanel
      Left = 353
      Top = 1
      Width = 160
      Height = 366
      Align = alLeft
      TabOrder = 1
      object Pn10: TPanel
        Left = 1
        Top = 1
        Width = 158
        Height = 16
        Align = alTop
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 0
          Width = 144
          Height = 13
          Caption = #1056#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1072#1103' '#1088#1072#1085#1078#1080#1088#1086#1074#1082#1072
        end
      end
      object MeResult: TMemo
        Left = 1
        Top = 17
        Width = 158
        Height = 348
        Align = alClient
        TabOrder = 1
      end
    end
    object SgRang: TStringGrid
      Left = 513
      Top = 1
      Width = 655
      Height = 366
      Align = alClient
      ColCount = 7
      DefaultColWidth = 110
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 2
      OnSelectCell = SgPointsSelectCell
      OnSetEditText = SgPointsSetEditText
    end
    object Pn9: TPanel
      Left = 1168
      Top = 1
      Width = 139
      Height = 366
      Align = alRight
      TabOrder = 3
      object RgTypeVivod: TRadioGroup
        Left = 0
        Top = 0
        Width = 137
        Height = 57
        Caption = #1042#1099#1074#1086#1076#1080#1084#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
        ItemIndex = 0
        Items.Strings = (
          #1053#1086#1084#1077#1088
          #1048#1084#1103)
        TabOrder = 0
        OnClick = RgTypeVivodClick
      end
    end
  end
  object Pn4: TPanel
    Left = 353
    Top = 41
    Width = 955
    Height = 437
    Align = alClient
    TabOrder = 3
    object SgPoints: TStringGrid
      Left = 1
      Top = 1
      Width = 953
      Height = 435
      Align = alClient
      ColCount = 1
      DefaultColWidth = 170
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnSelectCell = SgPointsSelectCell
      OnSetEditText = SgPointsSetEditText
    end
  end
end
