unit uCompanyAdmin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, AdvPanel, Grids, BaseGrid, AdvGrid, StdCtrls,
  Spin, DB, ADODB, ComCtrls, uSubForm, CommandArray,ActiveX, Gauges,iniFiles,
  ComObj, ZAbstractRODataset, ZAbstractDataset, ZDataset, Menus;

type
  TfmCompanyAdmin = class(TfmASubForm)
    AdvPanel1: TAdvPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    cmb_spgGroup: TComboBox;
    ed_scompanycode: TEdit;
    Label1: TLabel;
    btn_Search: TBitBtn;
    sg_Company: TAdvStringGrid;
    Panel12: TPanel;
    btn_Insert: TSpeedButton;
    btn_Update: TSpeedButton;
    btn_Save: TSpeedButton;
    btn_Delete: TSpeedButton;
    btn_Cancel: TSpeedButton;
    btn_Close: TSpeedButton;
    Label3: TLabel;
    ed_sCompanyName: TEdit;
    Splitter1: TSplitter;
    Label4: TLabel;
    ed_CompanyID: TEdit;
    Label5: TLabel;
    ed_CompanyName: TEdit;
    Label6: TLabel;
    ed_Phone: TEdit;
    Label7: TLabel;
    ed_Fax: TEdit;
    Label8: TLabel;
    ed_Addr1: TEdit;
    Label9: TLabel;
    ed_Addr2: TEdit;
    chk_AutoCompanyCode: TCheckBox;
    dt_sJoinDt: TDateTimePicker;
    Label14: TLabel;
    Label15: TLabel;
    ed_Passwd: TEdit;
    Label16: TLabel;
    ed_zip: TEdit;
    btn_Excel: TSpeedButton;
    pan_gauge: TPanel;
    Label23: TLabel;
    Gauge1: TGauge;
    SaveDialog1: TSaveDialog;
    TempQuery: TZQuery;
    cmb_Company: TComboBox;
    Label17: TLabel;
    cmb_Jijum: TComboBox;
    Label18: TLabel;
    cmb_Depart: TComboBox;
    Label19: TLabel;
    Label25: TLabel;
    cmb_sCompany: TComboBox;
    Label26: TLabel;
    cmb_sJijum: TComboBox;
    cmb_sDepart: TComboBox;
    Label27: TLabel;
    btn_CompanyCode: TSpeedButton;
    btn_Jijum: TSpeedButton;
    btn_Depart: TSpeedButton;
    Panel3: TPanel;
    GroupBox6: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    cmb_pgGroup: TComboBox;
    se_monitor: TSpinEdit;
    se_Attend: TSpinEdit;
    se_Food: TSpinEdit;
    cmb_ControlerType: TComboBox;
    cmb_ControlerRomType: TComboBox;
    cmb_CardReaderType: TComboBox;
    GroupBox7: TGroupBox;
    mem_etc: TMemo;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    N1: TMenuItem;
    lb_Count: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_CloseClick(Sender: TObject);
    procedure chk_AutoCompanyCodeClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure sg_CompanyClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_InsertClick(Sender: TObject);
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_ExcelClick(Sender: TObject);
    procedure ed_sCompanyNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ed_scompanycodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure cmb_sCompanyGubunChange(Sender: TObject);
    procedure cmb_sCompanyChange(Sender: TObject);
    procedure cmb_sJijumChange(Sender: TObject);
    procedure cmb_sDepartChange(Sender: TObject);
    procedure cmb_CompanyChange(Sender: TObject);
    procedure cmb_JijumChange(Sender: TObject);
    procedure cmb_spgGroupChange(Sender: TObject);
    procedure cmb_CompanyKeyPress(Sender: TObject; var Key: Char);
    procedure cmb_JijumKeyPress(Sender: TObject; var Key: Char);
    procedure cmb_CompanyExit(Sender: TObject);
    procedure cmb_JijumExit(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    State : string;
    ProgramTypeList :TStringList;
    sCompanyGubunList :TStringList;
    sCompanyCodeList :TStringList;
    sJijumCodeList :TStringList;
    sDepartCodeList :TStringList;
    CompanyGubunList :TStringList;
    CompanyCodeList :TStringList;
    JijumCodeList :TStringList;
    DepartCodeList :TStringList;
    ControlerTypeList :TStringList;
    ControlerRomTypeList :TStringList;
    CardReaderTypeList :TStringList;
    L_nSelectCompanyIndex : integer;
    L_nSelectJijumIndex : integer;
    L_bKeyPress : Boolean;
    L_bEnterKey : Boolean;
    { Private declarations }
    procedure FormClear;
    procedure FormEnable(aState:string);
    procedure ButtonEnable(aState:string);

    procedure cmbPGTypeLoad(cmb_Box:TComboBox;bAll:Boolean = True);
    procedure LoadCompanyGubun(cmb_Box:TComboBox;TempList:TStringList;bAll:Boolean = True);
    procedure LoadCompanyCode(cmb_Box:TComboBox;aCompanyGubunCode:string;TempList:TStringList;bAll:Boolean = True);
    procedure LoadJijumCode(cmb_Box:TComboBox;aCompanyCode:string;TempList:TStringList;bAll:Boolean = True);
    procedure LoadDepartCode(cmb_Box:TComboBox;aCompanyCode,aJijumCode:string;TempList:TStringList;bAll:Boolean = True);
    procedure LoadControlerType(cmb_Box:TComboBox;TempList:TStringList;bAll:Boolean = True);
    procedure LoadControlerRomType(cmb_Box:TComboBox;TempList:TStringList;bAll:Boolean = True);
    procedure LoadCardReaderType(cmb_Box:TComboBox;TempList:TStringList;bAll:Boolean = True);
  private
    procedure ShowCompanyID(aCode:string;aTopRow:integer = 0;aShow:Boolean=False);
    Function GetAutoCompanyCode:string;

    Function InsertTB_AUTHCOMPANY(aAuthCompanyID,aAuthCompanyName,
                                    aPasswd,aMonitorCount,aATCount,aFoodCount,
                                    aCompanyCode,aJijumCode,aDepartCode,
                                    aZip,aAddr1,aAddr2,aPhone,aFax,aJoinDt,
                                    aPgType,aControlerType,aControlerRomType,
                                    aCardReaderType,aMemo:string):Boolean;
    Function UpdateTB_AUTHCOMPANY(aAuthCompanyID,aAuthCompanyName,
                                    aPasswd,aMonitorCount,aATCount,aFoodCount,
                                    aCompanyCode,aJijumCode,aDepartCode,
                                    aZip,aAddr1,aAddr2,aPhone,aFax,aJoinDt,
                                    aPgType,aControlerType,aControlerRomType,
                                    aCardReaderType,aMemo:string):Boolean;
    Function DeleteTB_AUTHCOMPANY(aCode:string):Boolean;


    Function ExcelPrintOut(StringGrid:TAdvStringGrid;refFileName,SaveFileName:String;FileOut:Boolean;ExcelRowStart:integer;stTitle:string;bRowHeader,bColHeader:Boolean):Boolean;
  public
    { Public declarations }
  end;

var
  fmCompanyAdmin: TfmCompanyAdmin;

implementation
uses
  uDataModule,
  uLomosUtil;
{$R *.dfm}


procedure TfmCompanyAdmin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ProgramTypeList.Free;
  sCompanyGubunList.free;
  sCompanyCodeList.Free;
  sJijumCodeList.Free;
  sDepartCodeList.Free;
  CompanyGubunList.free;
  CompanyCodeList.Free;
  JijumCodeList.Free;
  DepartCodeList.Free;
  ControlerTypeList.Free;
  ControlerRomTypeList.Free;
  CardReaderTypeList.Free;

  Action := caFree;
end;

procedure TfmCompanyAdmin.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCompanyAdmin.cmbPGTypeLoad(cmb_Box: TComboBox;bAll:Boolean = True);
var
  stSql : string;
begin
  cmb_Box.Clear;
  ProgramTypeList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  ProgramTypeList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_PROGRAMGUBUN ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('PG_GUBUNNAME').AsString );
      ProgramTypeList.Add(FindField('PG_GUBUNCODE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.ButtonEnable(aState: string);
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

procedure TfmCompanyAdmin.FormClear;
begin
    ed_CompanyID.Text := '';
    ed_Passwd.Text := '';
    ed_CompanyName.Text := '';
    ed_Phone.Text := '';
    ed_Fax.Text := '';
    ed_Addr1.Text := '';
    ed_Addr2.Text := '';
    cmb_pgGroup.ItemIndex := 0;
    se_monitor.Value := 0;
    se_Attend.Value := 0;
    se_Food.Value := 0;
    dt_sJoinDt.Date := Now;
    ed_zip.Text := '';
    mem_etc.Text := '';
    cmb_ControlerType.ItemIndex := 0;
    cmb_ControlerRomType.ItemIndex := 0 ;
    cmb_CardReaderType.ItemIndex := 0;
    cmb_Company.ItemIndex := 0;
    cmb_Jijum.ItemIndex := 0;
    cmb_Depart.ItemIndex := 0;
    L_nSelectCompanyIndex := -1;
    L_nSelectJijumIndex := -1;
end;

procedure TfmCompanyAdmin.FormEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    sg_Company.Enabled := False;
    ed_CompanyID.Enabled := true;
    ed_Passwd.Enabled := True;
    ed_CompanyName.Enabled  := true;
    ed_Phone.Enabled := True;
    ed_Fax.Enabled := True;
    ed_Addr1.Enabled := True;
    ed_Addr2.Enabled := True;
    cmb_pgGroup.Enabled := True;
    se_monitor.Enabled := True;
    se_Attend.Enabled := True;
    se_Food.Enabled := True;
    chk_AutoCompanyCode.Enabled := True;
    dt_sJoinDt.Enabled := True;
    ed_zip.Enabled := True;
    mem_etc.ReadOnly := False;
    cmb_Company.Enabled := True;
    cmb_Jijum.Enabled := True;
    cmb_Depart.Enabled := True;
    cmb_ControlerType.Enabled := True;
    cmb_ControlerRomType.Enabled := True;
    cmb_CardReaderType.Enabled := True;
    btn_CompanyCode.Enabled := True;
    btn_Jijum.Enabled := True;
    btn_Depart.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    sg_Company.Enabled := true;
    ed_CompanyID.Enabled := False;
    ed_Passwd.Enabled := False;
    ed_CompanyName.Enabled  := False;
    ed_Phone.Enabled := False;
    ed_Fax.Enabled := False;
    ed_Addr1.Enabled := False;
    ed_Addr2.Enabled := False;
    cmb_pgGroup.Enabled := False;
    se_monitor.Enabled := False;
    se_Attend.Enabled := False;
    se_Food.Enabled := False;
    chk_AutoCompanyCode.Enabled := False;
    dt_sJoinDt.Enabled := False;
    ed_zip.Enabled := False;
    mem_etc.ReadOnly := True;
    cmb_Company.Enabled := False;
    cmb_Jijum.Enabled := False;
    cmb_Depart.Enabled := False;
    cmb_ControlerType.Enabled := False;
    cmb_ControlerRomType.Enabled := False;
    cmb_CardReaderType.Enabled := False;
    btn_CompanyCode.Enabled := False;
    btn_Jijum.Enabled := False;
    btn_Depart.Enabled := False;
  end else if upperCase(aState) = 'CLICK' then
  begin
    sg_Company.Enabled := true;
    ed_CompanyID.Enabled := False;
    ed_Passwd.Enabled := False;
    ed_CompanyName.Enabled  := False;
    ed_Phone.Enabled := False;
    ed_Fax.Enabled := False;
    ed_Addr1.Enabled := False;
    ed_Addr2.Enabled := False;
    cmb_pgGroup.Enabled := False;
    se_monitor.Enabled := False;
    se_Attend.Enabled := False;
    se_Food.Enabled := False;
    chk_AutoCompanyCode.Enabled := False;
    dt_sJoinDt.Enabled := False;
    ed_zip.Enabled := False;
    mem_etc.ReadOnly := True;
    cmb_Company.Enabled := False;
    cmb_Jijum.Enabled := False;
    cmb_Depart.Enabled := False;
    cmb_ControlerType.Enabled := False;
    cmb_ControlerRomType.Enabled := False;
    cmb_CardReaderType.Enabled := False;
    btn_CompanyCode.Enabled := False;
    btn_Jijum.Enabled := False;
    btn_Depart.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    sg_Company.Enabled := False;
    ed_CompanyID.Enabled := False;
    chk_AutoCompanyCode.Enabled := False;
    ed_Passwd.Enabled := True;
    ed_CompanyName.Enabled  := true;
    ed_Phone.Enabled := True;
    ed_Fax.Enabled := True;
    ed_Addr1.Enabled := True;
    ed_Addr2.Enabled := True;
    cmb_pgGroup.Enabled := True;
    se_monitor.Enabled := True;
    se_Attend.Enabled := True;
    se_Food.Enabled := True;
    dt_sJoinDt.Enabled := True;
    ed_zip.Enabled := False;
    mem_etc.ReadOnly := False;
    cmb_Company.Enabled := True;
    cmb_Jijum.Enabled := True;
    cmb_Depart.Enabled := True;
    cmb_ControlerType.Enabled := True;
    cmb_ControlerRomType.Enabled := True;
    cmb_CardReaderType.Enabled := True;
    btn_CompanyCode.Enabled := True;
    btn_Jijum.Enabled := True;
    btn_Depart.Enabled := True;
  end;
end;

procedure TfmCompanyAdmin.chk_AutoCompanyCodeClick(Sender: TObject);
begin
  if chk_AutoCompanyCode.Checked then ed_CompanyID.Text := GetAutoCompanyCode;

end;

function TfmCompanyAdmin.GetAutoCompanyCode: string;
var
  stSql : string;
  nSeq : integer;
begin
  nSeq := 1;
  stSql := 'select MAX(AU_COMPANYID) as AU_COMPANYID from TB_AUTHCOMPANY ';
  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      result := 'Z-' + FillZeroNumber(nSeq,8);
      Exit;
    End;
    if recordCount > 0 then
    begin
      if IsDigit(copy(FindField('AU_COMPANYID').AsString,3,8)) then
      begin
        nSeq := strtoint(copy(FindField('AU_COMPANYID').AsString,3,8)) + 1;
      end;
    end;
  end;
  result := 'Z-' + FillZeroNumber(nSeq,8);
end;

procedure TfmCompanyAdmin.btn_SearchClick(Sender: TObject);
begin
  ShowCompanyID('');
end;

procedure TfmCompanyAdmin.ShowCompanyID(aCode: string;aTopRow:integer=0;aShow:Boolean=False);
var
  stSql : string;
  nRow : integer;
  i : integer;
  TempAdoQuery : TZQuery;
  stWhere : string;
begin
  if Not aShow then
  begin
    if State = 'INSERT' then Exit;   //수정이나 추가 중에는 조회 되지 말자
    if State = 'UPDATE' then Exit;
  end;

  GridInit(sg_Company,2); //스트링그리드 초기화

  State := 'SEARCH';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);

  stWhere := '';

  if cmb_spgGroup.ItemIndex > 0 then
  begin
    if stWhere = '' then stWhere := stWhere + ' Where '
    else stWhere := stWhere + ' AND ';
    stWhere := stWhere + ' PG_GUBUNCODE = ''' + ProgramTypeList.Strings[cmb_spgGroup.ItemIndex] + ''' ';
  end;
  if cmb_sCompany.ItemIndex > 0 then
  begin
    if stWhere = '' then stWhere := stWhere + ' Where '
    else stWhere := stWhere + ' AND ';
    stWhere := stWhere + ' CO_COMPANYCODE = ''' + sCompanyCodeList.Strings[cmb_sCompany.ItemIndex] + ''' ';
{  end else if cmb_sCompanyGubun.ItemIndex > 0 then
  begin
    if sCompanyCodeList.Count > 1 then
    begin
      if stWhere = '' then stWhere := stWhere + ' Where '
      else stWhere := stWhere + ' AND ';
      stWhere := stWhere + ' (';
      for i := 1 to sCompanyCodeList.Count - 1 do
      begin
        if i <> 1 then stWhere := stWhere + 'OR ';
        stWhere := stWhere + ' CO_COMPANYCODE = ''' + sCompanyCodeList.Strings[i] + ''' ';
      end;
      stWhere := stWhere + ' )';
    end;  }
  end;
  if cmb_sJijum.ItemIndex > 0 then
  begin
    if stWhere = '' then stWhere := stWhere + ' Where '
    else stWhere := stWhere + ' AND ';
    stWhere := stWhere + ' CO_JIJUMCODE = ''' + sJijumCodeList.Strings[cmb_sJijum.ItemIndex] + ''' ';
  end;
  if cmb_sDepart.ItemIndex > 0 then
  begin
    if stWhere = '' then stWhere := stWhere + ' Where '
    else stWhere := stWhere + ' AND ';
    stWhere := stWhere + ' CO_DEPARTCODE = ''' + sDepartCodeList.Strings[cmb_sDepart.ItemIndex] + ''' ';
  end;

  if Trim(ed_sCompanyName.Text) <> '' then
  begin
    stWhere := stWhere + ' Where AU_COMPANYNAME Like ''%' + Trim(ed_sCompanyName.Text) + '%'' ';
  end;
  if Trim(ed_scompanycode.Text) <> '' then
  begin
    stWhere := stWhere + ' Where AU_COMPANYID Like ''%' + Trim(ed_scompanycode.Text) + '''% ';
  end;


  stSql := 'select * ';
  stSql := stSql + ' from TB_AUTHCOMPANY  ';
  if Trim(stWhere) <> '' then stSql := stSql + stWhere;
  stSql := stSql + ' order by AU_COMPANYID ';

  CoInitialize(nil);
  TempAdoQuery := TZQuery.Create(nil);
  TempAdoQuery.Connection := dmDB.ZConnection1;

  Try
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
        Exit;
      end;
      lb_Count.Caption := '조회:' + inttostr(RecordCount) + '건';
      
      with sg_Company do
      begin
        RowCount := RecordCount + 1;
        nRow := 1;
        while Not Eof do
        begin
          cells[0,nRow] := FindField('AU_COMPANYID').AsString;
          cells[1,nRow] := FindField('AU_COMPANYNAME').AsString;
          cells[2,nRow] := FindField('AU_PASSWD').AsString;
          cells[3,nRow] := inttostr(FindField('AU_MOCOUNT').AsInteger);
          cells[4,nRow] := inttostr(FindField('AU_ATCOUNT').AsInteger);
          cells[5,nRow] := inttostr(FindField('AU_FDCOUNT').AsInteger);
          cells[6,nRow] := FindField('CO_COMPANYCODE').AsString;
          cells[7,nRow] := FindField('CO_JIJUMCODE').AsString;
          cells[8,nRow] := FindField('CO_DEPARTCODE').AsString;
          cells[9,nRow] := FindField('AU_ZIP').AsString;
          cells[10,nRow] := FindField('AU_ADDR1').AsString;
          cells[11,nRow] := FindField('AU_ADDR2').AsString;
          cells[12,nRow] := FindField('AU_TEL').AsString;
          cells[13,nRow] := FindField('AU_FAX').AsString;
          cells[14,nRow] := FindField('AU_REGDATE').AsString;
          cells[15,nRow] := FindField('PG_GUBUNCODE').AsString;
          cells[16,nRow] := FindField('DE_DEVICETYPE').AsString;
          cells[17,nRow] := FindField('DE_ROMTYPE').AsString;
          cells[18,nRow] := FindField('CA_CARDTYPE').AsString;
          cells[19,nRow] := FindField('AU_MEMO').AsString;


          if FindField('AU_COMPANYID').AsString  = aCode then
          begin
            SelectRows(nRow,1);
          end;

          nRow := nRow + 1;
          Next;
        end;
        if aTopRow = 0 then
        begin
          if Row > 15 then TopRow := row - 14;
        end else
        begin
          TopRow := aTopRow;
        end;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
  sg_CompanyClick(sg_Company);
  //sg_Company.SetFocus;
end;

procedure TfmCompanyAdmin.sg_CompanyClick(Sender: TObject);
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
    ed_CompanyID.Text := cells[0,Row];
    ed_CompanyName.Text := cells[1,Row];
    ed_Passwd.Text := cells[2,Row];
    if isdigit(cells[3,Row]) then se_monitor.Value := strtoint(cells[3,Row]);
    if isdigit(cells[4,Row]) then se_Attend.Value := strtoint(cells[4,Row]);
    if isdigit(cells[5,Row]) then se_Food.Value := strtoint(cells[5,Row]);
    nIndex := CompanyCodeList.IndexOf(cells[6,Row]);
    cmb_Company.ItemIndex := nIndex;
    LoadJijumCode(cmb_Jijum,cells[6,Row],JijumCodeList,False);
    nIndex := JijumCodeList.IndexOf(cells[7,Row]);
    cmb_Jijum.ItemIndex := nIndex;
    LoadDepartCode(cmb_Depart,cells[6,Row],cells[7,Row],DepartCodeList,False);
    nIndex := DepartCodeList.IndexOf(cells[8,Row]);
    cmb_Depart.ItemIndex := nIndex;
    ed_Zip.Text := cells[9,Row];
    ed_Addr1.Text := cells[10,Row];
    ed_Addr2.Text := cells[11,Row];
    ed_Phone.Text := cells[12,Row];
    ed_Fax.Text := cells[13,Row];
    if Trim(cells[14,Row]) <> '' then
      dt_sJoinDt.Date := strToDate(copy(cells[14,Row],1,4) + '-' + copy(cells[14,Row],5,2) + '-' + copy(cells[14,Row],7,2) );
    nIndex := ProgramTypeList.IndexOf(cells[15,Row]);
    if nIndex > 0 then cmb_pgGroup.ItemIndex := nIndex;
    nIndex := ControlerTypeList.IndexOf(cells[16,Row]);
    if nIndex > 0 then cmb_ControlerType.ItemIndex := nIndex;
    nIndex := ControlerROMTypeList.IndexOf(cells[17,Row]);
    if nIndex > 0 then cmb_ControlerRomType.ItemIndex := nIndex;
    nIndex := CardReaderTypeList.IndexOf(cells[18,Row]);
    if nIndex > 0 then cmb_CardReaderType.ItemIndex := nIndex;
    mem_etc.Text := cells[19,Row];
//    showDeviceInfo(cells[0,Row]);
  end;
end;

procedure TfmCompanyAdmin.btn_CancelClick(Sender: TObject);
begin
  ShowCompanyID(ed_CompanyID.Text,sg_Company.TopRow,True);
end;

procedure TfmCompanyAdmin.btn_InsertClick(Sender: TObject);
begin
  State := 'INSERT';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);
  with sg_Company do
  begin
    if Cells[0,1] <> '' then
    begin
      AddRow;
      SelectRows(RowCount - 1,1);
      Enabled := True;
      if RowCount > 18 then TopRow := RowCount - 17;
      Enabled := False;
    end;
  end;
  if chk_AutoCompanyCode.Checked then
  begin
    chk_AutoCompanyCodeClick(self);
    ed_CompanyName.SetFocus;
  end
  else  ed_CompanyID.SetFocus;

  ed_Passwd.Text := FormatDateTime('nnsshh',now);

  cmb_pgGroup.ItemIndex := cmb_spgGroup.ItemIndex;
  se_monitor.Value := 1;
  
