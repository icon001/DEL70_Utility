unit uMasterID;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  uSubForm, CommandArray,ADODB,ActiveX,ZConnection,ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TfmMasterID = class(TfmASubForm)
    Panel12: TPanel;
    Panel1: TPanel;
    Label8: TLabel;
    Label1: TLabel;
    btn_Delete: TSpeedButton;
    btn_Save: TSpeedButton;
    btn_Update: TSpeedButton;
    btn_Insert: TSpeedButton;
    btn_Close: TSpeedButton;
    btn_Cancel: TSpeedButton;
    ed_Code: TEdit;
    ed_Name: TEdit;
    StatusBar1: TStatusBar;
    sg_Code: TAdvStringGrid;
    Label2: TLabel;
    ed_pw: TEdit;
    cmb_Company: TComboBox;
    Label7: TLabel;
    Label3: TLabel;
    cmb_Grade: TComboBox;
    Label4: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure sg_CodeClick(Sender: TObject);
    procedure btn_InsertClick(Sender: TObject);
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    State : string;
    CompanyCodeList : TStringList;
    { Private declarations }
    procedure FormClear;
    procedure FormEnable(aState:string);
    procedure ButtonEnable(aState:string);
  private
    procedure LoadCompanyCode;
    procedure ShowMasterID(aCode:string);
    Function InsertTB_MASTER(aCode,aName,apw,agrade,aCompanyCode:string):Boolean;
    Function UpdateTB_MASTER(aCode,aName,apw,agrade,aCompanyCode:string):Boolean;
    Function DELETETB_MASTER(aCode:string):Boolean;
  public
    { Public declarations }
  end;

var
  fmMasterID: TfmMasterID;

implementation
uses
  uDataModule,
  uLomosUtil;

{$R *.dfm}

procedure TfmMasterID.ButtonEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    btn_Insert.Enabled := False;
    btn_update.Enabled := false;
    btn_Save.Enabled := True;
    btn_delete.Enabled := False;
    btn_Cancel.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    btn_Insert.Enabled := True;
    btn_Update.Enabled := False;
    btn_Save.Enabled := False;
    btn_Delete.Enabled := False;
    btn_Cancel.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    btn_Insert.Enabled := False;
    btn_Update.Enabled := False;
    btn_Save.Enabled := True;
    btn_Delete.Enabled := False;
    btn_Cancel.Enabled := True;
  end else if upperCase(aState) = 'CLICK' then
  begin
    btn_Insert.Enabled := True;
    btn_Update.Enabled := True;
    btn_Save.Enabled := False;
    btn_Delete.Enabled := True;
    btn_Cancel.Enabled := False;
  end;
end;

procedure TfmMasterID.FormActivate(Sender: TObject);
begin
 ShowMasterID('');
end;

procedure TfmMasterID.FormClear;
begin
  ed_Code.Text := '';
  ed_Name.Text := '';
  ed_pw.Text := '';
  cmb_Grade.ItemIndex := 0;
  cmb_Company.ItemIndex := 0;
end;

procedure TfmMasterID.FormEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := true;
    ed_Name.Enabled  := true;
    ed_pw.Enabled := True;
    cmb_Grade.Enabled := True;
    cmb_Company.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
    ed_pw.Enabled := False;
    cmb_Grade.Enabled := False;
    cmb_Company.Enabled := False;
  end else if upperCase(aState) = 'CLICK' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
    ed_pw.Enabled := False;
    cmb_Grade.Enabled := False;
    cmb_Company.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := true;
    ed_pw.Enabled := true;
    cmb_Grade.Enabled := true;
    cmb_Company.Enabled := true;
  end;
end;

procedure TfmMasterID.ShowMasterID(aCode: string);
var
  stSql : string;
  nRow : integer;
  i : integer;
  TempAdoQuery : TZQuery;
begin
  GridInit(sg_Code,3); //스트링그리드 초기화

  State := 'SEARCH';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);

  stSql := 'select * from TB_MASTER ';
  stSql := stSql + ' Order by MA_USERID ';

  CoInitialize(nil);
  TempAdoQuery := TZQuery.Create(nil);
  TempAdoQuery.Connection := dmDB.ZConnection1;

  with TempAdoQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;

    Try
      Open;
    Except
      TempAdoQuery.Free;
      CoUninitialize;
      Exit;
    End;
    if RecordCount < 1 then
    begin
      TempAdoQuery.Free;
      CoUninitialize;
      Exit;
    end;

    with sg_Code do
    begin
      RowCount := RecordCount + 1;
      nRow := 1;
      while Not Eof do
      begin
        cells[0,nRow] := FindField('MA_USERID').AsString;
        cells[1,nRow] := FindField('MA_USERNAME').AsString;
        cells[2,nRow] := FindField('MA_USERPW').AsString;
        cells[3,nRow] := FindField('MA_USERGUBUN').AsString;
        cells[4,nRow] := FindField('CO_COMPANYCODE').AsString;
        if FindField('MA_USERID').AsString  = aCode then
        begin
          SelectRows(nRow,1);
        end;

        nRow := nRow + 1;
        Next;
      end;
    end;
  end;
  TempAdoQuery.Free;
  CoUninitialize;
  sg_CodeClick(sg_Code);
end;

procedure TfmMasterID.btn_CloseClick(Sender: TObject);
begin
  Close;

