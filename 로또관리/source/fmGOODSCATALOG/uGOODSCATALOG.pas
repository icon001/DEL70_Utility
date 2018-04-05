unit uGOODSCATALOG;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, ADODB, Grids, BaseGrid, AdvGrid,
  Gauges, ExtCtrls,iniFiles,ComObj, ZAbstractRODataset, ZAbstractDataset,
  ZDataset,ActiveX;

type
  TfmGOODSCATALOG = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label9: TLabel;
    btn_Search: TBitBtn;
    cmb_GoodsList: TComboBox;
    cmb_inOut: TComboBox;
    Label2: TLabel;
    cmb_OutType: TComboBox;
    Label3: TLabel;
    cmb_ProcessState: TComboBox;
    Label4: TLabel;
    dt_FromDate: TDateTimePicker;
    dt_toDate: TDateTimePicker;
    btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    btn_Insert: TSpeedButton;
    btn_Out: TSpeedButton;
    btn_static: TSpeedButton;
    sg_GoodsInoutList: TAdvStringGrid;
    btn_Excel: TSpeedButton;
    pan_gauge: TPanel;
    Label23: TLabel;
    Gauge1: TGauge;
    SaveDialog1: TSaveDialog;
    Label5: TLabel;
    ed_CustomerName: TEdit;
    TempQuery: TZQuery;
    cmb_Group: TComboBox;
    Label6: TLabel;
    cmb_Company: TComboBox;
    Label7: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_ExcelClick(Sender: TObject);
    procedure btn_InsertClick(Sender: TObject);
    procedure sg_GoodsInoutListDblClick(Sender: TObject);
    procedure btn_OutClick(Sender: TObject);
    procedure btn_staticClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmb_CompanyChange(Sender: TObject);
    procedure cmb_GroupChange(Sender: TObject);
    procedure cmb_GoodsListChange(Sender: TObject);
    procedure cmb_inOutChange(Sender: TObject);
    procedure cmb_OutTypeChange(Sender: TObject);
    procedure cmb_ProcessStateChange(Sender: TObject);
  private
    ASGroupCodeList : TStringList;
    sCompanyCodeList :TStringList;
    GoodsList : TStringList;
    { Private declarations }
    procedure LoadGroupCode;
    procedure LoadCompanyCode(cmb_Box:TComboBox;aCompanyGubunCode:string;TempList:TStringList;bAll:Boolean = True);
    procedure LoadGoodsList(aCompanyCode:string);
    procedure ShowInOutGoodsList(aSeq:string;aTopRow:integer=0);
    procedure sg_GoodsInoutListInitialize;
    Function ExcelPrintOut(StringGrid:TAdvStringGrid;refFileName,SaveFileName:String;FileOut:Boolean;ExcelRowStart:integer;stTitle:string;bRowHeader,bColHeader:Boolean):Boolean;
  public
    { Public declarations }
  end;

var
  fmGOODSCATALOG: TfmGOODSCATALOG;

implementation
uses
  uDataModule,
  uLomosUtil, uInGoods, uOutGoods, uGoodsInventory;

{$R *.dfm}

procedure TfmGOODSCATALOG.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ASGroupCodeList.Free;
  sCompanyCodeList.Free;
  GoodsList.Free;
  
  Action := caFree;
end;

procedure TfmGOODSCATALOG.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmGOODSCATALOG.FormShow(Sender: TObject);
begin
  LoadGroupCode;
  LoadCompanyCode(cmb_Company,'000',sCompanyCodeList);
  LoadGoodsList('000');
  sg_GoodsInoutListInitialize;
  dt_FromDate.Date := now - 30;
  dt_toDate.Date := now;
end;

procedure TfmGOODSCATALOG.LoadGoodsList(aCompanyCode:string);
var
  stSql : string;
  stGroupCode : string;
