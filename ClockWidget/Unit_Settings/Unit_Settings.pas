unit Unit_Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, ShellApi, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, ComCtrls, Vcl.ExtCtrls, WindowsDarkMode, IniFiles, Registry,
  Vcl.Samples.Spin, Vcl.Grids, Vcl.Buttons, Vcl.Menus, StrUtils, WinSvc,
  System.UITypes, System.Notification;

type
  TTrackBar = class(ComCtrls.TTrackBar)
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

type
  TForm2 = class(TForm)
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
    CheckBoxShowFrame: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure RadioButtonLastPositionClick(Sender: TObject);
    procedure LoadNastr;
    procedure RestoreStringInfo;
    procedure CheckAutoStart;
    procedure ApplyScaleImmediately;
    procedure CreateAutoStart(Enabled: Boolean);
    procedure MenuColorTrayIconClick(Sender: TObject);
    procedure MenuAutostartClick(Sender: TObject);
    procedure SpinEditDateFontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure RadioButtonCenterTopClick(Sender: TObject);
    procedure RadioButtonCustomFontClick(Sender: TObject);
    procedure CheckFontBoldClick(Sender: TObject);
    procedure ColorBoxNumberClick(Sender: TObject);
    procedure TrackBarScaleChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SpinEditScaleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpinEditScaleKeyPress(Sender: TObject; var Key: Char);
    procedure SpinEditScaleChange(Sender: TObject);
    procedure RadioButtonRightClick(Sender: TObject);
    procedure CheckBoxAutoColorClick(Sender: TObject);
    function IsMouseIgnored: Boolean;
    procedure CheckBoxIgnoreMouseClick(Sender: TObject);
    procedure RadioButtonRightTopClick(Sender: TObject);
    procedure CheckBoxShowFrameClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCurrentScale: Integer;
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  Form2: TForm2;
  i: Int64;
  LastSync: TDateTime;

implementation

{$R *.dfm}

uses
  Unit_Base;

procedure TForm2.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TTrackBar.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style;
end;

function TTrackBar.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Position := Position + WheelDelta div 120;
  Result := True;
end;

procedure TTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: Integer);
var
  GlobalPos, LocalPos: TPoint;
begin
  if self.Name = 'TrackBarScale' then
  begin
    if Button = mbLeft then
    begin
      GetCursorPos(GlobalPos);
      LocalPos := Form2.TrackBarScale.ScreenToClient(GlobalPos);
      Form2.TrackBarScale.Position := Round((Form2.TrackBarScale.Max / (Form2.TrackBarScale.Width - 28)) * (LocalPos.x - 14));
    end;
  end;
end;

procedure TForm2.ButtonSaveClick(Sender: TObject);
begin
  Form1.SaveNastr;
  application.ProcessMessages;
  Form2.Close;
end;

procedure TForm2.CheckAutoStart;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', TRUE);

  if (Reg.ValueExists(Application.Title) = TRUE) and (Reg.ReadString(Application.Title) = (ParamStr(0))) then
  begin
    Form2.MenuAutostart.Checked := TRUE;
  end;

  if (Reg.ValueExists(Application.Title) = TRUE) and (Reg.ReadString(Application.Title) <> (ParamStr(0))) then
  begin
    Form2.MenuAutostart.Checked := false;
  end;

  if Reg.ValueExists(Application.Title) = false then
  begin
    Form2.MenuAutostart.Checked := false;
  end;
  Reg.CloseKey;
  Reg.Free;
end;

procedure TForm2.CheckBoxAutoColorClick(Sender: TObject);
begin
  ColorBoxNumber.Enabled := not CheckBoxAutoColor.Checked;
  ColorBoxNumberClick(self);
  Form1.Timer2.Enabled := CheckBoxAutoColor.Checked;
end;

procedure TForm2.CheckBoxIgnoreMouseClick(Sender: TObject);
begin
    // Обновляем курсор на главной форме
  if Assigned(Form1) then
    Form1.UpdateCursorForAllLabels;
