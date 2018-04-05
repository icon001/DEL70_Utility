unit uDepartCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  uSubForm, CommandArray,ADODB,ActiveX,ZConnection,ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TfmDepartCode = class(TfmASubForm)
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
    cmb_Company: TComboBox;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    cmb_sCompanyGubun: TComboBox;
    Label4: TLabel;
    cmb_sCompany: TComboBox;
    Label5: TLabel;
    cmb_sJijumCode: TComboBox;
    cmb_JijumCode: TComboBox;
    Label6: TLabel;
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
    procedure cmb_sCompanyChange(Sender: TObject);
    procedure cmb_sJijumCodeChange(Sender: TObject);
  private
    State : string;
    CompanyGubunCodeList : TStringList;
    CompanyCodeList : TStringList;
    JijumCodeList : TStringList;
    { Private declarations }
    procedure FormClear;
    procedure FormEnable(aState:string);
    procedure ButtonEnable(aState:string);
  private
    procedure ShowProgrmaCode(aCode:string);
    Function InsertTB_DEPART(aCode,aName,aCompany,aJijum:string):Boolean;
    Function UpdateTB_DEPART(aCode,aName,aCompany,aJijum:string):Boolean;
    Function DELETETB_DEPART(aCompanyCode,aJijumCode,aDepartCode:string):Boolean;
    function GetMaxProgramCode:string;
    procedure LoadCompanyGubunCode;
    procedure LoadCompanyCode;
    procedure LoadJijumCode;
  public
    { Public declarations }
  end;

var
  fmDepartCode: TfmDepartCode;

implementation
uses
  uDataModule,
  uLomosUtil;

{$R *.dfm}

procedure TfmDepartCode.ButtonEnable(aState: string);
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

procedure TfmDepartCode.FormActivate(Sender: TObject);
begin
 ShowProgrmaCode('');
end;

procedure TfmDepartCode.FormClear;
begin
  ed_Code.Text := '';
  ed_Name.Text := '';
end;

procedure TfmDepartCode.FormEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := true;
    ed_Name.Enabled  := true;
    cmb_Company.Enabled := True;
    cmb_JijumCode.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
    cmb_Company.Enabled := False;
    cmb_JijumCode.Enabled := False;
  end else if upperCase(aState) = 'CLICK' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
    cmb_Company.Enabled := False;
    cmb_JijumCode.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := true;
    cmb_Company.Enabled := False;
    cmb_JijumCode.Enabled := False;
  end;
end;