begin
  cmb_GoodsList.Clear;
  GoodsList.Clear;
  cmb_GoodsList.Items.Add('전체');
  cmb_GoodsList.ItemIndex := 0;
  GoodsList.Add('');
  
  if aCompanyCode = '' then Exit;
  if aCompanyCode = '000' then Exit;
  stSql := 'select * from TB_GOODSLIST ';
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + aCompanyCode + ''' ';
  if cmb_Group.ItemIndex > 0 then
  begin
    stGroupCode := ASGroupCodeList.Strings[cmb_Group.ItemIndex];
    stSql := stSql + ' AND AG_CODE = ''' + stGroupCode + ''' ';
  end;

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    while Not Eof do
    begin
      GoodsList.Add(FindField('GL_CODE').AsString);
      cmb_GoodsList.Items.Add(FindField('GL_NAME').AsString);
      Next;
    end;
  end;


end;

procedure TfmGOODSCATALOG.btn_SearchClick(Sender: TObject);
begin
  ShowInOutGoodsList('');
end;

procedure TfmGOODSCATALOG.ShowInOutGoodsList(aSeq:string;aTopRow: integer = 0);
var
  stSql : string;
  nRow : integer;
  nIncount : integer;
  nOutCount : integer;
  stTemp : string;
begin
  sg_GoodsInoutListInitialize;

  nIncount := 0;
  nOutCount := 0;

  stSql := ' select a.SEQ,a.SL_DATE,a.SL_TIME,a.GL_CODE,b.GL_NAME,a.SL_INOUTGUBUN, ';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN a.SL_INOUTGUBUN = ''1'' THEN ''입고'' ';
  stSql := stSql + ' WHEN a.SL_INOUTGUBUN = ''2'' THEN ''출고'' ';
  stSql := stSql + ' ELSE '' '' ';
  stSql := stSql + ' END as INOUTGUBUN, ';
  stSql := stSql + ' a.SL_COUNT,b.GL_UNIT,a.SL_CUSTOMER,';
  stSql := stSql + ' a.SL_CUSTOMERTEL,a.SL_CUSTOMERADDR,a.SL_CUSTOMERMANAGER,';
  stSql := stSql + ' a.SL_DELIVERYCOMPANY,a.SL_DELIVERYNUM,a.SL_DELIVERYGUBUN,';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN a.SL_DELIVERYGUBUN = ''1'' THEN ''신규판매'' ';
  stSql := stSql + ' WHEN a.SL_DELIVERYGUBUN = ''2'' THEN ''기기교체'' ';
  stSql := stSql + ' ELSE '' '' ';
  stSql := stSql + ' END as DELIVERYGUBUN, ';
  stSql := stSql + ' a.SL_DELIVERYSTATE,';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN a.SL_DELIVERYSTATE = ''1'' THEN ''발송요청'' ';
  stSql := stSql + ' WHEN a.SL_DELIVERYSTATE = ''2'' THEN ''접수'' ';
  stSql := stSql + ' WHEN a.SL_DELIVERYSTATE = ''3'' THEN ''발송중'' ';
  stSql := stSql + ' WHEN a.SL_DELIVERYSTATE = ''4'' THEN ''발송완료'' ';
  stSql := stSql + ' WHEN a.SL_DELIVERYSTATE = ''5'' THEN ''수거완료'' ';
  stSql := stSql + ' ELSE '' '' ';
  stSql := stSql + ' END as DELIVERYSTATE,a.GC_CERTICODE,c.GC_CERTINAME,a.SL_CUSTOMERZIP ';
  stSql := stSql + ' from TB_STORELIST a ';
  stSql := stSql + ' Inner Join TB_GOODSLIST b ';
  stSql := stSql + ' ON ( a.CO_COMPANYCODE = b.CO_COMPANYCODE  ';
  stSql := stSql + ' AND a.GL_CODE = b.GL_CODE ) ';
{  stSql := stSql + ' Inner Join TB_ASGROUP d ';
  stSql := stSql + ' ON ( b.AG_CODE = d.AG_CODE) ';  }
  stSql := stSql + ' Left Join TB_GOODSCERTIFICATE c ';
  stSql := stSql + ' ON ( a.GC_CERTICODE = c.GC_CERTICODE ) ';
  stSql := stSql + ' Where a.SL_DATE Between ''' + FormatDateTime('yyyymmdd',dt_FromDate.date) + ''' ';
  stSql := stSql + ' AND ''' + FormatDateTime('yyyymmdd',dt_toDate.date) + ''' ';
  stSql := stSql + ' AND a.CO_COMPANYCODE = ''' + sCompanyCodeList.Strings[cmb_Company.itemIndex] + ''' ';
  if cmb_GoodsList.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.GL_CODE = ''' + GoodsList.Strings[cmb_GoodsList.itemIndex] + ''' ';
  end else
  begin
    if cmb_Group.ItemIndex > 0 then
    begin
      stSql := stSql + ' AND b.AG_CODE = ''' + ASGroupCodeList.Strings[cmb_Group.ItemIndex] + ''' ';
    end;
  end;
  if cmb_inOut.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.SL_INOUTGUBUN = ''' + copy(cmb_inOut.Text,1,1) + ''' ';
  end;
  if cmb_OutType.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.SL_DELIVERYGUBUN = ''' + copy(cmb_OutType.Text,1,1) + ''' ';
  end;
  if cmb_ProcessState.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.SL_DELIVERYSTATE = ''' + copy(cmb_ProcessState.Text,1,1) + ''' ';
  end;
  if Trim(ed_CustomerName.Text) <> '' then
  begin
    stSql := stSql + ' AND a.SL_CUSTOMER Like ''%' + Trim(ed_CustomerName.Text) + '%'' ';
  end;
  stSql := stSql + ' order by a.SL_DATE DESC,a.SL_TIME DESC';

  with sg_GoodsInoutList do
  begin
    with TempQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordCount = 0 then Exit;
      nRow :=1 ;
      rowCount := recordCount + 1;
      While Not Eof do
      begin
        stTemp := FindField('SL_DATE').AsString;
        cells[0,nRow] := FindField('SL_DATE').AsString;
        cells[1,nRow] := FindField('SL_TIME').AsString;
        cells[2,nRow] := FindField('GL_NAME').AsString;
        cells[3,nRow] := FindField('INOUTGUBUN').AsString;
        cells[4,nRow] := inttostr(FindField('SL_COUNT').asinteger);
        if cells[3,nRow] = '입고' then nIncount := nIncount + FindField('SL_COUNT').asinteger
        else nOutCount := nOutCount + FindField('SL_COUNT').asinteger;
        cells[5,nRow] := FindField('GL_UNIT').AsString;
        cells[6,nRow] := FindField('SL_CUSTOMER').AsString;
        cells[7,nRow] := FindField('SL_CUSTOMERTEL').AsString;
        cells[8,nRow] := FindField('SL_CUSTOMERADDR').AsString;
        cells[9,nRow] := FindField('SL_CUSTOMERMANAGER').AsString;
        cells[10,nRow] := FindField('SL_DELIVERYCOMPANY').AsString;
        cells[11,nRow] := FindField('SL_DELIVERYNUM').AsString;
        cells[12,nRow] := FindField('DELIVERYGUBUN').AsString;
        cells[13,nRow] := FindField('DELIVERYSTATE').AsString;
        cells[14,nRow] := FindField('GL_CODE').AsString;
        cells[15,nRow] := FindField('SL_INOUTGUBUN').AsString;
        cells[16,nRow] := FindField('SL_DELIVERYGUBUN').AsString;
        cells[17,nRow] := FindField('SL_DELIVERYSTATE').AsString;
        cells[18,nRow] := FindField('GC_CERTINAME').AsString;
        cells[19,nRow] := FindField('GC_CERTICODE').AsString;
        cells[20,nRow] := FindField('SL_CUSTOMERZIP').AsString;
        cells[21,nRow] := inttostr(FindField('SEQ').AsInteger);

        if cells[15,nRow] = '1' then
        begin
          RowColor[nRow] := clYellow;
        end else
        begin
          if cells[16,nRow] = '1' then
          begin
            if cells[17,nRow] = '1' then RowColor[nRow] := clBlue;
          end else if cells[16,nRow] = '2' then
          begin
            if cells[17,nRow] = '1' then RowColor[nRow] := clBlue
            else if cells[17,nRow] = '4' then RowColor[nRow] := clRed;
          end;
        end;
        if aSeq = cells[0,nRow] then
        begin
          SelectRows(nRow,1);
        end;
        inc(nRow);
        Next;
      end;
      if aTopRow <> 0 then TopRow := aTopRow;
    end;

    if nIncount <> 0 then
    begin
      rowcount := rowcount + 1;
      cells[3,rowcount-1] := '입고합계';
      cells[4,rowcount-1] := inttostr(nIncount);
    end;
    if nOutcount <> 0 then
    begin
      rowcount := rowcount + 1;
      cells[3,rowcount-1] := '출고합계';
      cells[4,rowcount-1] := inttostr(nOutcount);
    end;
  end;

end;

procedure TfmGOODSCATALOG.sg_GoodsInoutListInitialize;
begin
  with sg_GoodsInoutList do
  begin
    Clear;
    Rowcount := 2;
    cells[0,0] := '날짜';
    cells[1,0] := '시간';
    cells[2,0] := '물품명';
    cells[3,0] := '입/출고구분';
    cells[4,0] := '갯수';
    cells[5,0] := '단위';
    cells[6,0] := '거래처명';
    cells[7,0] := '거래처전화번호';
    cells[8,0] := '거래처주소';
    cells[9,0] := '거래처담당자';
    cells[10,0] := '택배사명';
    cells[11,0] := '택배번호';
    cells[12,0] := '출고타입';
    cells[13,0] := '처리상태';
    cells[14,0] := '물품코드';
    cells[15,0] := '입/출고구분코드';
    cells[16,0] := '출고타입코드';
    cells[17,0] := '처리상태코드';
    cells[18,0] := '인수증상태';
    cells[19,0] := '인수증코드';
    ColWidths[14] := 0;
    ColWidths[15] := 0;
    ColWidths[16] := 0;
    ColWidths[17] := 0;
    ColWidths[19] := 0;
    ColWidths[20] := 0;
  end;
end;

procedure TfmGOODSCATALOG.btn_ExcelClick(Sender: TObject);
var
  stRefFileName,stSaveFileName:String;
  stPrintRefPath : string;
  nExcelRowStart:integer;
  ini_fun : TiniFile;
  aFileName : string;
  stTitle : string;
begin
  btn_Excel.Enabled := False;
  Screen.Cursor:= crHourGlass;
  stTitle := '';
  ini_fun := TiniFile.Create(ExeFolder + '\print.ini');
  stPrintRefPath := ExeFolder + '\' ;
  stPrintRefPath := ini_fun.ReadString('환경설정','PrintRefPath',stPrintRefPath);
  stRefFileName  := ini_fun.ReadString('상품정보','참조파일','GoodsReport.xls');
  stRefFileName := stPrintRefPath + stRefFileName;
  nExcelRowStart := ini_fun.ReadInteger('상품정보','시작위치',6);
  ini_fun.Free;

  aFileName:='상품정보';
  SaveDialog1.FileName := aFileName;
  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;
    if SaveDialog1.FileName <> '' then
      if Not ExcelPrintOut(sg_GoodsInoutList,stRefFileName,stSaveFileName,True,nExcelRowStart,stTitle,False,False) then
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

function TfmGOODSCATALOG.ExcelPrintOut(StringGrid: TAdvStringGrid;
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

procedure TfmGOODSCATALOG.btn_InsertClick(Sender: TObject);
begin
  fmInGoods:= TfmInGoods.Create(Self);
  fmInGoods.L_stType := 'INSERT';
  if cmb_Company.itemIndex > -1 then
    fmInGoods.L_stCompanyCode := sCompanyCodeList.Strings[cmb_Company.itemIndex];
  fmInGoods.SHowmodal;
  fmInGoods.Free;
  ShowInOutGoodsList('',sg_GoodsInoutList.TopRow);

end;

procedure TfmGOODSCATALOG.sg_GoodsInoutListDblClick(Sender: TObject);
begin
  with sg_GoodsInoutList do
  begin
    if cells[15,Row] = '1' then //
    begin
      fmInGoods:= TfmInGoods.Create(Self);
      fmInGoods.L_stType := 'UPDATE';
      if cmb_Company.itemIndex > -1 then
        fmInGoods.L_stCompanyCode := sCompanyCodeList.Strings[cmb_Company.itemIndex];
      fmInGoods.L_stGoodsCode := cells[14,Row];
      fmInGoods.L_stDate := cells[0,Row];
      fmInGoods.L_stTime := cells[1,Row];
      fmInGoods.L_stGoodsCount := cells[4,Row];
      fmInGoods.ed_customername.Text := cells[6,Row];
      fmInGoods.ed_customerphone.Text := cells[7,Row];
      fmInGoods.ed_customeraddr.Text := cells[8,Row];
      fmInGoods.ed_customerperson.Text := cells[9,Row];
      fmInGoods.ed_zip.Text := cells[20,Row];
      fmInGoods.L_stSeq := cells[21,Row];
      fmInGoods.SHowmodal;
      fmInGoods.Free;
      ShowInOutGoodsList(cells[0,Row],sg_GoodsInoutList.TopRow);
    end else
    begin
      fmOutGoods:= TfmOutGoods.Create(Self);
      fmOutGoods.L_stType := 'UPDATE';
      if cmb_Company.itemIndex > -1 then
        fmOutGoods.L_stCompanyCode := sCompanyCodeList.Strings[cmb_Company.itemIndex];
      fmOutGoods.L_stGoodsCode := cells[14,Row];
      fmOutGoods.L_stDate := cells[0,Row];
      fmOutGoods.L_stTime := cells[1,Row];
      fmOutGoods.L_stGoodsCount := cells[4,Row];
      fmOutGoods.L_stCERTICode := cells[19,Row];
      fmOutGoods.ed_GoodsCount.Text := cells[4,Row];
      fmOutGoods.ed_customername.Text := cells[6,Row];
      fmOutGoods.ed_customerphone.Text := cells[7,Row];
      fmOutGoods.ed_customeraddr.Text := cells[8,Row];
      fmOutGoods.ed_customerperson.Text := cells[9,Row];
      if IsDigit(cells[16,Row]) then
        fmOutGoods.cmb_DELIVERYGUBUN.ItemIndex := strtoint(cells[16,Row]);
      if IsDigit(cells[17,Row]) then
        fmOutGoods.cmb_ProcessState.ItemIndex := strtoint(cells[17,Row]);
      fmOutGoods.ed_DELIVERYCOMPANY.Text := cells[10,Row];
      fmOutGoods.ed_DELIVERYNUM.Text := cells[11,Row];
      fmOutGoods.ed_zip.Text := cells[20,Row];
      fmOutGoods.L_stSeq := cells[21,Row];
      fmOutGoods.SHowmodal;
      fmOutGoods.Free;
      ShowInOutGoodsList(cells[0,Row],sg_GoodsInoutList.TopRow);
    end;
  end;
end;

procedure TfmGOODSCATALOG.btn_OutClick(Sender: TObject);
begin
  fmOutGoods:= TfmOutGoods.Create(Self);
  fmOutGoods.L_stType := 'INSERT';
  if cmb_Company.itemIndex > -1 then
    fmOutGoods.L_stCompanyCode := sCompanyCodeList.Strings[cmb_Company.itemIndex];
  fmOutGoods.SHowmodal;
  fmOutGoods.Free;
  ShowInOutGoodsList('',sg_GoodsInoutList.TopRow);  
end;

procedure TfmGOODSCATALOG.btn_staticClick(Sender: TObject);
begin
  fmGoodsInventory:= TfmGoodsInventory.Create(Self);
  fmGoodsInventory.SHowmodal;
  fmGoodsInventory.Free;  

end;

procedure TfmGOODSCATALOG.FormCreate(Sender: TObject);
begin
  ASGroupCodeList := TStringList.Create;
  sCompanyCodeList := TStringList.Create;
  GoodsList := TStringList.Create;
end;

procedure TfmGOODSCATALOG.LoadGroupCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  ASGroupCodeList.Clear;
  cmb_Group.Clear;
  ASGroupCodeList.Add('000');
  cmb_Group.Items.Add('전체');
  cmb_Group.ItemIndex := 0;

  stSql := 'select * from TB_ASGROUP ';
  stSql := stSql + ' order by AG_CODE ';

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
        cmb_Group.Items.Add(FindField('AG_NAME').AsString);
        ASGroupCodeList.Add(FindField('AG_CODE').AsString);
        Next;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmGOODSCATALOG.LoadCompanyCode(cmb_Box: TComboBox;
  aCompanyGubunCode: string; TempList: TStringList; bAll: Boolean);
var
  stSql : string;
begin
  cmb_Box.Clear;
  TempList.Clear;
  stSql := 'select a.* from TB_COMPANY a ';
  stSql := stSql + ' Inner Join (select CO_COMPANYCODE from TB_GOODSLIST GROUP BY CO_COMPANYCODE) b ';
  stSql := stSql + ' ON(a.CO_COMPANYCODE = b.CO_COMPANYCODE) ';
  stSql := stSql + ' order by a.CO_COMPANYCODE ';

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
  cmb_Box.ItemIndex := 0;
end;

procedure TfmGOODSCATALOG.cmb_CompanyChange(Sender: TObject);
var
  stCompanyCode : string;
begin
  stCompanyCode := sCompanyCodeList.Strings[cmb_Company.itemindex];
  LoadGoodsList(stCompanyCode);
  btn_SearchClick(self);
end;

procedure TfmGOODSCATALOG.cmb_GroupChange(Sender: TObject);
var
  stCompanyCode : string;
begin
  stCompanyCode := sCompanyCodeList.Strings[cmb_Company.itemindex];
  LoadGoodsList(stCompanyCode);
  btn_SearchClick(self);
end;

procedure TfmGOODSCATALOG.cmb_GoodsListChange(Sender: TObject);
begin
  btn_SearchClick(self);
end;

procedure TfmGOODSCATALOG.cmb_inOutChange(Sender: TObject);
begin
  btn_SearchClick(self);
end;

procedure TfmGOODSCATALOG.cmb_OutTypeChange(Sender: TObject);
begin
  btn_SearchClick(self);
end;

procedure TfmGOODSCATALOG.cmb_ProcessStateChange(Sender: TObject);
begin
  btn_SearchClick(self);
end;

initialization
  RegisterClass(TfmGOODSCATALOG);
Finalization
  UnRegisterClass(TfmGOODSCATALOG);

end.
