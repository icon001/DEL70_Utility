unit uCardToHex;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Button3: TButton;
    Label7: TLabel;
    Edit7: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  uLomosUtil;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  stCardNo : string;
  i : integer;
  stHEX : string;
begin
  stHEX := '';
  //stCardNo := EncodeCardNo(Edit1.text);
  //Edit2.Text := AsciiToHex(stCardNo);
  Edit2.Text :=  Dec2Hex64(StrtoInt64(Edit1.text),8);
  Edit3.Text :=  EncodeCardNo(Edit1.text);
  stCardNo := Edit3.Text;
  for i := 1 to Length(stCardNo) do
  begin
    stHEX := stHEX + Dec2Hex(Ord(stCardNo[I]),1);
  end;
  Edit4.Text := stHEX;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  stHex : string;
begin
  stHex := FillZeroNumber(Hex2Dec(copy(Edit2.text,1,4)),5) + FillZeroNumber(Hex2Dec(copy(Edit2.text,5,4)),5);
  Edit5.Text := stHex;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  stHex : string;
begin
  stHex := Dec2Hex64(strtoint(copy(Edit6.text,1,5)),4) + Dec2Hex64(strtoint(copy(Edit6.text,6,5)),4);
  Edit7.Text := FillZeroNumber2(Hex2Dec64(stHex),10);
end;

end.
