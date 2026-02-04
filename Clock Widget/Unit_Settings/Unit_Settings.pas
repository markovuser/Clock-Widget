Unit Unit_Settings;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, ShellApi, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ComCtrls,
  Vcl.ExtCtrls, WindowsDarkMode, IniFiles, Registry, Vcl.Samples.Spin, Vcl.Grids,
  Vcl.Buttons, Vcl.Menus, StrUtils, WinSvc, System.UITypes, System.Notification;

Type
  TTrackBar = Class(ComCtrls.TTrackBar)
  Protected
    Procedure MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: Integer); Override;
    Function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; Override;
    Procedure CreateParams(Var Params: TCreateParams); Override;
  End;

Type
  TForm2 = Class(TForm)
    TabControlButtons: TTabControl;
    ButtonSave: TButton;
    TabControlBody: TTabControl;
    GroupBox4: TGroupBox;
    MenuAutostart: TCheckBox;
    GroupBoxFont: TGroupBox;
    RadioButtonCustomFont: TRadioButton;
    GroupBox2: TGroupBox;
    MenuColorTrayIcon: TCheckBox;
    GroupBox3: TGroupBox;
    RadioButtonLastPosition: TRadioButton;
    RadioButtonCenterTop: TRadioButton;
    ColorBoxNumber: TColorBox;
    GroupBoxScale: TGroupBox;
    TrackBarScale: TTrackBar;
    CheckFontBold: TCheckBox;
    SpinEditScale: TSpinEdit;
    RadioButtonRight: TRadioButton;
    CheckBoxZero: TCheckBox;
    CheckBoxShowSign: TCheckBox;
    CheckBoxShowSeconds: TCheckBox;
    CheckBoxAutoColor: TCheckBox;
    CheckBoxIgnoreMouse: TCheckBox;
    RadioButtonRightTop: TRadioButton;
    Procedure FormCreate(Sender: TObject);
    Procedure ButtonSaveClick(Sender: TObject);
    Procedure RadioButtonLastPositionClick(Sender: TObject);
    Procedure LoadNastr;
    Procedure RestoreStringInfo;
    Procedure CheckAutoStart;
    Procedure ApplyScaleImmediately;
    Procedure CreateAutoStart(Enabled: Boolean);
    Procedure MenuColorTrayIconClick(Sender: TObject);
    Procedure MenuAutostartClick(Sender: TObject);
    Procedure SpinEditDateFontSizeKeyPress(Sender: TObject; Var Key: Char);
    Procedure RadioButtonCenterTopClick(Sender: TObject);
    Procedure RadioButtonCustomFontClick(Sender: TObject);
    Procedure CheckFontBoldClick(Sender: TObject);
    Procedure ColorBoxNumberClick(Sender: TObject);
    Procedure TrackBarScaleChange(Sender: TObject);
    Procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; Var Handled: Boolean);
    Procedure SpinEditScaleKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Procedure SpinEditScaleKeyPress(Sender: TObject; Var Key: Char);
    Procedure SpinEditScaleChange(Sender: TObject);
    Procedure RadioButtonRightClick(Sender: TObject);
    Procedure CheckBoxAutoColorClick(Sender: TObject);
    Function IsMouseIgnored: Boolean;
    Procedure CheckBoxIgnoreMouseClick(Sender: TObject);
    Procedure RadioButtonRightTopClick(Sender: TObject);
  Private
    { Private declarations }
    FCurrentScale: Integer;
  Public
    { Public declarations }
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  End;

Var
  Form2: TForm2;
  i: Int64;
  LastSync: TDateTime;

Implementation

{$R *.dfm}

Uses
  Unit_Base;

Procedure TTrackBar.CreateParams(Var Params: TCreateParams);
Begin
  Inherited;
  Params.Style := Params.Style;
End;

Function TTrackBar.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
Begin
  Position := Position + WheelDelta Div 120;
  Result := True;
End;

Procedure TTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Var
  GlobalPos, LocalPos: TPoint;
Begin
  If self.Name = 'TrackBarScale' Then
  Begin
    If Button = mbLeft Then
    Begin
      GetCursorPos(GlobalPos);
      LocalPos := Form2.TrackBarScale.ScreenToClient(GlobalPos);
      Form2.TrackBarScale.Position := Round((Form2.TrackBarScale.Max / (Form2.TrackBarScale.Width - 28)) * (LocalPos.x - 14));
    End;
  End;
End;

Procedure TForm2.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
End;

