VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form frmMain 
   Appearance      =   0  '���
   BackColor       =   &H80000005&
   BorderStyle     =   1  '���� ����
   Caption         =   "������Ʈ����"
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
   StartUpPosition =   2  'ȭ�� ���
   Begin VB.PictureBox Pbar1 
      BeginProperty Font 
         Name            =   "����"
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
      BackStyle       =   0  '����
      Caption         =   "���� ���� ������"
      Height          =   255
      Left            =   75
      TabIndex        =   4
      ToolTipText     =   "������ �������� ǥ�õǴ� ���ϻ�����.."
      Top             =   840
      Width           =   1395
   End
   Begin VB.Label LabelFS 
      BackStyle       =   0  '����
      Caption         =   "0 Kb"
      Height          =   225
      Left            =   1635
      TabIndex        =   3
      ToolTipText     =   "������ �������� ǥ�õǴ� ���ϻ�����.."
      Top             =   840
      Width           =   2145
   End
   Begin VB.Label Label1 
      Alignment       =   2  '��� ����
      Appearance      =   0  '���
      BackColor       =   &H80000005&
      BackStyle       =   0  '����
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
    Label1.Caption = vbCrLf & "���α׷������� üũ�ϰ��ֽ��ϴ�." & _
                         vbCrLf & "��ø� ��ٷ��ּ���."
    'Timer1.Interval = 1000
    
    frmMain.Caption = ReadINI("FormCaption", "Name", "���ݿ���������", App.Path & "\ver.ini")
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
Dim nProc&, ProcID& ' �ĺ���, ���μ���ID
Dim MovePath As String
Dim SystemDir As String * 30
Dim Dlen As Integer
Dim SAddr As String
Dim Con_Count As Integer
Dim sVer_File As String


'If Dir(App.Path & "\ver.ini") = "" Then
'    MsgBox "ȯ�������� �������� �ʽ��ϴ�." & vbCrLf & "�缳ġ �Ͽ� �ֽñ� �ٶ��ϴ�."
'    Exit Sub
'End If


'���� ���丮�� Ver.ini ������ �д´�.
'������ Ver.ini ������ �д´�.
'������ Ver������ [Update File] ������ �д´�.
'�� ������ �ش� ���� ������ ���� ������ ���Ѵ�.
'������ Ʋ�� ȭ�� ������ ������ �����鼭 �ش� ȭ���� �ٿ�ε� �Ѵ�.
'Move.exe ���α׷��� �����Ű�� ����
'Move.exe ���α׷��� /download ���丮�� exe ȭ���� �����Ͽ� ���μ��� �⵿���̸� ���� ���� �� �ڽ��� ���丮�� move �� ����
 
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
        MsgBox "���α׷� ������ ������ �߻��߽��ϴ�.(1)" & vbCrLf & "���߽ǿ� ���� �ٶ��ϴ�." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "0502-703-0369", App.Path & "\ver.ini"), , "KT���ݿ�����"
    End If
   Exit Sub
