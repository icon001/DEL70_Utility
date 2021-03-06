program LottoAdmin;

uses
  Forms,
  uMain in 'fmMain\uMain.pas' {fmMain},
  uDataModule in '..\Lib\uDataModule.pas' {dmDB: TDataModule},
  uSubForm in '..\Lib\uSubForm.pas' {fmASubForm},
  DIMime in '..\Lib\DIMime.pas',
  uLomosUtil in '..\Lib\uLomosUtil.pas',
  uLogin in '..\Lib\Login\uLogin.pas' {fmLogin},
  uDepartCode in 'fmDepartCode\uDepartCode.pas' {fmDepartCode},
  uQnaType in 'fmQnaType\uQnaType.pas' {fmQNACode},
  uCardReaderType in 'fmCardReaderType\uCardReaderType.pas' {fmCardReaderType},
  uMasterID in 'fmMasterID\uMasterID.pas' {fmMasterID},
  uGoodsCode in 'fmGoodsCode\uGoodsCode.pas' {fmGoodsCode},
  uAsGroupCode in 'fmASGroupCode\uAsGroupCode.pas' {fmASGroupCode},
  uCompanyGubun in 'fmCompanyGubun\uCompanyGubun.pas' {fmCompanyGubun},
  uCompanyCode in 'fmCompanyCode\uCompanyCode.pas' {fmCompanyCode},
  uJijumCode in 'fmJijumCode\uJijumCode.pas' {fmJijumCode},
  uTelGubunCode in 'fmTelGubunCode\uTelGubunCode.pas' {fmTelGubunCode},
  uCotrolerType in 'fmControlerType\uCotrolerType.pas' {fmControlerType},
  uCotrolerRomType in 'fmControlerRomType\uCotrolerRomType.pas' {fmControlerRomType},
  uCompanyAdmin in 'fmCompanyAdmin\uCompanyAdmin.pas' {fmCompanyAdmin},
  uCustomerKeyCreate in 'fmCustomerKeyCreate\uCustomerKeyCreate.pas' {fmCustomerKeyCreate},
  uSendTelNo in 'fmSendTelNo\uSendTelNo.pas' {fmSendTelNo},
  uSendMemo in 'fmSendMemo\uSendMemo.pas' {fmSendMemo},
  uMemoSearch in 'fmMemoSearch\uMemoSearch.pas' {fmMemoSearch},
  uMemoSendSearch in 'fmMemoSendSearch\uMemoSendSearch.pas' {fmMemoSendSearch},
  uGOODSCATALOG in 'fmGOODSCATALOG\uGOODSCATALOG.pas' {fmGOODSCATALOG},
  uInGoods in 'fmInGoods\uInGoods.pas' {fmInGoods},
  uOutGoods in 'fmOutGoods\uOutGoods.pas' {fmOutGoods},
  uGoodsInventory in 'fmGoodsInventory\uGoodsInventory.pas' {fmGoodsInventory},
  uProgramType in 'fmProgramType\uProgramType.pas' {fmProgramType},
  uLottoWinList2 in 'fmLottoWinList2\uLottoWinList2.pas' {fmLottoWinList2},
  uLottoMemberCreate in 'fmLottoMemberCreate\uLottoMemberCreate.pas' {fmLottoMemberCreate},
  uLottoStaticCreate1 in 'fmLottoStaticCreate1\uLottoStaticCreate1.pas' {fmLottoStaticCreate1},
  uLottoAdd in 'fmLottoAdd\uLottoAdd.pas' {fmLottoAdd},
  uLottoWinList1 in 'fmLottoWinList1\uLottoWinList1.pas' {fmLottoWinList1},
  uLottoWinList5 in 'fmLottoWinList5\uLottoWinList5.pas' {fmLottoWinList5},
  uLottoFunction in 'uLottoFunction.pas',
  uLottoWinList3 in 'fmLottoWinList3\uLottoWinList3.pas' {fmLottoWinList3},
  uLottoTest in 'fmLottoTest\uLottoTest.pas' {fmLottoTest},
  uLottoExtractCompar in 'fmLottoExtractCompar\uLottoExtractCompar.pas' {fmLottoExtractCompar},
  uLottoWinList4 in 'fmLottoWinList4\uLottoWinList4.pas' {fmLottoWinList4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
