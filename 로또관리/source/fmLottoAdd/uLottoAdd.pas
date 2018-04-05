unit uLottoAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset;

type
  TfmLottoAdd = class(TForm)
    StaticText1: TStaticText;
    ed_LottoSeq: TEdit;
    StaticText2: TStaticText;
    ed_no1: TEdit;
    ed_no2: TEdit;
    ed_no3: TEdit;
    ed_no4: TEdit;
    ed_no5: TEdit;
    ed_no6: TEdit;
    StaticText3: TStaticText;
    ed_no7: TEdit;
    btn_Save: TSpeedButton;
    SpeedButton1: TSpeedButton;
    TempQuery: TZQuery;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
  private
    { Private declarations }
    Function GetLottoMaxSeq:integer;
    function DeleteToLottoTable(aSeq : string):Boolean;
    function InsertIntoLottoTableSeq(aSeq : string):Boolean;
    function UpdateLottoNumber(aSeq,aNumber,aType:string):Boolean;
  public
    { Public declarations }
  end;

var
  fmLottoAdd: TfmLottoAdd;

implementation

uses
  uDataModule,
  uLomosUtil,
  uLottoFunction;
{$R *.dfm}

procedure TfmLottoAdd.FormCreate(Sender: TObject);
begin
  ed_LottoSeq.Text := inttostr(GetLottoMaxSeq + 1);  
end;

function TfmLottoAdd.GetLottoMaxSeq: integer;
var
  stSql : string;
begin
  result := 0;
  stSql := 'select max(seq) as seq from lotto ';
  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordcount < 0 then Exit;
    result := FindField('seq').AsInteger;
  end;

end;

procedure TfmLottoAdd.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoAdd.btn_SaveClick(Sender: TObject);
var
  arrNotWinNumberList: Array [0..100] of string;
  arrWinNumberList: Array [0..100] of string;
  arrNotWinNumberCountList: Array [0..100] of integer;
  arrWinNumberCountList: Array [0..100] of integer;
  i : integer;
  stLottoWin : string;
