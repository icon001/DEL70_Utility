program CardToHex;

uses
  Forms,
  uCardToHex in 'uCardToHex.pas' {Form1},
  uLomosUtil in '..\..\KT������Ʈ\Lib\uLomosUtil.pas',
  DIMime in '..\..\KT������Ʈ\Lib\DIMime.pas',
  DIMimeStreams in '..\..\KT������Ʈ\Lib\DIMimeStreams.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
