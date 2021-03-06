unit uConversion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection,
  ADODB, Buttons, StdCtrls;

type
  TForm1 = class(TForm)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ADOConnection: TADOConnection;
    ADOTmpQuery: TADOQuery;
    SpeedButton1: TSpeedButton;
    chk_AUTHCOMPANY: TCheckBox;
    chk_AUTHManager: TCheckBox;
    ADOQuery1: TADOQuery;
    ZQuery2: TZQuery;
    chkTB_AUTHMANAGELIST: TCheckBox;
    ZQuerySearch: TZQuery;
    ChkTB_TELLIST: TCheckBox;
    chkTB_GOODSINOUTLIST: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    Function NewDBConnect(aIp,aPort,aDataBase,aUser,aUserPw:string):Boolean;
    Function OldDBConnect(aIp,aPort,aDataBase,aUser,aUserPw:string):Boolean;

    Function TB_AUTHCOMPANYChange:Boolean;
    Function TB_AUTHManagerChange:Boolean;
    Function TB_AUTHMANAGELISTChange:Boolean;
    Function TB_TELLISTChange : Boolean;
    Function TELNUMBERChange(aSabun,aCOMPANYID,aMANAGERID:string):Boolean;
    Function chkTB_GOODSINOUTLISTChange : Boolean;
  private
    Function GetPersonID(aTelNo:string):string;
  private
    Function InsertNewTB_AUTHCOMPANY(aCOMPANYID,aCPNAME,aCPPHONE,aCPFAX,
                              aCPADDR1,aCPADDR2,aCPPGTYPE,aREGDATE,
                              aAUTHKEY,aMEMO:string):Boolean;
    Function InsertNewTB_PERSON(aSabun,aUSERNAME,aPOSI,aEMAIL1,aEMAIL2,aETC:string):Boolean;
    Function InsertNewTB_TELNUM(aSabun,aTELNO,aGUBUN:string):Boolean;
    Function InsertNewTB_QNALIST(aDATE,aTIME,aTELNO,aQUESTION,aDATA,aQnACODE,aConsultTYPE,aCUSTOMERNAME,aPersonID:string):Boolean;
    Function InsertNewTB_TELLIST(aDATE,aTIME,aTELNUM:string):Boolean;
    Function InsertNewTB_STORELIST(aDATE,aCode,aTime,aINOUTGUBUN,aDELIVERYGUBUN,
                         aDELIVERYSTATE,aCERTICODE,aCUSTOMERNAME,aCUSTOMERPERSON,
                         aZip,aCUSTOMERADDR,aCUSTOMERPHONE,aDELIVERYCOMPANY,
                         aDELIVERYNUM,aCOUNT:string):Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uLomosUtil;

{$R *.dfm}

{ TForm1 }

function TForm1.chkTB_GOODSINOUTLISTChange: Boolean;
var
  stSql : string;
  stCode : string;
begin
  stSql := 'Select * from TB_GOODSINOUTLIST ';
  stSql := stSql + ' order by GL_SEQ';
  with ADOTmpQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      stCode := '000';
      if FindField('GC_CODE').AsString = '001' then stCode := '001'
      else if FindField('GC_CODE').AsString = '002' then stCode := '011'
      else if FindField('GC_CODE').AsString = '003' then stCode := '401'
      else if FindField('GC_CODE').AsString = '004' then stCode := '501'
      else if FindField('GC_CODE').AsString = '005' then stCode := '432'
      else if FindField('GC_CODE').AsString = '006' then stCode := '431'
      else if FindField('GC_CODE').AsString = '007' then stCode := '021'
      else if FindField('GC_CODE').AsString = '008' then stCode := '901'
      else if FindField('GC_CODE').AsString = '009' then stCode := '902'
      else if FindField('GC_CODE').AsString = '010' then stCode := '502'
      else if FindField('GC_CODE').AsString = '011' then stCode := '903';

      InsertNewTB_STORELIST(FindField('GL_DATE').AsString,
                         stCode,
                         FormatDateTime('hhnnss',now),
                         FindField('GL_INOUTGUBUN').AsString,
                         FindField('GL_DELIVERYGUBUN').AsString,
                         FindField('GL_DELIVERYSTATE').AsString,
                         FindField('GC_CERTICODE').AsString,
                         FindField('GL_CUSTOMERNAME').AsString,
                         FindField('GL_CUSTOMERPERSON').AsString,
                         '',
                         FindField('GL_CUSTOMERADDR').AsString,
                         FindField('GL_CUSTOMERPHONE').AsString,
                         FindField('GL_DELIVERYCOMPANY').AsString,
                         FindField('GL_DELIVERYNUM').AsString,
                         inttostr(FindField('GL_COUNT').AsInteger));
      Next;
    end;
  end;

