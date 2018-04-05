Attribute VB_Name = "MCommon"
'Declare Function WinExec Lib "Kernel32" (ByVal lpCmdLine As String, ByVal nCmdShow As Integer) As Integer
Public Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Public Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Public GetStatus As Boolean

Public Sub updateprogress(pb As Control, ByVal percent)
   Dim num As String
   
   If Not pb.AutoRedraw Then
       pb.AutoRedraw = -1
   End If
   
   pb.Cls

   pb.ScaleWidth = 100
   pb.DrawMode = 10
   num = Format$(percent, "###") + "%"

   pb.CurrentX = 50 - pb.TextWidth(num) / 2
   pb.CurrentY = (pb.ScaleHeight - pb.TextHeight(num)) / 2
   pb.Print num

   pb.Line (0, 0)-(percent, pb.ScaleHeight), , BF
   pb.Refresh

End Sub



Public Function ExecProgram(Pathname As String, Windowstyle As Integer) As Boolean
    On Error GoTo ExecError
    Shell Pathname, Windowstyle
    ExecProgram = True
    Exit Function
ExecError:
ExecProgram = False
'    MsgBox "Error deleting File"
'    Resume
End Function

