VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form frmMain 
   Appearance      =   0  '평면
   BackColor       =   &H80000005&
   BorderStyle     =   1  '단일 고정
   Caption         =   "업데이트관리"
   ClientHeight    =   1320
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4905
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1320
   ScaleWidth      =   4905
   StartUpPosition =   2  '화면 가운데
   Begin VB.PictureBox Pbar1 
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   8.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   0
      ScaleHeight     =   165
      ScaleWidth      =   4860
      TabIndex        =   2
      Top             =   1080
      Width           =   4920
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   4560
      TabIndex        =   1
      Top             =   360
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.Timer TmrWait 
      Left            =   600
      Top             =   0
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   0
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      Protocol        =   4
      URL             =   "http://"
   End
   Begin VB.Label Label2 
      BackStyle       =   0  '투명
      Caption         =   "현재 파일 사이즈"
      Height          =   255
      Left            =   75
      TabIndex        =   4
      ToolTipText     =   "연결이 되있을떄 표시되는 파일사이즈.."
      Top             =   840
      Width           =   1395
   End
   Begin VB.Label LabelFS 
      BackStyle       =   0  '투명
      Caption         =   "0 Kb"
      Height          =   225
      Left            =   1635
      TabIndex        =   3
      ToolTipText     =   "연결이 되있을떄 표시되는 파일사이즈.."
      Top             =   840
      Width           =   2145
   End
   Begin VB.Label Label1 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      BackColor       =   &H80000005&
      BackStyle       =   0  '투명
      Caption         =   "Label1"
      ForeColor       =   &H80000008&
      Height          =   735
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   5000
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim MyFileNameDestination As String


Private Sub Command1_Click()
    Call CheckUpdate
    Unload Me
End Sub

Private Sub Form_Activate()
    Label1.Caption = vbCrLf & "프로그램버젼을 체크하고있습니다." & _
                         vbCrLf & "잠시만 기다려주세요."
    'Timer1.Interval = 1000
    
    frmMain.Caption = ReadINI("FormCaption", "Name", "현금영수증관리", App.Path & "\ver.ini")
    Command1_Click
    
    'Timer1.Interval = 0

End Sub

Private Sub Form_Load()
'
End Sub

Private Function FindFiles(ByVal dir_path As String, _
  Optional ByVal exclude_self As Boolean = True, _
  Optional ByVal exclude_parent As Boolean = True) As _
      String()
Dim num_files As Integer
Dim files() As String
Dim file_name As String
    file_name = Dir$(dir_path)
    Do While Len(file_name) > 0
        ' See if we should skip this file.
        If Not _
            (exclude_self And file_name = ".") Or _
            (exclude_parent And file_name = "..") _
        Then
            ' Save the file.
            num_files = num_files + 1
            ReDim Preserve files(1 To num_files)
            files(num_files) = file_name
        End If

        ' Get the next file.
        file_name = Dir$()
    Loop

    ' Return the list.
    FindFiles = files
End Function

Private Sub CheckUpdate(Optional ByRef ConnectionInfo As Long, Optional ByRef sConnectionName As String)


'==============================
Dim sUpDateFile() As String
Dim i, j As Integer
Dim NewVerCount As Integer
Dim New_ver, Old_ver As Double
Dim sDownPath As String
Dim sDownFile() As String
Dim sShutDown() As String
Dim nHwnd&
Dim nExit&, rt&
Dim nProc&, ProcID& ' 식별자, 프로세스ID
Dim MovePath As String
Dim SystemDir As String * 30
Dim Dlen As Integer
Dim SAddr As String
Dim Con_Count As Integer
Dim sVer_File As String


'If Dir(App.Path & "\ver.ini") = "" Then
'    MsgBox "환경파일이 존재하지 않습니다." & vbCrLf & "재설치 하여 주시기 바랍니다."
'    Exit Sub
'End If


'현재 디렉토리의 Ver.ini 정보를 읽는다.
'서버의 Ver.ini 정보를 읽는다.
'서버의 Ver정보의 [Update File] 정보를 읽는다.
'각 정보의 해당 서버 버젼과 로컬 버젼을 비교한다.
'버젼이 틀린 화일 정보를 가지고 있으면서 해당 화일을 다운로드 한다.
'Move.exe 프로그램을 실행시키고 종료
'Move.exe 프로그램은 /download 디렉토리의 exe 화일을 점검하여 프로세스 기동중이면 강제 종료 후 자신의 디렉토리로 move 후 종료
 
SAddr = ReadINI("ServerINIPath", "Path", "http://myhome.naver.com/icon001/ver/", App.Path & "\ver.ini")
sVer_File = ReadINI("ServerINIFile", "Name", "ver.ini", App.Path & "\ver.ini")

