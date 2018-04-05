unit uCardExcell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdPacket, OoMisc, AdPort,WinSpool, Buttons, Grids,
  BaseGrid, AdvGrid,ComObj;

const
 USE_ENUMPORTS_API = False;
 MAX_COMPORT = 36;       // 최대 255 까지
 MAX_LISTCOUNT = 100; //리스트 출력 count

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    cmb_ComPort: TComboBox;
    Label1: TLabel;
    ReaderPort: TApdComPort;
    ApdDataPacket1: TApdDataPacket;
    btn_PortRefresh: TButton;
    AdvStringGrid1: TAdvStringGrid;
    Label2: TLabel;
    ed_SerialHeader: TEdit;
    ed_Start: TEdit;
    Label3: TLabel;
    ed_End: TEdit;
    btn_Excell: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btn_creat: TButton;
    SaveDialog: TSaveDialog;
    procedure btn_PortRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmb_ComPortChange(Sender: TObject);
    procedure ApdDataPacket1StringPacket(Sender: TObject; Data: String);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ed_StartKeyPress(Sender: TObject; var Key: Char);
    procedure ed_EndKeyPress(Sender: TObject; var Key: Char);
    procedure ed_StartExit(Sender: TObject);
    procedure btn_creatClick(Sender: TObject);
    procedure ed_EndExit(Sender: TObject);
    procedure btn_ExcellClick(Sender: TObject);
  private
    ComPortList : TStringList;
    CardList : TStringList;
    nRow : integer;
    { Private declarations }
    function GetSerialPortList(List : TStringList; const doOpenTest : Boolean = True) : LongWord;
    function EncodeCommportName(PortNum : WORD) : String;
    function DecodeCommportName(PortName : String) : WORD;
    Procedure RcvCardDataByReader(aData:String);
    procedure StringGridInit;
    Function EncodeStr(ast:String):String;
    Function DecodeStr(ast:String):String;
    Function ExcelPrintOut(StringGrid:TStringGrid;refFileName,SaveFileName:String;FileOut:Boolean;ExcelRowStart:integer):Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uLomosUtil;
  
{$R *.dfm}

procedure TForm1.btn_PortRefreshClick(Sender: TObject);
var
  nCount : integer;
  i : integer;
  stTemp : string;
begin
    ReaderPort.Open := False;
    ApdDataPacket1.Enabled := False;
    ComPortList.Clear;
    nCount := GetSerialPortList(ComPortList);
    cmb_ComPort.Clear;
    if nCount = 0 then
    begin
      showmessage('시리얼 포트를 찾을 수 없습니다. 제어판에서 시리얼 포트를 확인하여 주세요.');
      Exit;
    end;

    for i:= 0 to nCount - 1 do
    begin
      cmb_ComPort.items.Add(ComPortList.Strings[i])
    end;
    cmb_ComPort.ItemIndex := 0;

    try
      ApdDataPacket1.AutoEnable := false;
      ApdDataPacket1.StartCond := scString;
      ApdDataPacket1.StartString := #$02;
      ApdDataPacket1.EndCond := [ecString];
      ApdDataPacket1.EndString := #$03;
      ApdDataPacket1.Timeout := 0;
      ReaderPort.ComNumber := Integer(ComPortList.Objects[cmb_ComPort.ItemIndex]);
      //ReaderPort.ComNumber := strtoint(copy(cmb_ComPort.text,4,Pos(':',cmb_ComPort.text) -4));
      ReaderPort.Open := true;
      ApdDataPacket1.Enabled := True;
    except
      MessageDlg('통신포트를 확인해 주세요', mtError, [mbOK], 0);
      Exit;
    end;

end;

function TForm1.DecodeCommportName(PortName: String): WORD;
var
 Pt : Integer;
begin
 PortName := UpperCase(PortName);
 if (Copy(PortName, 1, 3) = 'COM') then begin
    Delete(PortName, 1, 3);
    Pt := Pos(':', PortName);
    if Pt = 0 then Result := 0
       else Result := StrToInt(Copy(PortName, 1, Pt-1));
 end
 else if (Copy(PortName, 1, 7) = '\\.\COM') then begin
    Delete(PortName, 1, 7);
    Result := StrToInt(PortName);
 end
 else Result := 0;

end;

function TForm1.EncodeCommportName(PortNum: WORD): String;
begin
 if PortNum < 10
    then Result := 'COM' + IntToStr(PortNum) + ':'
    else Result := '\\.\COM'+IntToStr(PortNum);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ComPortList := TStringList.Create;
  CardList := TStringList.Create;
  nRow := 1;
end;

function TForm1.GetSerialPortList(List: TStringList;
  const doOpenTest: Boolean): LongWord;
type
 TArrayPORT_INFO_1 = array[0..0] Of PORT_INFO_1;
 PArrayPORT_INFO_1 = ^TArrayPORT_INFO_1;