begin
  if  Not isdigit(ed_LottoSeq.Text) then
  begin
    showmessage('당첨회차를 입력 하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no1.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no2.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no3.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no4.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no5.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no6.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;
  if  Not isdigit(ed_no7.Text) then
  begin
    showmessage('당첨번호를 입력하세요.');
    Exit;
  end;

  stLottoWin := FillZeroNumber(strtoint(ed_no1.Text),2) + ',' +
                FillZeroNumber(strtoint(ed_no2.Text),2) + ',' +
                FillZeroNumber(strtoint(ed_no3.Text),2) + ',' +
                FillZeroNumber(strtoint(ed_no4.Text),2) + ',' +
                FillZeroNumber(strtoint(ed_no5.Text),2) + ',' +
                FillZeroNumber(strtoint(ed_no6.Text),2);
                
  DeleteToLottoTable(ed_LottoSeq.Text);
  InsertIntoLottoTableSeq(ed_LottoSeq.Text);
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no1.Text,'1');
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no2.Text,'1');
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no3.Text,'1');
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no4.Text,'1');
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no5.Text,'1');
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no6.Text,'1');
  UpdateLottoNumber(ed_LottoSeq.Text,ed_no7.Text,'2');
  
  for i := 0 to 100 do
  begin
    arrNotWinNumberList[i] := '';
    arrWinNumberList[i] := '';
    arrNotWinNumberCountList[i] := 0;
    arrWinNumberCountList[i] := 0;
  end;
  for i := 7 to 20 do
  begin
    arrNotWinNumberList[i] := GetNotWinLottoNum(strtoint(ed_LottoSeq.Text),i,arrNotWinNumberCountList[i]);
    if Pos(FillZeroNumber(strtoint(ed_no1.Text),2),arrNotWinNumberList[i]) > 0 then
    begin
      if arrWinNumberList[i] <> '' then arrWinNumberList[i] := arrWinNumberList[i] + ',';
      arrWinNumberList[i]:= arrWinNumberList[i] + FillZeroNumber(strtoint(ed_no1.Text),2);
      arrWinNumberCountList[i] := arrWinNumberCountList[i] + 1;
    end;
    if Pos(FillZeroNumber(strtoint(ed_no2.Text),2),arrNotWinNumberList[i]) > 0 then
    begin
      if arrWinNumberList[i] <> '' then arrWinNumberList[i] := arrWinNumberList[i] + ',';
      arrWinNumberList[i]:= arrWinNumberList[i] + FillZeroNumber(strtoint(ed_no2.Text),2);
      arrWinNumberCountList[i] := arrWinNumberCountList[i] + 1;
    end;
    if Pos(FillZeroNumber(strtoint(ed_no3.Text),2),arrNotWinNumberList[i]) > 0 then
    begin
      if arrWinNumberList[i] <> '' then arrWinNumberList[i] := arrWinNumberList[i] + ',';
      arrWinNumberList[i]:= arrWinNumberList[i] + FillZeroNumber(strtoint(ed_no3.Text),2);
      arrWinNumberCountList[i] := arrWinNumberCountList[i] + 1;
    end;
    if Pos(FillZeroNumber(strtoint(ed_no4.Text),2),arrNotWinNumberList[i]) > 0 then
    begin
      if arrWinNumberList[i] <> '' then arrWinNumberList[i] := arrWinNumberList[i] + ',';
      arrWinNumberList[i]:= arrWinNumberList[i] + FillZeroNumber(strtoint(ed_no4.Text),2);
      arrWinNumberCountList[i] := arrWinNumberCountList[i] + 1;
    end;
    if Pos(FillZeroNumber(strtoint(ed_no5.Text),2),arrNotWinNumberList[i]) > 0 then
    begin
      if arrWinNumberList[i] <> '' then arrWinNumberList[i] := arrWinNumberList[i] + ',';
      arrWinNumberList[i]:= arrWinNumberList[i] + FillZeroNumber(strtoint(ed_no5.Text),2);
      arrWinNumberCountList[i] := arrWinNumberCountList[i] + 1;
    end;
    if Pos(FillZeroNumber(strtoint(ed_no6.Text),2),arrNotWinNumberList[i]) > 0 then
    begin
      if arrWinNumberList[i] <> '' then arrWinNumberList[i] := arrWinNumberList[i] + ',';
      arrWinNumberList[i]:= arrWinNumberList[i] + FillZeroNumber(strtoint(ed_no6.Text),2);
      arrWinNumberCountList[i] := arrWinNumberCountList[i] + 1;
    end;
  end;
  DeleteTB_NOTWINLOTTO(strtoint(ed_LottoSeq.Text));
  InsertIntoTB_NOTWINLOTTO_Seq(strtoint(ed_LottoSeq.Text));
  UpdateTB_NOTWINLOTTO_string(ed_LottoSeq.Text,'lottonumber',stLottoWin);
  for i := 7 to 20 do
  begin
    UpdateTB_NOTWINLOTTO_string(ed_LottoSeq.Text,'not' + inttostr(i) + 'number',arrNotWinNumberList[i]);
    UpdateTB_NOTWINLOTTO_int(ed_LottoSeq.Text,'not' + inttostr(i) + 'numbercount',inttostr(arrNotWinNumbercountList[i]));
    UpdateTB_NOTWINLOTTO_string(ed_LottoSeq.Text,'win' + inttostr(i) + 'number',arrWinNumberList[i]);
    UpdateTB_NOTWINLOTTO_int(ed_LottoSeq.Text,'win' + inttostr(i) + 'numbercount',inttostr(arrWinNumberCountList[i]));
  end;


end;

function TfmLottoAdd.DeleteToLottoTable(aSeq: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Delete From lotto where seq = ' + aSeq + ' ';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmLottoAdd.InsertIntoLottoTableSeq(aSeq: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Insert into lotto(seq) values(' + aSeq + ') ';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmLottoAdd.UpdateLottoNumber(aSeq, aNumber,
  aType: string): Boolean;
var
  stSql : string;
begin
  if Not isdigit(aNumber) then Exit;
  stSql := 'Update lotto set NO' + FillZeroNumber(strtoint(aNumber),2) + ' = ' + aType ;
  stSql := stSql + ' Where seq = ' + aSeq ;

  result := dmDB.ProcessExecSQL(stSql);

end;

end.
