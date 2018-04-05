unit uDataModule;

interface

uses
  SysUtils, Classes, DB, ADODB,ActiveX, ZConnection, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

const
  LINEEND = #13;  //클라이언트에서 한문장의 끝을 알리는 데이터값
  DATADELIMITER = '^';

type
  TdmDB = class(TDataModule)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZTempQuery: TZQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    Function DBConnect(aIp,aPort,aDataBase,aUser,aUserPw:string):Boolean;
    Function ProcessExecSQL(aSql:String): Boolean;
  end;

var
  dmDB: TdmDB;
  Master_ID : string;
  Master_TYPE : string;
  Master_Name : string;
  ExeFolder: String;
  ReceiveTelNumber : String;
  G_stServerIP : string;
  G_stServerPort : string;

implementation

{$R *.dfm}

{ TDataModule1 }

function TdmDB.DBConnect(aIp, aPort, aDataBase, aUser,
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

function TdmDB.ProcessExecSQL(aSql: String): Boolean;
var
  ExecQuery :TZQuery;
begin
  Result:= False;
  OleInitialize(nil);
  ExecQuery := TZQuery.Create(nil);
  ExecQuery.Connection := ZConnection1;
  with ExecQuery do
  begin
    Close;
    //SQL.Clear;
    SQL.Text:= aSql;
    try
      ExecSQL;
    except
    ON E: Exception do
      begin
//        ADOConnection.Connected := False;
//        ADOConnection.Connected := True;
//        SQLErrorLog('DBError:'+ SQL.Text);
        ExecQuery.Free;
        OleUninitialize;
        //ADOConnection.RollbackTrans;
        Exit;
      end
    end;
  end;
  ExecQuery.Free;
  OleUninitialize;
  Result:= True;
end;

end.