var
{$IF USE_ENUMPORTS_API}
 PL : PArrayPORT_INFO_1;
 TotalSize, ReturnCount : LongWord;
 Buf : String;
 CommNum : WORD;
{$IFEND}
 I : LongWord;
 CHandle : THandle;
begin
 List.Clear;
{$IF USE_ENUMPORTS_API}
 EnumPorts(nil, 1, nil, 0, TotalSize, ReturnCount);
 if TotalSize < 1 then begin
    Result := 0;
    Exit;
    end;
 GetMem(PL, TotalSize);
 EnumPorts(nil, 1, PL, TotalSize, TotalSize, Result);

 if Result < 1 then begin
    FreeMem(PL);
    Exit;
    end;

 for I:=0 to Result-1 do begin
    Buf := UpperCase(PL^[I].pName);
    CommNum := DecodeCommportName(PL^[I].pName);
    if CommNum = 0 then Continue;
    List.AddObject(EncodeCommportName(CommNum), Pointer(CommNum));
    end;
{$ELSE}
 for I:=1 to MAX_COMPORT do List.AddObject(EncodeCommportName(I), Pointer(I));
{$IFEND}
 // Open Test
 if List.Count > 0 then for I := List.Count-1 downto 0 do begin
    CHandle := CreateFile(PChar(List[I]), GENERIC_WRITE or GENERIC_READ,
     0, nil, OPEN_EXISTING,
     FILE_ATTRIBUTE_NORMAL,
     0);
    if CHandle = INVALID_HANDLE_VALUE then begin
if doOpenTest or (GetLastError() <> ERROR_ACCESS_DENIED) then List.Delete(I);
Continue;
end;
    CloseHandle(CHandle);
    end;

 Result := List.Count;
{$IF USE_ENUMPORTS_API}
 if Assigned(PL) then FreeMem(PL);
{$IFEND}

end;

procedure TForm1.cmb_ComPortChange(Sender: TObject);
begin
    try
      ReaderPort.Open := False;
      ApdDataPacket1.Enabled := False;
      ApdDataPacket1.AutoEnable := false;
      ApdDataPacket1.StartCond := scString;
      ApdDataPacket1.StartString := #$02;
      ApdDataPacket1.EndCond := [ecString];
      ApdDataPacket1.EndString := #$03;
      ApdDataPacket1.Timeout := 0;
      ReaderPort.ComNumber := Integer(ComPortList.Objects[cmb_ComPort.ItemIndex]);
      //ReaderPort.ComNumber := strtoint(copy(cmb_ComPort.text,4,Pos(':',cmb_ComPort.text) -4));
      ReaderPort.Open := true;
      ApdDataPacket1.Enabled := True;
    except
      MessageDlg('통신포트를 확인해 주세요', mtError, [mbOK], 0);
      Exit;
    end;

end;

procedure TForm1.ApdDataPacket1StringPacket(Sender: TObject; Data: String);
begin
  RcvCardDataByReader(Data);
  ApdDataPacket1.Enabled := True;
end;

procedure TForm1.RcvCardDataByReader(aData: String);
var
  aIndex: Integer;
  aCardNo:String;
  bCardNo: int64;
  stMsg : string;
  stHex : string;