end;

procedure TfmCompanyAdmin.btn_UpdateClick(Sender: TObject);
begin
  State := 'UPDATE';

  FormEnable(State);
  ButtonEnable(State);
  //ed_CompanyName.SetFocus;
  cmb_Company.SetFocus;
end;

procedure TfmCompanyAdmin.btn_DeleteClick(Sender: TObject);
var
  bResult : boolean;
begin
  if (Application.MessageBox(PChar('데이터를 삭제하시겠습니까?'),'삭제',MB_OKCANCEL) = ID_CANCEL)  then Exit;

  bResult := DeleteTB_AUTHCOMPANY(ed_CompanyID.Text);

  if bResult then ShowCompanyID('',sg_Company.TopRow,True)
  else showmessage('삭제실패.');

end;

function TfmCompanyAdmin.DeleteTB_AUTHCOMPANY(aCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_AUTHCOMPANY ';
  stSql := stSql + ' where AU_COMPANYID = ''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

procedure TfmCompanyAdmin.FormCreate(Sender: TObject);
begin
  ProgramTypeList := TStringList.Create;
  sCompanyGubunList := TStringList.Create;
  sCompanyCodeList := TStringList.Create;
  sJijumCodeList := TStringList.Create;
  sDepartCodeList := TStringList.Create;
  CompanyGubunList := TStringList.Create;
  CompanyCodeList := TStringList.Create;
  JijumCodeList := TStringList.Create;
  DepartCodeList := TStringList.Create;
  ControlerTypeList := TStringList.Create;
  ControlerRomTypeList := TStringList.Create;
  CardReaderTypeList := TStringList.Create;
end;

procedure TfmCompanyAdmin.btn_SaveClick(Sender: TObject);
var
  bResult : boolean;
  stPgType : string;
  stControlerType : string;
  stControlerRomType : string;
  stCardReaderType : string;
  stPhone:string;
  stMemo : string;
  stCompanyCode : string;
  stJijumCode : string;
  stDepartCode : string;
begin
  stPhone := Trim(StringReplace(ed_Phone.Text,'-','',[rfReplaceAll]));
  if Not isDigit(stPhone) then
  begin
    if stPhone <> '' then
    begin
      showmessage('대표전화번호가 이상합니다.');
      Exit;
    end;
  end;
  stPgType := '000';
  stControlerType := '000';
  stControlerRomType := '000';
  stCardReaderType := '000';
  stCompanyCode := '000';
  stJijumCode := '000';
  stDepartCode := '000';
  stMemo := StringReplace(mem_etc.Text,'''','''''',[rfReplaceAll]);
  if cmb_pgGroup.ItemIndex > 0 then stPgType := ProgramTypeList.Strings[cmb_pgGroup.ItemIndex];
  if cmb_ControlerType.ItemIndex > 0 then stControlerType := ControlerTypeList.Strings[cmb_ControlerType.ItemIndex];
  if cmb_ControlerRomType.ItemIndex > 0 then stControlerRomType := ControlerRomTypeList.Strings[cmb_ControlerRomType.ItemIndex];
  if cmb_CardReaderType.ItemIndex > 0 then stCardReaderType := CardReaderTypeList.Strings[cmb_CardReaderType.ItemIndex];
  if cmb_Company.ItemIndex > 0 then stCompanyCode := CompanyCodeList.Strings[cmb_Company.ItemIndex];
  if cmb_Jijum.ItemIndex > 0 then stJijumCode := JijumCodeList.Strings[cmb_Jijum.ItemIndex];
  if cmb_Depart.ItemIndex > 0 then stDepartCode := DepartCodeList.Strings[cmb_Depart.ItemIndex];

  if UpperCase(State) = 'INSERT' then
  begin
    bResult := InsertTB_AUTHCOMPANY(ed_CompanyID.Text,
                                    ed_CompanyName.Text,
                                    ed_Passwd.Text,
                                    inttostr(se_monitor.Value),
                                    inttostr(se_Attend.Value),
                                    inttostr(se_Food.Value),
                                    stCompanyCode,
                                    stJijumCode,
                                    stDepartCode,
                                    ed_zip.Text,
                                    ed_Addr1.Text,
                                    ed_Addr2.Text,
                                    ed_Phone.Text,
                                    ed_Fax.Text,
                                    FormatDateTime('yyyymmdd',dt_sJoinDt.Date),
                                    stPgType,
                                    stControlerType,
                                    stControlerRomType,
                                    stCardReaderType,
                                    stMemo
                                    );
  end
  else if UpperCase(State) = 'UPDATE' then
  begin
    bResult := UpdateTB_AUTHCOMPANY(ed_CompanyID.Text,
                                    ed_CompanyName.Text,
                                    ed_Passwd.Text,
                                    inttostr(se_monitor.Value),
                                    inttostr(se_Attend.Value),
                                    inttostr(se_Food.Value),
                                    stCompanyCode,
                                    stJijumCode,
                                    stDepartCode,
                                    ed_zip.Text,
                                    ed_Addr1.Text,
                                    ed_Addr2.Text,
                                    ed_Phone.Text,
                                    ed_Fax.Text,
                                    FormatDateTime('yyyymmdd',dt_sJoinDt.Date),
                                    stPgType,
                                    stControlerType,
                                    stControlerRomType,
                                    stCardReaderType,
                                    stMemo
                                    );
  end;

  if bResult then
  begin
    if UpperCase(State) = 'UPDATE' then ShowCompanyID(ed_CompanyID.Text,sg_Company.TopRow,True)
    else ShowCompanyID(ed_CompanyID.Text,1,True);
  end
  else showmessage('저장실패');

end;

function TfmCompanyAdmin.InsertTB_AUTHCOMPANY(aAuthCompanyID,aAuthCompanyName,
                                    aPasswd,aMonitorCount,aATCount,aFoodCount,
                                    aCompanyCode,aJijumCode,aDepartCode,
                                    aZip,aAddr1,aAddr2,aPhone,aFax,aJoinDt,
                                    aPgType,aControlerType,aControlerRomType,
                                    aCardReaderType,aMemo:string):Boolean;
var
  stSql : string;
begin
  stSql := ' Insert Into TB_AUTHCOMPANY(';
  stSql := stSql + 'AU_COMPANYID,';
  stSql := stSql + 'AU_COMPANYNAME,';
  stSql := stSql + 'AU_PASSWD,';
  stSql := stSql + 'AU_MOCOUNT,';
  stSql := stSql + 'AU_ATCOUNT,';
  stSql := stSql + 'AU_FDCOUNT,';
  stSql := stSql + 'CO_COMPANYCODE,';
  stSql := stSql + 'CO_JIJUMCODE,';
  stSql := stSql + 'CO_DEPARTCODE,';
  stSql := stSql + 'AU_ZIP,';
  stSql := stSql + 'AU_ADDR1,';
  stSql := stSql + 'AU_ADDR2,';
  stSql := stSql + 'AU_TEL,';
  stSql := stSql + 'AU_FAX,';
  stSql := stSql + 'AU_REGDATE,';
  stSql := stSql + 'PG_GUBUNCODE,';
  stSql := stSql + 'DE_DEVICETYPE,';
  stSql := stSql + 'DE_ROMTYPE,';
  stSql := stSql + 'CA_CARDTYPE,';
  stSql := stSql + 'AU_MEMO) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' + aAuthCompanyID + ''',';
  stSql := stSql + '''' + aAuthCompanyName + ''',';
  stSql := stSql + '''' + aPasswd + ''',';
  stSql := stSql + '' + aMonitorCount + ',';
  stSql := stSql + '' + aATCount + ',';
  stSql := stSql + '' + aFoodCount + ',';
  stSql := stSql + '''' + aCompanyCode + ''',';
  stSql := stSql + '''' + aJijumCode + ''',';
  stSql := stSql + '''' + aDepartCode + ''',';
  stSql := stSql + '''' + aZip + ''',';
  stSql := stSql + '''' + aAddr1 + ''',';
  stSql := stSql + '''' + aAddr2 + ''',';
  stSql := stSql + '''' + aPhone + ''',';
  stSql := stSql + '''' + aFax + ''',';
  stSql := stSql + '''' + aJoinDt + ''',';
  stSql := stSql + '''' + aPgType + ''',';
  stSql := stSql + '''' + aControlerType + ''',';
  stSql := stSql + '''' + aControlerRomType + ''',';
  stSql := stSql + '''' + aCardReaderType + ''',';
  stSql := stSql + '''' + aMemo + ''') ';

  //mem_etc.Text := stSql;
  //Exit;
  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmCompanyAdmin.UpdateTB_AUTHCOMPANY(aAuthCompanyID,aAuthCompanyName,
                                    aPasswd,aMonitorCount,aATCount,aFoodCount,
                                    aCompanyCode,aJijumCode,aDepartCode,
                                    aZip,aAddr1,aAddr2,aPhone,aFax,aJoinDt,
                                    aPgType,aControlerType,aControlerRomType,
                                    aCardReaderType,aMemo:string):Boolean;
var
  stSql : string;
begin
  stSql := ' Update TB_AUTHCOMPANY Set ';
  stSql := stSql + 'AU_COMPANYNAME = ''' + aAuthCompanyName + ''',';
  stSql := stSql + 'AU_PASSWD = ''' + aPasswd + ''',';
  stSql := stSql + 'AU_MOCOUNT = ' + aMonitorCount + ',';
  stSql := stSql + 'AU_ATCOUNT = ' + aATCount + ',';
  stSql := stSql + 'AU_FDCOUNT = ' + aFoodCount + ',';
  stSql := stSql + 'CO_COMPANYCODE = ''' + aCompanyCode + ''',';
  stSql := stSql + 'CO_JIJUMCODE = ''' + aJijumCode + ''',';
  stSql := stSql + 'CO_DEPARTCODE= ''' + aDepartCode + ''',';
  stSql := stSql + 'AU_ZIP = ''' + aZip + ''',';
  stSql := stSql + 'AU_ADDR1 = ''' + aAddr1 + ''',';
  stSql := stSql + 'AU_ADDR2 = ''' + aAddr2 + ''',';
  stSql := stSql + 'AU_TEL = ''' + aPhone + ''',';
  stSql := stSql + 'AU_FAX = ''' + aFax + ''',';
  stSql := stSql + 'AU_REGDATE = ''' + aJoinDt + ''',';
  stSql := stSql + 'PG_GUBUNCODE = ''' + aPgType + ''',';
  stSql := stSql + 'DE_DEVICETYPE = ''' + aControlerType + ''',';
  stSql := stSql + 'DE_ROMTYPE = ''' + aControlerRomType + ''',';
  stSql := stSql + 'CA_CARDTYPE = ''' + aCardReaderType + ''',';
  stSql := stSql + 'AU_MEMO = ''' + aMemo + ''' ';
  stSql := stSql + ' Where AU_COMPANYID = ''' + aAuthCompanyID + ''' ';

  result := dmDB.ProcessExecSQL(stSql);

end;



procedure TfmCompanyAdmin.btn_ExcelClick(Sender: TObject);
var
  stRefFileName,stSaveFileName:String;
  stPrintRefPath : string;
  nExcelRowStart:integer;
  ini_fun : TiniFile;
  aFileName : string;
  stTitle : string;
begin
{  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;
    if stSaveFileName <> '' then
    begin
      ExcelIO1.XLSExport(stSaveFileName);
    end;
    showmessage('파일생성 완료');
  end;    }
  btn_Excel.Enabled := False;
  Screen.Cursor:= crHourGlass;
  stTitle := '';
  ini_fun := TiniFile.Create(ExeFolder + '\print.ini');
  stPrintRefPath := ExeFolder + '\' ;
  stPrintRefPath := ini_fun.ReadString('환경설정','PrintRefPath',stPrintRefPath);
  stRefFileName  := ini_fun.ReadString('고객사정보','참조파일','CustomerReport.xls');
  stRefFileName := stPrintRefPath + stRefFileName;
  nExcelRowStart := ini_fun.ReadInteger('고객사정보','시작위치',6);
  ini_fun.Free;

  aFileName:='고객사정보';
  SaveDialog1.FileName := aFileName;
  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;
    if SaveDialog1.FileName <> '' then
      if Not ExcelPrintOut(sg_Company,stRefFileName,stSaveFileName,True,nExcelRowStart,stTitle,False,False) then
      begin
        Screen.Cursor:= crDefault;
        btn_Excel.Enabled := True;
        Exit;
      end;
      //showmessage('파일생성 완료');
  end;
  Screen.Cursor:= crDefault;
  btn_Excel.Enabled := True;
end;

function TfmCompanyAdmin.ExcelPrintOut(StringGrid: TAdvStringGrid;
  refFileName, SaveFileName: String; FileOut: Boolean;
  ExcelRowStart: integer; stTitle: string; bRowHeader,
  bColHeader: Boolean): Boolean;
var
  oXL, oWB, oSheet, oRng, VArray : Variant;
  nCol1,nCol2 : Integer;
  Loop : Integer;
  sCurDay,sPreDay : String;
  curDate : TDateTime;
  mergeStart :char;
  i,j,k : Integer;
  st : String;
  nColChar : integer;
  nFixCol,nFixRow : integer;

begin
  pan_gauge.Visible := True;
  Result := False;

  Try
    oXL := CreateOleObject('Excel.Application');
  Except
    showmessage('출력은 엑셀이 설치된 컴퓨터에서만 가능합니다.');
    exit;
  End;

  if FileExists(refFileName) = False then
  begin
    Showmessage(refFileName + ' 파일이 없습니다.');
    exit;
  end;


  oXL.Workbooks.Open(refFileName);
  oXL.DisplayAlerts := False;
//  oXL.Visible := True;
  oSheet := oXL.ActiveSheet;


  with StringGrid do
  begin

    //타이틀을 적자
    nCol1 := ColCount div 26;
    nCol2 := ColCount mod 26;
    if bRowHeader then
    begin
      oSheet.Range['A' + inttostr(ExcelRowStart - 1)].Value := stTitle;
      if bColHeader then nFixCol := 0
      else nFixCol := FixedCols ;
      for i:= 0 to FixedRows - 1 do
      begin
        for j:= nFixCol to ColCount - 1 do
        begin
          nColChar := j div 26;
          if j < 26 then
            oXL.Range[Chr(Ord('A') + j ) + inttostr(i+ ExcelRowStart)].Value := Cells[j,i]
          else
            oXL.Range[Chr(Ord('A') + nColChar - 1 ) + Chr(Ord('A') + j - (26 * nColChar) ) + inttostr(i+ ExcelRowStart)].Value := Cells[j,i];
        end;
      end;
      ExcelRowStart := ExcelRowStart + FixedRows ;
    end
    else    oSheet.Range['A' + inttostr(ExcelRowStart - FixedRows - 1)].Value := stTitle;

    Gauge1.MaxValue := ( RowCount - FixedRows );
    Gauge1.Progress := 0;
    for i := FixedRows to RowCount - 1 do
    begin

      if i <  RowCount - 2 then    //한칸씩 삽입
      begin
        oSheet.Range['A' + inttostr(i+ ExcelRowStart - FixedRows + 1) + ':' + Chr(Ord('A') + nCol1 ) + Chr(Ord('A') + nCol2 - 1 ) +  inttostr(i+ ExcelRowStart - FixedRows + 1)].Insert;
      end;
      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;
     {
      for j := 0 to ColCount - 1 do
      begin
        nColChar := j div 26;
        if j < 26 then
          oXL.Range[Chr(Ord('A') + j ) + inttostr(i+ ExcelRowStart - FixedRows)].Value := Cells[j,i]
        else
          oXL.Range[Chr(Ord('A') + nColChar - 1 ) + Chr(Ord('A') + j - (26 * nColChar) ) + inttostr(i+ ExcelRowStart - FixedRows)].Value := Cells[j,i];
        Gauge1.Progress := Gauge1.Progress + 1;
        Application.ProcessMessages;
      end;
      }
    end;
    StringGrid.CopyToClipBoard;
    oSheet.Range['A' + inttostr(ExcelRowStart - 1), 'A' + inttostr(ExcelRowStart - 1)].Select;
    oSheet.Paste;
  end;//With

  //oXL.Visible := False;
  if FileOut then  oSheet.SaveAs(SaveFileName)
  else  oSheet.PrintOut;
  //oSheet.SaveAs(ExtractFileDir(Application.ExeName) + '\WorkSch2.xls');
  oXL.ActiveWorkbook.Close(False);
  oXL.Quit;
  pan_gauge.Visible := False;
  Result := True;
end;

procedure TfmCompanyAdmin.ed_sCompanyNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
if key = vk_return then btn_SearchClick(self);

end;

procedure TfmCompanyAdmin.ed_scompanycodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = vk_return then btn_SearchClick(self);

end;

procedure TfmCompanyAdmin.FormShow(Sender: TObject);
begin
  cmbPGTypeLoad(cmb_spgGroup);
  cmbPGTypeLoad(cmb_pgGroup,False);
  //LoadCompanyGubun(cmb_sCompanyGubun,sCompanyGubunList);
  LoadCompanyCode(cmb_sCompany,'000',sCompanyCodeList);
  LoadJijumCode(cmb_sJijum,'000',sJijumCodeList);
  LoadDepartCode(cmb_sDepart,'000','000',sDepartCodeList);
  
  LoadCompanyCode(cmb_Company,'000',CompanyCodeList,False);
  LoadJijumCode(cmb_Jijum,'000',JijumCodeList,False);
  LoadDepartCode(cmb_Depart,'000','000',DepartCodeList,False);
  LoadControlerType(cmb_ControlerType,ControlerTypeList,False);
  LoadControlerRomType(cmb_ControlerRomType,ControlerRomTypeList,False);
  LoadCardReaderType(cmb_CardReaderType,CardReaderTypeList,False);
  ShowCompanyID('');

end;

procedure TfmCompanyAdmin.LoadCompanyGubun(cmb_Box: TComboBox;TempList:TStringList;
  bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_COMPANYGUBUN ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('CG_NAME').AsString );
      TempList.Add(FindField('CG_CODE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.LoadCompanyCode(cmb_Box: TComboBox;aCompanyGubunCode:string;
  TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_COMPANY ';
  //if aCompanyGubunCode <> '000' then
  stSql := stSql + ' Where CG_CODE > ''004'' ';  //고객사

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('CO_NAME').AsString );
      TempList.Add(FindField('CO_COMPANYCODE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.LoadJijumCode(cmb_Box: TComboBox;
  aCompanyCode: string; TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_JIJUM ';
  if aCompanyCode = '000' then Exit;
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + aCompanyCode + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('CO_JIJUMNAME').AsString );
      TempList.Add(FindField('CO_JIJUMCODE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.LoadDepartCode(cmb_Box: TComboBox; aCompanyCode,
  aJijumCode: string; TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_DEPART ';
  if aJijumCode = '000' then Exit;
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + aCompanyCode + ''' ';
  stSql := stSql + ' AND CO_JIJUMCODE = ''' + aJijumCode + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('CO_DEPARTNAME').AsString );
      TempList.Add(FindField('CO_DEPARTCODE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.cmb_sCompanyGubunChange(Sender: TObject);
begin
  LoadCompanyCode(cmb_sCompany,'004',sCompanyCodeList);
  LoadJijumCode(cmb_sJijum,'000',sJijumCodeList);
  LoadDepartCode(cmb_sDepart,'000','000',sDepartCodeList);
  ShowCompanyID('');

end;

procedure TfmCompanyAdmin.cmb_sCompanyChange(Sender: TObject);
begin
  LoadJijumCode(cmb_sJijum,sCompanyCodeList.Strings[cmb_sCompany.itemIndex],sJijumCodeList);
  LoadDepartCode(cmb_sDepart,'000','000',sDepartCodeList);
  ShowCompanyID('');

end;

procedure TfmCompanyAdmin.cmb_sJijumChange(Sender: TObject);
begin
  LoadDepartCode(cmb_sDepart,sCompanyCodeList.Strings[cmb_sCompany.itemIndex],sJijumCodeList.Strings[cmb_sJijum.itemIndex],sDepartCodeList);
  ShowCompanyID('');

end;

procedure TfmCompanyAdmin.cmb_sDepartChange(Sender: TObject);
begin
  ShowCompanyID('');

end;

procedure TfmCompanyAdmin.cmb_CompanyChange(Sender: TObject);
begin
  if L_bKeyPress then Exit;
  if cmb_Company.itemIndex < 0 then Exit;
  L_nSelectCompanyIndex := cmb_Company.ItemIndex;
  LoadJijumCode(cmb_Jijum,CompanyCodeList.Strings[cmb_Company.itemIndex],JijumCodeList,False);
  LoadDepartCode(cmb_Depart,CompanyCodeList.Strings[cmb_Company.itemIndex],'000',DepartCodeList,False);
end;

procedure TfmCompanyAdmin.cmb_JijumChange(Sender: TObject);
begin
  if cmb_Jijum.itemIndex < 0 then Exit;
  if L_bKeyPress then Exit;
  L_nSelectJijumIndex := cmb_Jijum.ItemIndex;
  LoadDepartCode(cmb_Depart,CompanyCodeList.Strings[cmb_Company.itemIndex],JijumCodeList.Strings[cmb_Jijum.itemIndex],DepartCodeList,False);

end;

procedure TfmCompanyAdmin.LoadCardReaderType(cmb_Box: TComboBox;
  TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_CARDTYPE ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('CA_NAME').AsString );
      TempList.Add(FindField('CA_CARDTYPE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.LoadControlerRomType(cmb_Box: TComboBox;
  TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_DEVICEROM ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('DE_ROMNAME').AsString );
      TempList.Add(FindField('DE_ROMTYPE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.LoadControlerType(cmb_Box: TComboBox;
  TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  if bAll then cmb_Box.Items.Add('전체')
  else cmb_Box.Items.Add('');
  TempList.Add('000');

  cmb_Box.ItemIndex := 0;
  stSql := 'select * from TB_DEVICETYPE ';

  with TempQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then Exit;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('DE_NAME').AsString );
      TempList.Add(FindField('DE_DEVICETYPE').AsString);
      Next;
    end;
  end;
end;

procedure TfmCompanyAdmin.cmb_spgGroupChange(Sender: TObject);
begin
  inherited;
  ShowCompanyID('');

end;

procedure TfmCompanyAdmin.cmb_CompanyKeyPress(Sender: TObject;
  var Key: Char);
var
  i : integer;
  stWriteCompanyName : string;
begin
  inherited;
  stWriteCompanyName := cmb_Company.Text;
  L_bKeyPress := True;
  L_bEnterKey := False;
  if Key <> #13 then exit;
  L_bEnterKey := True;
  L_bKeyPress := False;
  if L_nSelectCompanyIndex > (cmb_Company.Items.Count - 1) then Exit;
  for i:= L_nSelectCompanyIndex + 1 to cmb_Company.Items.Count - 1 do
  begin
    if Pos( UpperCase(stWriteCompanyName),UpperCase(cmb_Company.Items.Strings[i])) > 0 then
    begin
      cmb_Company.ItemIndex := i;
      cmb_Company.Text := cmb_Company.Items.Strings[i];
      break;
    end else L_nSelectCompanyIndex := -1;
  end;
  cmb_CompanyChange(Sender);

end;

procedure TfmCompanyAdmin.cmb_JijumKeyPress(Sender: TObject;
  var Key: Char);
var
  i : integer;
  stWriteJijumName : string;
begin
  inherited;
  stWriteJijumName := cmb_Jijum.Text;
  L_bKeyPress := True;
  L_bEnterKey := False;
  if Key <> #13 then exit;
  L_bEnterKey := True;
  L_bKeyPress := False;
  if L_nSelectJijumIndex > (cmb_Jijum.Items.Count - 1) then Exit;
  for i:= L_nSelectJijumIndex + 1 to cmb_Jijum.Items.Count - 1 do
  begin
    if Pos( UpperCase(stWriteJijumName),UpperCase(cmb_Jijum.Items.Strings[i])) > 0 then
    begin
      cmb_Jijum.ItemIndex := i;
      break;
    end else L_nSelectJijumIndex := -1;
  end;
  cmb_JijumChange(Sender);

end;

procedure TfmCompanyAdmin.cmb_CompanyExit(Sender: TObject);
var
  chKey : char;
begin
  inherited;
  L_bKeyPress := False;
  chKey := char(13);
  if Not L_bEnterKey then
    cmb_CompanyKeyPress(Sender,chKey);
  cmb_CompanyChange(Sender);

end;

procedure TfmCompanyAdmin.cmb_JijumExit(Sender: TObject);
var
  chKey : char;
begin
  inherited;
  L_bKeyPress := False;
  chKey := char(13);
  if Not L_bEnterKey then
    cmb_JijumKeyPress(Sender,chKey);
  cmb_JijumChange(Sender);

end;

procedure TfmCompanyAdmin.MenuItem1Click(Sender: TObject);
begin
  inherited;
  btn_SaveClick(btn_Save);
end;

procedure TfmCompanyAdmin.N1Click(Sender: TObject);
begin
  inherited;
  btn_UpdateClick(btn_Update);
end;

initialization
  RegisterClass(TfmCompanyAdmin);
Finalization
  UnRegisterClass(TfmCompanyAdmin);


end.