Procedure TForm2.ButtonSaveClick(Sender: TObject);
Begin
  Form1.SaveNastr;
  application.ProcessMessages;
  Form2.Close;
End;

Procedure TForm2.CheckAutoStart;
Var
  Reg: TRegistry;
Begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', TRUE);

  If (Reg.ValueExists(Application.Title) = TRUE) And (Reg.ReadString(Application.Title) = (ParamStr(0))) Then
  Begin
    Form2.MenuAutostart.Checked := TRUE;
  End;

  If (Reg.ValueExists(Application.Title) = TRUE) And (Reg.ReadString(Application.Title) <> (ParamStr(0))) Then
  Begin
    Form2.MenuAutostart.Checked := false;
  End;

  If Reg.ValueExists(Application.Title) = false Then
  Begin
    Form2.MenuAutostart.Checked := false;
  End;
  Reg.CloseKey;
  Reg.Free;
End;

Procedure TForm2.CheckBoxAutoColorClick(Sender: TObject);
Begin
  ColorBoxNumber.Enabled := Not CheckBoxAutoColor.Checked;
  ColorBoxNumberClick(self);
  Form1.Timer2.Enabled := CheckBoxAutoColor.Checked;
End;

Procedure TForm2.CheckBoxIgnoreMouseClick(Sender: TObject);
Begin
    // Обновляем курсор на главной форме
  If Assigned(Form1) Then
    Form1.UpdateCursorForAllLabels;
End;

Function TForm2.IsMouseIgnored: Boolean;
Begin
  Result := CheckBoxIgnoreMouse.Checked;
End;

Procedure TForm2.LoadNastr;
Var
  Ini: TMemIniFile;
Begin
  CheckAutoStart;
  Ini := TMemIniFile.Create(Form1.PortablePath);

  Form2.TrackBarScale.Position := Ini.ReadInteger('Option', Form2.TrackBarScale.Name, 0);
  FCurrentScale := Form2.TrackBarScale.Position;
  Form2.TrackBarScaleChange(self);

  Form2.RadioButtonCustomFont.Checked := Ini.ReadBool('Option', Form2.RadioButtonCustomFont.Name, false);
  If Form2.RadioButtonCustomFont.Checked = TRUE Then
  Begin
    Form2.RadioButtonCustomFontClick(self);
  End;

  Form2.RadioButtonLastPosition.Checked := Ini.ReadBool('Option', Form2.RadioButtonLastPosition.Name, false);
  If Form2.RadioButtonLastPosition.Checked = TRUE Then
  Begin
    Form2.RadioButtonLastPositionClick(self);
  End;

  Form2.RadioButtonCenterTop.Checked := Ini.ReadBool('Option', Form2.RadioButtonCenterTop.Name, false);
  If Form2.RadioButtonCenterTop.Checked = TRUE Then
  Begin
    Form2.RadioButtonCenterTopClick(self);
  End;
  Form2.RadioButtonRight.Checked := Ini.ReadBool('Option', Form2.RadioButtonRight.Name, false);
  If Form2.RadioButtonRight.Checked = TRUE Then
  Begin
    Form2.RadioButtonRightClick(self);
  End;
  Form2.RadioButtonRightTop.Checked := Ini.ReadBool('Option', Form2.RadioButtonRightTop.Name, false);
  If Form2.RadioButtonRightTop.Checked = TRUE Then
  Begin
    Form2.RadioButtonRightTopClick(self);
  End;
  application.ProcessMessages;
  RestoreStringInfo;

  application.ProcessMessages;

  // Цветная иконка
  Form2.MenuColorTrayIcon.Checked := Ini.ReadBool('Option', Form2.MenuColorTrayIcon.Name, false);
  Try
    If Form2.MenuColorTrayIcon.Checked = TRUE Then
    Begin
      Form1.TrayIcon1.IconIndex := 2;
      application.ProcessMessages;
    End;

    If Form2.MenuColorTrayIcon.Checked = false Then
    Begin
      If DarkModeIsEnabled = TRUE Then
      Begin
        If SystemUsesLightTheme = false Then
          Form1.TrayIcon1.IconIndex := 1;
        If SystemUsesLightTheme = TRUE Then
          Form1.TrayIcon1.IconIndex := 0;
        application.ProcessMessages;
      End;

      If DarkModeIsEnabled = false Then
      Begin
        If SystemUsesLightTheme = TRUE Then
          Form1.TrayIcon1.IconIndex := 0;
        If SystemUsesLightTheme = false Then
          Form1.TrayIcon1.IconIndex := 1;
        application.ProcessMessages;
      End;
    End;
  Except
  End;

  // Блокировка положения окна
  Form2.CheckBoxIgnoreMouse.Checked := Ini.ReadBool('Option', CheckBoxIgnoreMouse.Name, false);
  Form2.CheckBoxIgnoreMouseClick(Self);

  Form2.CheckBoxZero.Checked := Ini.ReadBool('Option', CheckBoxZero.Name, false);
  Form2.CheckBoxShowSign.Checked := Ini.ReadBool('Option', CheckBoxShowSign.Name, false);
  Form2.CheckBoxShowSeconds.Checked := Ini.ReadBool('Option', CheckBoxShowSeconds.Name, false);
  // Размерт шрифта

  Form2.CheckFontBold.Checked := Ini.ReadBool('Option', Form2.CheckFontBold.Name, false);
  Form2.CheckFontBoldClick(self);

  Form2.CheckBoxAutoColor.Checked := Ini.ReadBool('Option', Form2.CheckBoxAutoColor.Name, false);
  Form2.CheckBoxAutoColorClick(self);

  If Form2.CheckBoxAutoColor.Checked = false Then
  Begin
    Form2.ColorBoxNumber.Selected := Ini.ReadInteger('Option', Form2.ColorBoxNumber.Name, clWhite);
    Form2.ColorBoxNumberClick(Self);
  End;

  Ini.Free;
