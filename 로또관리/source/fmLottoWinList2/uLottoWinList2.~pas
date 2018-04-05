unit uLottoWinList2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Grids, BaseGrid, AdvGrid, uSubForm, CommandArray;

type
  TfmLottoWinList2 = class(TfmASubForm)
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
    procedure ListInitialize;
  public
    { Public declarations }
  end;

var
  fmLottoWinList2: TfmLottoWinList2;

implementation

uses
  uDataModule,
  uLomosUtil;
    
{$R *.dfm}

procedure TfmLottoWinList2.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoWinList2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmLottoWinList2.LoadSeq(cmb_Box: TComboBox; aFront: Boolean);
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

procedure TfmLottoWinList2.FormCreate(Sender: TObject);
begin
  LoadSeq(cmb_FromSeq,True);
  LoadSeq(cmb_ToSeq,False);
  ListInitialize;
end;

procedure TfmLottoWinList2.btn_SearchClick(Sender: TObject);
begin
  searchLottoWinList1(cmb_FromSeq.Text,cmb_ToSeq.Text);
end;

procedure TfmLottoWinList2.searchLottoWinList1(aFromSeq, aToSeq: string);
var
  stSql : string;
  stLottoWin : string;
  stLotto2 : string;
  stWin1Number : string;
  stWin2Number : string;
  stWin3Number : string;
  stWin4Number : string;
  stWin5Number : string;
  i : integer;
  nRow : integer;
  arrLottoList: Array [0..10000] of string; //10000 건 나올때까지 살수 있을까???
begin
  ListInitialize;

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
    nRow := 1;
    sg_LottoList.RowCount := RecordCount + 1;
    While Not Eof do
    begin
      with sg_LottoList do
      begin
        cells[0,nRow] := FindField('seq').AsString;
        for i := 1 to 45 do
        begin
          if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 1 then
          begin
            Colors[i,nRow] := clBlue;
          end else if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 2 then
          begin
            Colors[i,nRow] := clYellow;
          end else
          begin
            Colors[i,nRow] := clWhite;
          end;
        end;
      end;
      inc(nRow);
      Next;
    end;
  end;

end;

procedure TfmLottoWinList2.btn_ExcelClick(Sender: TObject);
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

procedure TfmLottoWinList2.FormShow(Sender: TObject);
begin
  inherited;
  btn_SearchClick(self);
end;

procedure TfmLottoWinList2.ListInitialize;
var
  i : integer;
begin
  with sg_LottoList do
  begin
    Clear;
    RowCount := 2;
    cells[0,0] := '차수';
    for i := 1 to 45 do
    begin
      cells[i,0] := FillZeroNumber(i,2);
    end;
  end;
end;

initialization
  RegisterClass(TfmLottoWinList2);
Finalization
  UnRegisterClass(TfmLottoWinList2);

end.
