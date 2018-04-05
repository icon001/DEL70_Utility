unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ImgList, ComCtrls, ToolWin,DB,IniFiles,
  antTaskbarIcon, ExtCtrls, MSNPopUp, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer,IdSocketHandle, ADODB, uSubForm, CommandArray,Registry,DateUtils,
  IdTCPConnection, IdTCPClient, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, StdCtrls, OoMisc, AdPort, AdWnPort, Gauges;

type
  TfmMain = class(TfmASubForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mn_Close: TMenuItem;
    mn_LottoStatistic: TMenuItem;
    ToolBar1: TToolBar;
    btn_TotClose: TToolButton;
    Menu_ImageList: TImageList;
    mn_CodeAdmin: TMenuItem;
    mn_LottoCsvLoad: TMenuItem;
    StatusBar1: TStatusBar;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    tbi: TantTaskbarIcon;
    ImageList1: TImageList;
    pmTest: TPopupMenu;
    miShow: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Ver011: TMenuItem;
    MSNPopUp1: TMSNPopUp;
    Image1: TImage;
    N26: TMenuItem;
    N27: TMenuItem;
    N29: TMenuItem;
    AdoConnectCheckTimer1: TTimer;
    N40: TMenuItem;
    TempQuery: TZQuery;
    ConnectCheckQuery: TZQuery;
    checkMemo: TZQuery;
    chkASList: TZQuery;
    N54: TMenuItem;
    WinsockPort1: TApdWinsockPort;
    mn_LottoAdd: TMenuItem;
    OpenDialog1: TOpenDialog;
    Gauge1: TGauge;
    mn_lottoList: TMenuItem;
    mn_lottoList1: TMenuItem;
    mn_lottoList2: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ToolButton1: TToolButton;
    N71: TMenuItem;
    N4: TMenuItem;
    N72: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure mn_CloseClick(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItem2Click(Sender: TObject);
    procedure miShowClick(Sender: TObject);
    procedure tbiDblClick(Sender: TObject);
    procedure MSNPopUp1URLClick(Sender: TObject; URL: String);
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure N23Click(Sender: TObject);
    procedure Action_ConsultReportExecute(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure Action_MemoSendExecute(Sender: TObject);
    procedure Action_ScheduleExecute(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure AdoConnectCheckTimer1Timer(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N39Click(Sender: TObject);
    procedure mn_CompanyGubunClick(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure N44Click(Sender: TObject);
    procedure N45Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N47Click(Sender: TObject);
    procedure N48Click(Sender: TObject);
    procedure N49Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure Action_GoodASListExecute(Sender: TObject);
    procedure N54Click(Sender: TObject);
    procedure WinsockPort1WsConnect(Sender: TObject);
    procedure WinsockPort1WsDisconnect(Sender: TObject);
    procedure WinsockPort1WsError(Sender: TObject; ErrCode: Integer);
    procedure WinsockPort1TriggerAvail(CP: TObject; Count: Word);
    procedure mn_LottoCsvLoadClick(Sender: TObject);
    procedure mn_LottoAddClick(Sender: TObject);
    procedure mn_lottoList1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure btn_TotCloseClick(Sender: TObject);
    procedure mn_lottoList2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N72Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    FLogined: Boolean;
    FPrivileges: String;
    L_bClose : Boolean;
    L_stOldData : string;
    FServerConnected: Boolean;
    L_bApplicationTerminate : Boolean;
    { Private declarations }
    procedure SetLogined(const Value: Boolean);
    procedure SetPrivileges(const Value: String);
    Function CreateWindowStartRegKey(aRegName,aValue:string):Boolean;
    Function DeleteWindowStartRegKey(aRegName:string):Boolean;

    procedure ScheduleAlarmCheck(aDate,aSCHEDULEID,aFROMTIME,aTOTIME,aSUBJECT,
        aCONTENT,aALARMTYPE,aSTARTDAY,aSTARTTIME,aREPEATTIME,aALARMTIME:string);

    procedure ScheduleAlarmShow(aDate,aSCHEDULEID,aFROMTIME,aTOTIME,aSUBJECT,
                      aCONTENT, aALARMTYPE, aSTARTDAY, aSTARTTIME,
                      aREPEATTIME, aALARMTIME:string);
    Function UpdateTB_SCHEDULEAlarmCheck(aDate,aSCHEDULEID,aAlarmTime,aAlarmFinish:string):Boolean;
    procedure SetServerConnected(const Value: Boolean);
  Public
    ModemSendDataList : TStringList;
  private
    ServerComBuff : string;

    procedure DataProcess(aRecvData:string);
    Function GetCustomerName(aTelNo:string;var aCompanyName,aDepartName:string):string;
    Function GetMasterName(aUserID:string):string;
    Function CheckNotConfirmMemo:Boolean;
    Function CheckASList : Boolean;
    Function AdoConnectCheck : Boolean;
  protected
{Detecting Windows Shutdown
To detect Windows Shutdown, you must trap WM_EndSession message. These steps should be taken: Declare a message handling
procedure in your Form's Private section: }
    procedure WMEndSession(var Msg : TWMEndSession); message WM_ENDSESSION;
{Detecting Windows shutdown
When Windows is shutting down, it sends a WM_QueryEndSession to all open applications. To detect (and prevent shutdown), you must
define a message handler to this message. Put this definition on the private section of the main form:}
    procedure WMQueryEndSession(var Msg : TWMQueryEndSession); message WM_QueryEndSession;
    //procedure WndProc(var Message: TMessage); override;
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public declarations }
    Procedure MDIChildShow(FormName:String;bMax:Boolean=True);
    procedure CustomerConsultingView(aTelNumber : string);
    
  Published
    Property Logined : Boolean read FLogined write  SetLogined; //프로퍼티를 생성함으로 Logined라는 변수가 바뀌면 SetLogined 라는 함수가 실행됨
    Property Privileges : String read FPrivileges write SetPrivileges;

    property ServerConnected : Boolean read FServerConnected write SetServerConnected;
  private
    wmTaskbar : word;
    procedure DefaultHandler(var Message);override;
  private
    procedure LottoCsvFileLineAdd(aLine:string);
    function DeleteToLottoTable(aSeq : string):Boolean;
    function InsertIntoLottoTableSeq(aSeq : string):Boolean;
    function UpdateLottoNumber(aSeq,aNumber,aType:string):Boolean;

  end;

var
  fmMain: TfmMain;
  G_stSendTelNum : string;


implementation
uses
  uDataModule,
  uLogin,
  uLomosUtil,
  uProgramType, uQnaType, uAsGroupCode, uGoodsCode,
  uCompanyGubun, uCompanyCode, uJijumCode, uDepartCode, uTelGubunCode,
  uCotrolerType, uCotrolerRomType, uCardReaderType, 
  uSendMemo, uMemoSearch, uMemoSendSearch, uMasterID, uLottoAdd,
  uLottoStaticCreate1, uLottoExtractCompar, uLottoTest;
  
{$R *.dfm}

procedure TfmMain.mn_CloseClick(Sender: TObject);
begin
  L_bClose := True;
  Close;
end;

procedure TfmMain.MDIChildShow(FormName: String;bMax:Boolean=True);
var
  tmpFormClass : TFormClass;
  tmpClass : TPersistentClass;
  tmpForm : TForm;
  clsName : String;
  i : Integer;
begin
  clsName := FormName;
  tmpClass := FindClass(clsName);
  if tmpClass <> nil then
  begin
    for i := 0 to Screen.FormCount - 1 do
    begin
      if Screen.Forms[i].ClassNameIs(clsName) then
      begin
        if Screen.ActiveForm = Screen.Forms[i] then
        begin
          if bMax then Screen.Forms[i].WindowState := wsMaximized;
          Exit;
        end;
        Screen.Forms[i].Show;
        Exit;
      end;
    end;

    tmpFormClass := TFormClass(tmpClass);
    tmpForm := tmpFormClass.Create(Self);
    tmpForm.Show;
  end;
 
end;

procedure TfmMain.N13Click(Sender: TObject);
begin
  fmQnaCode:= TfmQnaCode.Create(Self);
  fmQnaCode.SHowmodal;
  fmQnaCode.Free;
end;

procedure TfmMain.N18Click(Sender: TObject);
begin
   TLogin.GetObject.ShowLoginDlg;
   Master_ID := TLogin.GetObject.UserID;
   Master_Name := TLogin.GetObject.UserName;
   Master_TYPE := TLogin.GetObject.MasterType;
   Logined := TLogin.GetObject.Logined;
end;

procedure TfmMain.SetLogined(const Value: Boolean);
begin
  FLogined := Value;

  if Master_TYPE = '1' then
  begin
    mn_CodeAdmin.Enabled := Value;
  end;
  if Not Value then mn_CodeAdmin.Enabled := Value;
  mn_LottoStatistic.Enabled := Value;
  mn_lottoList.Enabled := Value;
  ToolBar1.Enabled := Value;
  
end;

procedure TfmMain.SetPrivileges(const Value: String);
begin
  FPrivileges := Value;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  LogoFile : string;
begin
  wmTaskbar := RegisterWindowMessage('TaskbarCreated');

  ExeFolder  := ExtractFileDir(Application.ExeName);

  L_bClose := False;
  Logined := False;
  if Not dmDB.DBConnect('zeron.able.or.kr','3306','lotto','lotto','lottopw') then
  begin
    showmessage('프로그램을 이용하시려면 인터넷망에 접속되어야 합니다.');
    Application.Terminate;
  end;

  LogoFile := ExeFolder + '\Logo.JPG';
  if FileExists(LogoFile) then
  Image1.Picture.LoadFromFile(LogoFile);

  AdoConnectCheckTimer1.Enabled := True;
end;

procedure TfmMain.N19Click(Sender: TObject);
begin
  Logined := False;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  L_bApplicationTerminate := True;
end;

procedure TfmMain.MenuItem2Click(Sender: TObject);
begin
  L_bClose := True;
  Close;
end;

procedure TfmMain.miShowClick(Sender: TObject);
begin
  SetForegroundWindow(Application.Handle);
  Visible := True;
end;

procedure TfmMain.tbiDblClick(Sender: TObject);
begin
   SetForegroundWindow(Application.Handle);
   Visible := True;
end;

procedure TfmMain.MSNPopUp1URLClick(Sender: TObject; URL: String);
begin
  SetForegroundWindow(Application.Handle);
  if MSNPopUp1.Title = '[메모]' then
  begin
    fmMemoSearch:= TfmMemoSearch.Create(Self);
    fmMemoSearch.SHow;
  end else if MSNPopUp1.Title = '[AS처리]' then
  begin
    Visible := True;
    MDIChildShow('TfmGOODSASList');
    self.FindClassForm('TfmGOODSASList').FindCommand('AS').Execute;
  end else
  begin
    Visible := True;
    CustomerConsultingView(ReceiveTelNumber);
  end;
end;

procedure TfmMain.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataStringStream: TStringStream;
  RecvData : String;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    RecvData:=DataStringStream.DataString;
    G_stServerIP := ABinding.PeerIP;
  finally
    DataStringStream.Free;
  end;
  if L_stOldData = RecvData then Exit;
  L_stOldData := RecvData;
  DataProcess(RecvData);
end;

procedure TfmMain.DataProcess(aRecvData: string);
var
  stSql : string;
  TempList : TStringList;
  nPos : integer;
  i : integer;
  stTelNo :string;
  stUserID : string;
  stCustomerName : string;
  stCompanyName : string;
  stDepartName : string;
begin

  TempList := TStringList.Create;
  TempList.Delimiter := ',';
  TempList.DelimitedText := aRecvData;
  stTelNo := '';
  stUserID := '';
  if Pos('MEMO',aRecvData) > 0 then  //전송된 메모
  begin
    For i:=0 to TempList.Count - 1 do
    begin
      if Pos('USERID',TempList.Strings[i]) > 0 then  //USERID
      begin
        nPos := Pos('=',TempList.Strings[i]);
        if nPos > 0 then
          stUserID := Trim(copy(TempList.Strings[i],nPos + 1,Length(TempList.Strings[i]) - nPos));
      end else if Pos('SENDID',TempList.Strings[i]) > 0 then  //SENDID;
      begin
        nPos := Pos('=',TempList.Strings[i]);
        if nPos > 0 then
          stTelNo := Trim(copy(TempList.Strings[i],nPos + 1,Length(TempList.Strings[i]) - nPos));
      end;
    end;
    if Master_ID <> stUserID then Exit;
    MSNPopUp1.Title := '[메모]';
    stCustomerName := GetMasterName(stTelNo);
    MSNPopUp1.Text := stTelNo + #10#13 + '[' + stCustomerName + ']' + '님' + #10#13 + '으로 부터 메모가 왔습니다.';
  end else if Pos('SEND',aRecvData) > 0 then  //전송된 메시지
  begin
    For i:=0 to TempList.Count - 1 do
    begin
      if Pos('USERID',TempList.Strings[i]) > 0 then  //USERID
      begin
        nPos := Pos('=',TempList.Strings[i]);
        if nPos > 0 then
          stUserID := Trim(copy(TempList.Strings[i],nPos + 1,Length(TempList.Strings[i]) - nPos));
      end else if Pos('TELNUM',TempList.Strings[i]) > 0 then  //TELNUM;
      begin
        nPos := Pos('=',TempList.Strings[i]);
        if nPos > 0 then
          stTelNo := Trim(copy(TempList.Strings[i],nPos + 1,Length(TempList.Strings[i]) - nPos));
      end;
    end;
    if Master_ID <> stUserID then Exit;
    MSNPopUp1.Title := '[전송]';
    stCustomerName := GetCustomerName(stTelNo,stCompanyName,stDepartName);
    MSNPopUp1.Text := stTelNo + #10#13
                      + '[' + stCompanyName + ']' + #10#13
                      + '[' + stDepartName + ']' + #10#13
                      + '[' + stCustomerName + ']' ; //+ '님' + #10#13 + '으로 부터 전화가 왔습니다.';
  end else
  begin
    For i:=0 to TempList.Count - 1 do
    begin
      if Pos('NMBR',TempList.Strings[i]) > 0 then
      begin
        nPos := Pos('=',TempList.Strings[i]);
        if nPos > 0 then
          stTelNo := Trim(copy(TempList.Strings[i],nPos + 1,Length(TempList.Strings[i]) - nPos));
      end;
    end;
    if stTelNo = '' then Exit;
    MSNPopUp1.Title := '[전화]';
    stCustomerName := GetCustomerName(stTelNo,stCompanyName,stDepartName);
    MSNPopUp1.Text := stTelNo + #10#13
                      + '[' + stCompanyName + ']' + #10#13
                      + '[' + stDepartName + ']' + #10#13
                      + '[' + stCustomerName + ']' ; //+ '님' + #10#13 + '으로 부터 전화가 왔습니다.';
  end;


  ReceiveTelNumber := stTelNo;
  MSNPopUp1.ShowPopUp;
end;

function TfmMain.GetCustomerName(aTelNo: string;var aCompanyName,aDepartName:string): string;
var
  stSql : string;
begin
  aCompanyName := '';
  aDepartName := '';
  result := '';
  stSql := ' select b.PE_NAME,c.CO_NAME,d.CO_JIJUMNAME from ';
  stSql := stSql + ' (select aa.* from TB_TELNUM aa ';
  stSql := stSql + ' Inner Join (select TE_TELNUMBER,MAX(TE_VIEWSEQ) as TE_VIEWSEQ ';
  stSql := stSql + ' From TB_TELNUM Group by TE_TELNUMBER ) bb ';
  stSql := stSql + ' ON (aa.TE_TELNUMBER = bb.TE_TELNUMBER ';
  stSql := stSql + ' AND aa.TE_VIEWSEQ = bb.TE_VIEWSEQ ) ';
  stSql := stSql + ' ) a ';
  stSql := stSql + ' Left Join TB_PERSON b ';
  stSql := stSql + ' ON(a.PE_CODE = b.PE_CODE) ';
  stSql := stSql + ' Left Join TB_COMPANY c ';
  stsql := stSql + ' ON(b.CO_COMPANYCODE = c.CO_COMPANYCODE) ';
  stSql := stSql + ' Left Join TB_JIJUM d ';
  stsql := stSql + ' ON(b.CO_COMPANYCODE = d.CO_COMPANYCODE ';
  stsql := stSql + ' AND b.CO_JIJUMCODE = d.CO_JIJUMCODE) ';
  stSql := stSql + ' Where a.TE_TELNUMBER = ''' + aTelNo + ''' ';

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
    result := FindField('PE_NAME').AsString;
    aCompanyName := FindField('CO_NAME').AsString;
    aDepartName := FindField('CO_JIJUMNAME').AsString;
  end;
end;

function TfmMain.CreateWindowStartRegKey(aRegName,
  aValue: string): Boolean;
var
  FReg : TRegistry;
begin
  FReg := TRegistry.Create;
 try
   FReg.RootKey := HKEY_CURRENT_USER;
   FReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',True);
   FReg.WriteString(aRegName, aValue);
   FReg.CloseKey;
 Finally
  FReg.Free;
 end;
 result := True;
end;

procedure TfmMain.N23Click(Sender: TObject);
var
  stExec:string;
begin
  stExec := ExtractFileDir(Application.ExeName) + '\SmartUpdate.exe';
  Delay(1000);
  My_RunDosCommand(stExec,True,False);
  Close;
end;

procedure TfmMain.Action_ConsultReportExecute(Sender: TObject);
begin
  MDIChildShow('TfmConsultReport');
end;

procedure TfmMain.WMEndSession(var Msg: TWMEndSession);
begin
  if Msg.EndSession = True then
  begin
//
  end;

end;

procedure TfmMain.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
//  if MessageDlg('Close Windows ?', mtConfirmation, [mbYes,mbNo], 0) = mrNo then
//    Msg.Result := 0
//  else
    L_bClose := True;
    Close;
    Delay(1000);
    Msg.Result := 1;

end;

procedure TfmMain.WndProc(var Msg: TMessage);
begin
  inherited;
    if Msg.WParam = SC_MINIMIZE then
    begin
      Close;
    end;

end;

function TfmMain.GetMasterName(aUserID: string): string;
var
  stSql : string;
begin
  result := '';
  stSql := ' select * from TB_AUTHADMIN ';
  stsql := stSql + ' Where AD_USERID = ''' + aUserID + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      open;
    Except
      Exit;
    End;
    if recordcount < 1 then Exit;
    result := FindField('AD_USERNAME').AsString;
  end;

end;

procedure TfmMain.N25Click(Sender: TObject);
begin
  fmMemoSearch:= TfmMemoSearch.Create(Self);
  fmMemoSearch.SHow;    
end;

function TfmMain.CheckNotConfirmMemo: Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Select * from TB_USERMEMO ';
  stSql := stSql + ' Where UM_USERID = ''' + Master_ID + ''' ';
  stSql := stSql + ' AND UM_CONFIRM = ''N'' ';
  With checkMemo do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordcount < 1 then Exit;
    result := True;
  end;
end;

procedure TfmMain.Action_MemoSendExecute(Sender: TObject);
begin
  fmSendMemo:= TfmSendMemo.Create(Self);
  fmSendMemo.SHow; 
end;

procedure TfmMain.Action_ScheduleExecute(Sender: TObject);
begin
{  fmSchedule:= TfmSchedule.Create(Self);
  fmSchedule.SHow; }

end;
//스케줄 체크하여 알람시간 도달시 알람 발생하자.
procedure TfmMain.ScheduleAlarmCheck(aDate, aSCHEDULEID, aFROMTIME,
  aTOTIME, aSUBJECT, aCONTENT, aALARMTYPE, aSTARTDAY, aSTARTTIME,
  aREPEATTIME, aALARMTIME: string);
var
  alarmDate : TDateTime;
  alarmStartDate : TDateTime;
  alarmShowTime : TDateTime;
  i : integer;
begin
  alarmDate := EncodeDateTime(strtoint(copy(aDate,1,4)),strtoint(copy(aDate,5,2)),strtoint(copy(aDate,7,2)),
                              strtoint(copy(aFROMTIME,1,2)),strtoint(copy(aFROMTIME,3,2)),strtoint(copy(aFROMTIME,5,2)),00);

  if Now > alarmDate then Exit;  //알람 발생일 보다 더 늦게 컴퓨터를 켰다.

  alarmStartDate := alarmDate  - strtoint(aSTARTDAY);
  alarmStartDate := ( alarmStartDate * 24.0 * 60.0 ) - ( strtoint(aSTARTTIME) * 60); //알람 시작 시간전
  alarmStartDate := alarmStartDate / (24.0 * 60.0);

  if alarmStartDate > now then Exit;  //알람 발생시작 시간이 현재보다 크면 빠져나감

  if aALARMTYPE = '0' then //한번 알람
  begin
    ScheduleAlarmShow(aDate,aSCHEDULEID,aFROMTIME,aTOTIME,aSUBJECT,
                      aCONTENT, aALARMTYPE, aSTARTDAY, aSTARTTIME,
                      aREPEATTIME, aALARMTIME);
    UpdateTB_SCHEDULEAlarmCheck(aDate,aSCHEDULEID,FormatDateTime('yyyymmddhhnnss',now),'Y');
  end else  //반복알람
  begin
    if Trim(aALARMTIME) <> '' then
    begin
      alarmShowTime := EncodeDateTime(strtoint(copy(aALARMTIME,1,4)),strtoint(copy(aALARMTIME,5,2)),strtoint(copy(aALARMTIME,7,2)),
                              strtoint(copy(aALARMTIME,9,2)),strtoint(copy(aALARMTIME,11,2)),strtoint(copy(aALARMTIME,13,2)),00); //최종 알람 발생 시간
      i := 1;
      while alarmStartDate < alarmDate do   //알람발생시간이 알람시간보다 작을때까지 계속 돌자.
      begin
        if alarmStartDate < alarmShowTime then    //알람 발생 시간이 최종 알람 시간 보다 작은 경우 다음 알람 발생 시간을 찾는다.
        begin
          alarmStartDate := ( alarmStartDate * 24.0 * 60.0 ) + ( i * strtoint(aREPEATTIME) * 60); //다음 알람 발생 시작 시간
          alarmStartDate := alarmStartDate / (24.0 * 60.0);
          if alarmStartDate > alarmDate then  //다음 구간이 알람사간 보다 크면 알람 발생을 중단한다.
          begin
            UpdateTB_SCHEDULEAlarmCheck(aDate,aSCHEDULEID,'','Y');
            Exit;
          end;
        end else //알람 발생 시간이 최종 알람 시간보다 큰경우 알람 발생 시간이 현재 보다 큰지 확인한다.
        begin
          if alarmStartDate > now then Exit; //알람 발생 시간이 아직 안되었다.
          break;
        end;
        inc(i);
      end;
    end;
    ScheduleAlarmShow(aDate,aSCHEDULEID,aFROMTIME,aTOTIME,aSUBJECT,
                      aCONTENT, aALARMTYPE, aSTARTDAY, aSTARTTIME,
                      aREPEATTIME, aALARMTIME);
    UpdateTB_SCHEDULEAlarmCheck(aDate,aSCHEDULEID,FormatDateTime('yyyymmddhhnnss',now),'N');
  end;
end;

procedure TfmMain.ScheduleAlarmShow(aDate, aSCHEDULEID, aFROMTIME, aTOTIME,
  aSUBJECT, aCONTENT, aALARMTYPE, aSTARTDAY, aSTARTTIME, aREPEATTIME,
  aALARMTIME: string);
begin
{  MSNPopUp1.Title := '[예약스케줄]';
  MSNPopUp1.Text := '스케줄 알람이 발생하였습니다.';
  MSNPopUp1.ShowPopUp;   }
{  fmScheduleAlarm:= TfmScheduleAlarm.Create(Self);
  fmScheduleAlarm.dt_Date.Date := EncodeDate(strtoint(copy(aDate,1,4)),strtoint(copy(aDate,5,2)),strtoint(copy(aDate,7,2)));
  fmScheduleAlarm.dt_StartTime.DateTime := EncodeDateTime(2000,01,01,strtoint(copy(aFROMTIME,1,2)),strtoint(copy(aFROMTIME,3,2)),strtoint(copy(aFROMTIME,5,2)),00 );
  fmScheduleAlarm.dt_EndTime.DateTime := EncodeDateTime(2000,01,01,strtoint(copy(aTOTIME,1,2)),strtoint(copy(aTOTIME,3,2)),strtoint(copy(aTOTIME,5,2)),00 );
  fmScheduleAlarm.ed_SCSubject.Text := aSUBJECT;
  fmScheduleAlarm.mem_Memo.Text := aCONTENT;
  fmScheduleAlarm.SHow;
}
end;

function TfmMain.UpdateTB_SCHEDULEAlarmCheck(aDate, aSCHEDULEID,
  aAlarmTime, aAlarmFinish: string): Boolean;
var
  stsql : string;
begin
{  stSql := ' Update TB_SCHEDULE set ';
  if Trim(aAlarmTime) <> '' then  stSql := stSql + 'SD_ALARMTIME = ''' + aAlarmTime + ''',';
  stSql := stSql + ' SD_ALARMFINISH = ''' + aAlarmFinish + ''' ';
  stSql := stSql + ' Where AD_USERID = ''' + Master_ID + ''' ';
  stSql := stsql + ' AND SD_DATE = ''' + aDate + ''' ';
  stSql := stSql + ' AND SD_SCHEDULEID = ' + aSCHEDULEID ;

  result := DataModule1.ProcessExecSQL(stSql);   }
end;

procedure TfmMain.N28Click(Sender: TObject);
begin
  fmMemoSendSearch:= TfmMemoSendSearch.Create(Self);
  fmMemoSendSearch.SHow;

end;

function TfmMain.DeleteWindowStartRegKey(aRegName: string): Boolean;
var
  FReg : TRegistry;
begin
  FReg := TRegistry.Create;
 try
   FReg.RootKey := HKEY_LOCAL_MACHINE;
   FReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',True);
   FReg.DeleteValue(aRegName);
   FReg.CloseKey;
 Finally
  FReg.Free;
 end;
 result := True;
end;

procedure TfmMain.AdoConnectCheckTimer1Timer(Sender: TObject);
begin
  if AdoConnectCheck then Exit;
  AdoConnectCheckTimer1.Enabled := False;
  dmDB.DBConnect('zeron.able.or.kr','3306','lotto','lotto','lottopw');
  AdoConnectCheckTimer1.Enabled := True; 
end;

function TfmMain.AdoConnectCheck: Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Select * from TB_MASTER ';
  With ConnectCheckQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordcount < 1 then Exit;
    result := True;
  end;
end;

procedure TfmMain.ToolButton7Click(Sender: TObject);
begin
  MDIChildShow('TfmGOODSCATALOG');
end;

procedure TfmMain.N33Click(Sender: TObject);
begin
  MDIChildShow('TfmGOODSCATALOG');
end;


procedure TfmMain.N35Click(Sender: TObject);
begin
  fmGoodsCode:= TfmGoodsCode.Create(Self);
  fmGoodsCode.SHowmodal;
  fmGoodsCode.Free;

end;

procedure TfmMain.N39Click(Sender: TObject);
begin
  fmASGroupCode:= TfmASGroupCode.Create(Self);
  fmASGroupCode.SHowmodal;
  fmASGroupCode.Free;
end;

procedure TfmMain.mn_CompanyGubunClick(Sender: TObject);
begin
  fmCompanyGubun:= TfmCompanyGubun.Create(Self);
  fmCompanyGubun.SHowmodal;
  fmCompanyGubun.Free;

end;

procedure TfmMain.N43Click(Sender: TObject);
begin
  fmCompanyCode:= TfmCompanyCode.Create(Self);
  fmCompanyCode.SHowmodal;
  fmCompanyCode.Free;

end;

procedure TfmMain.N44Click(Sender: TObject);
begin
  fmJijumCode:= TfmJijumCode.Create(Self);
  fmJijumCode.SHowmodal;
  fmJijumCode.Free; 
end;

procedure TfmMain.N45Click(Sender: TObject);
begin
  fmDepartCode:= TfmDepartCode.Create(Self);
  fmDepartCode.SHowmodal;
  fmDepartCode.Free;  
end;

procedure TfmMain.N53Click(Sender: TObject);
begin
  fmTelGubunCode:= TfmTelGubunCode.Create(Self);
  fmTelGubunCode.SHowmodal;
  fmTelGubunCode.Free;
end;

procedure TfmMain.N47Click(Sender: TObject);
begin
  fmControlerType:= TfmControlerType.Create(Self);
  fmControlerType.SHowmodal;
  fmControlerType.Free;

end;

procedure TfmMain.N48Click(Sender: TObject);
begin
  fmControlerRomType:= TfmControlerRomType.Create(Self);
  fmControlerRomType.SHowmodal;
  fmControlerRomType.Free;

end;

procedure TfmMain.N49Click(Sender: TObject);
begin
  fmCardReaderType:= TfmCardReaderType.Create(Self);
  fmCardReaderType.SHowmodal;
  fmCardReaderType.Free;

end;

procedure TfmMain.N51Click(Sender: TObject);
begin
  fmMasterID:= TfmMasterID.Create(Self);
  fmMasterID.SHowmodal;
  fmMasterID.Free;

end;

procedure TfmMain.CustomerConsultingView(aTelNumber: string);
begin
  MDIChildShow('TfmCustomerConsulting');
  if aTelNumber <> '' then
  begin
    self.FindClassForm('TfmCustomerConsulting').FindCommand('REFRESH').Params.Values['TELNUM'] := aTelNumber;
    self.FindClassForm('TfmCustomerConsulting').FindCommand('REFRESH').Execute;
  end;

end;

procedure TfmMain.Action_GoodASListExecute(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmGOODSASList');

end;

function TfmMain.CheckASList: Boolean;
var
  stSql : string;
begin
  result := False;
  stSql:= 'Select * from TB_ASLIST ';
  stSql := stSql + ' where AL_NEXTID = ''' + Master_ID + ''' ';
  stSql := stSql + ' AND AL_CONFIRM <> ''Y'' ';
  stSql := stSql + ' AND AL_STATE <> ''9'' ';

  with chkASList do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordcount < 1 then Exit;
    result := True;
  end;
end;

procedure TfmMain.N54Click(Sender: TObject);
begin
  inherited;
  N23Click(self);
end;

procedure TfmMain.DefaultHandler(var Message);
begin
  inherited DefaultHandler(Message);
  with Tmessage(message) do
  begin
    if Msg = wmTaskbar then
    begin
      if tbi = nil then
      begin
        tbi := TantTaskbarIcon.Create(self);
      end;
      {사라진 트레이 재생}

      tbi.Visible := False;
      tbi.Visible := True;
      tbi.Hint := '고객관리프로그램';
    end;
  end;//with

end;

procedure TfmMain.SetServerConnected(const Value: Boolean);
begin
  if FServerConnected = Value then Exit;
  FServerConnected := Value;
end;

procedure TfmMain.WinsockPort1WsConnect(Sender: TObject);
begin
  inherited;
  ServerConnected := True;
end;

procedure TfmMain.WinsockPort1WsDisconnect(Sender: TObject);
begin
  inherited;
  ServerConnected := False;

end;

procedure TfmMain.WinsockPort1WsError(Sender: TObject; ErrCode: Integer);
begin
  inherited;
  ServerConnected := False;
  ErrCode := 0;
end;

procedure TfmMain.WinsockPort1TriggerAvail(CP: TObject; Count: Word);
var
  st:String;
  I: Integer;
  aData:String;
  nIndex : integer;
  stTemp : string;
begin
  st:= '';
  ServerConnected := True;
  Try
    for I := 1 to Count do st := st + WinsockPort1.GetChar;
  Except
    Exit;
  End;
  ServerComBuff:= ServerComBuff + st ;
  if pos(#$3,ServerComBuff) > 0 then
  begin
    if L_bApplicationTerminate then Exit;
    aData:= Copy(ServerComBuff,1,Pos(#$3,ServerComBuff));
    ServerComBuff := '';
    //if L_stOldData = aData then Exit;
    L_stOldData := aData;
    DataProcess(aData);
  end;

end;

procedure TfmMain.mn_LottoCsvLoadClick(Sender: TObject);
var
  tmpLottoList : TStringList;
  i : integer;
begin
  OpenDialog1.DefaultExt:= 'CSV';
  OpenDialog1.Filter := 'CSV files (*.CSV)|*.CSV';
  Try
    tmpLottoList := TStringList.Create;
    if OpenDialog1.Execute then
    begin
      tmpLottoList.LoadFromFile(OpenDialog1.FileName);
    end else Exit;
    if tmpLottoList.Count = 0 then Exit;
    Gauge1.Visible := True;
    Gauge1.Progress := 0;
    Gauge1.MaxValue := tmpLottoList.Count - 1;
    for i := 0 to tmpLottoList.Count - 1 do
    begin
      Gauge1.Progress := i;
      LottoCsvFileLineAdd(tmpLottoList.Strings[i]);
      Application.ProcessMessages;
    end;
    Gauge1.Visible := False;
  Finally
    tmpLottoList.Free;
  End;

end;

procedure TfmMain.LottoCsvFileLineAdd(aLine: string);
var
  tmpLottoNumList : TStringList;
  i : integer;
begin
  Try
    tmpLottoNumList := TStringList.Create;
    tmpLottoNumList.Delimiter := ',';
    tmpLottoNumList.DelimitedText := aLine;
    if tmpLottoNumList.Count < 8 then Exit;
    DeleteToLottoTable(tmpLottoNumList.Strings[0]);
    InsertIntoLottoTableSeq(tmpLottoNumList.Strings[0]);

    for i := 1 to 6 do
    begin
      UpdateLottoNumber(tmpLottoNumList.Strings[0],tmpLottoNumList.Strings[i],'1');
    end;
    UpdateLottoNumber(tmpLottoNumList.Strings[0],tmpLottoNumList.Strings[7],'2');

  Finally
    tmpLottoNumList.Free;
  End;

end;

function TfmMain.DeleteToLottoTable(aSeq: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Delete From lotto where seq = ' + aSeq + ' ';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmMain.InsertIntoLottoTableSeq(aSeq: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Insert into lotto(seq) values(' + aSeq + ') ';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmMain.UpdateLottoNumber(aSeq, aNumber, aType: string): Boolean;
var
  stSql : string;
begin
  if Not isdigit(aNumber) then Exit;
  stSql := 'Update lotto set NO' + FillZeroNumber(strtoint(aNumber),2) + ' = ' + aType ;
  stSql := stSql + ' Where seq = ' + aSeq ;

  result := dmDB.ProcessExecSQL(stSql);

end;

procedure TfmMain.mn_LottoAddClick(Sender: TObject);
begin
  inherited;
  fmLottoAdd := TfmLottoAdd.Create(Self);
  fmLottoAdd.ShowModal;
  fmLottoAdd.free;
//
end;

procedure TfmMain.mn_lottoList1Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList1');

end;

procedure TfmMain.N3Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoMemberCreate',False);

end;

procedure TfmMain.btn_TotCloseClick(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList1');

end;

procedure TfmMain.mn_lottoList2Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList2');

end;

procedure TfmMain.ToolButton1Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList2');

end;

procedure TfmMain.N71Click(Sender: TObject);
begin
  inherited;
  fmLottoStaticCreate1 := TfmLottoStaticCreate1.Create(Self);
  fmLottoStaticCreate1.ShowModal;
  fmLottoStaticCreate1.free;

end;

procedure TfmMain.N72Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList3');

end;

procedure TfmMain.N5Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList4');

end;

procedure TfmMain.N7Click(Sender: TObject);
begin
  inherited;
  fmLottoExtractCompar := TfmLottoExtractCompar.Create(Self);
  fmLottoExtractCompar.ShowModal;
  fmLottoExtractCompar.free;

end;

procedure TfmMain.N8Click(Sender: TObject);
begin
  inherited;
  fmLottoTest := TfmLottoTest.Create(Self);
  fmLottoTest.ShowModal;
  fmLottoTest.free;

end;

procedure TfmMain.N9Click(Sender: TObject);
begin
  inherited;
  MDIChildShow('TfmLottoWinList5');

end;

end.