end;

procedure TfmMasterID.btn_CancelClick(Sender: TObject);
begin
  ShowMasterID(ed_Code.Text);

end;

procedure TfmMasterID.sg_CodeClick(Sender: TObject);
begin
  State := 'CLICK';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);
  with (Sender as TStringGrid) do
  begin
    if cells[0,Row] = '' then exit;
    ed_Code.Text := cells[0,Row];
    ed_Name.Text := cells[1,Row];
    ed_pw.Text := cells[2,Row];
    if isDigit(cells[3,Row]) then
      cmb_Grade.ItemIndex := strtoint(cells[3,Row]);
    cmb_Company.ItemIndex := CompanyCodeList.indexof(cells[4,Row]);
  end;
end;

procedure TfmMasterID.btn_InsertClick(Sender: TObject);
begin
  State := 'INSERT';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);
  with sg_Code do
  begin
    if Cells[0,1] <> '' then
    begin
      AddRow;
      SelectRows(RowCount - 1,1);
      Enabled := True;
      if RowCount > 5 then TopRow := RowCount - 5;
      Enabled := False;
    end;
  end;

  ed_Code.SetFocus;
end;

procedure TfmMasterID.btn_UpdateClick(Sender: TObject);
begin
  State := 'UPDATE';

  FormEnable(State);
  ButtonEnable(State);
  ed_Name.SetFocus;
end;

procedure TfmMasterID.btn_DeleteClick(Sender: TObject);
var
  bResult : boolean;
begin
  if (Application.MessageBox(PChar('데이터를 삭제하시겠습니까?'),'삭제',MB_OKCANCEL) = ID_CANCEL)  then Exit;

  bResult := DeleteTB_MASTER(ed_Code.Text);

  if bResult then ShowMasterID('')
  else showmessage('삭제실패.');
end;

function TfmMasterID.DeleteTB_MASTER(aCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_MASTER ';
  stSql := stSql + ' where MA_USERID = ''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

procedure TfmMasterID.btn_SaveClick(Sender: TObject);
var
  bResult : boolean;
begin
  if UpperCase(State) = 'INSERT' then
    bResult := InsertTB_MASTER(ed_Code.Text,ed_Name.Text,ed_pw.Text,copy(cmb_grade.Text,1,1),CompanyCodeList.Strings[cmb_Company.ItemIndex])
  else if UpperCase(State) = 'UPDATE' then
    bResult := UpdateTB_MASTER(ed_Code.Text,ed_Name.Text,ed_pw.Text,copy(cmb_grade.Text,1,1),CompanyCodeList.Strings[cmb_Company.ItemIndex]);

  if bResult then ShowMasterID(ed_Code.Text)
  else showmessage('저장실패');
end;

function TfmMasterID.InsertTB_MASTER(aCode,aName,apw,agrade,aCompanyCode: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Insert Into TB_MASTER( ';
  stSql := stSql + ' MA_USERID,';
  stSql := stSql + ' MA_USERNAME,';
  stSql := stSql + ' MA_USERPW,';
  stSql := stSql + ' MA_USERGUBUN,';
  stSql := stSql + ' CO_COMPANYCODE )' ;
  stSql := stSql + ' values( ';
  stSql := stSql + '''' + aCode + ''',';
  stSql := stSql + '''' + aName + ''',';
  stSql := stSql + '''' + apw + ''',';
  stSql := stSql + '''' + agrade + ''',';
  stSql := stSql + '''' + aCompanyCode + '''';
  stSql := stSql + ')';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmMasterID.UpdateTB_MASTER(aCode,aName,apw,agrade,aCompanyCode: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Update TB_MASTER set ';
  stSql := stSql + ' MA_USERNAME = ''' + aName + ''', ';
  stSql := stSql + ' MA_USERPW = ''' + apw + ''', ';
  stSql := stSql + ' MA_USERGUBUN = ''' + agrade + ''', ';
  stSql := stSql + ' CO_COMPANYCODE = ''' + aCompanyCode + ''' ';
  stSql := stSql + ' where MA_USERID =''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;


procedure TfmMasterID.FormCreate(Sender: TObject);
begin
  inherited;
  CompanyCodeList := TStringList.Create;

end;

procedure TfmMasterID.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CompanyCodeList.Free;
end;

procedure TfmMasterID.LoadCompanyCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  CompanyCodeList.Clear;
  cmb_Company.Clear;

  stSql := 'select * from TB_COMPANY ';
  stSql := stsql + ' where CG_CODE < ''004'' ';
  stSql := stSql + ' order by CO_COMPANYCODE ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TZQuery.Create(nil);
    TempAdoQuery.Connection := dmDB.ZConnection1;

    with TempAdoQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Text := stSql;

      Try
        Open;
      Except
        Exit;
      End;
      if RecordCount < 1 then
      begin
        btn_Insert.Enabled := False;
        exit;
      end;
      btn_Insert.Enabled := True;

      while Not Eof do
      begin
        cmb_Company.Items.Add(FindField('CO_NAME').AsString);
        CompanyCodeList.Add(FindField('CO_COMPANYCODE').AsString);
        Next;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
  cmb_Company.ItemIndex := 0;
end;

procedure TfmMasterID.FormShow(Sender: TObject);
begin
  inherited;
  LoadCompanyCode;
end;

end.
