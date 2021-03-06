unit uLottoExtractCompar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Math, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TfmLottoExtractCompar = class(TForm)
    Panel1: TPanel;
    btn_Extract: TButton;
    btn_Close: TButton;
    btn_stop: TButton;
    TempQuery: TZQuery;
    Label1: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_ExtractClick(Sender: TObject);
  private
    { Private declarations }
    L_bStop : Boolean;
    L_nCount : int64;
    function ExtractLotto(var aSeq:string) : Boolean;
    function CheckLottoWinNumber(aLottoNum:string;var aSeq:string):Boolean;
  public
    { Public declarations }
  end;

var
  fmLottoExtractCompar: TfmLottoExtractCompar;

implementation
uses
  uLomosUtil,
  uDataModule;
{$R *.dfm}

procedure TfmLottoExtractCompar.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLottoExtractCompar.btn_stopClick(Sender: TObject);
begin
  L_bStop := True;
end;

procedure TfmLottoExtractCompar.btn_ExtractClick(Sender: TObject);
var
  stSeq : string;
  bResult : Boolean;
begin
  Try
    btn_Extract.Enabled := False;
    L_nCount := 1;
    L_bStop := False;
    bResult := False;
    memo2.Lines.Clear;
    While True do
    begin
      bResult := ExtractLotto(stSeq);
      if bResult then break;
      if L_bStop then Exit;
      L_nCount := L_nCount + 1;
      Label1.Caption := inttostr(L_nCount);
      if L_nCount > 8000000 then Exit;
      Application.ProcessMessages;
    end;
    if bResult then
    begin
      memo1.Lines.Add('[' + inttostr(L_nCount) + ']' + stSeq);
    end else
    begin
      memo1.Lines.Add('800만번 돌렸는데 안나옴 - 로직 에러');
    end;
  Finally
    btn_Extract.Enabled := True;
  end;
end;

function TfmLottoExtractCompar.ExtractLotto(var aSeq:string): Boolean;
var
  i : integer;
  Lotto45List : TStringList;
  nRandom : integer;
  stLottoNum : string;
  WinLottoList : TStringList;
begin
  result := False;
  Try
    stLottoNum := '';
    Lotto45List := TStringList.Create;
    WinLottoList := TStringList.Create;
    WinLottoList.Clear;
    Lotto45List.Clear;
    for i := 1 to 45 do
    begin
      Lotto45List.Add(FillZeroNumber(i,2));
    end;
    for i:= 1 to 6 do
    begin
      Randomize;
      nRandom:= Random(Lotto45List.Count);
      WinLottoList.Add(Lotto45List.Strings[nRandom]);
      Lotto45List.Delete(nRandom);
    end;
    WinLottoList.Sort;
    for i := 0 to WinLottoList.Count - 1 do
    begin
      if stLottoNum <> '' then stLottoNum := stLottoNum + ',';
      stLottoNum := stLottoNum + WinLottoList.Strings[i];
    end;
    memo2.Lines.Add(stLottoNum);
    result := CheckLottoWinNumber(stLottoNum,aSeq);
  Finally
    WinLottoList.Free;
    Lotto45List.Free;
  End;

end;

function TfmLottoExtractCompar.CheckLottoWinNumber(aLottoNum: string;
  var aSeq: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Select * from TB_NOTWINLOTTO where lottonumber = ''' + aLottoNum + ''' ';

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
    aSeq := FindField('seq').asstring;
    result := True;
  end;

end;

end.
