program FileConversion;

uses
  Forms,
  uFileConversion in 'uFileConversion.pas' {Form1},
  msData in 'msData.pas',
  dEXIF in 'dEXIF.pas',
  dIPTC in 'dIPTC.pas',
  DIMime in '..\..\Lib\DIMime.pas',
  uLomosUtil in 'uLomosUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
