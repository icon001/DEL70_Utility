unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls,DB, ADODB,ActiveX,
  ZConnection, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type

  TLogin = class(TComponent)
  private
    FLogined: Boolean;
    FSYSADMIN: Boolean;
    procedure SetLogined(const Value: Boolean);
    class function FindSelf:TComponent;
    { Private declarations }
  public
    { Public declarations }
    EmpSn : Integer;    //사원번호
    ProgIDs,UserID,UserName,CompanyCode,DepartCode,Grade : String;
    MasterType : string;
    Procedure ShowLoginDlg;
    function  LoginUser(aUserID,aPw:string):Boolean;
    procedure SetSysAdmin(const Value: Boolean);
    class Function GetObject:TLogin;   //자기자신을 찾는것  class 는 폼생성전에도 사용가능
    Property SYSADMIN : Boolean read FSYSADMIN write SetSYSADMIN;
  Published
    { Published declarations }
    Property Logined : Boolean read FLogined write SetLogined;


  end;

  TfmLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    edPassword: TEdit;
    edUserID: TEdit;
    sbLogin: TSpeedButton;
    sbCancel: TSpeedButton;
    procedure sbLoginClick(Sender: TObject);
    procedure sbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edUserIDKeyPress(Sender: TObject; var Key: Char);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLogin: TfmLogin;

implementation

uses
  uLomosUtil,
  uDataModule,
  IniFiles;

{$R *.dfm}


procedure TfmLogin.sbLoginClick(Sender: TObject);
var
  stUserName: String;
  stSql: String;
  TempAdoQuery : TZQuery;
  ini_fun : TiniFile;
  stUserPw : string;
  stMasterType : string;
begin


  TLogin.GetObject.ProgIDs:=''; //사용가능한 프로그램 목록 초기화

  Try
    CoInitialize(nil);
    TempAdoQuery := TZQuery.Create(nil);
    TempAdoQuery.Connection := dmDB.ZConnection1;
    with  TempAdoQuery  do
    begin
      stSql := 'Select * from TB_MASTER ';
      stSql := stSql + ' Where ma_userid = ''' + Trim(edUserID.text) + ''' ';
      stSql := stSql + ' AND ma_userpw = ''' + Trim(edPassword.text) + ''' ';
      Close;
      SQL.Clear;
      SQL.Text := stSql;

      Try
        Open;
      Except
         TLogin.GetObject.Logined  := False ;
      End;

      if RecordCount < 1 then
      begin
          Application.messagebox(PChar('사용자 정보가 틀립니다.'),PChar(Application.MainForm.Caption),mb_OK);
          TLogin.GetObject.Logined  := False ;
          Exit;
      end;

      stUserName:=   FindField('MA_USERNAME').asString;
      stUserPw :=   FindField('MA_USERPW').asString;
      stMasterType :=   FindField('MA_TYPE').asString;
    end;
  Finally
     TempAdoQuery.Free;
     CoUninitialize;
  End;

  //로그인 성공시
  TLogin.GetObject.UserID := edUserID.text;
  TLogin.GetObject.UserName := stUserName;
  TLogin.GetObject.MasterType := stMasterType;
  TLogin.GetObject.Logined  := True ;

  Close;
end;

{ TLogin }

class function TLogin.FindSelf: TComponent;
var
  Loop:Integer;
begin
  Result:=Nil;
  for Loop:=0 to Application.ComponentCount-1 do begin
      if Application.Components[Loop] is TLogin then begin
          Result:= Application.Components[Loop];
          Break;
      end;
  end;
end;

class function TLogin.GetObject: TLogin;
begin
   If FindSelf = Nil then TLogin.Create(Application);
   Result := TLogin(FindSelf);

end;

function TLogin.LoginUser(aUserID, aPw: string): Boolean;
var
  stUserName: String;
  stSql: String;
  TempAdoQuery : TZQuery;
  stUserCompanyCode : string;
begin

  result := False;
  ProgIDs:=''; //사용가능한 프로그램 목록 초기화

  Try
    CoInitialize(nil);
    TempAdoQuery := TZQuery.Create(nil);
    TempAdoQuery.Connection := dmDB.ZConnection1;
    with  TempAdoQuery  do
    begin
      stSql := 'Select * from TB_MASTER ';
      stSql := stSql + ' Where ma_userid = ''' + aUserID + ''' ';
      stSql := stSql + ' AND ma_userpw = ''' + aPw + ''' ';
      Close;
      SQL.Clear;
      SQL.Text := stSql;

      Try
        Open;
      Except
        Logined  := False ;
        Exit;
      End;

      if RecordCount < 1 then
      begin
        Exit;
      end;

      stUserName:=   FindField('MA_USERNAME').asString;
    end;
  Finally
     TempAdoQuery.Free;
     CoUninitialize;
  End;

  //로그인 성공시
  UserID := aUserID;
  UserName := stUserName;
  Logined  := True ;
  result := True;
end;

procedure TLogin.SetLogined(const Value: Boolean);
begin
  FLogined := Value;
end;

procedure TLogin.SetSYSADMIN(const Value: Boolean);
begin
  FSYSADMIN := Value;
end;

procedure TLogin.ShowLoginDlg;
begin
  FLogined := False;

  fmLogin:=TfmLogin.Create(Nil);
  Try
    fmLogin.ShowModal;
  Finally
    fmLogin.Free;
  End;
end;

procedure TfmLogin.sbCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLogin.FormCreate(Sender: TObject);
begin
  edUserID.Text:= '';
  edPassword.Text := '';
end;

procedure TfmLogin.edUserIDKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    edPassword.SetFocus;
  end;
end;

procedure TfmLogin.edPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    sbLogin.click;
  end;
end;

end.