End If
WriteINI "ServerINIPath", "Path", ReadINI("ServerINIPath", "Path", SAddr, App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"


sUpDateFile = Split(ReadINI("Update File", "Name", "", App.Path & "\download\" & sVer_File), ";")  '������Ʈ ȭ�� ����
sShutDown = Split(ReadINI("ShutDownProcess", "Name", "", App.Path & "\download\" & sVer_File), ";")

NewVerCount = 0

LabelFS.Visible = True
Label2.Visible = True
Pbar1.Visible = True
Pbar1.ForeColor = RGB(0, 0, 255) ' û�� ����ǥ��

GetStatus = True  '���������� ��� ȭ�� �ٿ� ���� ��� true �̸� �ϳ��� �����Ѱ�� False �� �����

For i = 0 To UBound(sUpDateFile()) - 1
    
    Label1.Caption = vbCrLf & "���α׷��� ���׷��̵� �ϰ� �ֽ��ϴ�." & _
                         vbCrLf & i + 1 & "/" & UBound(sUpDateFile()) & "��ø� ��ٷ��ּ���." & _
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
            Con_Count = 0 'Connect Count �ʱ�ȭ
Connect_Retry:
            Con_Count = Con_Count + 1
Sleep 200
            If Inet1.StillExecuting = True Then  'Inet1 �ʱ�ȭ
                Inet1.Cancel
            End If
            
            Inet1.Protocol = icHTTP
           ' MsgBox sDownPath, , "KT���ݿ�����"
            Inet1.Execute sDownPath, "GET"  'Inet1�� �̿��ؼ� �ٿ�ε� ����
            
            While Inet1.StillExecuting  '�ٿ�ε� �޴� ���� ���
                DoEvents
            Wend
            
            If GetStatus = False Then  'ȭ���� �Ѱ��� ���� ���� ��� �ٿ�ε� ���� ȭ���� ���� �� ���� ���α׷� ����
                If Con_Count < 4 Then
                    'GetStatus = True  '�߰��� ����� ���???
                    GoTo Connect_Retry:  '���� ���н� 3���� ��õ� �غ� �Ŀ� �׷��� �����̸� �Ʒ� ������ ó�� ��
                End If
                For j = 0 To i
                    DeleteFile App.Path & "\download\" & sUpDateFile(j)
                Next j
                If ExecProgram(App.Path & "\" & ReadINI("StartProgram", "Name", "", App.Path & "\ver.ini"), vbNormalFocus) = False Then
                    MsgBox "���α׷� ������ ������ �߻��߽��ϴ�.(2)" & vbCrLf & "���߽ǿ� ���� �ٶ��ϴ�." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "0502-703-0369", App.Path & "\ver.ini"), , "KT���ݿ�����"
                End If
                
                Exit Sub
            End If
'           �Ǵٸ� ������� �ٿ�ε� �޴� ���
            
'            sDownPath = sDownPath & sUpDateFile(i)
'            If GetInternetFile(Inet1, sDownPath, App.Path & "\download\") = False Then
'               DeleteFile App.Path & "\download\" & sUpDateFile(i) 'delete �ٿ� �޴� ȭ�� ����
'            End If
        End If
    End If
    
Next i

If NewVerCount > 0 Then
    Label1.Caption = vbCrLf & "����� ���α׷��� �����ϰ� �ֽ��ϴ�." & _
                         vbCrLf & "��ø� ��ٷ��ּ���."
Else
    Label1.Caption = vbCrLf & "���α׷��� �������Դϴ�." & _
                         vbCrLf & "��ø� ��ٷ��ּ���."
End If
                         
LabelFS.Visible = False
Label2.Visible = False
Pbar1.Visible = False
DoEvents

'' ������Ʈ �� ���α׷��� ���� ����ǰ� �ִ� ���α׷��� ������ ���� ��Ų��.
For i = 0 To UBound(sShutDown()) - 1
    ProcID& = GetPidByImage(sShutDown(i))  '���μ��� ID �ڵ鰪�� ã�´�.
    
    If ProcID <> 0 Then
        CloseProcess (ProcID)
        ProcID& = GetPidByImage(sShutDown(i)) '���� ���� ȭ���� 2���̻� ����Ǵ� ��찡 �ִ��� üũ
        While ProcID
            CloseProcess (ProcID)
            ProcID& = GetPidByImage(sShutDown(i))
        Wend
    End If
Next i
'For i = 1 To UBound(sDownFile())  '�ٿ���� ȭ�ϸ� ���� �Ҷ��� ������ �߻�
'    If (GetFileExtension(sDownFile(i))) = "exe" Then
'        '���μ����� ����Ǵ��� Ȯ�� �� ���μ��� shut down
'        ProcID& = GetPidByImage(sDownFile(i))  '���μ��� ID �ڵ鰪�� ã�´�.
'
'        If ProcID <> 0 Then
'            CloseProcess (ProcID)
'            ProcID& = GetPidByImage(sDownFile(i)) '���� ���� ȭ���� 2���̻� ����Ǵ� ��찡 �ִ��� üũ
'            While ProcID
'                CloseProcess (ProcID)
'                ProcID& = GetPidByImage(sDownFile(i))
'            Wend
'        End If
'    End If
'Next i

sDownFile = FindFiles(App.Path & "\download\")

'' ȭ���� �ش� ���丮�� �̵���Ų��.
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
            MsgBox sDownFile(i) & " ������ ������Ʈ �ϴµ� �����Ͽ����ϴ�.(3)" & vbCrLf & "���߽� ���� �ٶ��ϴ�." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "0502-703-0369", App.Path & "\ver.ini"), , "KT���ݿ�����"
        Else
            '������Ʈ �� ȭ������ ���
            WriteINI sDownFile(i), "Ver", ReadINI(sDownFile(i), "ver", "1.0", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI sDownFile(i), "Path", ReadINI(sDownFile(i), "Path", "", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI sDownFile(i), "LocalPath", ReadINI(sDownFile(i), "LocalPath", "", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "ServerINIFile", "Name", ReadINI("ServerINIFile", "Name", sVer_File, App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "StartProgram", "Name", ReadINI("StartProgram", "Name", "", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "AS_TEL", "Phone", ReadINI("AS_TEL", "Phone", "02-710-1923", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
            WriteINI "FormCaption", "Name", ReadINI("FormCaption", "Name", "���ݿ���������", App.Path & "\download\" & sVer_File), App.Path & "\ver.ini"
        End If

    End If
Next i


If ExecProgram(App.Path & "\" & ReadINI("StartProgram", "Name", "", App.Path & "\ver.ini"), vbNormalFocus) = False Then
    MsgBox "���α׷� ������ ������ �߻��߽��ϴ�.(4)" & vbCrLf & "���߽ǿ� ���� �ٶ��ϴ�." & vbCrLf & "TEL:" & ReadINI("AS_TEL", "Phone", "02-710-1923", App.Path & "\ver.ini"), , "KT���ݿ�����"
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

