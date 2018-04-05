unit uLottoMemberCreate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset;

type
  TfmLottoMemberCreate = class(TForm)
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    ed_id: TEdit;
    st_State: TStaticText;
    ed_username: TEdit;
    ed_pw: TEdit;
    btn_Save: TSpeedButton;
    btn_Close: TSpeedButton;
    TempQuery: TZQuery;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ed_idKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_SaveClick(Sender: TObject);
  private
    { Private declarations }
    function DupCheckID(aId:string):Boolean;
  public
    { Public declarations }
  end;

var
  fmLottoMemberCreate: TfmLottoMemberCreate;

implementation

uses
  uDataModule;
{$R *.dfm}

procedure TfmLottoMemberCreate.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoMemberCreate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmLottoMemberCreate.ed_idKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DupCheckID(ed_id.Text);
end;

function TfmLottoMemberCreate.DupCheckID(aId: string): Boolean;
var
  stSql : string;
begin
  st_State.Caption := '';
  btn_Save.Enabled := False;
  if Trim(aId) = '' then
  begin
    Exit;
  end;
  result := False;
  stSql := ' select * from TB_MASTER where ma_userid = ''' + aID + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordcount < 1 then
    begin
      st_State.Font.Color := clBlue;
      st_State.Caption := '사용가능';
      btn_Save.Enabled := True;
    end else
    begin
      st_State.Font.Color := clRed;
      st_State.Caption := '사용불가';
      btn_Save.Enabled := False;
    end;
  end;


end;

procedure TfmLottoMemberCreate.btn_SaveClick(Sender: TObject);
var
  stSql : string;
begin
  stSql := 'Insert Into TB_MASTER(ma_userid,ma_username,ma_userpw) ';
  stSql := stSql + ' values( ';
  stSql := stSql + '''' + ed_id.Text + ''',';
  stSql := stSql + '''' + ed_username.Text + ''',';
  stSql := stSql + '''' + ed_pw.Text + ''') ';

  if dmDB.ProcessExecSQL(stSql) then
  begin
    Close;
  end else
  begin
    showmessage('회원가입에 실패하였습니다.');
  end;
end;

initialization
  RegisterClass(TfmLottoMemberCreate);
Finalization
  UnRegisterClass(TfmLottoMemberCreate);

end.