end;

procedure TForm2.CheckBoxShowFrameClick(Sender: TObject);
begin
  if CheckBoxShowFrame.Checked then
  begin
    Form1.RoundedCorners := rcOn;
  end;

  if CheckBoxShowFrame.Checked = false then
  begin
    Form1.RoundedCorners := rcOff;
  end;

end;

function TForm2.IsMouseIgnored: Boolean;
begin
  Result := CheckBoxIgnoreMouse.Checked;
end;

procedure TForm2.LoadNastr;
var
  Ini: TMemIniFile;
begin
  CheckAutoStart;
  Ini := TMemIniFile.Create(Form1.PortablePath);

  Form2.TrackBarScale.Position := Ini.ReadInteger('Option', Form2.TrackBarScale.Name, 0);
  FCurrentScale := Form2.TrackBarScale.Position;
  Form2.TrackBarScaleChange(self);

  Form2.RadioButtonCustomFont.Checked := Ini.ReadBool('Option', Form2.RadioButtonCustomFont.Name, false);
  if Form2.RadioButtonCustomFont.Checked = TRUE then
  begin
    Form2.RadioButtonCustomFontClick(self);
  end;

  Form2.RadioButtonLastPosition.Checked := Ini.ReadBool('Option', Form2.RadioButtonLastPosition.Name, false);
  if Form2.RadioButtonLastPosition.Checked = TRUE then
  begin
    Form2.RadioButtonLastPositionClick(self);
  end;

  Form2.RadioButtonCenterTop.Checked := Ini.ReadBool('Option', Form2.RadioButtonCenterTop.Name, false);
  if Form2.RadioButtonCenterTop.Checked = TRUE then
  begin
    Form2.RadioButtonCenterTopClick(self);
  end;
  Form2.RadioButtonRight.Checked := Ini.ReadBool('Option', Form2.RadioButtonRight.Name, false);
  if Form2.RadioButtonRight.Checked = TRUE then
  begin
    Form2.RadioButtonRightClick(self);
  end;
  Form2.RadioButtonRightTop.Checked := Ini.ReadBool('Option', Form2.RadioButtonRightTop.Name, false);
  if Form2.RadioButtonRightTop.Checked = TRUE then
  begin
    Form2.RadioButtonRightTopClick(self);
  end;
  application.ProcessMessages;
  RestoreStringInfo;

  application.ProcessMessages;

  // Цветная иконка
  Form2.MenuColorTrayIcon.Checked := Ini.ReadBool('Option', Form2.MenuColorTrayIcon.Name, false);
  try
    if Form2.MenuColorTrayIcon.Checked = TRUE then
    begin
      Form1.TrayIcon1.IconIndex := 2;
      application.ProcessMessages;
    end;

    if Form2.MenuColorTrayIcon.Checked = false then
    begin
      if DarkModeIsEnabled = TRUE then
      begin
        if SystemUsesLightTheme = false then
          Form1.TrayIcon1.IconIndex := 1;
        if SystemUsesLightTheme = TRUE then
          Form1.TrayIcon1.IconIndex := 0;
        application.ProcessMessages;
      end;

      if DarkModeIsEnabled = false then
      begin
        if SystemUsesLightTheme = TRUE then
          Form1.TrayIcon1.IconIndex := 0;
        if SystemUsesLightTheme = false then
          Form1.TrayIcon1.IconIndex := 1;
        application.ProcessMessages;
      end;
    end;
  except
  end;

  // Блокировка положения окна
  Form2.CheckBoxIgnoreMouse.Checked := Ini.ReadBool('Option', CheckBoxIgnoreMouse.Name, false);
  Form2.CheckBoxIgnoreMouseClick(Self);
 //Рамка окна
  Form2.CheckBoxShowFrame.Checked := Ini.ReadBool('Option', CheckBoxShowFrame.Name, false);
  Form2.CheckBoxShowFrameClick(Self);

  Form2.CheckBoxZero.Checked := Ini.ReadBool('Option', CheckBoxZero.Name, false);
  Form2.CheckBoxShowSign.Checked := Ini.ReadBool('Option', CheckBoxShowSign.Name, false);
  Form2.CheckBoxShowSeconds.Checked := Ini.ReadBool('Option', CheckBoxShowSeconds.Name, false);
  // Размерт шрифта

  Form2.CheckFontBold.Checked := Ini.ReadBool('Option', Form2.CheckFontBold.Name, false);
  Form2.CheckFontBoldClick(self);

  Form2.CheckBoxAutoColor.Checked := Ini.ReadBool('Option', Form2.CheckBoxAutoColor.Name, false);
  Form2.CheckBoxAutoColorClick(self);

  if Form2.CheckBoxAutoColor.Checked = false then
  begin
    Form2.ColorBoxNumber.Selected := Ini.ReadInteger('Option', Form2.ColorBoxNumber.Name, clWhite);
    Form2.ColorBoxNumberClick(Self);
  end;

  Ini.Free;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(Form1) then
  begin
    // Отправляем главную форму на задний план
    SetWindowPos(Form1.Handle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOREDRAW or SWP_NOOWNERZORDER);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Form1.Globload;
  SpinEditScale.MaxValue := TrackBarScale.Max;
  SpinEditScale.MinValue := TrackBarScale.Min;
  OnMouseWheel := FormMouseWheel;