procedure TfmDepartCode.ShowProgrmaCode(aCode: string);
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

  stSql := 'select * from TB_DEPART ';
  if cmb_sCompany.ItemIndex > -1 then
  begin
    stSql := stSql + ' Where CO_COMPANYCODE = ''' + CompanyCodeList.Strings[cmb_sCompany.ItemIndex] + ''' ';
    if cmb_sJijumCode.ItemIndex > -1 then
    begin
      stSql := stSql + ' AND CO_JIJUMCODE = ''' + JijumCodeList.Strings[cmb_sJijumCode.ItemIndex] + ''' ';
    end else Exit;
  end;
  stSql := stSql + ' order by CO_DEPARTCODE ';

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
        cells[0,nRow] := FindField('CO_DEPARTCODE').AsString;
        cells[1,nRow] := FindField('CO_DEPARTNAME').AsString;
        cells[2,nRow] := FindField('CO_COMPANYCODE').AsString;
        cells[3,nRow] := FindField('CO_JIJUMCODE').AsString;
        if FindField('CO_DEPARTCODE').AsString  = aCode then
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

procedure TfmDepartCode.btn_CloseClick(Sender: TObject);
begin
  Close;

end;

procedure TfmDepartCode.btn_CancelClick(Sender: TObject);
begin
  ShowProgrmaCode(ed_Code.Text);

end;

procedure TfmDepartCode.sg_CodeClick(Sender: TObject);
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
    nIndex := CompanyCodeList.IndexOf(cells[2,Row]);
    cmb_Company.ItemIndex := nIndex;
  end;
end;

procedure TfmDepartCode.btn_InsertClick(Sender: TObject);
var
  stCode : string;
begin
  stCode := GetMaxProgramCode;
  if stCode = '000' then
  begin
    showmessage('회사코드 또는 지점코드를 생성 후 작업하세요.');
    Exit;
  end;
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
  cmb_Company.ItemIndex := cmb_sCompany.ItemIndex;
  cmb_JijumCode.ItemIndex := cmb_sJijumCode.ItemIndex;
  ed_Code.Text := stCode;

  ed_Code.SetFocus;
end;

procedure TfmDepartCode.btn_UpdateClick(Sender: TObject);
begin
  State := 'UPDATE';

  FormEnable(State);
  ButtonEnable(State);
  ed_Name.SetFocus;
end;

procedure TfmDepartCode.btn_DeleteClick(Sender: TObject);
var
  bResult : boolean;
begin
  if (Application.MessageBox(PChar('데이터를 삭제하시겠습니까?'),'삭제',MB_OKCANCEL) = ID_CANCEL)  then Exit;

  bResult := DeleteTB_DEPART(companyCodeList.Strings[cmb_Company.itemIndex],JijumCodeList.Strings[cmb_sJijumCode.itemIndex],ed_Code.Text);

  if bResult then ShowProgrmaCode('')
  else showmessage('삭제실패.');
end;

function TfmDepartCode.DeleteTB_DEPART(aCompanyCode,aJijumCode,aDepartCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_DEPART ';
  stSql := stSql + ' where CO_COMPANYCODE = ''' + aCompanyCode + '''';
  stSql := stSql + ' AND CO_JIJUMCODE = ''' + aJijumCode + '''';
  stSql := stSql + ' AND CO_DEPARTCODE = ''' + aDepartCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

procedure TfmDepartCode.btn_SaveClick(Sender: TObject);
var
  bResult : boolean;
  stCompany : string;
  stJijum : string;
begin
  stCompany := '000';
  if cmb_Company.ItemIndex > -1 then stCompany := CompanyCodeList.Strings[cmb_Company.ItemIndex];
  stJijum := '000';
  if cmb_JijumCode.ItemIndex > -1 then stJijum := JijumCodeList.Strings[cmb_JijumCode.ItemIndex];

  if UpperCase(State) = 'INSERT' then
    bResult := InsertTB_DEPART(ed_Code.Text,ed_Name.Text,stCompany,stJijum)
  else if UpperCase(State) = 'UPDATE' then
    bResult := UpdateTB_DEPART(ed_Code.Text,ed_Name.Text,stCompany,stJijum);

  if bResult then ShowProgrmaCode(ed_Code.Text)
  else showmessage('저장실패');
end;

