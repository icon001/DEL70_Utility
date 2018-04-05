program ZTBMSAdmin;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uDataModule in '..\..\Lib\uDataModule.pas' {dmDB: TDataModule},
  uSubForm in '..\..\Lib\uSubForm.pas' {fmASubForm},
  DIMime in '..\..\Lib\DIMime.pas',
  uLomosUtil in '..\..\Lib\uLomosUtil.pas',
  uLogin in '..\..\Lib\Login\uLogin.pas' {fmLogin},
  uDepartCode in '..\fmDepartCode\uDepartCode.pas' {fmDepartCode},
  uQnaType in '..\fmQnaType\uQnaType.pas' {fmQNACode},
  uCardReaderType in '..\fmCardReaderType\uCardReaderType.pas' {fmCardReaderType},
  uProgramType in '..\fmProgramType\uProgramType.pas' {fmProgramType},
  uGoodsCode in '..\fmGoodsCode\uGoodsCode.pas' {fmGoodsCode},
  uAsGroupCode in '..\fmASGroupCode\uAsGroupCode.pas' {fmASGroupCode},
  uCompanyGubun in '..\fmCompanyGubun\uCompanyGubun.pas' {fmCompanyGubun},
  uCompanyCode in '..\fmCompanyCode\uCompanyCode.pas' {fmCompanyCode},
  uJijumCode in '..\fmJijumCode\uJijumCode.pas' {fmJijumCode},
  uConsultCode in '..\fmConsultCode\uConsultCode.pas' {fmConsultCode},
  uTelGubunCode in '..\fmTelGubunCode\uTelGubunCode.pas' {fmTelGubunCode},
  uCotrolerType in '..\fmControlerType\uCotrolerType.pas' {fmControlerType},
  uCotrolerRomType in '..\fmControlerRomType\uCotrolerRomType.pas' {fmControlerRomType},
  uCompanyAdmin in '..\fmCompanyAdmin\uCompanyAdmin.pas' {fmCompanyAdmin},
  uManagerAdminN in '..\fmManagerAdmin\uManagerAdminN.pas' {fmManagerAdmin},
  uTelNumberUpdate in '..\fmManagerAdmin\fmTelNumberUpdate\uTelNumberUpdate.pas' {fmTelNumberUpdate},
  uCustomerKeyCreate in '..\fmCustomerKeyCreate\uCustomerKeyCreate.pas' {fmCustomerKeyCreate},
  uCustomerConsulting in '..\fmCustomerConsulting\uCustomerConsulting.pas' {fmCustomerConsulting},
  uSendTelNo in '..\fmSendTelNo\uSendTelNo.pas' {fmSendTelNo},
  uSendMemo in '..\fmSendMemo\uSendMemo.pas' {fmSendMemo},
  uManagerAdd in '..\fmManagerAdd\uManagerAdd.pas' {fmManagerAdd},
  uMemoSearch in '..\fmMemoSearch\uMemoSearch.pas' {fmMemoSearch},
  uMemoSendSearch in '..\fmMemoSendSearch\uMemoSendSearch.pas' {fmMemoSendSearch},
  uConsultReport in '..\fmConsultReport\uConsultReport.pas' {fmConsultReport},
  uGOODSCATALOG in '..\fmGOODSCATALOG\uGOODSCATALOG.pas' {fmGOODSCATALOG},
  uInGoods in '..\fmInGoods\uInGoods.pas' {fmInGoods},
  uOutGoods in '..\fmOutGoods\uOutGoods.pas' {fmOutGoods},
  uGoodsInventory in '..\fmGoodsInventory\uGoodsInventory.pas' {fmGoodsInventory},
  uReceiveTelNum in '..\fmReceiveTelNum\uReceiveTelNum.pas' {fmReceiveTelNum},
  uGOODSASList in '..\fmGOODSASList\uGOODSASList.pas' {fmGOODSASList},
  uInASList in '..\fmInASList\uInASList.pas' {fmInASList};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
