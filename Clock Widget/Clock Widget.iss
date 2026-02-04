#define MyAppName "Clock Widget"
#define MyAppNameSafe StringChange(MyAppName, " ", "-")
#define MyAppVersion "2.9.26.128"
#define MyAppPublisher "Nikolay Markov"
#define MyAppURL "https://sites.google.com/view/simpleutilities/index"
#define MyAppExeName "ClockWidget.exe"
#define MyAppSource "D:\Delphi Programs\" + MyAppName + "\Application\" + MyAppName

[Setup]
AppId={{8FC3245B-9767-41FE-B5B7-3E7B6A1AA12E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

VersionInfoVersion={#MyAppVersion}
VersionInfoDescription={#MyAppName}
VersionInfoTextVersion={#MyAppVersion}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoCopyright={#MyAppPublisher}

DisableWelcomePage=no
DisableReadyPage=yes
DisableDirPage=auto
DisableProgramGroupPage=auto
DefaultDirName={commonpf32}\{#MyAppPublisher}\{#MyAppName}
DefaultGroupName={#MyAppName}

OutputDir=D:\Software\My Projects
OutputBaseFilename={#MyAppNameSafe}-setup
SetupIconFile={image}\{#MyAppName}.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName} {#MyAppVersion}

Compression=lzma/Max
SolidCompression=yes  

ChangesAssociations=True
ShowTasksTreeLines=true
DirExistsWarning=no
CloseApplications=no
RestartApplications=False
WizardStyle=modern windows11 dynamic includetitlebar excludelightbuttons   
MinVersion=10.0 

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl";LicenseFile: "{#MyAppSource}\License-RU.txt";
Name: "english"; MessagesFile: "compiler:Default.isl";LicenseFile: "{#MyAppSource}\License-EN.txt";
Name: "french"; MessagesFile: "compiler:Languages\French.isl";LicenseFile: "{#MyAppSource}\License-EN.txt";  
Name: "german"; MessagesFile: "compiler:Languages\German.isl";LicenseFile: "{#MyAppSource}\License-EN.txt";   

[Messages]
BeveledLabel= {#MyAppName} {#MyAppVersion}
SetupWindowTitle={#MyAppName} {#MyAppVersion}
FinishedHeadingLabel={#MyAppName} {#MyAppVersion}
WelcomeLabel1 ={#MyAppName} {#MyAppVersion}

russian.InstallingLabel=Пожалуйста, подождите, идет установка {#MyAppName} {#MyAppVersion}
russian.FinishedHeadingLabel=Установка завершена
russian.FinishedLabelNoIcons=Установка {#MyAppName} {#MyAppVersion} завершена

english.InstallingLabel=Please wait, installation {#MyAppName} {#MyAppVersion} is in progress
english.FinishedHeadingLabel=Installation is complete
english.FinishedLabelNoIcons=Installation of {#MyAppName} {#MyAppVersion} is complete

french.InstallingLabel=Veuillez patienter, l'installation de {#MyAppName} {#MyAppVersion} est en cours
french.FinishedHeadingLabel=Installation terminée
french.FinishedLabelNoIcons=L'installation de {#MyAppName} {#MyAppVersion} est terminée

german.InstallingLabel=Bitte warten, die Installation von {#MyAppName} {#MyAppVersion} läuft.
german.FinishedHeadingLabel=Installation abgeschlossen.
german.FinishedLabelNoIcons=Installation von {#MyAppName} {#MyAppVersion} abgeschlossen.

[CustomMessages]
russian.UninstallProgram=Удалить {#MyAppName}
russian.ProgramOnTheWeb=Сайт {#MyAppName}
russian.AddAutostart=Добавить {#MyAppName} в автозагрузку
russian.Start=Автозагрузка

english.UninstallProgram=Uninstall {#MyAppName}
english.ProgramOnTheWeb=Website {#MyAppName}
english.AddAutostart=Add {#MyAppName} to startup
english.Start=Autostart

french.UninstallProgram=Désinstaller {#MyAppName}
french.ProgramOnTheWeb=Site Web {#MyAppName}
french.AddAutostart=Ajouter {#MyAppName} au démarrage
french.Start=Démarrage automatique

german.UninstallProgram={#MyAppName} deinstallieren
german.ProgramOnTheWeb=Website {#MyAppName}
german.AddAutostart={#MyAppName} zum Start hinzufügen
german.Start=Autostart

[Files]
Source: "{#MyAppSource}\{#MyAppExeName}"; DestDir: "{app}\"; Flags: ignoreversion; BeforeInstall: TaskKill('{#MyAppExeName}')
Source: "{#MyAppSource}\Config\Option.ini"; DestDir: "{userappdata}\{#MyAppPublisher}\{#MyAppName}\Config\"; Flags: ignoreversion onlyifdoesntexist;
Source: "{#MyAppSource}\Language\English.ini"; DestDir: "{app}\Language"; Flags: ignoreversion;
Source: "{#MyAppSource}\Language\French.ini"; DestDir: "{app}\Language"; Flags: ignoreversion;
Source: "{#MyAppSource}\Language\German.ini"; DestDir: "{app}\Language"; Flags: ignoreversion; 
Source: "{#MyAppSource}\Language\Russian.ini"; DestDir: "{app}\Language"; Flags: ignoreversion;
Source: "{#MyAppSource}\libeay32.dll"; DestDir: "{app}\"; Flags: ignoreversion;
Source: "{#MyAppSource}\License-EN.txt"; DestDir: "{app}\"; Flags: ignoreversion;
Source: "{#MyAppSource}\License-RU.txt"; DestDir: "{app}\"; Flags: ignoreversion;
Source: "{#MyAppSource}\ssleay32.dll"; DestDir: "{app}\"; Flags: ignoreversion;

[Registry]
; Для 64-битных систем
Root: HKCU64; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; \
    ValueType: string; ValueName: "{#MyAppName}"; ValueData: "{app}\{#MyAppExeName}"; \
    Check: IsWin64; Flags: uninsdeletevalue ; Tasks: Autostart

; Для 32-битных систем
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; \
    ValueType: string; ValueName: "{#MyAppName}"; ValueData: "{app}\{#MyAppExeName}"; \
    Check: not IsWin64; Flags: uninsdeletevalue ;Tasks: Autostart

[INI]
FileName: "{userappdata}\{#MyAppPublisher}\{#MyAppName}\Config\Option.ini"; Section: "Language"; Key: "Language"; String: "English";Languages:english;  
FileName: "{userappdata}\{#MyAppPublisher}\{#MyAppName}\Config\Option.ini"; Section: "Language"; Key: "Language"; String: "russian";Languages:russian;
FileName: "{userappdata}\{#MyAppPublisher}\{#MyAppName}\Config\Option.ini"; Section: "Language"; Key: "Language"; String: "German";Languages:German; 
FileName: "{userappdata}\{#MyAppPublisher}\{#MyAppName}\Config\Option.ini"; Section: "Language"; Key: "Language"; String: "French";Languages:French; 

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; Flags: unchecked
Name: "Autostart"; Description: "{cm:AddAutostart}"; GroupDescription: "{cm:Start}"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall shellexec; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[InstallDelete] 
Type: filesandordirs; Name: "{group}\*"
Type: filesandordirs; Name: "{app}\Language\*"
Type: filesandordirs; Name: "{userprograms}\{#MyAppName}\*"
Type: dirifempty; Name: "{userprograms}\{#MyAppName}"
Type: filesandordirs; Name: "{commonprograms}\{#MyAppName}\*"
Type: dirifempty; Name: "{commonprograms}\{#MyAppName}"  
Type: files; Name: "{commondesktop}\{#MyAppName}.lnk"
Type: files; Name: "{userdesktop}\{#MyAppName}.lnk"
Type: files; Name: "{userdesktop}\{#MyAppName}.lnk"

[UninstallDelete] 
Type: filesandordirs; Name: "{app}\*"
Type: filesandordirs; Name: "{group}\*"
Type: filesandordirs; Name: "{userappdata}\{#MyAppPublisher}\{#MyAppName}\*"
Type: dirifempty; Name: "{userappdata}\{#MyAppPublisher}\"
Type: filesandordirs; Name: "{userprograms}\{#MyAppName}\*"
Type: dirifempty; Name: "{userprograms}\{#MyAppName}"
Type: filesandordirs; Name: "{commonprograms}\{#MyAppName}\*"
Type: dirifempty; Name: "{commonprograms}\{#MyAppName}" 

//Pascal
[Code]
// Создаем запись реестра только если НЕ в тихом режиме
function ShouldCreateRegistryEntry(): Boolean;
begin       
  Result := not WizardSilent();
end;

procedure TaskKill(FileName: String);
var
  ResultCode: Integer;
begin
  Exec('taskkill.exe', '/f /im ' + '"' + FileName + '"', '', SW_HIDE,
   ewWaitUntilTerminated, ResultCode);
end;

function InitializeUninstall(): Boolean;
begin
  TaskKill('{#MyAppExeName}');
  Result := True;
end;

// Код для прогресс-бара (обязательный)
const
  GWL_WNDPROC = -4;
  SB_VERT = 1;
  SB_BOTTOM = 7;
  WM_VSCROLL = $0115; 
  WM_ERASEBKGND = $0014;

type
  WPARAM = UINT_PTR;
  LPARAM = LongInt;
  LRESULT = LongInt;

var
  OldStatusLabelWndProc: LongInt;
  OldFilenameLabelWndProc: LongInt;
  OldProgressListBoxWndProc: LongInt;
  ProgressListBox: TNewListBox;
  PrevStatus: string;
  PrevFileName: string;

function CallWindowProc(
  lpPrevWndFunc: LongInt; hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; external 'CallWindowProcW@user32.dll stdcall';  
function SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: LongInt): LongInt;
  external 'SetWindowLongW@user32.dll stdcall';

procedure AddProgress(S: string);
begin
  if S <> '' then
  begin
    ProgressListBox.Items.Add(S);
    ProgressListBox.ItemIndex := ProgressListBox.Items.Count;
    SendMessage(ProgressListBox.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  end;
end;

function StatusLabelWndProc(
  hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := CallWindowProc(OldStatusLabelWndProc, hwnd, uMsg, wParam, lParam);
  if PrevStatus <> WizardForm.StatusLabel.Caption then
  begin
    AddProgress(WizardForm.StatusLabel.Caption);
    PrevStatus := WizardForm.StatusLabel.Caption;
  end;
end;

function FilenameLabelWndProc(
  hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := CallWindowProc(OldFilenameLabelWndProc, hwnd, uMsg, wParam, lParam);
  if PrevFileName <> WizardForm.FilenameLabel.Caption then
  begin
    AddProgress(WizardForm.FilenameLabel.Caption);
    PrevFileName := WizardForm.FilenameLabel.Caption;
  end;
end;

function ProgressListBoxWndProc(
  hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  // reduce flicker
  if uMsg = WM_ERASEBKGND then
  begin
    Result := 1;
  end
    else
  begin
    Result := CallWindowProc(OldProgressListBoxWndProc, hwnd, uMsg, wParam, lParam);
  end;
end;

procedure InitializeWizard;
begin
  // Автоматически принимаем лицензию (для обычной установки)
  WizardForm.LicenseAcceptedRadio.Checked := True;
  WizardForm.LicenseAcceptedRadio.Visible := False;
  WizardForm.LicenseNotAcceptedRadio.Visible := False;
  WizardForm.LicenseMemo.Height :=
    WizardForm.LicenseNotAcceptedRadio.Top +
    WizardForm.LicenseNotAcceptedRadio.Height -
    WizardForm.LicenseMemo.Top - ScaleY(5);

  // Код прогресс-бара
  OldStatusLabelWndProc :=
    SetWindowLong(WizardForm.StatusLabel.Handle, GWL_WNDPROC,
      CreateCallback(@StatusLabelWndProc));
  OldFilenameLabelWndProc :=
    SetWindowLong(WizardForm.FilenameLabel.Handle, GWL_WNDPROC,
      CreateCallback(@FilenameLabelWndProc));
  WizardForm.ProgressGauge.Top := WizardForm.FilenameLabel.Top;
  ProgressListBox := TNewListBox.Create(WizardForm);
  ProgressListBox.Parent := WizardForm.ProgressGauge.Parent;
  ProgressListBox.Top :=
    WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + ScaleY(8);
  ProgressListBox.Width := WizardForm.FilenameLabel.Width;
  ProgressListBox.Height :=
    ProgressListBox.Parent.ClientHeight - ProgressListBox.Top - ScaleY(16);
  ProgressListBox.Anchors := [akLeft, akTop, akRight, akBottom];
  OldProgressListBoxWndProc :=
    SetWindowLong(ProgressListBox.Handle, GWL_WNDPROC,
      CreateCallback(@ProgressListBoxWndProc));
  WizardForm.StatusLabel.Width := WizardForm.StatusLabel.Width - ScaleY(24);
  WizardForm.FilenameLabel.Width := WizardForm.FilenameLabel.Width - ScaleY(24);
end;

procedure DeinitializeSetup();
begin
  SetWindowLong(WizardForm.StatusLabel.Handle, GWL_WNDPROC, OldStatusLabelWndProc);
  SetWindowLong(WizardForm.FilenameLabel.Handle, GWL_WNDPROC, OldFilenameLabelWndProc);
  SetWindowLong(ProgressListBox.Handle, GWL_WNDPROC, OldProgressListBoxWndProc);
end;