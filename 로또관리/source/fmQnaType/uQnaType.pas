unit uQnaType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, Grids, BaseGrid, AdvGrid,
  uSubForm, CommandArray,ADODB,ActiveX,ZConnection,ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TfmQNACode = class(TfmASubForm)
    Panel12: TPanel;
    Panel1: TPanel;
    Label8: TLabel;
    Label1: TLabel;
    btn_Delete: TSpeedButton;
    btn_Save: TSpeedButton;
    btn_Update: TSpeedButton;
    btn_Insert: TSpeedButton;
    btn_Close: TSpeedButton;
    btn_Cancel: TSpeedButton;
    ed_Code: TEdit;
    ed_Name: TEdit;
    StatusBar1: TStatusBar;
    sg_Code: TAdvStringGrid;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sg_CodeClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_InsertClick(Sender: TObject);
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
  private
    State : string;
    { Private declarations }
    procedure FormClear;
    procedure FormEnable(aState:string);
    procedure ButtonEnable(aState:string);
  private
    procedure ShowQNACode(aCode:string);

    Function InsertTB_QNATYPE(aCode,aName:string):Boolean;
    Function UpdateTB_QNATYPE(aCode,aName:string):Boolean;
    Function DeleteTB_QNATYPE(aCode:string):Boolean;
    Function GetMaxCode:string;
  public
    { Public declarations }
  end;

var
  fmQNACode: TfmQNACode;

implementation

{$R *.dfm}
uses
  uDataModule,
  uLomosUtil;

{ TForm1 }

procedure TfmQNACode.ButtonEnable(aState: string);
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

procedure TfmQNACode.FormClear;
begin
  ed_Code.Text := '';
  ed_Name.Text := '';

end;

procedure TfmQNACode.FormEnable(aState: string);
begin
  if upperCase(aState) = 'INSERT'  then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := true;
    ed_Name.Enabled  := true;
  end else if upperCase(aState) = 'SEARCH' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
  end else if upperCase(aState) = 'CLICK' then
  begin
    sg_Code.Enabled := True;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := False;
  end else if upperCase(aState) = 'UPDATE' then
  begin
    sg_Code.Enabled := False;
    ed_Code.Enabled := False;
    ed_Name.Enabled  := true;
  end;
end;

procedure TfmQNACode.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmQNACode.FormActivate(Sender: TObject);
begin
   ShowQNACode('');
end;

procedure TfmQNACode.ShowQNACode(aCode: string);
var
  stSql : string;
  nRow : integer;
  i : integer;
  TempAdoQuery : TZQuery;
begin
  GridInitialize(sg_Code); //스트링그리드 초기화

  State := 'SEARCH';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);

  stSql := 'select * from TB_QNATYPE ';

  CoInitialize(nil);
  TempAdoQuery := TZQuery.Create(nil);
  TempAdoQuery.Connection := dmDB.ZConnection1;

  with TempAdoQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;

    Try
      Open;
    Except
      TempAdoQuery.Free;
      CoUninitialize;
      Exit;
    End;
    if RecordCount < 1 then
    begin
      TempAdoQuery.Free;
      CoUninitialize;
      Exit;
    end;

    with sg_Code do
    begin
      RowCount := RecordCount + 1;
      nRow := 1;
      while Not Eof do
      begin
        cells[0,nRow] := FindField('QA_TYPE').AsString;
        cells[1,nRow] := FindField('QA_NAME').AsString;
        if FindField('QA_TYPE').AsString  = aCode then
        begin
          SelectRows(nRow,1);
        end;

        nRow := nRow + 1;
        Next;
      end;
    end;
  end;
  TempAdoQuery.Free;
  CoUninitialize;
  sg_CodeClick(sg_Code);
end;

procedure TfmQNACode.sg_CodeClick(Sender: TObject);
begin
  State := 'CLICK';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);
  with (Sender as TStringGrid) do
  begin
    if cells[0,Row] = '' then exit;
    ed_Code.Text := cells[0,Row];
    ed_Name.Text := cells[1,Row];
  end;
