program CardToHex;

uses
  Forms,
  uCardToHex in 'uCardToHex.pas' {Form1},
  uLomosUtil in '..\..\KT프로젝트\Lib\uLomosUtil.pas',
  DIMime in '..\..\KT프로젝트\Lib\DIMime.pas',
  DIMimeStreams in '..\..\KT프로젝트\Lib\DIMimeStreams.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
