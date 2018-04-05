program ZTBMSAdmin;

uses
  Forms,
  uMain in '..\..\source\fmMain\uMain.pas' {fmMain},
  uDataModule in '..\uDataModule.pas' {DataModule1: TDataModule},
  uCompanyAdmin in '..\..\source\fmCompanyAdmin\uCompanyAdmin.pas' {fmCompanyAdmin},
  uCustomerKeyCreate in '..\..\source\fmCustomerKeyCreate\uCustomerKeyCreate.pas' {fmCustomerKeyCreate},
  uProgramType in '..\..\source\fmProgramType\uProgramType.pas' {fmProgramType},
  uSubForm in '..\uSubForm.pas' {fmASubForm},
  uManagerGubun in '..\..\source\fmManagerGubun\uManagerGubun.pas' {fmManagerGubun},
  DIMime in '..\DIMime.pas',
  uLomosUtil in '..\uLomosUtil.pas',
  uManagerAdmin in '..\..\source\fmManagerAdmin\uManagerAdmin.pas' {fmManagerAdmin},
  uQnaType in '..\..\source\fmQnaType\uQnaType.pas' {fmQnaType},
  uManagerAdminN in '..\..\source\fmManagerAdmin\uManagerAdminN.pas' {fmManagerAdmin1},
  uCustomerConsulting in '..\..\source\fmCustomerConsulting\uCustomerConsulting.pas' {fmCustomerConsulting},
  uConsultCode in '..\..\source\fmConsultCode\uConsultCode.pas' {fmConsultCode},
  uLogin in 'uLogin.pas' {fmLogin},
  uSendTelNo in '..\..\source\fmSendTelNo\uSendTelNo.pas' {fmSendTelNo},
  uConsultReport in '..\..\source\fmConsultReport\uConsultReport.pas' {fmConsultReport},
  uSendMemo in '..\..\source\fmSendMemo\uSendMemo.pas' {fmSendMemo},
  uMemoSendSearch in '..\..\source\fmMemoSendSearch\uMemoSendSearch.pas' {fmMemoSendSearch},
  uSchedule in '..\..\source\fmSchedule\uSchedule.pas' {fmSchedule},
  uScheduleAlarm in '..\..\source\fmScheduleAlarm\uScheduleAlarm.pas' {fmScheduleAlarm},
  uConsultUpdate in '..\..\source\fmConsultUpdate\uConsultUpdate.pas' {fmConsultUpdate},
  uMemoSearch in '..\..\source\fmMemoSearch\uMemoSearch.pas' {fmMemoSearch},
  uReceiveTelNum in '..\..\source\fmReceiveTelNum\uReceiveTelNum.pas' {fmReceiveTelNum};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
