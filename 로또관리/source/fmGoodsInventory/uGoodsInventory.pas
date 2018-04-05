unit uGoodsInventory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, Grids, BaseGrid, AdvGrid, DB, ADODB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset,ActiveX;

type
  TfmGoodsInventory = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    dt_FromDate: TDateTimePicker;
    dt_toDate: TDateTimePicker;
    Label1: TLabel;
    btn_Search: TBitBtn;
    btn_Close: TSpeedButton;
    sg_GoodsInventory: TAdvStringGrid;
    TempQuery: TZQuery;
    Label6: TLabel;
    cmb_Group: TComboBox;
    cmb_Company: TComboBox;
    Label7: TLabel;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmb_GroupChange(Sender: TObject);
    procedure cmb_CompanyChange(Sender: TObject);
  private
    ASGroupCodeList : TStringList;
    sCompanyCodeList :TStringList;
    procedure LoadGroupCode;
    procedure LoadCompanyCode(cmb_Box:TComboBox;aCompanyGubunCode:string;TempList:TStringList;bAll:Boolean = True);
    { Private declarations }
    procedure sg_GoodsInventoryInitialize;
  public
    { Public declarations }
  end;

var
  fmGoodsInventory: TfmGoodsInventory;

implementation
uses
  uDataModule;

{$R *.dfm}

procedure TfmGoodsInventory.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmGoodsInventory.btn_SearchClick(Sender: TObject);
var
  stSql : string;
  nRow : integer;
begin
  stSql := ' Select a.GL_CODE,b.GL_NAME,b.GL_STORECOUNT, ';
  stSql := stSql + ' sum(a.INCOUNT) as INCOUNT,';
  stSql := stSql + ' sum(a.OUTCOUNT) as OUTCOUNT,';
  stSql := stSql + ' sum(a.NOTINCOUNT) as NOTINCOUNT ';
  stSql := stSql + ' From TB_GOODSLIST b ';
  stSql := stSql + ' Left Join ( ';
  stSql := stSql + ' select GL_CODE,';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN SL_INOUTGUBUN = ''1'' THEN SL_COUNT ';
  stSql := stSql + ' ELSE 0 ';
  stSql := stsql + ' END AS INCOUNT, ';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN SL_INOUTGUBUN = ''2'' THEN ';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN SL_DELIVERYSTATE <> ''5'' THEN SL_COUNT ';
  stSql := stSql + ' ELSE 0 ';
  stSql := stSql + ' END ';
  stSql := stSql + ' ELSE 0 ';
  stSql := stsql + ' END AS OUTCOUNT, ';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN SL_DELIVERYGUBUN = ''2'' THEN ';
  stSql := stSql + ' CASE ';
  stSql := stSql + ' WHEN SL_DELIVERYSTATE = ''4'' THEN SL_COUNT ';
  stSql := stSql + ' ELSE 0 ';
  stSql := stSql + ' END ';
  stSql := stSql + ' ELSE 0 ';
  stSql := stsql + ' END AS NOTINCOUNT ';
  stSql := stSql + ' from TB_STORELIST ';
  stSql := stSql + ' Where SL_DATE Between ''' + FormatDateTime('yyyymmdd',dt_FromDate.Date) + ''' ';
  stSql := stSql + ' AND ''' + FormatDateTime('yyyymmdd',dt_toDate.Date) + ''' ';
  stSql := stSql + ' ) a ';
  stSql := stSql + ' ON (a.GL_CODE = b.GL_CODE) ';
  if cmb_Company.ItemIndex < 0 then Exit;
  stSql := stSql + ' Where b.CO_COMPANYCODE = ''' + sCompanyCodeList.Strings[cmb_Company.ItemIndex] + ''' ';
  if cmb_Group.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND b.AG_CODE = ''' + ASGroupCodeList.Strings[cmb_Group.ItemIndex] + ''' ';
  end; 
  stSql := stSql + ' GROUP BY a.GL_CODE,b.GL_NAME,b.GL_STORECOUNT ';
  stSql := stSql + ' Order by a.GL_CODE ';
  
  sg_GoodsInventoryInitialize;

  with sg_GoodsInventory do
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
      if recordCount < 1 then Exit;
      nRow :=1 ;
      rowCount := recordCount + 1;
      While Not Eof do
      begin
        cells[0,nRow] := FindField('GL_NAME').AsString;
        cells[1,nRow] := inttostr(FindField('INCOUNT').asinteger);
        cells[2,nRow] := inttostr(FindField('OUTCOUNT').asinteger);
        cells[3,nRow] := inttostr(FindField('NOTINCOUNT').asinteger);
        cells[4,nRow] := inttostr(FindField('INCOUNT').asinteger - FindField('OUTCOUNT').asinteger);
        cells[5,nRow] := inttostr(FindField('GL_STORECOUNT').asinteger);
        inc(nRow);
        Next;
      end;
    end;
  end;

end;

procedure TfmGoodsInventory.sg_GoodsInventoryInitialize;
begin
  with sg_GoodsInventory do
  begin
    Clear;
    Rowcount := 2;
    cells[0,0] := '¹°Ç°¸í';
    cells[1,0] := 'ÀÔ°í°¹¼ö';
    cells[2,0] := 'Ãâ°í°¹¼ö';
    cells[3,0] := '¹Ì¼ö°Å°¹¼ö';
    cells[4,0] := '±â°£º°Àç°í°¹¼ö';
    cells[5,0] := 'ÃÑÀç°í°¹¼ö';

  end;
end;

procedure TfmGoodsInventory.FormShow(Sender: TObject);
begin
  dt_toDate.Date := Now - 30;
  dt_toDate.Date := Now;
  LoadGroupCode;
  LoadCompanyCode(cmb_Company,'000',sCompanyCodeList);
  btn_SearchClick(self);
end;

procedure TfmGoodsInventory.FormCreate(Sender: TObject);
begin
    ASGroupCodeList := TStringList.Create;
    sCompanyCodeList := TStringList.Create;

end;

procedure TfmGoodsInventory.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    ASGroupCodeList.Free;
    sCompanyCodeList.free;

end;

procedure TfmGoodsInventory.LoadCompanyCode(cmb_Box: TComboBox;
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

procedure TfmGoodsInventory.LoadGroupCode;
var
  stSql : string;
  i : integer;
  TempAdoQuery : TZQuery;
begin

  ASGroupCodeList.Clear;
  cmb_Group.Clear;
  ASGroupCodeList.Add('000');
  cmb_Group.Items.Add('ÀüÃ¼');
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

procedure TfmGoodsInventory.cmb_GroupChange(Sender: TObject);
begin
  btn_SearchClick(self);
end;

procedure TfmGoodsInventory.cmb_CompanyChange(Sender: TObject);
begin
  btn_SearchClick(self);
end;

end.