end;

function TForm1.GetPersonID(aTelNo: string): string;
var
  stSql : string;
begin
  aTelNo := StringReplace(aTelNo,'-','',[rfReplaceAll]);
  result := '';
  stSql := 'select * from TB_TELNUM ';
  stSql := stSql + ' Where TE_TELNUMBER = ''' + aTelNo + ''' ';
  stSql := stSql + ' Order by TE_VIEWSEQ DESC ';

  with ZQuerySearch do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 0 then exit;
    First;
    result := FindField('PE_CODE').AsString;
  end;

end;

function TForm1.InsertNewTB_AUTHCOMPANY(aCOMPANYID, aCPNAME, aCPPHONE,
  aCPFAX, aCPADDR1, aCPADDR2, aCPPGTYPE, aREGDATE, aAUTHKEY,
  aMEMO: string): Boolean;
var
  stSql : string;
begin
  aMEMO := StringReplace(aMEMO,'''','''''',[rfReplaceAll]);
  result := False;
  stSql := ' Insert Into TB_AUTHCOMPANY(';
  stSql := stSql + 'AU_COMPANYID,';
  stSql := stSql + 'AU_COMPANYNAME,';
  stSql := stSql + 'AU_PASSWD,';
  stSql := stSql + 'AU_ADDR1,';
  stSql := stSql + 'AU_ADDR2,';
  stSql := stSql + 'AU_TEL,';
  stSql := stSql + 'AU_FAX,';
  stSql := stSql + 'AU_REGDATE,';
  stSql := stSql + 'PG_GUBUNCODE,';
  stSql := stSql + 'AU_MEMO) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' + aCOMPANYID + ''',';
  stSql := stSql + '''' + aCPNAME + ''',';
  stSql := stSql + '''' + aAUTHKEY + ''',';
  stSql := stSql + '''' + aCPADDR1 + ''',';
  stSql := stSql + '''' + aCPADDR2 + ''',';
  stSql := stSql + '''' + aCPPHONE + ''',';
  stSql := stSql + '''' + aCPFAX + ''',';
  stSql := stSql + '''' + aREGDATE + ''',';
  stSql := stSql + '''' + aCPPGTYPE + ''',';
  stSql := stSql + '''' + aMEMO + ''') ';

  with ZQuery1 do
  begin
    Sql.Text := stSql;
    Try
      Execsql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.InsertNewTB_PERSON(aSabun, aUSERNAME, aPOSI, aEMAIL1,
  aEMAIL2, aETC: string): Boolean;
var
  stSql : string;
