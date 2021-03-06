unit uLottoWinList4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Grids, BaseGrid, AdvGrid, uSubForm, CommandArray, ExtCtrls,
  Gauges;

type
  TfmLottoWinList4 = class(TfmASubForm)
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
    function CheckNextLotto(aSeq:integer):Boolean;
  public
    { Public declarations }
  end;

var
  fmLottoWinList4: TfmLottoWinList4;

implementation

uses
  uDataModule,
  uLomosUtil;
    
{$R *.dfm}

procedure TfmLottoWinList4.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoWinList4.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmLottoWinList4.LoadSeq(cmb_Box: TComboBox; aFront: Boolean);
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

procedure TfmLottoWinList4.FormCreate(Sender: TObject);
begin
  LoadSeq(cmb_FromSeq,True);
  LoadSeq(cmb_ToSeq,False);
end;

procedure TfmLottoWinList4.btn_SearchClick(Sender: TObject);
begin
  searchLottoWinList1(cmb_FromSeq.Text,cmb_ToSeq.Text);
end;

procedure TfmLottoWinList4.searchLottoWinList1(aFromSeq, aToSeq: string);
var
  stSql : string;
  i,j : integer;
  nRow : integer;
  nLastSeq : integer;
  arrWinNumberseqList: Array [0..45] of integer; //최종 나온 회차 등록
  arrWinNumberTotList: Array [0..45] of integer; //최종 나온 회차 등록
  nDiff : integer;
  nDiffSeq : integer; //시작회차와 마지막회차의 구간
  nAvr : integer;
  nPer : integer;
begin
  nDiffSeq := strtoint(aToSeq) - strtoint(aFromSeq);
  GridInitialize(sg_LottoList);
  for i := 0 to 45 do
  begin
    arrWinNumberseqList[i] := 0;
    arrWinNumberTotList[i] := 0;
  end;
  with  sg_LottoList do
  begin
    RowCount := 46;
    for i := 1 to 45 do
    begin
      cells[0,i] := Fillzeronumber(i,2);
      for j := 1 to ColCount - 1 do
      begin
        cells[j,i] := '0';
      end;
    end;
  end;


  stSql := ' select * from lotto ';
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

    While Not Eof do
    begin
      with sg_LottoList do
      begin
        nLastSeq := FindField('seq').AsInteger;
        for i := 1 to 45 do
        begin
          if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 1 then
          begin
            nDiff := nLastSeq - arrWinNumberseqList[i];
            if ndiff > 20 then
            begin
              nDiff:= 20;
            end;
            cells[nDiff,i] := inttostr(strtoint(cells[nDiff,i]) + 1);
            arrWinNumberseqList[i] := nLastSeq;
            arrWinNumberTotList[i] := arrWinNumberTotList[i] + 1;
          end
        end;
      end;
      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;
      Next;
    end;
  end;
  nLastSeq := nLastSeq + 1;
  for i := 1 to 45 do
  begin
    sg_LottoList.cells[21,i] := inttostr(arrWinNumberTotList[i]);
    if strtoint(sg_LottoList.cells[21,i]) = 0 then nAvr := 0
    else nAvr := nDiffSeq div strtoint(sg_LottoList.cells[21,i]);
    sg_LottoList.cells[22,i]:= inttostr(nAvr);
    nDiff := nLastSeq - arrWinNumberseqList[i];
    if nDiff > 20 then nDiff := 20;
    if strtoint(sg_LottoList.cells[21,i]) = 0 then nPer := 0
    else nPer := (strtoint(sg_LottoList.cells[nDiff,i]) * 100) div strtoint(sg_LottoList.cells[21,i]);
    sg_LottoList.cells[23,i] := FillzeroNumber(nPer,2) + '%';
  end;
  if CheckNextLotto(nLastSeq) then
  begin
  end;
  Gauge1.Visible := False;

end;

procedure TfmLottoWinList4.btn_ExcelClick(Sender: TObject);
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

procedure TfmLottoWinList4.FormShow(Sender: TObject);
begin
  inherited;
  //btn_SearchClick(self);
end;

function TfmLottoWinList4.GetNotWinLottoNum(aSeq, aDiff: integer;var aCount:integer): string;
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

function TfmLottoWinList4.CheckNextLotto(aSeq: integer): Boolean;
var
  stSql : string;
  i : integer;
begin
  result := False;
  stSql := 'Select * from lotto where seq = ' + inttostr(aSeq);

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
    First;
    for i:=1 to 45 do
    begin
      if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 1 then sg_LottoList.cells[24,i] := '1';
    end;

  end;


end;

initialization
  RegisterClass(TfmLottoWinList4);
Finalization
  UnRegisterClass(TfmLottoWinList4);

end.
