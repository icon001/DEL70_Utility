Attribute VB_Name = "MReadFile"
Const ChunkSize = 1024

Public Function Wait(seconds)


frmMain.TmrWait.Enabled = True


frmMain.TmrWait.Interval = 1000 * seconds

While frmMain.TmrWait.Interval > 0
    DoEvents
Wend


frmMain.TmrWait.Enabled = False

End Function

Public Function RetreiveFile(Inet1 As Inet, FileDestination As String, StatusBar1 As Control, LabelFileSize As Label, ByRef LabelStatus As Label) As Boolean
On Error GoTo RetreiveFile_Error:

    Dim FileSize As Long
    Dim FileSizeKB As Long
    Dim FileData() As Byte
    Dim DComplete As Boolean: DComplete = False
    Dim FileP1 As Long
    Dim LStatus As Long
    Dim FileStr As String
    Dim m_HTTPHeader As String
    

    m_HTTPHeader = Inet1.GetHeader

    If LenB(StrConv(m_HTTPHeader, vbFromUnicode)) < 3 Then
        RetreiveFile = False
        GetStatus = False
        Exit Function
    End If
    
    Select Case Mid$(m_HTTPHeader, 10, 3)
        Case "401"              '// Unauthorized Access (파일에 대한 접근 권한이 없을때)
            RetreiveFile = False
            GetStatus = False
            Exit Function
        Case "403"              '// Access Denied (파일접근을 거부했을 경우)
            RetreiveFile = False
            GetStatus = False
            Exit Function
        Case "404"              '// 파일을 찾을 수 없습니다.
            RetreiveFile = False
            GetStatus = False
            Exit Function
    End Select

 
    
    'Get the file size from the file header
    FileSize = Inet1.GetHeader("Content-Length")
        
    FileSizeKB = Format(FileSize / 1000, "#.##")
    
    'Set Labels to show up info
    LabelFileSize.Caption = FileSizeKB & " Kb"
'    LabelStatus.Caption = "0 bytes" & " / " & FileSize & " bytes"
      
    'Set the progress bar
'    StatusBar1.Max = FileSize
'    StatusBar1.Value = 0
    LStatus = 0
    updateprogress StatusBar1, (LStatus / FileSize) * 100

    ' Get first chunk.
    FileData() = Inet1.GetChunk(ChunkSize, icByteArray)
    
    FileStr = CStr(FileData())
    
    'Assign freefile number
    FileP1 = FreeFile
    
    ' Open binary file to save
    Open FileDestination For Binary Access Write As #FileP1
On Error GoTo FileOpen_Error:
      
    ' loop until we have retreive all file bytes , by chunk of 1024 bytes
    Do While Not DComplete
      
        'write to the file
        Put #FileP1, , FileData()
        
        'update progress bar and status label
        'the iif() is in case the file is less than 1024 bytes, oups !
        LStatus = IIf(LStatus + ChunkSize > FileSize, FileSize, LStatus + ChunkSize)
        updateprogress StatusBar1, (LStatus / FileSize) * 100
        
        'LabelStatus.Caption = StatusBar1.Value & " bytes" & " / " & FileSize & " bytes"
        
        '이 페이지를 찾을 수 없습니다.
        
        ' Get other chunks
        FileData() = Inet1.GetChunk(ChunkSize, icByteArray)
        
        ' Let window do its things
        DoEvents
         
        'If the FileData is empty, we are done !
        If UBound(FileData()) = -1 Then DComplete = True
         
      Loop
      
      'Close the file
      Close #FileP1
      'cancel any left over proccess (just in case)
      Inet1.Cancel
      RetreiveFile = True
      GetStatus = True
      Exit Function

FileOpen_Error:
    Close #FileP1
    
RetreiveFile_Error:
    RetreiveFile = False
    GetStatus = False
    DeleteFile FileDestination
'Resume
'    Close #FileP1
End Function
