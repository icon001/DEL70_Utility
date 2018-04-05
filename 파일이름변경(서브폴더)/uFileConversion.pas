unit uFileConversion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, ImgList, ExtCtrls, FindFile,
  FolderDialog, DB, Grids, DBGrids, ADODB, Gauges, 
  Jpeg, dExif, msData,dIPTC,mmsystem;

type
  TForm1 = class(TForm)
    Location: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ed_Save: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    FindButton: TSpeedButton;
    btnClose: TSpeedButton;
    btnChange: TSpeedButton;
    ProgressImagePanel: TPanel;
    ProgressImage: TImage;
    ProgressImageTimer: TTimer;
    ProgressImages: TImageList;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FileName_: TEdit;
    Location_: TEdit;
    Subfolders: TCheckBox;
    Phrase: TEdit;
    CaseSenstitive: TCheckBox;
    WholeWord: TCheckBox;
    TabSheet3: TTabSheet;
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    CreatedBeforeDate: TDateTimePicker;
    CreatedAfterDate: TDateTimePicker;
    CreatedBeforeTime: TDateTimePicker;
    CreatedAfterTime: TDateTimePicker;
    CBD: TCheckBox;
    CBT: TCheckBox;
    CAD: TCheckBox;
    CAT: TCheckBox;
    TabSheet5: TTabSheet;
    ModifiedBeforeDate: TDateTimePicker;
    ModifiedAfterDate: TDateTimePicker;
    ModifiedBeforeTime: TDateTimePicker;
    ModifiedAfterTime: TDateTimePicker;
    MBD: TCheckBox;
    MBT: TCheckBox;
    MAD: TCheckBox;
    MAT: TCheckBox;
    TabSheet6: TTabSheet;
    AccessedBeforeDate: TDateTimePicker;
    AccessedAfterDate: TDateTimePicker;
    AccessedBeforeTime: TDateTimePicker;
    AccessedAfterTime: TDateTimePicker;
    ABD: TCheckBox;
    ABT: TCheckBox;
    AAD: TCheckBox;
    AAT: TCheckBox;
    TabSheet2: TTabSheet;
    Attributes: TGroupBox;
    System: TCheckBox;
    Hidden: TCheckBox;
    Readonly: TCheckBox;
    Archive: TCheckBox;
    Directory: TCheckBox;
    Compressed: TCheckBox;
    Encrypted: TCheckBox;
    Offline: TCheckBox;
    SparseFile: TCheckBox;
    ReparsePoint: TCheckBox;
    Temporary: TCheckBox;
    Device: TCheckBox;
    Normal: TCheckBox;
    NotContentIndexed: TCheckBox;
    Virtual: TCheckBox;
    FileSize: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    SizeMaxEdit: TEdit;
    SizeMinEdit: TEdit;
    SizeMin: TUpDown;
    SizeMax: TUpDown;
    SizeMinUnit: TComboBox;
    SizeMaxUnit: TComboBox;
    StatusBar: TStatusBar;
    FindFile: TFindFile;
    StopButton: TSpeedButton;
    Threaded: TCheckBox;
    FolderDialog1: TFolderDialog;
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOExecQuery: TADOQuery;
    Gauge1: TGauge;
    ADOseqQuery: TADOQuery;
    FileName: TEdit;
    Label6: TLabel;
    chkYYYY: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure FindFileFolderChange(Sender: TObject; const Folder: String;
      var IgnoreFolder: TFolderIgnore);
    procedure FindFileSearchBegin(Sender: TObject);
    procedure FindFileSearchAbort(Sender: TObject);
    procedure FindFileSearchFinish(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure ProgressImageTimerTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FindFileFileMatch(Sender: TObject;
      const FileInfo: TFileDetails);
    procedure btnChangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    Folders: Integer;
    FindFiles:Integer;
    StartTime: DWord;
    SortedColumn: Integer;
    Descending: Boolean;
    { Private declarations }
    Function AdoConnected:Boolean;
    Function InsertFileInfo(aFileName,aFullName,aFileSize,aCreateTime,aModifiedTime,aAccessedTime,aCreateDate,aAttribute:string):Boolean;
    Function InsertNewFile(anewdate,aseq,aFullName,aFileName:string):Boolean;
    Function GetSeq(aCurDate:string):integer;
    function GetExifDate(aFileName:string):string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ImgData:TImgData;

implementation
uses
  uLomosUtil;
{$R *.dfm}

function GetAttributeStatus(CB: TCheckBox): TFileAttributeStatus;
begin
  case CB.State of
    cbUnchecked: Result := fsUnset;
    cbChecked: Result := fsSet;
  else
    Result := fsIgnore;
  end;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FindButtonClick(Sender: TObject);
var
  iFindResult: integer;
  srSchRec : TSearchRec;
begin
  if Location.Text = '' then
  begin
    showmessage('검색할 디렉토리를 선택하세요.');
    Exit;
  end;
(*
  iFindResult := FindFirst(Location.Text + '\' + FileName.Text, faAnyFile - faDirectory, srSchRec);
  while iFindResult = 0 do
  begin
    iFindResult := FindNext(srSchRec);
  end;
*)

  // Sets FileFile properties
  FindFile.Threaded := Threaded.Checked;
  // - Name & Location
  with FindFile.Criteria.Files do
  begin
    FileName := Self.FileName.Text;
    Location := Self.Location.Text;
    Subfolders := Self.Subfolders.Checked;
  end;
  // - Containing Text
  with FindFile.Criteria.Content do
  begin
    Phrase := Self.Phrase.Text;
    Options := [];
    if Self.CaseSenstitive.Checked then
      Options := Options + [csoCaseSensitive];
    if Self.WholeWord.Checked then
      Options := Options + [csoWholeWord];
  end;
  // - Attributes
  with FindFile.Criteria.Attributes do
  begin
    Archive := GetAttributeStatus(Self.Archive);
    Readonly := GetAttributeStatus(Self.Readonly);
    Hidden := GetAttributeStatus(Self.Hidden);
    System := GetAttributeStatus(Self.System);
    Directory := GetAttributeStatus(Self.Directory);
    Compressed := GetAttributeStatus(Self.Compressed);
    Encrypted := GetAttributeStatus(Self.Encrypted);
    Offline := GetAttributeStatus(Self.Offline);
    ReparsePoint := GetAttributeStatus(Self.ReparsePoint);
    SparseFile := GetAttributeStatus(Self.SparseFile);
    Temporary := GetAttributeStatus(Self.Temporary);
    Device := GetAttributeStatus(Self.Device);
    Normal := GetAttributeStatus(Self.Normal);
    Virtual := GetAttributeStatus(Self.Virtual);
    NotContentIndexed := GetAttributeStatus(Self.NotContentIndexed);
  end;
  // - Size ranges
  with FindFile.Criteria.Size do
  begin
    Min := Self.SizeMin.Position;
    case Self.SizeMinUnit.ItemIndex of
      1: Min := Min * 1024;
      2: Min := Min * 1024 * 1024;
      3: Min := Min * 1024 * 1024 * 1024;
    end;
    Max := Self.SizeMax.Position;
    case Self.SizeMaxUnit.ItemIndex of
      1: Max := Max * 1024;
      2: Max := Max * 1024 * 1024;
      3: Max := Max * 1024 * 1024 * 1024;
    end;
  end;
  // - TimeStamp ranges
  with FindFile.Criteria.TimeStamp do
  begin
    Clear;
    // Created on
    if Self.CBD.Checked then
      CreatedBefore := Self.CreatedBeforeDate.Date;
    if Self.CBT.Checked then
      CreatedBefore := CreatedBefore + Self.CreatedBeforeTime.Time;
    if Self.CAD.Checked then
      CreatedAfter := Self.CreatedAfterDate.Date;
    if Self.CAT.Checked then
      CreatedAfter := CreatedAfter + Self.CreatedAfterTime.Time;
    // Modified on
    if Self.MBD.Checked then
      ModifiedBefore := Self.ModifiedBeforeDate.Date;
    if Self.MBT.Checked then
      ModifiedBefore := ModifiedBefore + Self.ModifiedBeforeTime.Time;
    if Self.MAD.Checked then
      ModifiedAfter := Self.ModifiedAfterDate.Date;
    if Self.MAT.Checked then
      ModifiedAfter := ModifiedAfter + Self.ModifiedAfterTime.Time;
    // Accessed on
    if Self.ABD.Checked then
      AccessedBefore := Self.AccessedBeforeDate.Date;
    if Self.ABT.Checked then
      AccessedBefore := AccessedBefore + Self.AccessedBeforeTime.Time;
    if Self.AAD.Checked then
      AccessedAfter := Self.AccessedAfterDate.Date;
    if Self.AAT.Checked then
      AccessedAfter := AccessedAfter + Self.AccessedAfterTime.Time;
  end;
  // Begins search
  FindFile.Execute;
end;

procedure TForm1.FindFileFolderChange(Sender: TObject;
  const Folder: String; var IgnoreFolder: TFolderIgnore);
begin
  Inc(Folders);
  StatusBar.SimpleText := Folder;
  if not FindFile.Threaded then
    Application.ProcessMessages;

end;

procedure TForm1.FindFileSearchBegin(Sender: TObject);
var
  stSql : string;
begin
  Folders := 0;
  FindFiles := 0;
  SortedColumn := -1;
  FindButton.Enabled := False;
  StopButton.Enabled := True;
  Threaded.Enabled := False;
  if AdoConnected then
  begin
    stSql := 'delete from FILEINFO ';
    with ADOExecQuery do
    begin
      Close;
      Sql.Clear;
      Sql.Text := stSql;
      Try
        ExecSql;
      Except
        Exit;
      End;
    end;
  end;
  ProgressImagePanel.Visible := True;
  ProgressImageTimer.Enabled := True;
  StartTime := GetTickCount;

end;

procedure TForm1.FindFileSearchAbort(Sender: TObject);
begin
  StatusBar.SimpleText := 'Cancelling search, please wait...';
end;

procedure TForm1.FindFileSearchFinish(Sender: TObject);
var
  stSql : string;
begin
  StatusBar.SimpleText := Format('%d folder(s) searched and %d file(s) found - %.3f second(s)',
    [Folders, FindFiles, (GetTickCount - StartTime) / 1000]);
  if FindFile.Aborted then
    StatusBar.SimpleText := 'Search cancelled - ' + StatusBar.SimpleText;
  ProgressImageTimer.Enabled := False;
  ProgressImagePanel.Visible := False;
  Threaded.Enabled := True;
  StopButton.Enabled := False;
  FindButton.Enabled := True;
  stSql := 'select * from FILEINFO';
  with ADOQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
  end;
end;

procedure TForm1.StopButtonClick(Sender: TObject);
begin
  FindFile.Abort;
end;

procedure TForm1.ProgressImageTimerTimer(Sender: TObject);
var
  stSql : string;
begin
  ProgressImages.Tag := (ProgressImages.Tag + 1) mod ProgressImages.Count;
  ProgressImages.GetBitmap(ProgressImages.Tag, ProgressImage.Picture.Bitmap);
  ProgressImage.Refresh;
{  stSql := 'select * from FILEINFO';
  with ADOQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
  end;   }
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if FolderDialog1.Execute then
  begin
    Location.Text := FolderDialog1.Directory;
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if FolderDialog1.Execute then
  begin
    ed_Save.Text := FolderDialog1.Directory;
  end;

end;

procedure TForm1.FindFileFileMatch(Sender: TObject;
  const FileInfo: TFileDetails);
var
  stFileName,stFullName,stFileSize:string;
  stCreateTime,stModifiedTime,stAccessedTime,stCreateDate:string;
  stAttribute : string;
  stExifDate : string;
begin
  inc(FindFiles);

  stFileName := FileInfo.Name;
  stFullName := FileInfo.Location;
  stFileSize := inttostr(FileInfo.Size);
  stCreateTime := formatDateTime('yyyymmddHHMMSS',FileInfo.CreatedTime);
  stModifiedTime := formatDateTime('yyyymmddHHMMSS',FileInfo.ModifiedTime);
  stAccessedTime := formatDateTime('yyyymmddHHMMSS',FileInfo.AccessedTime);
  stCreateDate := formatDateTime('yyyymmdd',FileInfo.ModifiedTime);
  stExifDate := '';
  stAttribute := ExtractFileExt( stFileName );
  if UpperCase(stAttribute) = '.JPG' then
    stExifDate := GetExifDate(FileInfo.Location + '\' + FileInfo.Name);
  if stExifDate <> '' then
  begin
    stCreateTime := stExifDate;
    stCreateDate := copy(stExifDate,1,8);
  end;
  InsertFileInfo(stFileName,stFullName,stFileSize,stCreateTime,stModifiedTime,stAccessedTime,stCreateDate,stAttribute);
end;

function TForm1.AdoConnected: Boolean;
var
  conStr : string;
  stExeFolder : String;
  DBName : string;
begin
  result := False;
  stExeFolder  := ExtractFileDir(Application.ExeName);
  conStr := '';
  DBName := stExeFolder + '\FileName.mdb';
  conStr := 'Provider=Microsoft.Jet.OLEDB.4.0;';
  conStr := conStr + 'Data Source=' + DBName + ';';
  conStr := conStr + 'Persist Security Info=True;';
  conStr := conStr + 'Jet OLEDB:Database ';
//  if stuserPW <> '' then  conStr := conStr + ' Password=' + stuserPW;

  ADOConnection.Connected := False;
  ADOConnection.ConnectionString := conStr;
  ADOConnection.LoginPrompt:= false ;
  Try
    ADOConnection.Open;
  Except
    on E : EDatabaseError do
      begin
        // ERROR MESSAGE-BOX DISPLAY
        ShowMessage(E.Message );
        Exit;
      end;
  End;
  result := True;
end;

function TForm1.InsertFileInfo(aFileName, aFullName, aFileSize,
  aCreateTime, aModifiedTime, aAccessedTime, aCreateDate,aAttribute: string): Boolean;
var
  stSql : string;
  stSubFolder : string;
  nPosCount : integer;
  nPosIndex : integer;
begin
  stSubFolder := ExtractFileDir(aFullName);
  if stSubFolder[Length(stSubFolder)] = '\' then stSubFolder := copy(stSubFolder,1,Length(stSubFolder)-1);
  nPosCount := posCount('\',stSubFolder);
  nPosIndex := PosIndex('\',stSubFolder,nPosCount);
  stSubFolder := copy(stSubFolder,nPosIndex + 1,Length(stSubFolder) - nPosIndex);
  
  result := False;
  stSql := ' Insert Into FileInfo(';
  stSql := stSql + 'FileName,';
  stSql := stSql + 'FullName,';
  stSql := stSql + 'FileSize,';
  stSql := stSql + 'CreateTime,';
  stSql := stSql + 'ModifiedTime,';
  stSql := stSql + 'AccessedTime,';
  stSql := stSql + 'CreateDate,';
  stSql := stSql + 'Attribute, ';
  stSql := stSql + 'SubFolder';
  stSql := stSql + ')';
  stSql := stSql + ' Values (';
  stSql := stSql + '''' + aFileName + ''',';
  stSql := stSql + '''' + aFullName + ''',';
  stSql := stSql + '''' + aFileSize + ''',';
  stSql := stSql + '''' + aCreateTime + ''',';
  stSql := stSql + '''' + aModifiedTime + ''',';
  stSql := stSql + '''' + aAccessedTime + ''',';
  stSql := stSql + '''' + aCreateDate + ''',';
  stSql := stSql + '''' + aAttribute + ''', ';
  stSql := stSql + '''' + stSubFolder + ''' ) ';
  with ADOExecQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      ExecSql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

procedure TForm1.btnChangeClick(Sender: TObject);
var
  stSql : string;
  stOldfile: string;
  stNewDir : string;
  stNewFile : string;
  stCurFolder : string;
  stYYYY : string;
  nSeq : integer;
begin
  stCurFolder := '';
  stYYYY := '';
  stNewDir := '';
  nSeq := 0;
  if ed_Save.Text = '' then
  begin
    showmessage('저장할 디렉토리를 선택하세요.');
    Exit;
  end;
  stSql := 'select * from FILEINFO order by subFolder';
  with ADOQuery do
  begin
    Close;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    Gauge1.Visible := True;
    Gauge1.MaxValue := Recordcount;
    Gauge1.Progress := 0;
    while Not Eof do
    begin
      Gauge1.Progress := Gauge1.Progress + 1;

      stNewDir := ed_Save.Text ;
      if stCurFolder <> Findfield('subFolder').AsString then
      begin
        stCurFolder := Findfield('subFolder').AsString;
        nSeq := 1;
      end;
      stOldfile := Findfield('Fullname').AsString + Findfield('FileName').AsString;
      if FileExists(stOldfile) then
      begin
        stNewFile := stNewDir  + '\' + stCurFolder + FillZeroNumber(nSeq,3) + FindField('Attribute').AsString;
        //FileCtrl.CopyFiles(stOldFile,stNewFile);
        CopyFile(PChar(stOldFile), PChar(stNewFile), False);
        inc(nSeq);
      end;
      Next;
      Application.ProcessMessages;
    end;
    Gauge1.Visible := False;
  end;
end;

function TForm1.GetSeq(aCurDate: string): integer;
var
  stSql :string;
begin
  result := 1;
  stSql := 'select Max(seq) as seq from NewFile ';
  stSql := stSql + ' Where newdate = ''' + aCurDate + ''' ';
  with ADOseqQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if FindField('seq').IsNull then Exit;
    result := FindField('seq').AsInteger + 1;
  end;
end;

function TForm1.InsertNewFile(anewdate, aseq, aFullName,
  aFileName: string): Boolean;
var
  stSql : string;
begin
  result := False;
  stSql := ' Insert Into NewFile(';
  stSql := stSql + 'newdate,';
  stSql := stSql + 'seq,';
  stSql := stSql + 'FullName,';
  stSql := stSql + 'FileName ';
  stSql := stSql + ')';
  stSql := stSql + ' Values (';
  stSql := stSql + '''' + anewdate + ''',';
  stSql := stSql + aseq + ',';
  stSql := stSql + '''' + aFullName + ''',';
  stSql := stSql + '''' + aFileName + ''' ) ';
  with ADOExecQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      ExecSql;
    Except
      Exit;
    End;
  end;
  result := True;
end;

function TForm1.GetExifDate(aFileName: string): string;
var
  item:TTagEntry;
  stDateTime : string;
begin
  result := '';

  ImgData.BuildList := GenAll;  // on by default anyway

  ImgData.ProcessFile(aFileName);
  if not ImgData.HasEXIF() then
    exit;

  ImgData.ExifObj.ResetIterator;
  while ImgData.ExifObj.IterateFoundTags(GenericEXIF ,item) do
  begin
    if item.Desc = 'Date Time' then
    begin
      stDateTime := StringReplace(item.Data,':','',[rfReplaceAll]);
      stDateTime := StringReplace(stDateTime,' ','',[rfReplaceAll]);
      if copy(stDateTime,1,8) <> '00000000' then result := stDateTime;
      break;
    end;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ImgData := TimgData.Create;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ImgData.Free;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  DBGrid1.Height := Height - 228;
  DBGrid1.Width := Width - 10;
end;

end.
