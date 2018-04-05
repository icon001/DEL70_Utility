unit uOutGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, DB, ADODB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset,ActiveX;

type
  TfmOutGoods = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    dt_Date: TDateTimePicker;
    Label1: TLabel;
    cmb_GoodsList: TComboBox;
    ed_GoodsCount: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    ed_customername: TEdit;
    ed_customerphone: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ed_customeraddr: TEdit;
    ed_customerperson: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    ed_DELIVERYCOMPANY: TEdit;
    Label9: TLabel;
    ed_DELIVERYNUM: TEdit;
    Label10: TLabel;
    cmb_DELIVERYGUBUN: TComboBox;
    Label11: TLabel;
    cmb_ProcessState: TComboBox;
    btn_Save: TBitBtn;
    btn_Delete: TBitBtn;
    btn_Close: TSpeedButton;
    cmb_Certifi: TComboBox;
    Label12: TLabel;
    TempQuery: TZQuery;
    cmb_Group: TComboBox;
    Label13: TLabel;
    ed_zip: TEdit;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmb_GroupChange(Sender: TObject);
  private
    ASGroupCodeList : TStringList;
    GoodsCodeList:TStringList;
    CertiCodeList:TStringList;
    { Private declarations }
    procedure LoadGroupCode;
    procedure LoadGoodsList;
    procedure LoadCertiCodeList;
    procedure InsertTB_GOODSINOUTLIST;
    procedure UpdateTB_GOODSINOUTLIST;
    function UpdateTB_GOODSLISTOutCountAdd(aGoodsCode,aGoodsCount:string):Boolean;
    function UpdateTB_GOODSLISTOutCountSub(aGoodsCode,aGoodsCount:string):Boolean;
    function UpdateTB_GoodslistOutCountDelete:Boolean;
    procedure FormClear;
  public
    L_stType : string;
    L_stGoodsSeq : string;
    L_stGoodsCode : string;
    L_stCERTICode : string;
    L_stDate: string;
    L_stTime : string;
    L_stCompanyCode : string;
    L_stGoodsCount : string;
    L_stSeq : string;
    { Public declarations }
  end;

var
  fmOutGoods: TfmOutGoods;

implementation
uses
  uDataModule,
  uLomosUtil;

{$R *.dfm}

{ TfmOutGoods }

procedure TfmOutGoods.LoadGoodsList;
var
  stSql : string;
  stGroupCode : string;
