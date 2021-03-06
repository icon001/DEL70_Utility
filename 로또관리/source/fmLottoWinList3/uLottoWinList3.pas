unit uLottoWinList3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Grids, BaseGrid, AdvGrid, uSubForm, CommandArray, ExtCtrls,
  Gauges;

type
  TfmLottoWinList3 = class(TfmASubForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    btn_Search: TSpeedButton;
    btn_Close: TSpeedButton;
    btn_Excel: TSpeedButton;
    cmb_FromSeq: TComboBox;
    cmb_ToSeq: TComboBox;
    sg_LottoList: TAdvStringGrid;
    TempQuery: TZQuery;
    SaveDialog1: TSaveDialog;
    NotWinQuery1: TZQuery;
    rg_gubun: TRadioGroup;
    Gauge1: TGauge;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_ExcelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSeq(cmb_Box:TComboBox;aFront:Boolean);
    procedure searchLottoWinList1(aFromSeq,aToSeq:string);
    function GetNotWinLottoNum(aSeq,aDiff:integer;var aCount:integer):string;
  public
    { Public declarations }
  end;

var
  fmLottoWinList3: TfmLottoWinList3;

implementation

uses
  uDataModule,
  uLomosUtil;
    
{$R *.dfm}

procedure TfmLottoWinList3.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoWinList3.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmLottoWinList3.LoadSeq(cmb_Box: TComboBox; aFront: Boolean);
var
  stSql : string;
begin
  stSql := 'Select * from lotto ';
  stSql := stSql + ' order by seq ';
  cmb_Box.Clear;

  with TempQuery do
  begin
    Close;
    sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      cmb_Box.Items.Add(FindField('seq').AsString);
      Next;
    end;
  end;
  if aFront then cmb_Box.ItemIndex := 0
  else cmb_Box.ItemIndex := cmb_Box.Items.Count - 1;
end;

procedure TfmLottoWinList3.FormCreate(Sender: TObject);
begin
  LoadSeq(cmb_FromSeq,True);
  LoadSeq(cmb_ToSeq,False);
end;

procedure TfmLottoWinList3.btn_SearchClick(Sender: TObject);
begin
  searchLottoWinList1(cmb_FromSeq.Text,cmb_ToSeq.Text);
end;

procedure TfmLottoWinList3.searchLottoWinList1(aFromSeq, aToSeq: string);
var
  stSql : string;
  i : integer;
  nRow : integer;
begin
  gridInit(sg_LottoList,30);

  stSql := ' select * from TB_NOTWINLOTTO ';
  stSql := stSql + ' Where seq between ' + aFromSeq + ' and ' + aToSeq;
  stSql := stSql + ' order by seq ';

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordcount < 1 then Exit;
    Gauge1.Visible := True;
    Gauge1.MaxValue := recordcount;
    Gauge1.Progress := 0;
    nRow := 1;
    sg_LottoList.RowCount := RecordCount + 1;
    While Not Eof do
    begin
      with sg_LottoList do
      begin
        cells[0,nRow] := FindField('seq').AsString;
        cells[1,nRow] := FindField('lottonumber').AsString;
        if rg_gubun.ItemIndex = 1 then
        begin
          for i := 7 to 20 do
          begin
            cells[(i - 6) * 2,nRow] := FindField('not' + inttostr(i) + 'number').AsString;
            cells[((i - 6) * 2) + 1,nRow] := FindField('win' + inttostr(i) + 'number').AsString;
          end;
        end else
        begin
          for i := 7 to 20 do
          begin
            cells[(i - 6) * 2,nRow] := FindField('not' + inttostr(i) + 'numbercount').AsString;
            cells[((i - 6) * 2) + 1,nRow] := FindField('win' + inttostr(i) + 'numbercount').AsString;
          end;
        end;
      end;
      inc(nRow);
      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;
      Next;
    end;
  end;
  Gauge1.Visible := False;

end;

procedure TfmLottoWinList3.btn_ExcelClick(Sender: TObject);
var
  stSaveFileName : string;
begin
  inherited;
  SaveDialog1.DefaultExt:= 'CSV';
  SaveDialog1.Filter := 'Text files (*.CSV)|*.CSV';
  SaveDialog1.FileName := '당첨내역';
  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;
    if stSaveFileName <> '' then
    begin
      sg_LottoList.SaveToCSV(stSaveFileName);
      //showmessage('파일생성 완료');
    end;
  end;

end;

procedure TfmLottoWinList3.FormShow(Sender: TObject);
begin
  inherited;
  //btn_SearchClick(self);
end;

function TfmLottoWinList3.GetNotWinLottoNum(aSeq, aDiff: integer;var aCount:integer): string;
var
  stResult :string;
  arrLottoList: Array [0..45] of integer;
  stSql : string;
  i : integer;
begin
  stResult := '';
  aCount := 0;
  for i:= 0 to 45 do
  begin
    arrLottoList[i] := 0;
  end;
  stSql := 'select * from lotto where seq between ' + inttostr(aSeq - aDiff) + ' and ' + inttostr(aSeq - 1);

  Try
    with NotWinQuery1 do
    begin
      close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      While not Eof do
      begin
        for i:=1 to 45 do
        begin
          if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 1 then arrLottoList[i] := 1;
        end;
        Next;
      end;
      for i:= 1 to 45 do
      begin
        if arrLottoList[i] = 0 then
        begin
          if stResult <> '' then stResult := stResult + ',';
          stResult := stResult + FillZeroNumber(i,2);
          aCount := aCount + 1;
        end;
      end;
    end;
  Finally
    result := stResult;
  End;
end;

initialization
  RegisterClass(TfmLottoWinList3);
Finalization
  UnRegisterClass(TfmLottoWinList3);

end.