End;

Procedure TForm2.FormCreate(Sender: TObject);
Begin
  Form1.Globload;
  SpinEditScale.MaxValue := TrackBarScale.Max;
  SpinEditScale.MinValue := TrackBarScale.Min;
  OnMouseWheel := FormMouseWheel;
End;

Procedure TForm2.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; Var Handled: Boolean);
Var
  ComponentAtPosition: TControl;
Begin
  // Получаем компонент, находящийся под курсором мыши
  ComponentAtPosition := FindDragTarget(Mouse.CursorPos, False);

  // Проверяем, является ли компонент типом TSpinEdit
  If Assigned(ComponentAtPosition) And (ComponentAtPosition Is TSpinEdit) Then
  Begin
    With TComponent(ComponentAtPosition) As TSpinEdit Do
    Begin
      SetFocus();
      If WheelDelta > 0 Then
        Value := Value + 1
      Else
        Value := Value - 1;

      SelectAll(); // Выделение текста

      Handled := True;
    End;
  End;
End;

Procedure tForm2.CreateAutoStart(Enabled: Boolean);
Var
  Reg: TRegistry;
Begin
  If Enabled = true Then
  Begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', TRUE);
    Reg.WriteString(Application.Title, ParamStr(0));
    Reg.CloseKey;
    Reg.Free;
  End;

  If Enabled = false Then
  Begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', TRUE);
    Reg.DeleteValue(Application.Title);
    Reg.CloseKey;
    Reg.Free;
  End;
End;

Procedure TForm2.MenuAutostartClick(Sender: TObject);
Begin
  If MenuAutostart.Checked Then
  Begin
    CreateAutoStart(True);
  End
  Else
  Begin
    CreateAutoStart(false);
  End;
End;

Procedure TForm2.MenuColorTrayIconClick(Sender: TObject);
Begin
  Try
    If Form2.MenuColorTrayIcon.Checked = TRUE Then
    Begin
      Form1.TrayIcon1.IconIndex := 2;
      application.ProcessMessages;
    End;

    If Form2.MenuColorTrayIcon.Checked = false Then
    Begin
      If DarkModeIsEnabled = TRUE Then
      Begin
        If SystemUsesLightTheme = false Then
          Form1.TrayIcon1.IconIndex := 1;
        If SystemUsesLightTheme = TRUE Then
          Form1.TrayIcon1.IconIndex := 0;
        application.ProcessMessages;
      End;

      If DarkModeIsEnabled = false Then
      Begin
        If SystemUsesLightTheme = TRUE Then
          Form1.TrayIcon1.IconIndex := 0;
        If SystemUsesLightTheme = false Then
          Form1.TrayIcon1.IconIndex := 1;
        application.ProcessMessages;
      End;
    End;
  Except
  End;
End;

Procedure TForm2.RadioButtonCenterTopClick(Sender: TObject);
Begin
  RadioButtonLastPosition.Checked := false;
  RadioButtonRight.Checked := false;
  RadioButtonCenterTop.Checked := TRUE;
