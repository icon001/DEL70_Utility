Attribute VB_Name = "MFile"

Public Sub DeleteFile(FileName As String)
    On Error GoTo DelError
    Kill FileName
    Exit Sub
DelError:
'    MsgBox "Error deleting File"
'    Resume
End Sub


Public Sub MakeDIR(Path As String)
    On Error GoTo DIRError
    MkDir Path
    Exit Sub
DIRError:
End Sub

Function MoveFile(Source As String, Destination As String) As Boolean
    On Error GoTo MoveError
    FileCopy Source, Destination
    Kill Source
    MoveFile = True
    Exit Function
MoveError:
MoveFile = False
End Function


Public Sub Save(FileName As String)

'    If FileReal = True Then
'        If MsgBox("Overwrite File?", vbYesNo) = vbYes Then
'            DeleteFile (FileName)
'            'save file code
'        Else
'            'do NOT overwrite the file
'        End If
'    End If
End Sub


Public Function FileReal(FileName) As Boolean
    On Error GoTo Error


    If Dir(FileName) = FileName Then
        FileReal = True
    Else
        FileReal = False
    End If
    Exit Function
Error:
    Exit Function
End Function


Public Function GetFileSize(FileName) As String
    On Error GoTo Gfserror
    Dim TempStr As String
    TempStr = FileLen(FileName)


    If TempStr >= "1024" Then
        'KB
        TempStr = CCur(TempStr / 1024) & "KB"
    Else


        If TempStr >= "1048576" Then
            'MB
            TempStr = CCur(TempStr / (1024 * 1024)) & "KB"
        Else
            TempStr = CCur(TempStr) & "B"
        End If
    End If
    GetFileSize = TempStr
    Exit Function
Gfserror:
    GetFileSize = "0B"
    Resume
End Function


Public Function GetAttrib(FileName) As String
    On Error GoTo GAError
    Dim TempStr As String
    TempStr = GetAttr(FileName)


    If TempStr = "64" Then
        TempStr = "Alias"
    End If


    If TempStr = "32" Then
        TempStr = "Archive"
    End If


    If TempStr = "16" Then
        TempStr = "Directory"
    End If


    If TempStr = "2" Then
        TempStr = "Hidden"
    End If


    If TempStr = "0" Then
        TempStr = "Normal"
    End If


    If TempStr = "1" Then
        TempStr = "ReadOnly"
    End If


    If TempStr = "4" Then
        TempStr = "System"
    End If


    If TempStr = "8" Then
        TempStr = "Volume"
    End If
    GetAttrib = TempStr
    Exit Function
GAError:
    GetAttrib = "Unknown"
    Resume
End Function


Public Sub SetHidden(FileName As String)
    On Error Resume Next
    SetAttr FileName, vbHidden
End Sub


Public Sub SetReadOnly(FileName As String)
    On Error Resume Next
    SetAttr FileName, vbReadOnly
End Sub


Public Sub SetSystem(FileName As String)
    On Error Resume Next
    SetAttr FileName, vbSystem
End Sub


Public Sub SetNormal(FileName As String)
    On Error Resume Next
    SetAttr FileName, vbNormal
End Sub


Public Function GetFileExtension(FileName As String)
    On Error Resume Next
    Dim TempStr As String
    TempStr = Right(FileName, 2)


    If Left(TempStr, 1) = "." Then
        GetFileExtension = Right(FileName, 1)
        Exit Function
    Else
        TempStr = Right(FileName, 3)


        If Left(TempStr, 1) = "." Then
            GetFileExtension = Right(FileName, 2)
            Exit Function
        Else
            TempStr = Right(FileName, 4)


            If Left(TempStr, 1) = "." Then
                GetFileExtension = Right(FileName, 3)
                Exit Function
            Else
                TempStr = Right(FileName, 5)


                If Left(TempStr, 1) = "." Then
                    GetFileExtension = Right(FileName, 4)
                    Exit Function
                Else
                    GetFileExtension = "Unknown"
                End If
            End If
        End If
    End If
    
End Function


Public Function GetFileDate(FileName As String) As String
    On Error Resume Next
    GetFileDate = FileDateTime(FileName)
End Function




Public Sub CopyFile(Source As String, Destination As String)
    On Error GoTo CopyError
    FileCopy Source, Destination
    Exit Sub
CopyError:
    MsgBox "Error copying File"
    Resume
End Sub



Public Sub RemoveDIR(Path As String)
    On Error GoTo DIRError2
    RmDir Path
    Exit Sub
DIRError2:
    MsgBox "Error removing Directory"
    Resume
End Sub


Public Sub CloseAllFiles()
    On Error Resume Next
    Reset
End Sub