begin
  //STX 삭제
  aIndex:= Pos(#$2,aData);
  if aIndex > 0 then Delete(aData,aIndex,1);
  //ETX삭제
  aIndex:= Pos(#$3,aData);
  if aIndex > 0 then Delete(aData,aIndex,1);

  stHex := aData;
  bCardNo:= Hex2Dec64(aData);
  aCardNo:= FillZeroNumber2(bCardNo,10);
  if CardList.IndexOf(aCardNo)> -1 then
  begin
    showmessage('중복된 카드번호가 있습니다. 확인후 입력하세요.');
    Exit;
  end;
  CardList.Add(aCardNo);
  AdvStringGrid1.Cells[1,nRow] := aCardNo;
  AdvStringGrid1.Cells[2,nRow] := stHex;
  if nRow + 1 < AdvStringGrid1.RowCount then
  begin
    nRow := nRow + 1;
    AdvStringGrid1.SelectRange(1,1,nRow,nRow);
  end;
end;

procedure TForm1.AdvStringGrid1Click(Sender: TObject);
begin
  nRow := AdvStringGrid1.Row;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  btn_PortRefreshClick(Sender);
  StringGridInit;
end;

procedure TForm1.ed_StartKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    ed_End.SetFocus;
{  end
  else  begin
    if strtoint(ed_Start.Text) > strtoint(ed_end.Text) then
    begin
      showmessage('마지막 일련번호가 시작일련번호보다 작을 수 없습니다.');
      ed_Start.SetFocus;
    end;  }
  end;
end;

procedure TForm1.ed_EndKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    AdvStringGrid1.SetFocus;
{  end
  else  begin
    if strtoint(ed_Start.Text) > strtoint(ed_end.Text) then
    begin
      showmessage('마지막 일련번호가 시작일련번호보다 작을 수 없습니다.');
      ed_Start.SetFocus;
    end;   }
  end;

end;

procedure TForm1.ed_StartExit(Sender: TObject);
begin

  if strtoint(ed_Start.Text) > strtoint(ed_end.Text) then
  begin
    showmessage('마지막 일련번호가 시작일련번호보다 작을 수 없습니다.');
    ed_Start.SetFocus;
    Exit;
  end;
  //btn_creatClick(Sender);

end;

procedure TForm1.StringGridInit;
begin
  nRow := 1;
  CardList.Clear;
  with AdvStringGrid1 do
  begin
    ClearCols(0,RowCount);
    ClearCols(1,RowCount);
    RowCount := 2;
    Cells[0,0] := '일련번호';
    Cells[1,0] := '카드번호';
    Cells[2,0] := 'HEX 값';
  end;
end;

procedure TForm1.btn_creatClick(Sender: TObject);
var
  nCount : integer;
  i : integer;
begin
  StringGridInit;

  nCount := strtoint(ed_end.Text) - strtoint(ed_start.Text) + 1;

  if nCount < 1 then Exit;
  with AdvStringGrid1 do
  begin
    RowCount := nCount + 1;
    for i:= 1 to ncount do
    begin
      Cells[0,i] := ed_SerialHeader.Text + FillZeroNumber(strtoint(ed_start.Text) + i - 1,5);
    end;
  end;

end;

procedure TForm1.ed_EndExit(Sender: TObject);
begin
  if strtoint(ed_Start.Text) > strtoint(ed_end.Text) then
  begin
    showmessage('마지막 일련번호가 시작일련번호보다 작을 수 없습니다.');
    ed_End.SetFocus;
    Exit;
  end;
  //btn_creatClick(Sender);

end;

procedure TForm1.btn_ExcellClick(Sender: TObject);
var
  stRefFileName,stSaveFileName:String;
  stPrintRefPath : string;
  nExcelRowStart:integer;
  aFileName : string;
  stTitle : string;
begin
  Screen.Cursor:= crHourGlass;
  stRefFileName := ExtractFileDir(Application.ExeName) + '\xlsheader.xls' ;
  nExcelRowStart := 2;

  SaveDialog.Title:= '엑셀 파일 저장';
  SaveDialog.DefaultExt:= 'xls';
  SaveDialog.Filter := 'XLS files (*.xls)|*.xls';
  if SaveDialog.Execute then
  begin
    stSaveFileName := SaveDialog.FileName;
    ExcelPrintOut(AdvStringGrid1,stRefFileName,stSaveFileName,True,nExcelRowStart);
    ShowMessage('저장되었습니다.');
  end;

  Screen.Cursor:= crDefault;
end;

function TForm1.DecodeStr(ast: String): String;
var
s: String[255];
c: array[0..255] of Byte absolute s;
i: Integer;
begin


  s := ast;
  for i := 1 to Length(s) do s[i] := Char(13 xor Ord(c[i]));
  Result := s;

end;

function TForm1.EncodeStr(ast: String): String;
var
s: String[255];
c: array[0..255] of Byte absolute s;
i: Integer;
begin
  s:= ast;
  for i := 1 to Ord(s[0]) do c[i] := 13 xor c[i];
  Result:= s;

end;

function TForm1.ExcelPrintOut(StringGrid: TStringGrid; refFileName,
  SaveFileName: String; FileOut: Boolean; ExcelRowStart: integer): Boolean;
var
  oXL, oWB, oSheet, oRng, VArray : Variant;
  nCol : Integer;
  Loop : Integer;
  sCurDay,sPreDay : String;
  curDate : TDateTime;
  mergeStart :char;
  i,j,k : Integer;
  st : String;

begin
  Result := False;

  Try
    oXL := CreateOleObject('Excel.Application');
  Except
    showmessage('출력은 엑셀이 설치된 컴퓨터에서만 가능합니다.');
    exit;
  End;

  if FileExists(refFileName) = False then
  begin
    Showmessage(refFileName + ' 파일이 없습니다.');
    exit;
  end;


  oXL.Workbooks.Open(refFileName);
//  oXL.Visible := True;
  oSheet := oXL.ActiveSheet;


  with StringGrid do
  begin

    //타이틀을 적자

    nCol := ColCount;
    for i := FixedRows to RowCount - 1 do
    begin

      for j := 0 to ColCount - 1 do
      begin
        oXL.Range[Chr(Ord('A') + j ) + inttostr(i+ ExcelRowStart - FixedRows)].Value := Cells[j,i];
      end;

    end;

  end;//With

  //oXL.Visible := False;
  if FileOut then  oSheet.SaveAs(SaveFileName)
  else  oSheet.PrintOut;
  //oSheet.SaveAs(ExtractFileDir(Application.ExeName) + '\WorkSch2.xls');
  oXL.ActiveWorkbook.Close(False);
  oXL.Quit;

  Result := True;
end;

end.
