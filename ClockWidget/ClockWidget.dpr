program ClockWidget;



{$R *.dres}

uses
  Vcl.Forms,
  Windows,
  Unit_Base in 'Unit_Base\Unit_Base.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  WindowsDarkMode in 'Units\WindowsDarkMode\WindowsDarkMode.pas',
  Unit_About in 'Unit_About\Unit_About.pas' {Form8},
  Unit_Settings in 'Unit_Settings\Unit_Settings.pas' {Form2},
  Translation in 'Units\Translation\Translation.pas',
  Unit_Update in 'Unit_Update\Unit_Update.pas' {Form10},
  FileInfoUtils in 'Units\FileInfoUtils\FileInfoUtils.pas';

{$R *.res}

var
  HM: THandle;

function Check: Boolean;
begin
  HM := OpenMutex(MUTEX_ALL_ACCESS, False, 'Clock Widget');
  Result := (HM <> 0);
  if HM = 0 then
    HM := CreateMutex(nil, False, 'Clock Widget');
end;

begin
  if Check then
    Exit;

  SetThreadLocale(1049);
  Application.Initialize;
  Application.MainFormOnTaskBar := False;
  Application.Title := 'Clock Widget';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm10, Form10);
  Form1.LoadLanguage;
  Form1.CleanTranslationsLikeGlobload;
  Form1.Globload;
  Form2.LoadNastr;

  if not Form1.IsWindows10Or11 then
  begin
    MessageBox(0, PChar(Form1.LangOnlyWindows.Caption), PChar(Form1.LangError.Caption), MB_ICONERROR);
    Exit;
  end;

  Form1.Timer1.Enabled := True;
  Application.Run;
end.

