unit uSendTelNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, Buttons, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TfmSendTelNo = class(TForm)
    Label1: TLabel;
    cmb_UserName: TComboBox;
    btn_Send: TSpeedButton;
    btn_CanCel: TSpeedButton;
    TempQuery: TZQuery;
    procedure FormCreate(Sender: TObject);
    procedure btn_SendClick(Sender: TObject);
    procedure btn_CanCelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    MasterIDList:TStringList;
    { Private declarations }
    procedure  LoadUserName(cmb_box:TComboBox);
  public
    L_TelNumber : string;
    L_bSend : Boolean;
    { Public declarations }

  end;

var
  fmSendTelNo: TfmSendTelNo;

implementation

uses
  uDataModule,
  uLomosUtil, uMain;
{$R *.dfm}

procedure TfmSendTelNo.FormCreate(Sender: TObject);
begin
  L_bSend :=  False;
  MasterIDList := TStringList.Create;
end;

procedure TfmSendTelNo.btn_SendClick(Sender: TObject);
var
  stMasterID : string;
  stSendData : string;
begin
  if cmb_UserName.ItemIndex < 0 then
  begin
    showmessage('받는사람을 선택하세요.');
    Exit;
  end;
  if L_TelNumber = '' then
  begin
    showmessage('전화번호가 없습니다.');
    Exit;
  end;
  L_bSend := True;

  stMasterID := MasterIDList.Strings[cmb_UserName.ItemIndex];
  stSendData := 'SEND,USERID=' + stMasterID + ',TELNUM=' + L_TelNumber;

  fmMain.ModemSendDataList.add(stSendData);

  Close;
end;

procedure TfmSendTelNo.btn_CanCelClick(Sender: TObject);
begin
  L_bSend := False;
  Close;
end;

procedure TfmSendTelNo.LoadUserName(cmb_box: TComboBox);
var
  stSql : string;
begin
  MasterIDList.Clear;
  cmb_box.Clear;
  cmb_box.ItemIndex := -1;
  stSql := ' Select * from TB_MASTER ';
  stSql := stSql + ' Where MA_USERID <> ''' + Master_ID + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if RecordCount < 1 then Exit;
    While Not Eof do
    begin
      MasterIDList.Add(FindField('MA_USERID').AsString);
      cmb_box.Items.Add(FindField('MA_USERNAME').AsString);
      Next;
    end;
  end;
end;

procedure TfmSendTelNo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MasterIDList.Free;
end;

procedure TfmSendTelNo.FormShow(Sender: TObject);
begin
  LoadUserName(cmb_UserName);
end;

end.