If Dir(App.Path & "\download\", vbDirectory) = "" Then
    MakeDIR (App.Path & "\download\")
End If

SAddr = SAddr & sVer_File

If Dir(App.Path & "\download\" & sVer_File) <> "" Then
    Kill (App.Path & "\download\" & sVer_File)
End If

If GetInternetFile(Inet1, SAddr, App.Path & "\download") = False Then
    If ExecProgram(App.Path & "\" & ReadINI("StartProgram", "Name", "", App.Path & "\ver.ini"), vbNormalFocus) = False Then
        MsgBox "프로그램 실행중 문제가 발생했습니다.(1)" & vbCrLf & "개발실에 문의 바랍니다." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "0502-703-0369", App.Path & "\ver.ini"), , "KT현금영수증"
    End If
   Exit Sub
End If
WriteINI "ServerINIPath", "Path", ReadINI("ServerINIPath", "Path", SAddr, App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"


sUpDateFile = Split(ReadINI("Update File", "Name", "", App.Path & "\download\" & sVer_File), ";")  '업데이트 화일 정보
sShutDown = Split(ReadINI("ShutDownProcess", "Name", "", App.Path & "\download\" & sVer_File), ";")

NewVerCount = 0

LabelFS.Visible = True
Label2.Visible = True
Pbar1.Visible = True
Pbar1.ForeColor = RGB(0, 0, 255) ' 청색 진도표시

GetStatus = True  '정상적으로 모든 화일 다운 받은 경우 true 이며 하나라도 실패한경우 False 로 변경됨

For i = 0 To UBound(sUpDateFile()) - 1
    
    Label1.Caption = vbCrLf & "프로그램을 업그레이드 하고 있습니다." & _
                         vbCrLf & i + 1 & "/" & UBound(sUpDateFile()) & "잠시만 기다려주세요." & _
                         vbCrLf & "(" & sUpDateFile(i) & ")"
    
'    updateprogress Pbar1, (i / UBound(sUpDateFile())) * 100
    
    If sUpDateFile(i) = "" Then
        Exit For
    End If
    
    New_ver = CDbl(ReadINI(sUpDateFile(i), "ver", "0", App.Path & "\download\" & sVer_File))
    Old_ver = CDbl(ReadINI(sUpDateFile(i), "ver", "0", App.Path & "\ver.ini"))
    
    If New_ver <> Old_ver Then
        NewVerCount = NewVerCount + 1
        sDownPath = ReadINI(sUpDateFile(i), "path", "http://myhome.naver.com/icon001/down/", App.Path & "\download\" & sVer_File)
        
        If sDownPath <> "0" Then
            
            sDownPath = sDownPath & sUpDateFile(i)
            MyFileNameDestination = App.Path & "\download\" & sUpDateFile(i)
            Con_Count = 0 'Connect Count 초기화
Connect_Retry:
            Con_Count = Con_Count + 1
Sleep 200
            If Inet1.StillExecuting = True Then  'Inet1 초기화
                Inet1.Cancel
            End If
            
            Inet1.Protocol = icHTTP
           ' MsgBox sDownPath, , "KT현금영수증"
            Inet1.Execute sDownPath, "GET"  'Inet1을 이용해서 다운로드 받음
            
            While Inet1.StillExecuting  '다운로드 받는 동안 대기
                DoEvents
            Wend
            
            If GetStatus = False Then  '화일을 한개라도 받지 못한 경우 다운로드 받은 화일을 삭제 후 기존 프로그램 실행
                If Con_Count < 4 Then
                    'GetStatus = True  '중간에 끊기는 경우???
                    GoTo Connect_Retry:  '접속 실패시 3번은 재시도 해본 후에 그래도 에러이면 아래 사항을 처리 함
                End If
                For j = 0 To i
                    DeleteFile App.Path & "\download\" & sUpDateFile(j)
                Next j
                If ExecProgram(App.Path & "\" & ReadINI("StartProgram", "Name", "", App.Path & "\ver.ini"), vbNormalFocus) = False Then
                    MsgBox "프로그램 실행중 문제가 발생했습니다.(2)" & vbCrLf & "개발실에 문의 바랍니다." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "0502-703-0369", App.Path & "\ver.ini"), , "KT현금영수증"
                End If
                
                Exit Sub
            End If
'           또다른 방법으로 다운로드 받는 방법
            
'            sDownPath = sDownPath & sUpDateFile(i)
'            If GetInternetFile(Inet1, sDownPath, App.Path & "\download\") = False Then
'               DeleteFile App.Path & "\download\" & sUpDateFile(i) 'delete 다운 받던 화일 삭제
'            End If
        End If
    End If
    
Next i

If NewVerCount > 0 Then
    Label1.Caption = vbCrLf & "변경된 프로그램을 적용하고 있습니다." & _
                         vbCrLf & "잠시만 기다려주세요."
Else
    Label1.Caption = vbCrLf & "프로그램을 수행중입니다." & _
                         vbCrLf & "잠시만 기다려주세요."
End If
                         
LabelFS.Visible = False
Label2.Visible = False
Pbar1.Visible = False
DoEvents

'' 업데이트 할 프로그램중 현재 실행되고 있는 프로그램이 있으면 종료 시킨다.
For i = 0 To UBound(sShutDown()) - 1
    ProcID& = GetPidByImage(sShutDown(i))  '프로세스 ID 핸들값을 찾는다.
    
    If ProcID <> 0 Then
        CloseProcess (ProcID)
        ProcID& = GetPidByImage(sShutDown(i)) '같은 실행 화일이 2개이상 실행되는 경우가 있는지 체크
        While ProcID
            CloseProcess (ProcID)
            ProcID& = GetPidByImage(sShutDown(i))
        Wend
    End If
Next i
'For i = 1 To UBound(sDownFile())  '다운받은 화일만 조사 할때는 문제점 발생
'    If (GetFileExtension(sDownFile(i))) = "exe" Then
'        '프로세스가 실행되는지 확인 후 프로세스 shut down
'        ProcID& = GetPidByImage(sDownFile(i))  '프로세스 ID 핸들값을 찾는다.
'
'        If ProcID <> 0 Then
'            CloseProcess (ProcID)
'            ProcID& = GetPidByImage(sDownFile(i)) '같은 실행 화일이 2개이상 실행되는 경우가 있는지 체크
'            While ProcID
'                CloseProcess (ProcID)
'                ProcID& = GetPidByImage(sDownFile(i))
'            Wend
'        End If
'    End If
'Next i

sDownFile = FindFiles(App.Path & "\download\")

'' 화일을 해당 디렉토리에 이동시킨다.
For i = 1 To UBound(sDownFile())
    If sDownFile(i) <> sVer_File Then
        MovePath = ReadINI(sDownFile(i), "Localpath", ".\", App.Path & "\download\" & sVer_File)
        If InStr(1, MovePath, "{Windows}") Then
            Dlen = GetWindowsDirectory(SystemDir, 30)
            MovePath = Replace(MovePath, "{Windows}", Trim(Left(SystemDir, Dlen)))
        ElseIf InStr(1, MovePath, "{WindowsSystem}") Then
            Dlen = GetSystemDirectory(SystemDir, 30)
            MovePath = Replace(MovePath, "{WindowsSystem}", Trim(Left(SystemDir, Dlen)))
        ElseIf Left(MovePath, 1) = "\" Then
            MovePath = Mid(MovePath, 2)
        Else
            MovePath = App.Path & "\" & MovePath
        End If
        If Dir(MovePath, vbDirectory) = "" Then
            MakeDIR MovePath
        End If
        
        If (MoveFile(App.Path & "\download\" & sDownFile(i), MovePath & "\" & sDownFile(i))) = False Then
            MsgBox sDownFile(i) & " 파일을 업데이트 하는데 실패하였습니다.(3)" & vbCrLf & "개발실 문의 바랍니다." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "0502-703-0369", App.Path & "\ver.ini"), , "KT현금영수증"
        Else
            '업데이트 된 화일정보 기록
            WriteINI sDownFile(i), "Ver", ReadINI(sDownFile(i), "ver", "1.0", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI sDownFile(i), "Path", ReadINI(sDownFile(i), "Path", "", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI sDownFile(i), "LocalPath", ReadINI(sDownFile(i), "LocalPath", "", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "ServerINIFile", "Name", ReadINI("ServerINIFile", "Name", sVer_File, App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "StartProgram", "Name", ReadINI("StartProgram", "Name", "", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "AS_TEL", "Phone", ReadINI("AS_TEL", "Phone", "02-710-1923", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "FormCaption", "Name", ReadINI("FormCaption", "Name", "현금영수증관리", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
        End If

    End If
Next i


If ExecProgram(App.Path & "\" & ReadINI("StartProgram", "Name", "", App.Path & "\ver.ini"), vbNormalFocus) = False Then
    MsgBox "프로그램 실행중 문제가 발생했습니다.(4)" & vbCrLf & "개발실에 문의 바랍니다." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "02-710-1923", App.Path & "\ver.ini"), , "KT현금영수증"
End If


End Sub

Private Sub Inet1_StateChanged(ByVal State As Integer)
    
    If State = icError Then
        Debug.Print Inet1.ResponseCode & ":" & Inet1.ResponseInfo
    End If
    
    If State = icResponseCompleted Then
        RetreiveFile Inet1, MyFileNameDestination, Pbar1, LabelFS, Label1
    End If

End Sub

