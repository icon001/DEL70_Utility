unit uLottoWinList1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Grids, BaseGrid, AdvGrid, uSubForm, CommandArray;

type
  TfmLottoWinList1 = class(TfmASubForm)
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
  public
    { Public declarations }
  end;

var
  fmLottoWinList1: TfmLottoWinList1;

implementation

uses
  uDataModule,
  uLomosUtil;
    
{$R *.dfm}

procedure TfmLottoWinList1.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoWinList1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmLottoWinList1.LoadSeq(cmb_Box: TComboBox; aFront: Boolean);
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

procedure TfmLottoWinList1.FormCreate(Sender: TObject);
begin
  LoadSeq(cmb_FromSeq,True);
  LoadSeq(cmb_ToSeq,False);
end;

procedure TfmLottoWinList1.btn_SearchClick(Sender: TObject);
begin
  searchLottoWinList1(cmb_FromSeq.Text,cmb_ToSeq.Text);
end;

procedure TfmLottoWinList1.searchLottoWinList1(aFromSeq, aToSeq: string);
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
  gridInit(sg_LottoList,8);

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
      stLottoWin := '';
      stLotto2 := '';
      stWin1Number := '';
      stWin2Number := '';
      stWin3Number := '';
      stWin4Number := '';
      stWin5Number := '';
      for i := 1 to 45 do
      begin
        if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 1 then
        begin
          if stLottoWin <> '' then stLottoWin := stLottoWin + ',';
          stLottoWin := stLottoWin + FillZeroNumber(i,2);
          if (FindField('seq').AsInteger - 1) > 0 then
          begin
            if Pos(FillZeroNumber(i,2),arrLottoList[FindField('seq').AsInteger - 1]) > 0 then
            begin
              if stWin1Number <>  '' then stWin1Number := stWin1Number + ',';
              stWin1Number := stWin1Number + FillZeroNumber(i,2);
            end;
          end;
          if (FindField('seq').AsInteger - 2) > 0 then
          begin
            if Pos(FillZeroNumber(i,2),arrLottoList[FindField('seq').AsInteger - 2]) > 0 then
            begin
              if stWin2Number <>  '' then stWin2Number := stWin2Number + ',';
              stWin2Number := stWin2Number + FillZeroNumber(i,2);
            end;
          end;
          if (FindField('seq').AsInteger - 3) > 0 then
          begin
            if Pos(FillZeroNumber(i,2),arrLottoList[FindField('seq').AsInteger - 3]) > 0 then
            begin
              if stWin3Number <>  '' then stWin3Number := stWin3Number + ',';
              stWin3Number := stWin3Number + FillZeroNumber(i,2);
            end;
          end;
          if (FindField('seq').AsInteger - 4) > 0 then
          begin
            if Pos(FillZeroNumber(i,2),arrLottoList[FindField('seq').AsInteger - 4]) > 0 then
            begin
              if stWin4Number <>  '' then stWin4Number := stWin4Number + ',';
              stWin4Number := stWin4Number + FillZeroNumber(i,2);
            end;
          end;
          if (FindField('seq').AsInteger - 5) > 0 then
          begin
            if Pos(FillZeroNumber(i,2),arrLottoList[FindField('seq').AsInteger - 5]) > 0 then
            begin
              if stWin5Number <>  '' then stWin5Number := stWin5Number + ',';
              stWin5Number := stWin5Number + FillZeroNumber(i,2);
            end;
          end;
        end else if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 2 then stLotto2 := FillZeroNumber(i,2);
      end;
      arrLottoList[FindField('seq').AsInteger] := stLottoWin;
      with sg_LottoList do
      begin
        cells[0,nRow] := FindField('seq').AsString;
        cells[1,nRow] := stLottoWin;
        cells[2,nRow] := stLotto2;
        cells[3,nRow] := stWin1Number;
        cells[4,nRow] := stWin2Number;
        cells[5,nRow] := stWin3Number;
        cells[6,nRow] := stWin4Number;
        cells[7,nRow] := stWin5Number;
      end;
      inc(nRow);
      Next;
    end;
  end;

end;

procedure TfmLottoWinList1.btn_ExcelClick(Sender: TObject);
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

procedure TfmLottoWinList1.FormShow(Sender: TObject);
begin
  inherited;
  btn_SearchClick(self);
end;

initialization
  RegisterClass(TfmLottoWinList1);
Finalization
  UnRegisterClass(TfmLottoWinList1);

end.