end;

procedure TForm2.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  ComponentAtPosition: TControl;
begin
  // Получаем компонент, находящийся под курсором мыши
  ComponentAtPosition := FindDragTarget(Mouse.CursorPos, False);

  // Проверяем, является ли компонент типом TSpinEdit
  if Assigned(ComponentAtPosition) and (ComponentAtPosition is TSpinEdit) then
  begin
    with TComponent(ComponentAtPosition) as TSpinEdit do
    begin
      SetFocus();
      if WheelDelta > 0 then
        Value := Value + 1
      else
        Value := Value - 1;

      SelectAll(); // Выделение текста

      Handled := True;
    end;
  end;
end;

procedure tForm2.CreateAutoStart(Enabled: Boolean);
var
  Reg: TRegistry;
begin
  if Enabled = true then
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', TRUE);
    Reg.WriteString(Application.Title, ParamStr(0));
    Reg.CloseKey;
    Reg.Free;
  end;

  if Enabled = false then
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', TRUE);
    Reg.DeleteValue(Application.Title);
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure TForm2.MenuAutostartClick(Sender: TObject);
begin
  if MenuAutostart.Checked then
  begin
    CreateAutoStart(True);
  end
  else
  begin
    CreateAutoStart(false);
  end;
end;

procedure TForm2.MenuColorTrayIconClick(Sender: TObject);
begin
  try
    if Form2.MenuColorTrayIcon.Checked = TRUE then
    begin
      Form1.TrayIcon1.IconIndex := 2;
      application.ProcessMessages;
    end;

    if Form2.MenuColorTrayIcon.Checked = false then
    begin
      if DarkModeIsEnabled = TRUE then
      begin
        if SystemUsesLightTheme = false then
          Form1.TrayIcon1.IconIndex := 1;
        if SystemUsesLightTheme = TRUE then
          Form1.TrayIcon1.IconIndex := 0;
        application.ProcessMessages;
      end;

      if DarkModeIsEnabled = false then
      begin
        if SystemUsesLightTheme = TRUE then
          Form1.TrayIcon1.IconIndex := 0;
        if SystemUsesLightTheme = false then
          Form1.TrayIcon1.IconIndex := 1;
        application.ProcessMessages;
      end;
    end;
  except
  end;
end;

procedure TForm2.RadioButtonCenterTopClick(Sender: TObject);
begin
  RadioButtonLastPosition.Checked := false;
  RadioButtonRight.Checked := false;
  RadioButtonCenterTop.Checked := TRUE;
end;