function TfmDepartCode.InsertTB_DEPART(aCode, aName,aCompany,aJijum: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Insert Into TB_DEPART( ';
  stSql := stSql + ' CO_COMPANYCODE,';
  stSql := stSql + ' CO_JIJUMCODE,';
  stSql := stSql + ' CO_DEPARTCODE,';
  stSql := stSql + ' CO_DEPARTNAME  )' ;
  stSql := stSql + ' values( ';
  stSql := stSql + '''' + aCompany + ''',';
  stSql := stSql + '''' + aJijum + ''',';
  stSql := stSql + '''' + aCode + ''',';
  stSql := stSql + '''' + aName + ''' ';
  stSql := stSql + ')';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmDepartCode.UpdateTB_DEPART(aCode, aName,aCompany,aJijum: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Update TB_DEPART set ';
  stSql := stSql + ' CO_DEPARTNAME = ''' + aName + ''' ';
  stSql := stSql + ' where CO_COMPANYCODE =''' + aCompany + '''';
  stSql := stSql + ' AND CO_JIJUMCODE =''' + aJijum + '''';
  stSql := stSql + ' AND CO_DEPARTCODE =''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmDepartCode.GetMaxProgramCode: string;
var
  stSql : string;
  TempAdoQuery : TZQuery;
begin
  result := '000';
  if cmb_sCompany.itemindex < 0 then Exit;
  if cmb_sJijumCode.itemindex < 0 then Exit;

  stSql := 'select Max(CO_DEPARTCODE) as CO_DEPARTCODE from TB_DEPART ';
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + CompanyCodeList.Strings[cmb_sCompany.itemindex] + ''' ';
  stSql := stSql + ' AND CO_JIJUMCODE = ''' + JijumCodeList.Strings[cmb_sJijumCode.itemindex] + ''' ';

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
      if FindField('CO_DEPARTCODE').IsNull then
      begin
        result := '001';
      end else if isdigit(FindField('CO_DEPARTCODE').AsString) then
      begin
        result := FillZeroNumber(strtoint(FindField('CO_DEPARTCODE').AsString) + 1,3);
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmDepartCode.LoadCompanyGubunCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  CompanyGubunCodeList.Clear;
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

procedure TfmDepartCode.FormCreate(Sender: TObject);
begin
  inherited;
  CompanyGubunCodeList := TStringList.Create;
  CompanyCodeList := TStringList.Create;
  JijumCodeList := TStringList.Create;
  LoadCompanyGubunCode;
  LoadCompanyCode;
  LoadJijumCode;
end;

procedure TfmDepartCode.FormDestroy(Sender: TObject);
begin
  inherited;
  CompanyGubunCodeList.Free;
  CompanyCodeList.Free;
  JijumCodeList.Free;
end;

procedure TfmDepartCode.cmb_sCompanyGubunChange(Sender: TObject);
begin
  inherited;
  LoadCompanyCode;
  LoadJijumCode;
  ShowProgrmaCode('');
end;

procedure TfmDepartCode.LoadCompanyCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  CompanyCodeList.Clear;
  cmb_sCompany.Clear;
  cmb_Company.Clear;

  stSql := 'select * from TB_COMPANY ';
  if cmb_sCompanyGubun.ItemIndex > 0 then
  begin
    stSql := stSql + ' Where CG_CODE = ''' + CompanyGubunCodeList.Strings[cmb_sCompanyGubun.ItemIndex - 1] + ''' ';
  end;
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
        cmb_sCompany.Items.Add(FindField('CO_NAME').AsString);
        cmb_Company.Items.Add(FindField('CO_NAME').AsString);
        CompanyCodeList.Add(FindField('CO_COMPANYCODE').AsString);
        Next;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
  if cmb_sCompany.Items.Count > 0 then cmb_sCompany.ItemIndex := 0;
end;

procedure TfmDepartCode.cmb_sCompanyChange(Sender: TObject);
begin
  inherited;
  LoadJijumCode;
  ShowProgrmaCode('');
end;

procedure TfmDepartCode.LoadJijumCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  JijumCodeList.Clear;
  cmb_sJijumCode.Clear;
  cmb_JijumCode.Clear;

  stSql := 'select * from TB_JIJUM ';
  if cmb_sCompany.ItemIndex > -1 then
  begin
    stSql := stSql + ' Where CO_COMPANYCODE = ''' + CompanyCodeList.Strings[cmb_sCompany.ItemIndex] + ''' ';
  end else Exit;
  stSql := stSql + ' order by CO_JIJUMCODE ';

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
        cmb_sJijumCode.Items.Add(FindField('CO_JIJUMNAME').AsString);
        cmb_JijumCode.Items.Add(FindField('CO_JIJUMNAME').AsString);
        JijumCodeList.Add(FindField('CO_JIJUMCODE').AsString);
        Next;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
  if cmb_sJijumCode.Items.Count > 0 then cmb_sJijumCode.ItemIndex := 0;
end;

procedure TfmDepartCode.cmb_sJijumCodeChange(Sender: TObject);
begin
  inherited;
  ShowProgrmaCode('');
end;

end.