end;

procedure TfmQNACode.btn_CancelClick(Sender: TObject);
begin
  ShowQNACode(ed_Code.Text);

end;

procedure TfmQNACode.btn_InsertClick(Sender: TObject);
begin
  State := 'INSERT';
  FormClear;
  FormEnable(State);
  ButtonEnable(State);
  with sg_Code do
  begin
    if Cells[0,1] <> '' then
    begin
      AddRow;
      SelectRows(RowCount - 1,1);
      Enabled := True;
      if RowCount > 5 then TopRow := RowCount - 5;
      Enabled := False;
    end;
  end;
  ed_Code.Text := GetMaxCode;

  ed_Code.SetFocus;
end;

procedure TfmQNACode.btn_UpdateClick(Sender: TObject);
begin
  State := 'UPDATE';

  FormEnable(State);
  ButtonEnable(State);
  ed_Name.SetFocus;
end;

procedure TfmQNACode.btn_DeleteClick(Sender: TObject);
var
  bResult : boolean;
begin
  if (Application.MessageBox(PChar('데이터를 삭제하시겠습니까?'),'삭제',MB_OKCANCEL) = ID_CANCEL)  then Exit;

  bResult := DeleteTB_QNATYPE(ed_Code.Text);

  if bResult then ShowQNACode('')
  else showmessage('삭제실패.');
end;

function TfmQNACode.DeleteTB_QNATYPE(aCode: string): Boolean;
var
  stSql : string;
begin

  result := False;
  stSql := 'Delete From TB_QNATYPE ';
  stSql := stSql + ' where QA_TYPE = ''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

procedure TfmQNACode.btn_SaveClick(Sender: TObject);
var
  bResult : boolean;
begin
  if UpperCase(State) = 'INSERT' then
    bResult := InsertTB_QNATYPE(ed_Code.Text,ed_Name.Text)
  else if UpperCase(State) = 'UPDATE' then
    bResult := UpdateTB_QNATYPE(ed_Code.Text,ed_Name.Text);

  if bResult then ShowQNACode(ed_Code.Text)
  else showmessage('저장실패');
end;

function TfmQNACode.InsertTB_QNATYPE(aCode,
  aName: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Insert Into TB_QNATYPE( ';
  stSql := stSql + ' QA_TYPE,';
  stSql := stSql + ' QA_NAME )' ;
  stSql := stSql + ' values( ';
  stSql := stSql + '''' + aCode + ''',';
  stSql := stSql + '''' + aName + '''';
  stSql := stSql + ')';

  result := dmDB.ProcessExecSQL(stSql);

end;

function TfmQNACode.UpdateTB_QNATYPE(aCode,
  aName: string): Boolean;
var
  stSql : string;
begin

  stSql := ' Update TB_QNATYPE set ';
  stSql := stSql + ' QA_NAME = ''' + aName + ''' ';
  stSql := stSql + ' where QA_TYPE =''' + aCode + '''';

  result := dmDB.ProcessExecSQL(stSql);
end;

function TfmQNACode.GetMaxCode: string;
var
  stSql : string;
  TempAdoQuery : TZQuery;
begin
  result := '0000000000';

  stSql := 'select Max(QA_TYPE) as QA_TYPE from TB_QNATYPE ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TZQuery.Create(nil);
    TempAdoQuery.Connection := dmDB.ZConnection1;

    with TempAdoQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Text := stSql;

      Try
        Open;
      Except
        TempAdoQuery.Free;
        CoUninitialize;
        Exit;
      End;
      if RecordCount < 1 then
      begin
        Exit;
      end;
      if FindField('QA_TYPE').IsNull then
      begin
        result := '1';
      end else if isdigit(FindField('QA_TYPE').AsString) then
      begin
        result := inttostr(strtoint(FindField('QA_TYPE').AsString) + 1);
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

end.