begin
  aETC := StringReplace(aETC,'''','''''',[rfReplaceAll]);
  result := False;
  stSql := ' Insert Into TB_PERSON(';
  stSql := stSql + 'PE_CODE,';
  stSql := stSql + 'PE_NAME,';
  stSql := stSql + 'PE_POSITIONNAME,';
  stSql := stSql + 'PE_EMAIL1,';
  stSql := stSql + 'PE_EMAIL2,';
  stSql := stSql + 'PE_MEMO) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' + aSabun + ''',';
  stSql := stSql + '''' + aUSERNAME + ''',';
  stSql := stSql + '''' + aPOSI + ''',';
  stSql := stSql + '''' + aEMAIL1 + ''',';
  stSql := stSql + '''' + aEMAIL2 + ''',';
  stSql := stSql + '''' + aETC + ''') ';

  with ZQuery1 do
  begin
    Sql.Text := stSql;
    Try
      Execsql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.InsertNewTB_QNALIST(aDATE, aTIME, aTELNO, aQUESTION, aDATA,
  aQnACODE, aConsultTYPE, aCUSTOMERNAME,aPersonID: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Insert Into TB_QNALIST(';
  stSql := stSql + 'QA_DATE,';
  stSql := stSql + 'QA_TIME,';
  stSql := stSql + 'QA_NAME,';
  stSql := stSql + 'QA_TEL,';
  stSql := stSql + 'QA_TYPE,';
  stSql := stSql + 'CN_TYPE,';
  stSql := stSql + 'QA_SUBJECT,';
  stSql := stSql + 'QA_DATA,';
  stSql := stSql + 'PE_CODE) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' + aDATE + ''',';
  stSql := stSql + '''' + aTIME + ''',';
  stSql := stSql + '''' + aCUSTOMERNAME + ''',';
  stSql := stSql + '''' + aTELNO + ''',';
  stSql := stSql + '''' + aQnACODE + ''',';
  stSql := stSql + '''' + aConsultTYPE + ''',';
  stSql := stSql + '''' + aQUESTION + ''',';
  stSql := stSql + '''' + aDATA + ''',';
  stSql := stSql + '''' + aPersonID + ''') ';

  with ZQuery2 do
  begin
    Sql.Text := stSql;
    Try
      Execsql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.InsertNewTB_STORELIST(aDATE, aCode, aTime, aINOUTGUBUN,
  aDELIVERYGUBUN, aDELIVERYSTATE, aCERTICODE, aCUSTOMERNAME,
  aCUSTOMERPERSON, aZip, aCUSTOMERADDR, aCUSTOMERPHONE, aDELIVERYCOMPANY,
  aDELIVERYNUM, aCOUNT: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Insert Into TB_STORELIST(';
  stSql := stSql + 'CO_COMPANYCODE,';
  stSql := stSql + 'GL_CODE,';
  stSql := stSql + 'SL_DATE,';
  stSql := stSql + 'SL_TIME,';
  stSql := stSql + 'SL_INOUTGUBUN,';
  stSql := stSql + 'SL_DELIVERYGUBUN,';
  stSql := stSql + 'SL_DELIVERYSTATE,';
  stSql := stSql + 'GC_CERTICODE,';
  stSql := stSql + 'SL_CUSTOMER,';
  stSql := stSql + 'SL_CUSTOMERMANAGER,';
  stSql := stSql + 'SL_CUSTOMERZIP,';
  stSql := stSql + 'SL_CUSTOMERADDR,';
  stSql := stSql + 'SL_CUSTOMERTEL,';
  stSql := stSql + 'SL_DELIVERYCOMPANY,';
  stSql := stSql + 'SL_DELIVERYNUM,';
  stSql := stSql + 'SL_COUNT ) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''00001'',';
  stSql := stSql + '''' + aCode + ''',';
  stSql := stSql + '''' + aDATE + ''',';
  stSql := stSql + '''' + aTime + ''',';
  stSql := stSql + '''' + aINOUTGUBUN + ''',';
  stSql := stSql + '''' + aDELIVERYGUBUN + ''',';
  stSql := stSql + '''' + aDELIVERYSTATE + ''',';
  stSql := stSql + '''' + aCERTICODE + ''',';
  stSql := stSql + '''' + aCUSTOMERNAME + ''',';
  stSql := stSql + '''' + aCUSTOMERPERSON + ''',';
  stSql := stSql + '''' + aZip + ''',';
  stSql := stSql + '''' + aCUSTOMERADDR + ''',';
  stSql := stSql + '''' + aCUSTOMERPHONE + ''',';
  stSql := stSql + '''' + aDELIVERYCOMPANY + ''',';
  stSql := stSql + '''' + aDELIVERYNUM + ''',';
  stSql := stSql + '' + aCOUNT + ' ) ';

  with ZQuery2 do
  begin
    Sql.Text := stSql;
    Try
      Execsql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.InsertNewTB_TELLIST(aDATE, aTIME,
  aTELNUM: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Insert Into TB_TELLIST(';
  stSql := stSql + 'TL_TELNUMBER,';
  stSql := stSql + 'TL_DATE,';
  stSql := stSql + 'TL_TIME ) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' +  aTELNUM + ''',';
  stSql := stSql + '''' + aDATE + ''',';
  stSql := stSql + '''' + aTIME + ''') ';

  with ZQuery2 do
  begin
    Sql.Text := stSql;
    Try
      Execsql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.InsertNewTB_TELNUM(aSabun, aTELNO,
  aGUBUN: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Insert Into TB_TELNUM(';
  stSql := stSql + 'TE_TELNUMBER,';
  stSql := stSql + 'TE_GUBUN,';
  stSql := stSql + 'PE_CODE,';
  stSql := stSql + 'TE_VIEWSEQ) ';
  stSql := stSql + ' VALUES(';
  stSql := stSql + '''' + aTELNO + ''',';
  stSql := stSql + '''' + '00' + aGUBUN + ''',';
  stSql := stSql + '''' + aSabun + ''',';
  stSql := stSql + '0) ';

  with ZQuery2 do
  begin
    Sql.Text := stSql;
    Try
      Execsql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.NewDBConnect(aIp, aPort, aDataBase, aUser,
  aUserPw: string): Boolean;
begin
  result := False;
  ZConnection1.Protocol := 'mysql';
  ZConnection1.Database := aDataBase;
  ZConnection1.HostName := aIp;
  ZConnection1.Port := strtoint(aPort);
  ZConnection1.User := aUser;
  ZConnection1.Password := aUserPw;
  try
    ZConnection1.Connect;
  Except
    Exit;
  End;
  result := True;

end;

function TForm1.OldDBConnect(aIp, aPort, aDataBase, aUser,
  aUserPw: string): Boolean;
var
  conStr : string;
begin
  result := False;

  conStr := 'Provider=SQLOLEDB.1;';
  conStr := constr + 'Password=' + aUserPw + ';';
  conStr := constr + 'Persist Security Info=True;';
  conStr := constr + 'User ID=' + aUser + ';';
  conStr := constr + 'Initial Catalog=' + aDataBase + ';';
  conStr := constr + 'Data Source=' + aIp  + ',' + aPort;

  with ADOConnection do
  begin
    Connected := False;
    Try
      ConnectionString := conStr;
      LoginPrompt:= false ;
      Connected := True;
    Except
      on E : EDatabaseError do
        begin
          // ERROR MESSAGE-BOX DISPLAY
          ShowMessage(E.Message );
          Exit;
        end;
      else
        begin
          ShowMessage('데이터베이스 접속 에러' );
          Exit;
        end;
    End;
    CursorLocation := clUseServer;
  end;
  result := True;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if Not NewDBConnect('zeron.able.or.kr','3306','zerp','zeron','zeronpass') then
  begin
    showmessage('mysql 서버접속 에러');
    Exit;
  end;
  if Not OldDBConnect('zeron.co.kr','1433','zeron','zeron','zeronpass') then
  begin
    showmessage('mssql 서버접속 에러');
    Exit;
  end;
  if chk_AUTHCOMPANY.Checked then
  begin
    TB_AUTHCOMPANYChange;
  end;
  if chk_AUTHManager.checked then
  begin
    TB_AUTHManagerChange;
  end;
  if chkTB_AUTHMANAGELIST.Checked then
  begin
    TB_AUTHMANAGELISTChange;
  end;
  if ChkTB_TELLIST.Checked then
  begin
    TB_TELLISTChange;
  end;
  if chkTB_GOODSINOUTLIST.Checked then
  begin
    chkTB_GOODSINOUTLISTChange;
  end;
  showmessage('변경 완료');
end;

function TForm1.TB_AUTHCOMPANYChange: Boolean;
var
  stSql : string;
begin
  stSql := 'select * from TB_AUTHCOMPANY where AC_COMPANYID Like ''Z-%'' ';

  with ADOTmpQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      InsertNewTB_AUTHCOMPANY(FindField('AC_COMPANYID').AsString,
                              FindField('AC_CPNAME').AsString,
                              FindField('AC_CPPHONE').AsString,
                              FindField('AC_CPFAX').AsString,
                              FindField('AC_CPADDR1').AsString,
                              FindField('AC_CPADDR2').AsString,
                              FindField('AC_CPPGTYPE').AsString,
                              FindField('AC_REGDATE').AsString,
                              FindField('AC_AUTHKEY').AsString,
                              FindField('AC_MEMO').AsString);

      Next;
    end;
  end;

end;

function TForm1.TB_AUTHMANAGELISTChange: Boolean;
var
  stSql : string;
  nSabun : integer;
  stPersonID : string;
begin
  stSql := 'Select * from TB_AUTHMANAGELIST ';
  stSql := stSql + ' order by AM_DATE,AM_TIME ';
  nSabun := 1;
  with ADOTmpQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      stPersonID := GetPersonID(FindField('AM_TELNO').AsString);
      InsertNewTB_QNALIST(FindField('AM_DATE').AsString,
                         FindField('AM_TIME').AsString,
                         FindField('AM_TELNO').AsString,
                         FindField('AM_QUESTION').AsString,
                         FindField('AM_DATA').AsString,
                         FindField('AC_CONSULTCODE').AsString,
                         FindField('AC_QNATYPE').AsString,
                         FindField('AM_CUSTOMERNAME').AsString,
                         stPersonID);
      inc(nSabun);
      Next;
    end;
  end;
end;

function TForm1.TB_AUTHManagerChange: Boolean;
var
  stSql : string;
  nSabun : integer;
begin
  stSql := 'Select * from TB_AUTHMANAGER ';
  stSql := stSql + ' order by AC_COMPANYID,AM_MANAGERID ';
  nSabun := 1;
  with ADOTmpQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      InsertNewTB_PERSON(FillZeroNumber(nSabun,10),
                         FindField('AM_USERNAME').AsString,
                         FindField('AM_POSI').AsString,
                         FindField('AM_EMAIL1').AsString,
                         FindField('AM_EMAIL2').AsString,
                         FindField('AM_ETC').AsString);
      TELNUMBERChange(FillZeroNumber(nSabun,10),FindField('AC_COMPANYID').AsString,FindField('AM_MANAGERID').AsString);
      inc(nSabun);
      Next;
    end;
  end;

end;

function TForm1.TB_TELLISTChange: Boolean;
var
  stSql : string;
begin
  stSql := 'Select * from TB_TELLIST ';
  stSql := stSql + ' order by TL_DATE,TL_TIME';
  with ADOTmpQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      InsertNewTB_TELLIST(FindField('TL_DATE').AsString,
                         FindField('TL_TIME').AsString,
                         FindField('TL_TELNUM').AsString);
      Next;
    end;
  end;
   

end;

function TForm1.TELNUMBERChange(aSabun, aCOMPANYID,
  aMANAGERID: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Select * from TB_CUSTOMERID ';
  stSql := stSql + ' Where AC_COMPANYID = ''' + aCompanyID + ''' ';
  stSql := stSql + ' AND AM_MANAGERID = ''' + aManagerID + ''' ';
  with ADOQuery1 do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    While Not Eof do
    begin
      InsertNewTB_TELNUM(aSabun,
                         FindField('CT_TELNO').AsString,
                         FindField('CT_GUBUN').AsString);

      Next;
    end;
  end;
end;

end.
