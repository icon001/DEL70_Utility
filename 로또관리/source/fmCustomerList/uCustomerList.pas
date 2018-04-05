unit uCustomerList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, AdvPanel, Grids, BaseGrid, AdvGrid, StdCtrls;

type
  TfmCompanyAdmin = class(TForm)
    AdvPanel1: TAdvPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    cmb_spgGroup: TComboBox;
    ed_scompanycode: TEdit;
    Label1: TLabel;
    btn_Search: TBitBtn;
    sg_ComState: TAdvStringGrid;
    Panel12: TPanel;
    btn_Insert: TSpeedButton;
    btn_Update: TSpeedButton;
    btn_Save: TSpeedButton;
    btn_Delete: TSpeedButton;
    btn_Cancel: TSpeedButton;
    btn_Close: TSpeedButton;
    Label3: TLabel;
    ed_sCompanyName: TEdit;
    Splitter1: TSplitter;
    Label4: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label7: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    Edit6: TEdit;
    Label10: TLabel;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCompanyAdmin: TfmCompanyAdmin;

implementation

{$R *.dfm}


procedure TfmCompanyAdmin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmCompanyAdmin.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

initialization
  RegisterClass(TfmCompanyAdmin);
Finalization
  UnRegisterClass(TfmCompanyAdmin);


end.