begin
  cmb_GoodsList.Clear;
  cmb_GoodsList.Items.Add('');
  cmb_GoodsList.ItemIndex := 0;
  GoodsCodeList.Clear;
  GoodsCodeList.Add('');
  stSql := 'select * from TB_GOODSLIST ';
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + L_stCompanyCode + ''' ';
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
      GoodsCodeList.Add(FindField('GL_CODE').AsString);
      cmb_GoodsList.Items.Add(FindField('GL_NAME').AsString);
      Next;
    end;
  end;

end;

procedure TfmOutGoods.FormCreate(Sender: TObject);
begin
  GoodsCodeList := TStringList.Create;
  GoodsCodeList.Clear;
  CertiCodeList := TStringList.Create;
  CertiCodeList.Clear;
  ASGroupCodeList := TStringList.Create;
end;

procedure TfmOutGoods.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOutGoods.FormShow(Sender: TObject);
var
  nIndex : integer;
begin
  LoadGroupCode;
  LoadGoodsList;
  LoadCertiCodeList;
  if L_stType = 'INSERT' then
  begin
    dt_Date.Date := Now;
    btn_Save.Caption := '출고';
    btn_Delete.Visible := False;
  end else
  begin
    cmb_Group.Enabled := False;
    cmb_GoodsList.Enabled := False;
    ed_GoodsCount.Text := L_stGoodsCount;
    dt_Date.Date := strtodate(copy(L_stDate,1,4) + '-' + copy(L_stDate,5,2) + '-' + copy(L_stDate,7,2));
    btn_Save.Caption := '수정';
    btn_Delete.Visible := True;
    nIndex := GoodsCodeList.IndexOf(L_stGoodsCode);
    if nIndex > 0 then
    begin
      cmb_GoodsList.ItemIndex := nIndex;
    end;
    nIndex := CertiCodeList.IndexOf( L_stCERTICode);
    if nIndex > 0 then
    begin
      cmb_Certifi.ItemIndex := nIndex;
    end;
  end;
end;

procedure TfmOutGoods.btn_SaveClick(Sender: TObject);
begin
  if L_stType = 'INSERT' then
  begin
    InsertTB_GOODSINOUTLIST;
  end else
  begin
    UpdateTB_GOODSINOUTLIST;
  end;

end;

procedure TfmOutGoods.InsertTB_GOODSINOUTLIST;
var
  stSql : string;
  stOutDate : string;
  stGoodsCode : string;
  stGoodsCount : string;
  stCeritCode : string;
begin
  stOutDate := FormatDateTime('yyyymmdd',dt_Date.Date);
  if cmb_GoodsList.ItemIndex < 1 then
  begin
    showmessage('출고 물품을 선택하셔야 합니다.');
    Exit;
  end;
  stGoodsCode := GoodsCodeList.Strings[cmb_GoodsList.ItemIndex];
  if Not IsDigit(ed_GoodsCount.Text) then
  begin
    showmessage('물품갯수는 숫자만 입력 가능 합니다.');
    Exit;
  end;
  stGoodsCount := ed_GoodsCount.Text;

  stCeritCode := '';
  if cmb_Certifi.itemIndex > 0 then
  stCeritCode := CertiCodeList.Strings[cmb_Certifi.itemIndex];

  stSql := ' Insert Into TB_STORELIST( ';
  stSql := stSql + ' CO_COMPANYCODE,';
  stSql := stSql + ' SL_DATE,';
  stSql := stSql + ' SL_TIME,';
  stSql := stSql + ' GL_CODE,';
  stSql := stSql + ' SL_INOUTGUBUN,';
  stSql := stSql + ' SL_DELIVERYGUBUN,';
  stSql := stSql + ' SL_DELIVERYSTATE,';
  stSql := stSql + ' GC_CERTICODE,';
  stSql := stSql + ' SL_COUNT,';
  stSql := stSql + ' SL_CUSTOMER,';
  stSql := stSql + ' SL_CUSTOMERTEL,';
  stSql := stSql + ' SL_CUSTOMERZIP,';
  stSql := stSql + ' SL_CUSTOMERADDR,';
  stSql := stSql + ' SL_CUSTOMERMANAGER,';
  stSql := stSql + ' SL_DELIVERYCOMPANY,';
  stSql := stSql + ' SL_DELIVERYNUM,';
  stSql := stSql + ' SL_REQUESTID,';
  stSql := stSql + ' SL_LASTDATE,';
  stSql := stSql + ' MA_USERID';
  stSql := stSql + ' )';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' + L_stCompanyCode + ''',';
  stSql := stSql + '''' + stOutDate + ''',';
  stSql := stSql + '''' + FormatDateTime('hhnnss',now) + ''',';
  stSql := stSql + '''' + stGoodsCode + ''',';
  stSql := stSql + '''2'',';   //출고
  stSql := stSql + '''' + copy(cmb_DELIVERYGUBUN.Text,1,1) + ''',';
  stSql := stSql + '''' + copy(cmb_ProcessState.Text,1,1) + ''',';
  stSql := stSql + '''' + stCeritCode + ''',';
  stSql := stSql + '' + stGoodsCount + ',';
  stSql := stSql + '''' + ed_customername.text + ''',';
  stSql := stSql + '''' + ed_customerphone.Text + ''',';
  stSql := stSql + '''' + ed_zip.Text + ''',';
  stSql := stSql + '''' + ed_customeraddr.Text + ''',';
  stSql := stSql + '''' + ed_customerperson.Text + ''', ';
  stSql := stSql + '''' + ed_DELIVERYCOMPANY.Text + ''', ';
  stSql := stSql + '''' + ed_DELIVERYNUM.Text + ''', ';
  stSql := stSql + '''' + Master_ID + ''', ';
  stSql := stSql + '''' + FormatDateTime('yyyymmddhhnnss',now) + ''', ';
  stSql := stSql + '''' + Master_ID + ''') ';

  if dmDB.ProcessExecSQL(stSql) then
  begin
    UpdateTB_GOODSLISTOutCountAdd(stGoodsCode,stGoodsCount);
    FormClear;
  end else
  begin
    showmessage('데이터 저장 실패');
  end;
