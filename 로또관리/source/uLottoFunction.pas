unit uLottoFunction;

interface
uses
  SysUtils,
  uDataModule,
  uLomosUtil;


    function GetNotWinLottoNum(aSeq,aDiff:integer;var aCount:integer):string;
    function DeleteTB_NOTWINLOTTO(aSeq:integer):Boolean;
    function InsertIntoTB_NOTWINLOTTO_Seq(aSeq:integer):Boolean;
    function UpdateTB_NOTWINLOTTO_string(aSeq,aField,aValue:string):Boolean;
    function UpdateTB_NOTWINLOTTO_int(aSeq,aField,aValue:string):Boolean;
implementation

function GetNotWinLottoNum(aSeq,aDiff:integer;var aCount:integer):string;
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

    with dmDB.ZTempQuery do
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
function DeleteTB_NOTWINLOTTO(aSeq:integer):Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Delete from TB_NOTWINLOTTO where seq = ' + inttostr(aSeq);

  result := dmDB.ProcessExecSQL(stSql);

end;
function InsertIntoTB_NOTWINLOTTO_Seq(aSeq:integer):Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' insert into TB_NOTWINLOTTO(seq) values(' + inttostr(aSeq) + ')';

  result := dmDB.ProcessExecSQL(stSql);

end;
function UpdateTB_NOTWINLOTTO_string(aSeq,aField,aValue:string):Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' update TB_NOTWINLOTTO set ' + aField + '= ''' + aValue + ''' ';
  stSql := stSql + ' Where seq = ' + aSeq ;

  result := dmDB.ProcessExecSQL(stSql);

end;

function UpdateTB_NOTWINLOTTO_int(aSeq,aField,aValue:string):Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' update TB_NOTWINLOTTO set ' + aField + '= ' + aValue + ' ';
  stSql := stSql + ' Where seq = ' + aSeq ;

  result := dmDB.ProcessExecSQL(stSql);

end;
end.
