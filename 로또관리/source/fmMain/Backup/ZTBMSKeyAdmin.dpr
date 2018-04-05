program ZTBMSKeyAdmin;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uDataModule in '..\..\Lib\uDataModule.pas' {DataModule1: TDataModule},
  uCompanyAdmin in '..\fmCompanyAdmin\uCompanyAdmin.pas' {fmCompanyAdmin},
  uCustomerKeyCreate in '..\fmCustomerKeyCreate\uCustomerKeyCreate.pas' {fmCustomerKeyCreate},
  uProgramType in '..\fmProgramType\uProgramType.pas' {fmProgramType},
  uSubForm in '..\..\Lib\uSubForm.pas' {fmASubForm},
  uManagerGubun in '..\fmManagerGubun\uManagerGubun.pas' {fmManagerGubun},
  DIMime in '..\..\Lib\DIMime.pas',
  uLomosUtil in '..\..\Lib\uLomosUtil.pas',
  uManagerAdmin in '..\fmManagerAdmin\uManagerAdmin.pas' {fmManagerAdmin},
  uQnaType in '..\fmQnaType\uQnaType.pas' {fmQnaType},
  uManagerAdminN in '..\fmManagerAdmin\uManagerAdminN.pas' {fmManagerAdmin1},
  uCustomerConsulting in '..\fmCustomerConsulting\uCustomerConsulting.pas' {fmCustomerConsulting},
  uConsultCode in '..\fmConsultCode\uConsultCode.pas' {fmConsultCode},
  uLogin in '..\..\Lib\Login\uLogin.pas' {fmLogin},
  uSendMemo in '..\fmSendMemo\uSendMemo.pas' {fmSendMemo},
  uMemoSearch in '..\fmMemoSearch\uMemoSearch.pas' {fmMemoSearch},
  uSchedule in '..\fmSchedule\uSchedule.pas' {fmSchedule},
  uScheduleAlarm in '..\fmScheduleAlarm\uScheduleAlarm.pas' {fmScheduleAlarm},
  uMemoSendSearch in '..\fmMemoSendSearch\uMemoSendSearch.pas' {fmMemoSendSearch},
  uSendTelNo in '..\fmSendTelNo\uSendTelNo.pas' {fmSendTelNo},
  uConsultUpdate in '..\fmConsultUpdate\uConsultUpdate.pas' {fmConsultUpdate},
  uReceiveTelNum in '..\fmReceiveTelNum\uReceiveTelNum.pas' {fmReceiveTelNum};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