End;

Procedure TForm2.RadioButtonCustomFontClick(Sender: TObject);
Begin
  RadioButtonCustomFont.Checked := TRUE;
  Form1.FontApply;
  RestoreStringInfo;
End;

Procedure TForm2.RadioButtonLastPositionClick(Sender: TObject);
Var
  Ini: TMemIniFile;
Begin
  Ini := TMemIniFile.Create(Form1.PortablePath);
  RadioButtonLastPosition.Checked := TRUE;
  RadioButtonCenterTop.Checked := false;
  RadioButtonRight.Checked := false;
  RadioButtonRightTop.Checked := false;
  Form1.Top := Ini.ReadInteger('Option', 'Top', Form1.Top);
  Form1.Left := Ini.ReadInteger('Option', 'Left', Form1.Left);
  Form1.KeepFormInWorkArea;
  Ini.Free;
End;

Procedure TForm2.RadioButtonRightClick(Sender: TObject);
Var
  Ini: TMemIniFile;
Begin
  Ini := TMemIniFile.Create(Form1.PortablePath);
  RadioButtonLastPosition.Checked := false;
  RadioButtonCenterTop.Checked := false;
  RadioButtonRightTop.Checked := false;
  RadioButtonRight.Checked := true;
  Form1.Top := Ini.ReadInteger('Option', 'Top', Form1.Top);
  Ini.Free;
End;

Procedure TForm2.RadioButtonRightTopClick(Sender: TObject);
Begin
  RadioButtonLastPosition.Checked := false;
  RadioButtonCenterTop.Checked := false;
  RadioButtonRight.Checked := false;
  RadioButtonRightTop.Checked := true;
End;

Procedure TForm2.RestoreStringInfo;
Begin
  Form1.Height := 0;
  Form1.Height := Form1.Height + Form1.LabelSpace1.Height + Form1.LabelTime.Height + Form1.LabelSpace2.Height + Form1.LabelDate.Height + +Form1.LabelDay.Height;
End;

Procedure TForm2.SpinEditDateFontSizeKeyPress(Sender: TObject; Var Key: Char);
Begin
  Key := #0;
End;

Procedure TForm2.SpinEditScaleChange(Sender: TObject);
Begin
  TrackBarScale.Position := Form2.SpinEditScale.Value;
End;

Procedure TForm2.SpinEditScaleKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
  If Key In [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_BACK, VK_DELETE] Then
    Exit
  Else If Not (Key In [VK_TAB, VK_RETURN, VK_ESCAPE]) Then
    Key := 0;
End;

Procedure TForm2.SpinEditScaleKeyPress(Sender: TObject; Var Key: Char);
Begin
  Key := #0;
End;

Procedure TForm2.ApplyScaleImmediately;
Begin
  If Assigned(Form1) Then
  Begin
    // Применяем масштаб к главному окну

    Form1.ApplyScale(FCurrentScale);

  End;
End;

Procedure TForm2.TrackBarScaleChange(Sender: TObject);
Begin
  Form2.SpinEditScale.Value := TrackBarScale.Position;
  FCurrentScale := TrackBarScale.Position;
  ApplyScaleImmediately;
  Application.ProcessMessages;
End;

Procedure TForm2.CheckFontBoldClick(Sender: TObject);
Begin
  If CheckFontBold.Checked Then
  Begin
    Form1.LabelTime.Font.Style := Form1.LabelTime.Font.Style + [fsBold];
    Form1.LabelDate.Font.Style := Form1.LabelDate.Font.Style + [fsBold];
    Form1.LabelDay.Font.Style := Form1.LabelDay.Font.Style + [fsBold];
  End;

  If CheckFontBold.Checked = false Then
  Begin
    Form1.LabelTime.Font.Style := Form1.LabelTime.Font.Style - [fsBold];
    Form1.LabelDate.Font.Style := Form1.LabelDate.Font.Style - [fsBold];
    Form1.LabelDay.Font.Style := Form1.LabelDay.Font.Style - [fsBold];
  End;
End;

Procedure TForm2.ColorBoxNumberClick(Sender: TObject);
Begin
  If CheckBoxAutoColor.Checked = false Then
  Begin
    Form1.LabelTime.Font.Color := Form2.ColorBoxNumber.Selected;
    Form1.LabelDate.Font.Color := Form2.ColorBoxNumber.Selected;
    Form1.LabelDay.Font.Color := Form2.ColorBoxNumber.Selected;
  End;
End;

End.

