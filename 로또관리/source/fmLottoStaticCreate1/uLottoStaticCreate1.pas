unit uLottoStaticCreate1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Grids, BaseGrid, AdvGrid, uSubForm, CommandArray, ExtCtrls,
  Gauges;

type
  TfmLottoStaticCreate1 = class(TfmASubForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    btn_create: TSpeedButton;
    btn_Close: TSpeedButton;
    cmb_FromSeq: TComboBox;
    cmb_ToSeq: TComboBox;
    sg_LottoList: TAdvStringGrid;
    TempQuery: TZQuery;
    SaveDialog1: TSaveDialog;
    NotWinQuery1: TZQuery;
    Gauge1: TGauge;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_createClick(Sender: TObject);
    procedure btn_ExcelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSeq(cmb_Box:TComboBox;aFront:Boolean);
    procedure CreateLottoWinList1(aFromSeq,aToSeq:string);
//    function GetNotWinLottoNum(aSeq,aDiff:integer;var aCount:integer):string;
  private
{    function DeleteTB_NOTWINLOTTO(aSeq:integer):Boolean;
    function InsertIntoTB_NOTWINLOTTO_Seq(aSeq:integer):Boolean;
    function UpdateTB_NOTWINLOTTO_string(aSeq,aField,aValue:string):Boolean;
    function UpdateTB_NOTWINLOTTO_int(aSeq,aField,aValue:string):Boolean;
}
  public
    { Public declarations }
  end;

var
  fmLottoStaticCreate1: TfmLottoStaticCreate1;

implementation

uses
  uDataModule,
  uLomosUtil,
  uLottoFunction;
    
{$R *.dfm}

procedure TfmLottoStaticCreate1.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoStaticCreate1.LoadSeq(cmb_Box: TComboBox; aFront: Boolean);
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

procedure TfmLottoStaticCreate1.FormCreate(Sender: TObject);
begin
  LoadSeq(cmb_FromSeq,True);
  LoadSeq(cmb_ToSeq,False);
end;

procedure TfmLottoStaticCreate1.btn_createClick(Sender: TObject);
begin
  CreateLottoWinList1(cmb_FromSeq.Text,cmb_ToSeq.Text);
end;

procedure TfmLottoStaticCreate1.CreateLottoWinList1(aFromSeq, aToSeq: string);
var
  stSql : string;
  stLottoWin : string;
  arrNotWinNumberList: Array [0..100] of string;
  arrWinNumberList: Array [0..100] of string;
  arrNotWinNumberCountList: Array [0..100] of integer;
  arrWinNumberCountList: Array [0..100] of integer;
  i,j : integer;
begin

  stSql := ' select * from lotto ';
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
      stLottoWin := '';
      for i := 0 to 100 do
      begin
        arrNotWinNumberList[i] := '';
        arrWinNumberList[i] := '';
        arrNotWinNumberCountList[i] := 0;
        arrWinNumberCountList[i] := 0;
      end;
      for i := 7 to 20 do
      begin
        arrNotWinNumberList[i] := GetNotWinLottoNum(FindField('seq').AsInteger,i,arrNotWinNumberCountList[i]);
      end;
      for i := 1 to 45 do
      begin
        if FindField('NO' + FillZeroNumber(i,2)).AsInteger = 1 then
        begin
          if stLottoWin <> '' then stLottoWin := stLottoWin + ',';
          stLottoWin := stLottoWin + FillZeroNumber(i,2);
          for j := 7 to 20 do
          begin
            if Pos(FillZeroNumber(i,2),arrNotWinNumberList[j]) > 0 then
            begin
              if arrWinNumberList[j] <> '' then arrWinNumberList[j] := arrWinNumberList[j] + ',';
              arrWinNumberList[j]:= arrWinNumberList[j] + FillZeroNumber(i,2);
              arrWinNumberCountList[j] := arrWinNumberCountList[j] + 1;
            end;
          end;
        end;
      end;
      DeleteTB_NOTWINLOTTO(FindField('seq').AsInteger);
      InsertIntoTB_NOTWINLOTTO_Seq(FindField('seq').AsInteger);
      UpdateTB_NOTWINLOTTO_string(inttostr(FindField('seq').AsInteger),'lottonumber',stLottoWin);
      for i := 7 to 20 do
      begin
        UpdateTB_NOTWINLOTTO_string(inttostr(FindField('seq').AsInteger),'not' + inttostr(i) + 'number',arrNotWinNumberList[i]);
        UpdateTB_NOTWINLOTTO_int(inttostr(FindField('seq').AsInteger),'not' + inttostr(i) + 'numbercount',inttostr(arrNotWinNumbercountList[i]));
        UpdateTB_NOTWINLOTTO_string(inttostr(FindField('seq').AsInteger),'win' + inttostr(i) + 'number',arrWinNumberList[i]);
        UpdateTB_NOTWINLOTTO_int(inttostr(FindField('seq').AsInteger),'win' + inttostr(i) + 'numbercount',inttostr(arrWinNumberCountList[i]));
      end;
      Gauge1.Progress := Gauge1.Progress + 1;
      Application.ProcessMessages;
      Next;
    end;
  end;
  Gauge1.Visible := False;

end;

procedure TfmLottoStaticCreate1.btn_ExcelClick(Sender: TObject);
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

procedure TfmLottoStaticCreate1.FormShow(Sender: TObject);
begin
  inherited;
  //btn_SearchClick(self);
end;
    {
function TfmLottoStaticCreate1.GetNotWinLottoNum(aSeq, aDiff: integer;var aCount:integer): string;
var
  stResult :string;
  arrLottoList: Array [0..45] of integer;
  stSql : string;
  i : integer;
begin
  stResult := '';
  aCount := 0;
  Try
    if (aSeq - aDiff) < 1 then Exit;
    for i:= 0 to 45 do
    begin
      arrLottoList[i] := 0;
    end;
    stSql := 'select * from lotto where seq between ' + inttostr(aSeq - aDiff) + ' and ' + inttostr(aSeq - 1);

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

function TfmLottoStaticCreate1.DeleteTB_NOTWINLOTTO(
  aSeq: integer): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Delete from TB_NOTWINLOTTO where seq = ' + inttostr(aSeq);

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmLottoStaticCreate1.InsertIntoTB_NOTWINLOTTO_Seq(
  aSeq: integer): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' insert into TB_NOTWINLOTTO(seq) values(' + inttostr(aSeq) + ')';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmLottoStaticCreate1.UpdateTB_NOTWINLOTTO_int(aSeq,aField,
  aValue: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' update TB_NOTWINLOTTO set ' + aField + '= ' + aValue + ' ';
  stSql := stSql + ' Where seq = ' + aSeq ;

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmLottoStaticCreate1.UpdateTB_NOTWINLOTTO_string(aSeq,aField,
  aValue: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' update TB_NOTWINLOTTO set ' + aField + '= ''' + aValue + ''' ';
  stSql := stSql + ' Where seq = ' + aSeq ;

  result := dmDB.ProcessExecSQL(stSql);

end; }

end.
