unit uCompanyCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  uSubForm, CommandArray,ADODB,ActiveX,ZConnection,ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TfmCompanyCode = class(TfmASubForm)
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
    cmb_CompanyGubun: TComboBox;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    cmb_sCompanyGubun: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure sg_CodeClick(Sender: TObject);
    procedure btn_InsertClick(Sender: TObject);
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmb_sCompanyGubunChange(Sender: TObject);
  private
    State : string;
    CompanyGubunCodeList : TStringList;
    { Private declarations }
    procedure FormClear;
    procedure FormEnable(aState:string);
    procedure ButtonEnable(aState:string);
  private
    procedure ShowProgrmaCode(aCode:string);
    Function InsertTB_COMPANY(aCode,aName,aCompanyGubun:string):Boolean;
    Function UpdateTB_COMPANY(aCode,aName,aCompanyGubun:string):Boolean;
    Function DELETETB_COMPANY(aCode:string):Boolean;
    Function DeleteTB_DEPARTCompany(aCode:string):Boolean;
    Function DeleteTB_JIJUMCompany(aCode:string):Boolean;
    function GetMaxProgramCode:string;
    procedure LoadCompanyGubunCode;
  public
    { Public declarations }
  end;

var
  fmCompanyCode: TfmCompanyCode;

implementation
uses
  uDataModule,
  uLomosUtil;

{$R *.dfm}

procedure TfmCompanyCode.ButtonEnable(aState: string);
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

procedure TfmCompanyCode.FormActivate(Sender: TObject);
begin
 ShowProgrmaCode('');
end;

procedure TfmCompanyCode.FormClear;
begin
  ed_Code.Text := '';
  ed_Name.Text := '';
end;

procedure TfmCompanyCode.FormEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := true;
    ed_Name.Enabled  := true;
    cmb_CompanyGubun.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
    cmb_CompanyGubun.Enabled := False;
  end else if upperCase(aState) = 'CLICK' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
    cmb_CompanyGubun.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := true;
    cmb_CompanyGubun.Enabled := True;
  end;
end;

procedure TfmCompanyCode.ShowProgrmaCode(aCode: string);
var
  stSql : string;
  nRow : integer;
  i : integer;
  TempAdoQuery : TZQuery;
