unit uSchedule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlannerMonthView, StdCtrls, ExtCtrls, ComCtrls, Grids, BaseGrid,
  AdvGrid, DB, ADODB, PlannerCal, uSubForm, CommandArray, Buttons,DateUtils;

type
  TfmSchedule = class(TfmASubForm)
    Panel12: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    dt_Date: TDateTimePicker;
    Label1: TLabel;
    sg_memo: TAdvStringGrid;
    Panel3: TPanel;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    dt_StartTime: TDateTimePicker;
    Label3: TLabel;
    dt_EndTime: TDateTimePicker;
    ed_SCSubject: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    mem_Memo: TMemo;
    GroupBox5: TGroupBox;
    rg_AlarmType: TRadioGroup;
    GroupBox6: TGroupBox;
    ed_StartDay: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    ed_StartTime: TEdit;
    GroupBox7: TGroupBox;
    ed_RepeatTime: TEdit;
    Label8: TLabel;
    TempQuery: TADOQuery;
    PlannerCalendar1: TPlannerCalendar;
    btn_Insert: TSpeedButton;
    btn_Update: TSpeedButton;
    btn_Save: TSpeedButton;
    btn_Delete: TSpeedButton;
    btn_Cancel: TSpeedButton;
    btn_Close: TSpeedButton;
    ed_scheduleID: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure PlannerCalendar1DaySelect(Sender: TObject;
      SelDate: TDateTime);
    procedure sg_memoClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_InsertClick(Sender: TObject);
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure PlannerCalendar1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    State : string;
    L_nTopRow : integer;
    { Private declarations }
    Procedure Load_Schedule(aMonth:string);
    procedure ScheduleShow(aDate,aName: string);

    procedure ShowScheduleList(aDate,aID:string;aTopRow:integer = 0);
    procedure FormClear;
    procedure FormEnable(aState:string);
    procedure ButtonEnable(aState:string);
    Function GetScheduleID(aDate:string):string;

    Function DeleteTB_Schedule(aDate,aID:string):Boolean;
    Function InsertTB_SCHEDULE(aDate,ascheduleID,aStartTime,
                                 aEndTime,aSubject,aMemo,aAlarmType,
                                 aAlarmStartDay,aAlarmStartTime,
                                 aAlarmRepeatTime:string):Boolean;
    Function UpdateTB_SCHEDULE(aDate,ascheduleID,aStartTime,
                                 aEndTime,aSubject,aMemo,aAlarmType,
                                 aAlarmStartDay,aAlarmStartTime,
                                 aAlarmRepeatTime:string):Boolean;
  public
    { Public declarations }
  end;

var
  fmSchedule: TfmSchedule;

implementation
uses
  uDataModule;

{$R *.dfm}

procedure TfmSchedule.FormCreate(Sender: TObject);
begin
//  Month.Date := Now;
  PlannerCalendar1.Date := Now;
  dt_date.Date := Now;
  Load_Schedule(FormatDateTime('yyyyMM',PlannerCalendar1.Date));
  PlannerCalendar1DaySelect(PlannerCalendar1,Now);
end;

procedure TfmSchedule.Load_Schedule(aMonth: string);
var
  stSql : string;
  stDate : string;
begin
  PlannerCalendar1.Events.Clear;
  stSql := ' select * from TB_SCHEDULE ';
  stSql := stSql + ' Where AD_USERID = ''' + Master_ID + ''' ';
  stSql := stSql + ' AND SUBSTRING(SD_DATE,1,6) = ''' + aMonth + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    while Not Eof do
    begin
      with PlannerCalendar1.Events.Add do
      begin
        date := EncodeDate(strtoint(copy(FindField('SD_DATE').AsString,1,4)),strtoint(copy(FindField('SD_DATE').AsString,5,2)),strtoint(copy(FindField('SD_DATE').AsString,7,2)));
        hint := FindField('SD_SUBJECT').AsString;
        shape := evsCircle;
        color := clRed;
      end;
      Next;
    end;
  end;
  PlannerCalendar1.Repaint;
end;

procedure TfmSchedule.ScheduleShow(aDate, aName: string);
var
  i : integer;
begin
{  with Month.CreateItem do
  begin
    ItemStartTime :=  strToDate(aDate);
    ItemEndTime := strToDate(aDate);
    Text.Text := aName;
  end;

  for i:= 0 to Month.Items.Count - 1 do
  begin
    Month.Items.Items[i].Color := clBlue;
    Month.Items.Items[i].Font.Size := 2;
  end;}
end;

procedure TfmSchedule.PlannerCalendar1DaySelect(Sender: TObject;
  SelDate: TDateTime);
begin
  //showmessage(FormatDateTime('yyymmdd',SelDate));
  ShowScheduleList(FormatDateTime('yyyymmdd',SelDate),'',1);
end;

