object Form2: TForm2
  Left = 0
  Top = 0
  Cursor = crHandPoint
  AutoSize = True
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 351
  ClientWidth = 329
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 340
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  RoundedCorners = rcOn
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  TextHeight = 15
  object TabControlButtons: TTabControl
    Left = 0
    Top = 316
    Width = 329
    Height = 35
    Align = alBottom
    TabOrder = 1
    object ButtonSave: TButton
      Left = 4
      Top = 6
      Width = 321
      Height = 25
      Cursor = crHandPoint
      Align = alClient
      Caption = 'Ok'
      TabOrder = 0
      OnClick = ButtonSaveClick
    end
  end
  object TabControlBody: TTabControl
    Left = 0
    Top = 0
    Width = 329
    Height = 316
    Align = alClient
    TabOrder = 0
    object GroupBox4: TGroupBox
      Left = 4
      Top = 265
      Width = 321
      Height = 47
      Align = alClient
      Caption = #1040#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1072
      TabOrder = 0
      object MenuAutostart: TCheckBox
        Left = 6
        Top = 17
        Width = 305
        Height = 17
        Cursor = crHandPoint
        Caption = #1040#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' Windows'
        TabOrder = 0
        OnClick = MenuAutostartClick
      end
    end
    object GroupBoxFont: TGroupBox
      Left = 4
      Top = 135
      Width = 321
      Height = 65
      Align = alTop
      Caption = #1064#1088#1080#1092#1090
      TabOrder = 1
      object RadioButtonCustomFont: TRadioButton
        Left = 6
        Top = 20
        Width = 113
        Height = 17
        Cursor = crHandPoint
        Caption = #1042#1089#1090#1088#1086#1077#1085#1085#1099#1081
        TabOrder = 0
        OnClick = RadioButtonCustomFontClick
      end
      object ColorBoxNumber: TColorBox
        Left = 167
        Top = 17
        Width = 145
        Height = 22
        Cursor = crHandPoint
        DefaultColorColor = clWhite
        NoneColorColor = clWhite
        Selected = clWhite
        TabOrder = 1
        OnClick = ColorBoxNumberClick
      end
      object CheckFontBold: TCheckBox
        Left = 6
        Top = 43
        Width = 100
        Height = 17
        Cursor = crHandPoint
        Caption = #1055#1086#1083#1091#1078#1080#1088#1085#1099#1081
        TabOrder = 2
        OnClick = CheckFontBoldClick
      end
      object CheckBoxAutoColor: TCheckBox
        Left = 167
        Top = 43
        Width = 144
        Height = 17
        Cursor = crHandPoint
        Caption = #1040#1074#1090#1086' '#1094#1074#1077#1090
        TabOrder = 3
        OnClick = CheckBoxAutoColorClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 4
      Top = 6
      Width = 321
      Height = 84
      Align = alTop
      Caption = #1042#1080#1076
      TabOrder = 2
      object MenuColorTrayIcon: TCheckBox
        Left = 6
        Top = 17
        Width = 150
        Height = 17
        Cursor = crHandPoint
        Caption = #1062#1074#1077#1090#1085#1072#1103' '#1080#1082#1086#1085#1082#1072
        TabOrder = 0
        OnClick = MenuColorTrayIconClick
      end
      object CheckBoxZero: TCheckBox
        Left = 167
        Top = 17
        Width = 144
        Height = 17
        Cursor = crHandPoint
        Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1085#1086#1083#1100
        TabOrder = 1
      end
      object CheckBoxShowSign: TCheckBox
        Left = 167
        Top = 38
        Width = 144
        Height = 17
        Cursor = crHandPoint
        Caption = #1052#1080#1075#1072#1102#1097#1080#1081' '#1079#1085#1072#1082' '#39':'#39
        TabOrder = 2
      end
      object CheckBoxShowSeconds: TCheckBox
        Left = 167
        Top = 59
        Width = 144
        Height = 17
        Cursor = crHandPoint
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1077#1082#1091#1085#1076#1099
        TabOrder = 3
      end
      object CheckBoxIgnoreMouse: TCheckBox
        Left = 6
        Top = 38
        Width = 150
        Height = 17
        Cursor = crHandPoint
        Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100' '#1084#1099#1096#1100
        TabOrder = 4
        OnClick = CheckBoxIgnoreMouseClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 4
      Top = 200
      Width = 321
      Height = 65
      Align = alTop
      Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077' '#1086#1082#1085#1072
      TabOrder = 3
      object RadioButtonLastPosition: TRadioButton
        Left = 6
        Top = 38
        Width = 181
        Height = 17
        Cursor = crHandPoint
        Caption = #1055#1086#1089#1083#1077#1076#1085#1077#1077
        TabOrder = 1
        OnClick = RadioButtonLastPositionClick
      end
      object RadioButtonCenterTop: TRadioButton
        Left = 6
        Top = 17
        Width = 150
        Height = 17
        Cursor = crHandPoint
        Caption = #1055#1086' '#1094#1077#1085#1090#1088#1091' '#1089#1074#1077#1088#1093#1091
        TabOrder = 0
        OnClick = RadioButtonCenterTopClick
      end
      object RadioButtonRight: TRadioButton
        Left = 167
        Top = 40
        Width = 144
        Height = 17
        Cursor = crHandPoint
        Caption = #1057#1087#1088#1072#1074#1072
        TabOrder = 2
        OnClick = RadioButtonRightClick
      end
      object RadioButtonRightTop: TRadioButton
        Left = 167
        Top = 17
        Width = 144
        Height = 17
        Cursor = crHandPoint
        Caption = #1057#1087#1088#1072#1074#1072' '#1089#1074#1077#1088#1093#1091
        TabOrder = 3
        OnClick = RadioButtonRightTopClick
      end
    end
    object GroupBoxScale: TGroupBox
      Left = 4
      Top = 90
      Width = 321
      Height = 45
      Align = alTop
      Caption = #1052#1072#1089#1096#1090#1072#1073
      TabOrder = 4
      object TrackBarScale: TTrackBar
        Left = 6
        Top = 17
        Width = 145
        Height = 24
        Cursor = crHandPoint
        Max = 400
        Min = 40
        Position = 100
        TabOrder = 0
        TickStyle = tsNone
        OnChange = TrackBarScaleChange
      end
      object SpinEditScale: TSpinEdit
        Left = 167
        Top = 15
        Width = 145
        Height = 24
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = SpinEditScaleChange
        OnKeyDown = SpinEditScaleKeyDown
        OnKeyPress = SpinEditScaleKeyPress
      end
    end
  end
end