begin
  GridInitialize(sg_Code); //스트링그리드 초기화

  State := 'SEARCH';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);

  stSql := 'select * from TB_COMPANY ';
  if cmb_sCompanyGubun.ItemIndex > 0 then
  begin
    stSql := stSql + ' Where CG_CODE = ''' + CompanyGubunCodeList.Strings[cmb_sCompanyGubun.ItemIndex - 1] + ''' ';
  end;
  stSql := stSql + ' order by CO_COMPANYCODE ';

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
        cells[0,nRow] := FindField('CO_COMPANYCODE').AsString;
        cells[1,nRow] := FindField('CO_NAME').AsString;
        cells[2,nRow] := FindField('CG_CODE').AsString;
        if FindField('CO_COMPANYCODE').AsString  = aCode then
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

procedure TfmCompanyCode.btn_CloseClick(Sender: TObject);
begin
  Close;

end;

procedure TfmCompanyCode.btn_CancelClick(Sender: TObject);
begin
  ShowProgrmaCode(ed_Code.Text);

end;

procedure TfmCompanyCode.sg_CodeClick(Sender: TObject);
var
  nIndex : integer;
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
    nIndex := CompanyGubunCodeList.IndexOf(cells[2,Row]);
    cmb_CompanyGubun.ItemIndex := nIndex;
  end;
end;

procedure TfmCompanyCode.btn_InsertClick(Sender: TObject);
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
  ed_Code.Text := GetMaxProgramCode;

  ed_Code.SetFocus;
end;

procedure TfmCompanyCode.btn_UpdateClick(Sender: TObject);
begin
  State := 'UPDATE';

  FormEnable(State);
  ButtonEnable(State);
  ed_Name.SetFocus;
end;

procedure TfmCompanyCode.btn_DeleteClick(Sender: TObject);
var
  bResult : boolean;
begin
  if (Application.MessageBox(PChar('데이터를 삭제하시겠습니까?'),'삭제',MB_OKCANCEL) = ID_CANCEL)  then Exit;

  bResult := DeleteTB_DEPARTCompany(ed_Code.Text);
  bResult := DeleteTB_JIJUMCompany(ed_Code.Text);
  bResult := DeleteTB_COMPANY(ed_Code.Text);

  if bResult then ShowProgrmaCode('')
  else showmessage('삭제실패.');
end;

function TfmCompanyCode.DeleteTB_COMPANY(aCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_COMPANY ';
  stSql := stSql + ' where CO_COMPANYCODE = ''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

procedure TfmCompanyCode.btn_SaveClick(Sender: TObject);
var
  bResult : boolean;
  stCompanyGubun : string;
begin
  stCompanyGubun := '000';
  if cmb_CompanyGubun.ItemIndex > -1 then stCompanyGubun := CompanyGubunCodeList.Strings[cmb_CompanyGubun.ItemIndex];
  if UpperCase(State) = 'INSERT' then
    bResult := InsertTB_COMPANY(ed_Code.Text,ed_Name.Text,stCompanyGubun)
  else if UpperCase(State) = 'UPDATE' then
    bResult := UpdateTB_COMPANY(ed_Code.Text,ed_Name.Text,stCompanyGubun);

  if bResult then ShowProgrmaCode(ed_Code.Text)
  else showmessage('저장실패');
end;

function TfmCompanyCode.InsertTB_COMPANY(aCode, aName,aCompanyGubun: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Insert Into TB_COMPANY( ';
  stSql := stSql + ' CO_COMPANYCODE,';
  stSql := stSql + ' CO_NAME ,' ;
  stSql := stSql + ' CG_CODE )' ;
  stSql := stSql + ' values( ';
  stSql := stSql + '''' + aCode + ''',';
  stSql := stSql + '''' + aName + ''',';
  stSql := stSql + '''' + aCompanyGubun + '''';
  stSql := stSql + ')';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmCompanyCode.UpdateTB_COMPANY(aCode, aName,aCompanyGubun: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Update TB_COMPANY set ';
  stSql := stSql + ' CO_NAME = ''' + aName + ''', ';
  stSql := stSql + ' CG_CODE = ''' + aCompanyGubun + ''' ';
  stSql := stSql + ' where CO_COMPANYCODE =''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmCompanyCode.GetMaxProgramCode: string;
var
  stSql : string;
  TempAdoQuery : TZQuery;
begin
  result := '0000000000';
  

  stSql := 'select Max(CO_COMPANYCODE) as CO_COMPANYCODE from TB_COMPANY ';
  if cmb_sCompanyGubun.ItemIndex > 0 then
  begin
    stSql := stSql + ' Where CG_CODE = ''' + CompanyGubunCodeList.Strings[cmb_sCompanyGubun.ItemIndex - 1] + ''' '
  end;

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
        TempAdoQuery.Free;
        CoUninitialize;
        Exit;
      End;
      if RecordCount < 1 then
      begin
        Exit;
      end;
      if FindField('CO_COMPANYCODE').IsNull then
      begin
        result := '00001';
      end else if isdigit(FindField('CO_COMPANYCODE').AsString) then
      begin
        result := FillZeroNumber(strtoint(FindField('CO_COMPANYCODE').AsString) + 1,5);
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmCompanyCode.LoadCompanyGubunCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  CompanyGubunCodeList.Clear;
  cmb_CompanyGubun.Clear;
  cmb_sCompanyGubun.Clear;
  cmb_sCompanyGubun.Items.Add('전체');
  cmb_sCompanyGubun.ItemIndex := 0;

  stSql := 'select * from TB_COMPANYGUBUN ';
  stSql := stSql + ' order by CG_CODE ';

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
      if RecordCount < 1 then exit;

      while Not Eof do
      begin
        cmb_CompanyGubun.Items.Add(FindField('CG_NAME').AsString);
        cmb_sCompanyGubun.Items.Add(FindField('CG_NAME').AsString);
        CompanyGubunCodeList.Add(FindField('CG_CODE').AsString);
        Next;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmCompanyCode.FormCreate(Sender: TObject);
begin
  inherited;
  CompanyGubunCodeList := TStringList.Create;
  LoadCompanyGubunCode;
end;

procedure TfmCompanyCode.FormDestroy(Sender: TObject);
begin
  inherited;
  CompanyGubunCodeList.Free;
end;

procedure TfmCompanyCode.cmb_sCompanyGubunChange(Sender: TObject);
begin
  inherited;
  ShowProgrmaCode('');
end;

function TfmCompanyCode.DeleteTB_DEPARTCompany(aCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_DEPART ';
  stSql := stSql + ' where CO_COMPANYCODE = ''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmCompanyCode.DeleteTB_JIJUMCompany(aCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_JIJUM ';
  stSql := stSql + ' where CO_COMPANYCODE = ''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);

end;

end.