end;

procedure TfmOutGoods.UpdateTB_GOODSINOUTLIST;
var
  stSql : string;
  stOutDate : string;
  stGoodsCode : string;
  stGoodsCount : string;
  stCeritCode : string;
  nChangeGoodsCount : integer;
begin
  stOutDate := FormatDateTime('yyyymmdd',dt_Date.Date);
  if cmb_GoodsList.ItemIndex < 1 then
  begin
    showmessage('출고 물품을 선택하셔야 합니다.');
    Exit;
  end;
  stGoodsCode := GoodsCodeList.Strings[cmb_GoodsList.ItemIndex];
  if Not IsDigit(ed_GoodsCount.Text) then
  begin
    showmessage('물품갯수는 숫자만 입력 가능 합니다.');
    Exit;
  end;
  stGoodsCount := ed_GoodsCount.Text;
  stCeritCode := '';
  if cmb_Certifi.itemIndex > 0 then
  stCeritCode := CertiCodeList.Strings[cmb_Certifi.itemIndex];

  stSql := ' Update TB_STORELIST set ';
  stSql := stSql + ' SL_DATE = ''' + stOutDate + ''',';
  stSql := stSql + ' SL_DELIVERYGUBUN = ''' + copy(cmb_DELIVERYGUBUN.Text,1,1) + ''',';
  stSql := stSql + ' SL_DELIVERYSTATE = ''' + copy(cmb_ProcessState.Text,1,1) + ''',';
  stSql := stSql + ' GC_CERTICODE = ''' + stCeritCode + ''',';
  stSql := stSql + ' SL_COUNT = ' + stGoodsCount + ',';
  stSql := stSql + ' SL_CUSTOMER = ''' + ed_customername.text + ''',';
  stSql := stSql + ' SL_CUSTOMERTEL = ''' + ed_customerphone.Text + ''',';
  stSql := stSql + ' SL_CUSTOMERZIP = ''' + ed_zip.Text + ''',';
  stSql := stSql + ' SL_CUSTOMERADDR = ''' + ed_customeraddr.Text + ''',';
  stSql := stSql + ' SL_CUSTOMERMANAGER = ''' + ed_customerperson.Text + ''', ';
  stSql := stSql + ' SL_DELIVERYCOMPANY = ''' + ed_DELIVERYCOMPANY.Text + ''',';
  stSql := stSql + ' SL_DELIVERYNUM = ''' + ed_DELIVERYNUM.Text + ''',';
  stSql := stSql + ' SL_LASTDATE = ''' + FormatDateTime('yyyymmddhhnnss',now) + ''', ';
  stSql := stSql + ' MA_USERID = ''' + Master_ID + ''' ';
  stSql := stSql + ' Where SEQ = ' + L_stSeq + ' ';
  {stSql := stSql + ' AND GL_CODE = ''' + L_stGoodsCode + ''' ';
  stSql := stSql + ' AND SL_DATE = ''' + L_stDate + ''' ';
  stSql := stSql + ' AND SL_TIME = ''' + L_stTime + ''' '; }

  if dmDB.ProcessExecSQL(stSql) then
  begin                                  
    nChangeGoodsCount := strtoint(stGoodsCount) - strtoint(L_stGoodsCount);
    if nChangeGoodsCount < 0 then UpdateTB_GOODSLISTOutCountSub(L_stGoodsCode,inttostr(nChangeGoodsCount))
    else if nChangeGoodsCount > 0 then UpdateTB_GOODSLISTOutCountAdd(L_stGoodsCode,inttostr(nChangeGoodsCount));
    Close;
  end else
  begin
    showmessage('데이터 저장 실패');
  end;
end;

procedure TfmOutGoods.FormClear;
begin
  cmb_GoodsList.ItemIndex := 0;
  cmb_DELIVERYGUBUN.ItemIndex := 1;
  cmb_ProcessState.ItemIndex := 1;
  ed_GoodsCount.Text := '1';
  ed_customername.Text := '';
  ed_customerphone.Text := '';
  ed_customeraddr.Text := '';
  ed_customerperson.Text := '';
  ed_DELIVERYCOMPANY.Text := '';
  ed_DELIVERYNUM.Text := '';
end;

procedure TfmOutGoods.btn_DeleteClick(Sender: TObject);
var
  stSql : string;
begin
  stSql := 'Delete From TB_STORELIST ';
  stSql := stSql + ' Where SEQ = ' + L_stSeq + ' ';
  {stSql := stSql + ' AND GL_CODE = ''' + L_stGoodsCode + ''' ';
  stSql := stSql + ' AND SL_DATE = ''' + L_stDate + ''' ';
  stSql := stSql + ' AND SL_TIME = ''' + L_stTime + ''' ';
  stSql := stSql + ' AND SL_INOUTGUBUN = ''2'' ';    }

  if dmDB.ProcessExecSQL(stSql) then
  begin
    UpdateTB_GoodslistOutCountDelete;
    Close;
  end else
  begin
    showmessage('삭제에 실패하였습니다.');
  end;

end;

procedure TfmOutGoods.LoadCertiCodeList;
var
  stSql : string;
begin
  cmb_Certifi.Clear;
  cmb_Certifi.Items.Add('');
  cmb_Certifi.ItemIndex := 0;
  CertiCodeList.Clear;
  CertiCodeList.Add('');
  stSql := 'select * from TB_GOODSCERTIFICATE ';

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
      CertiCodeList.Add(FindField('GC_CERTICODE').AsString);
      cmb_Certifi.Items.Add(FindField('GC_CERTINAME').AsString) ;
      Next;
    end;
  end;
end;

procedure TfmOutGoods.LoadGroupCode;
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

procedure TfmOutGoods.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ASGroupCodeList.Free;
  GoodsCodeList.Free;
  CertiCodeList.Free;
end;

procedure TfmOutGoods.cmb_GroupChange(Sender: TObject);
begin
  LoadGoodsList;
end;

function TfmOutGoods.UpdateTB_GOODSLISTOutCountAdd(aGoodsCode,
  aGoodsCount: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_GOODSLIST Set GL_STORECOUNT = GL_STORECOUNT - ' + aGoodsCount ;
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + L_stCompanyCode + ''' ';
  stSql := stSql + ' AND GL_CODE = ''' + aGoodsCode + ''' ';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmOutGoods.UpdateTB_GOODSLISTOutCountSub(aGoodsCode,
  aGoodsCount: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_GOODSLIST Set GL_STORECOUNT = GL_STORECOUNT ' + aGoodsCount ;
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + L_stCompanyCode + ''' ';
  stSql := stSql + ' AND GL_CODE = ''' + aGoodsCode + ''' ';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmOutGoods.UpdateTB_GoodslistOutCountDelete: Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_GOODSLIST Set GL_STORECOUNT = GL_STORECOUNT + ' + L_stGoodsCount ;
  stSql := stSql + ' Where CO_COMPANYCODE = ''' + L_stCompanyCode + ''' ';
  stSql := stSql + ' AND GL_CODE = ''' + L_stGoodsCode + ''' ';

  result := dmDB.ProcessExecSQL(stSql);

end;

end.