procedure TfmSchedule.ShowScheduleList(aDate,aID:string;aTopRow:integer = 0);
var
  stSql : string;
  nRow : integer;
begin
  GridInitialize(sg_memo);
  FormClear;
  dt_Date.date := EncodeDate(strtoint(copy(aDate,1,4)),strtoint(copy(aDate,5,2)),strtoint(copy(aDate,7,2)));
  stSql := ' select * from TB_SCHEDULE ';
  stSql := stSql + ' Where AD_USERID = ''' + Master_ID + ''' ';
  stSql := stSql + ' AND SD_DATE = ''' + aDate + ''' ';

  with TempQuery do
  begin
    close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 1 then Exit;
    with sg_memo do
    begin
      rowCount := recordCount + 1;
      nRow := 1;
      While Not Eof do
      begin
        Cells[0,nRow] := FindField('SD_SUBJECT').AsString;
        Cells[1,nRow] := FindField('AD_USERID').AsString;
        Cells[2,nRow] := FindField('SD_DATE').AsString;
        Cells[3,nRow] := FindField('SD_SCHEDULEID').AsString;
        Cells[4,nRow] := FindField('SD_FROMTIME').AsString;
        Cells[5,nRow] := FindField('SD_TOTIME').AsString;
        Cells[6,nRow] := FindField('SD_SUBJECT').AsString;
        Cells[7,nRow] := FindField('SD_CONTENT').AsString;
        Cells[8,nRow] := FindField('SD_ALARMTYPE').AsString;
        Cells[9,nRow] := FindField('SD_STARTDAY').AsString;
        Cells[10,nRow] := FindField('SD_STARTTIME').AsString;
        Cells[11,nRow] := FindField('SD_REPEATTIME').AsString;

        if (FindField('SD_SCHEDULEID').AsString )  = aID then
        begin
          SelectRows(nRow,1);
        end;
        inc(nRow);
        Next;
      end;
      if aTopRow = 0 then
      begin
        if Row > 4 then TopRow := Row - 4;
      end else
      begin
        TopRow := aTopRow;
      end;
    end;
  end;
  sg_memoClick(sg_memo);
end;

procedure TfmSchedule.FormClear;
begin
  ed_scheduleID.Text := '';
//  dt_Date.Date := Now;
  dt_StartTime.DateTime := Now;
  dt_EndTime.DateTime := Now;
  ed_SCSubject.Text := '';
  mem_Memo.Text := '';
  rg_AlarmType.ItemIndex := 0;
  ed_StartDay.Text := '';
  ed_StartTime.Text := '';
  ed_RepeatTime.Text := '';
end;

procedure TfmSchedule.sg_memoClick(Sender: TObject);
var
  i : integer;
begin
  State := 'CLICK';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);

  with sg_memo do
  begin
    ed_scheduleID.Text := Cells[3,Row];
    dt_StartTime.DateTime := EncodeDateTime(2000,01,01,strtoint(copy(Cells[4,Row],1,2)),strtoint(copy(Cells[4,Row],3,2)),strtoint(copy(Cells[4,Row],5,2)),00 );
    dt_EndTime.DateTime := EncodeDateTime(2000,01,01,strtoint(copy(Cells[5,Row],1,2)),strtoint(copy(Cells[5,Row],3,2)),strtoint(copy(Cells[5,Row],5,2)),00 );
    ed_SCSubject.Text := Cells[6,Row];
    mem_Memo.Text := Cells[7,Row];
    rg_AlarmType.ItemIndex := strtoint(Cells[8,Row]);
    ed_StartDay.Text := Cells[9,Row];
    ed_StartTime.Text := Cells[10,Row];
    ed_RepeatTime.Text := Cells[11,Row];
  end;
  
end;

procedure TfmSchedule.ButtonEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    btn_Insert.Enabled := False;
    btn_update.Enabled := false;
    btn_Save.Enabled := True;
    btn_delete.Enabled := False;
    btn_Cancel.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    btn_Insert.Enabled := True;
    btn_Update.Enabled := False;
    btn_Save.Enabled := False;
    btn_Delete.Enabled := False;
    btn_Cancel.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    btn_Insert.Enabled := False;
    btn_Update.Enabled := False;
    btn_Save.Enabled := True;
    btn_Delete.Enabled := False;
    btn_Cancel.Enabled := True;
  end else if upperCase(aState) = 'CLICK' then
  begin
    btn_Insert.Enabled := True;
    btn_Update.Enabled := True;
    btn_Save.Enabled := False;
    btn_Delete.Enabled := True;
    btn_Cancel.Enabled := False;
  end;
end;

procedure TfmSchedule.FormEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    dt_StartTime.Enabled := True;
    dt_EndTime.Enabled := True;
    ed_SCSubject.Enabled := True;
    mem_Memo.Enabled := True;
    rg_AlarmType.Enabled := True;
    ed_StartDay.Enabled := True;
    ed_StartTime.Enabled := True;
    ed_RepeatTime.Enabled := True;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    dt_StartTime.Enabled := False;
    dt_EndTime.Enabled := False;
    ed_SCSubject.Enabled := False;
    mem_Memo.Enabled := False;
    rg_AlarmType.Enabled := False;
    ed_StartDay.Enabled := False;
    ed_StartTime.Enabled := False;
    ed_RepeatTime.Enabled := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    dt_StartTime.Enabled := True;
    dt_EndTime.Enabled := True;
    ed_SCSubject.Enabled := True;
    mem_Memo.Enabled := True;
    rg_AlarmType.Enabled := True;
    ed_StartDay.Enabled := True;
    ed_StartTime.Enabled := True;
    ed_RepeatTime.Enabled := True;
  end else if upperCase(aState) = 'CLICK' then
  begin
    dt_StartTime.Enabled := False;
    dt_EndTime.Enabled := False;
    ed_SCSubject.Enabled := False;
    mem_Memo.Enabled := False;
    rg_AlarmType.Enabled := False;
    ed_StartDay.Enabled := False;
    ed_StartTime.Enabled := False;
    ed_RepeatTime.Enabled := False;
  end;
end;

procedure TfmSchedule.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSchedule.btn_InsertClick(Sender: TObject);
begin
  State := 'INSERT';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);
  with sg_memo do
  begin
    L_nTopRow := TopRow;
    if Cells[0,1] <> '' then
    begin
      AddRow;
      SelectRows(RowCount - 1,1);
      Enabled := True;
      if RowCount > 11 then TopRow := RowCount - 11;
      Enabled := False;
    end;
  end;
  ed_scheduleID.Text := GetScheduleID(FormatDateTime('yyyymmdd',dt_Date.date));
  ed_SCSubject.SetFocus;

end;

procedure TfmSchedule.btn_UpdateClick(Sender: TObject);
begin
  State := 'UPDATE';
  FormEnable(State);
  ButtonEnable(State);
  L_nTopRow := sg_memo.TopRow;

  ed_SCSubject.SetFocus;

end;

procedure TfmSchedule.btn_CancelClick(Sender: TObject);
begin
  ShowScheduleList(FormatDateTime('yyyymmdd',dt_Date.date),ed_scheduleID.text,L_nTopRow);
end;

procedure TfmSchedule.btn_DeleteClick(Sender: TObject);
begin
  if (Application.MessageBox(PChar('데이터를 삭제하시겠습니까?'),'삭제',MB_OKCANCEL) = ID_CANCEL)  then Exit;

  if DeleteTB_Schedule(FormatDateTime('yyyymmdd',dt_Date.date),ed_scheduleID.text) then
    ShowScheduleList(FormatDateTime('yyyymmdd',dt_Date.date),ed_scheduleID.text,sg_memo.TopRow)
  else showmessage('데이터 삭제에 실패했습니다');
    
end;

function TfmSchedule.DeleteTB_Schedule(aDate, aID: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Delete From TB_Schedule ';
  stSql := stSql + ' Where AD_USERID = ''' + Master_ID + ''' ';
  stSql := stSql + ' AND SD_DATE = ''' + aDate + ''' ';
  stSql := stSql + ' AND SD_SCHEDULEID = ' + aID + ' ';

  result := DataModule1.ProcessExecSQL(stSql);

end;

procedure TfmSchedule.btn_SaveClick(Sender: TObject);
var
  stDate : string;
  bResult : Boolean;
begin
  if Trim(ed_SCSubject.Text) = '' then
  begin
    showmessage('제목은 필수적으로 입력해 주세요.');
    Exit;
  end;
  if Trim(ed_StartDay.Text) = '' then ed_StartDay.Text := '0';
  if Trim(ed_StartTime.Text) = '' then ed_StartTime.Text := '0';
  if Trim(ed_RepeatTime.Text) = '' then ed_RepeatTime.Text := '0';
  stDate := FormatDateTime('yyyymmdd',dt_Date.date);
  if UpperCase(State) = 'INSERT' then
  begin
    bResult := InsertTB_SCHEDULE(
                                 stDate,
                                 ed_scheduleID.Text,
                                 FormatDateTime('hhnnss',dt_StartTime.DateTime),
                                 FormatDateTime('hhnnss',dt_EndTime.DateTime),
                                 ed_SCSubject.Text,
                                 mem_Memo.Text,
                                 inttostr(rg_AlarmType.ItemIndex),
                                 ed_StartDay.Text,
                                 ed_StartTime.Text,
                                 ed_RepeatTime.Text
                                 );
  end else if UpperCase(State) = 'UPDATE' then
  begin
    bResult := UpdateTB_SCHEDULE(
                                 stDate,
                                 ed_scheduleID.Text,
                                 FormatDateTime('hhnnss',dt_StartTime.DateTime),
                                 FormatDateTime('hhnnss',dt_EndTime.DateTime),
                                 ed_SCSubject.Text,
                                 mem_Memo.Text,
                                 inttostr(rg_AlarmType.ItemIndex),
                                 ed_StartDay.Text,
                                 ed_StartTime.Text,
                                 ed_RepeatTime.Text
                                 );
  end;
  if bResult then
  begin
    if UpperCase(State) = 'INSERT' then
      ShowScheduleList(FormatDateTime('yyyymmdd',dt_Date.date),ed_scheduleID.text)
    else ShowScheduleList(FormatDateTime('yyyymmdd',dt_Date.date),ed_scheduleID.text,sg_memo.TopRow);
  end else showmessage('저장실패');
end;

function TfmSchedule.GetScheduleID(aDate: string): string;
var
  stSql : string;
begin
  result := '1';

  stSql := ' Select Max(SD_SCHEDULEID) as SD_SCHEDULEID ';
  stSql := stSql + ' FROM TB_SCHEDULE ';
  stSql := stSql + ' Where AD_USERID = ''' + Master_ID + ''' ';
  stSql := stSql + ' AND SD_DATE = ''' + aDate + ''' ';

  with TempQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if RecordCount < 1 then Exit;
    result := inttostr(FindField('SD_SCHEDULEID').AsInteger + 1);
  end;

end;

function TfmSchedule.InsertTB_SCHEDULE(aDate, ascheduleID, aStartTime,
  aEndTime, aSubject, aMemo, aAlarmType, aAlarmStartDay, aAlarmStartTime,
  aAlarmRepeatTime: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Insert Into TB_SCHEDULE( ';
  stSql := stSql + ' AD_USERID,';
  stSql := stSql + ' SD_DATE,';
  stSql := stSql + ' SD_SCHEDULEID,';
  stSql := stSql + ' SD_FROMTIME,';
  stSql := stSql + ' SD_TOTIME,';
  stSql := stSql + ' SD_SUBJECT,';
  stSql := stSql + ' SD_CONTENT,';
  stSql := stSql + ' SD_ALARMTYPE,';
  stSql := stSql + ' SD_STARTDAY,';
  stSql := stSql + ' SD_STARTTIME,';
  stSql := stSql + ' SD_REPEATTIME,';
  stSql := stSql + ' SD_ALARMFINISH ) ';
  stSql := stSql + ' Values(';
  stSql := stSql + '''' + Master_ID + ''',';
  stSql := stSql + '''' + aDate + ''',';
  stSql := stSql + ascheduleID + ',';
  stSql := stSql + '''' + aStartTime + ''',';
  stSql := stSql + '''' + aEndTime + ''',';
  stSql := stSql + '''' + aSubject + ''',';
  stSql := stSql + '''' + aMemo + ''',';
  stSql := stSql + '''' + aAlarmType + ''',';
  stSql := stSql + aAlarmStartDay + ',';
  stSql := stSql + aAlarmStartTime + ',';
  stSql := stSql + aAlarmRepeatTime + ', ';
  stSql := stSql + '''N'')';

  result := DataModule1.ProcessExecSQL(stSql);
end;

function TfmSchedule.UpdateTB_SCHEDULE(aDate, ascheduleID, aStartTime,
  aEndTime, aSubject, aMemo, aAlarmType, aAlarmStartDay, aAlarmStartTime,
  aAlarmRepeatTime: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_SCHEDULE  Set ';
  stSql := stSql + ' SD_FROMTIME = ''' + aStartTime + ''',';
  stSql := stSql + ' SD_TOTIME = ''' + aEndTime + ''',';
  stSql := stSql + ' SD_SUBJECT = ''' + aSubject + ''',';
  stSql := stSql + ' SD_CONTENT = ''' + aMemo + ''',';
  stSql := stSql + ' SD_ALARMTYPE = ''' + aAlarmType + ''',';
  stSql := stSql + ' SD_STARTDAY = ' + aAlarmStartDay + ',';
  stSql := stSql + ' SD_STARTTIME = ' + aAlarmStartTime + ',';
  stSql := stSql + ' SD_REPEATTIME = ' + aAlarmRepeatTime + ' ';
  stSql := stSql + ' WHERE AD_USERID = ''' + Master_ID + ''' ' ;
  stSql := stSql + ' AND SD_DATE = ''' + aDate + ''' ';
  stSql := stSql + ' AND SD_SCHEDULEID = ' + ascheduleID ;

  result := DataModule1.ProcessExecSQL(stSql);
end;

procedure TfmSchedule.PlannerCalendar1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Load_Schedule(FormatDateTime('yyyyMM',PlannerCalendar1.Date));

end;

end.