procedure TForm2.RadioButtonCustomFontClick(Sender: TObject);
begin
  RadioButtonCustomFont.Checked := TRUE;
  Form1.FontApply;
  RestoreStringInfo;
end;

procedure TForm2.RadioButtonLastPositionClick(Sender: TObject);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(Form1.PortablePath);
  RadioButtonLastPosition.Checked := TRUE;
  RadioButtonCenterTop.Checked := false;
  RadioButtonRight.Checked := false;
  RadioButtonRightTop.Checked := false;
  Form1.Top := Ini.ReadInteger('Option', 'Top', Form1.Top);
  Form1.Left := Ini.ReadInteger('Option', 'Left', Form1.Left);
  Form1.KeepFormInWorkArea;
  Ini.Free;
end;

procedure TForm2.RadioButtonRightClick(Sender: TObject);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(Form1.PortablePath);
  RadioButtonLastPosition.Checked := false;
  RadioButtonCenterTop.Checked := false;
  RadioButtonRightTop.Checked := false;
  RadioButtonRight.Checked := true;
  Form1.Top := Ini.ReadInteger('Option', 'Top', Form1.Top);
  Ini.Free;
end;

procedure TForm2.RadioButtonRightTopClick(Sender: TObject);
begin
  RadioButtonLastPosition.Checked := false;
  RadioButtonCenterTop.Checked := false;
  RadioButtonRight.Checked := false;
  RadioButtonRightTop.Checked := true;
end;

procedure TForm2.RestoreStringInfo;
begin
  Form1.Height := 0;
  Form1.Height := Form1.Height + Form1.LabelSpace1.Height + Form1.LabelTime.Height + Form1.LabelSpace2.Height + Form1.LabelDate.Height + +Form1.LabelDay.Height;
end;

procedure TForm2.SpinEditDateFontSizeKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm2.SpinEditScaleChange(Sender: TObject);
begin
  TrackBarScale.Position := Form2.SpinEditScale.Value;
end;

procedure TForm2.SpinEditScaleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_BACK, VK_DELETE] then
    Exit
  else if not (Key in [VK_TAB, VK_RETURN, VK_ESCAPE]) then
    Key := 0;
end;

procedure TForm2.SpinEditScaleKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm2.ApplyScaleImmediately;
begin
  if Assigned(Form1) then
  begin
    // Применяем масштаб к главному окну

    Form1.ApplyScale(FCurrentScale);

  end;
end;

procedure TForm2.TrackBarScaleChange(Sender: TObject);
begin
  Form2.SpinEditScale.Value := TrackBarScale.Position;
  FCurrentScale := TrackBarScale.Position;
  ApplyScaleImmediately;
  Application.ProcessMessages;
end;

procedure TForm2.CheckFontBoldClick(Sender: TObject);
begin
  if CheckFontBold.Checked then
  begin
    Form1.LabelTime.Font.Style := Form1.LabelTime.Font.Style + [fsBold];
    Form1.LabelDate.Font.Style := Form1.LabelDate.Font.Style + [fsBold];
    Form1.LabelDay.Font.Style := Form1.LabelDay.Font.Style + [fsBold];
  end;

  if CheckFontBold.Checked = false then
  begin
    Form1.LabelTime.Font.Style := Form1.LabelTime.Font.Style - [fsBold];
    Form1.LabelDate.Font.Style := Form1.LabelDate.Font.Style - [fsBold];
    Form1.LabelDay.Font.Style := Form1.LabelDay.Font.Style - [fsBold];
  end;
end;

procedure TForm2.ColorBoxNumberClick(Sender: TObject);
begin
  if CheckBoxAutoColor.Checked = false then
  begin
    Form1.LabelTime.Font.Color := Form2.ColorBoxNumber.Selected;
    Form1.LabelDate.Font.Color := Form2.ColorBoxNumber.Selected;
    Form1.LabelDay.Font.Color := Form2.ColorBoxNumber.Selected;
  end;
end;

end.

