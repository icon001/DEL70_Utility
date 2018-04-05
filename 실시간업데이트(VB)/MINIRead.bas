Attribute VB_Name = "MINIRead"
Option Explicit

'INI 파일에 값을 써 넣는다.
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias _
        "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, _
        ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal _
        lpFileName As String) As Long

'INI 파일에 값을 읽어온다.
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias _
        "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, _
        ByVal lpString As Any, ByVal lpFileName As String) As Long
        
''*************************************************************************************************
''INI 파일 Read (strSection:섹션명 / strKey:키값 / strValue:지정된값 / strFileName:INI파일경로명)
''Sample : aaa = ReadINI("MEDICOM", "ver", "", app.path & "\mna.ini")
''*************************************************************************************************

Public Function ReadINI(ByVal strSection As String, ByVal strKey As String, _
                        ByVal strValue As String, ByVal strFileName As String) As String

On Error GoTo ReadINI_Error:
    
    Dim iRet As Long                    'API 함수의 리턴값 받음
    Dim strRet As String * 250          'INI 값 Read
    
    '전달된 파리미터에 해당하는 값을 읽어들인다.
    iRet = GetPrivateProfileString(strSection, strKey, strValue, strRet, 250, strFileName)
    
    '25자리일 경우에는 해당되는 값이 없는내용을 리턴한다.
    ''If iRet = 25 Then
    If iRet = 0 Then
        '값이 없을 경우
        ReadINI = strValue
    Else
        '값이 있을 경우는 값을 리턴한다.
        ReadINI = Mid(strRet, 1, InStr(strRet, Chr(0)) - 1)
    End If
    Exit Function

ReadINI_Error:
    ReadINI = strValue
End Function

''*************************************************************************************************
''INI 파일 Write (strSection:섹션명 / strKey:키값 / strValue:저장할값 / strFileName:INI파일경로명)
''Sample : If WriteINI("MEDICOM", "ver", "1.0.5", app.path & "\mna.ini") = False Then
''*************************************************************************************************

Public Function WriteINI(ByVal strSection As String, ByVal strKey As String, _
                    ByVal strValue As String, ByVal strFileName As String) As Boolean
    
On Error GoTo WriteINI_Error

    Dim iRet As Long                    'API 함수의 리턴값 받음

    '값이 25자리라면, 1자리를 붙여서 입력한다.
    If Len(strValue) = 25 Then
        strValue = strValue & Space(1)
    End If

    'INI 파일에 값을 쓴다.
    iRet = WritePrivateProfileString(strSection, strKey, strValue, strFileName)

    '처리값의 성공여부
    If iRet = 0 Then
        WriteINI = False
    Else
        WriteINI = True
    End If

    Exit Function

WriteINI_Error:
    WriteINI = False
End Function


''*************************************************************************************************
''INI 파일 Write (strSection:섹션명 / strKey:키값 / strValue:저장할값 / strFileName:INI파일경로명)
''Sample : If WriteINI("MEDICOM", "ver", "1.0.5", app.path & "\mna.ini") = False Then
''*************************************************************************************************
Public Function WriteINIFile(ByVal strSection As String, ByVal strKey As String, _
                    ByVal strValue As String, ByVal strFileName As String) As Boolean
On Error GoTo WriteINIFile_Error
Dim L_stFileNumber As String          '파일번호
Dim L_stRead As String              '파일읽은내용
Dim L_stGroup() As String           '분류한 내용을 가지는그룹
Dim L_stTemp() As String
Dim i, j As Integer
Dim L_bFlag As Boolean

    L_stFileNumber = FreeFile
    L_bFlag = False

    Open strFileName For Input Access Read As #L_stFileNumber '파일 오픈
    
    'Do While Not EOF(1)   ' 파일의 끝을 만날 때까지 반복합니다. 한번만 읽기 때문에 필요 없음
        Erase L_stGroup
        Line Input #L_stFileNumber, L_stRead   ' 변수로 데이터 행을 읽어들입니다. 한줄임
        L_stGroup() = Split(L_stRead, "[")  'strSection으로 구분
   ' Loop
    
    For i = LBound(L_stGroup) To UBound(L_stGroup)
        If ((Left(L_stGroup(i), Len(strSection)) = strSection)) Then '현재 섹션이면
            L_stTemp() = Split(L_stGroup(i), Chr(10)) 'chr(10)으로 구분
            For j = LBound(L_stTemp) To UBound(L_stTemp)
                If ((Left(L_stTemp(j), Len(strKey)) = strKey)) Then  '현재 섹션에 strKey 가 있으면
                    L_stTemp(j) = strKey & "=" & strValue
                    L_bFlag = True
                End If
                
            Next j
            If (L_bFlag = False) Then '현재 섹션에 strKey가 없으면 add 시킴
                   ReDim L_stTemp(j + 1)
                   L_stTemp(j + 1) = strKey & "=" & strValue
                   L_bFlag = True
            End If
            
            L_stGroup(i) = "" '현재 섹션을 비움
                        
            For j = LBound(L_stTemp) To UBound(L_stTemp)  '현재 섹션을 변경된 섹션 값으로 저장
                L_stGroup(i) = L_stGroup(i) & L_stTemp(j) & Chr(10)
            Next j
           
        End If
        
    Next i
    
    If L_bFlag = False Then '현재 ini 화일에 섹션이 없으면 현재 섹션을 add 시킴
        ReDim L_stGroup(i + 1)
        L_stGroup(i + 1) = strSection & "]" & Chr(10) & strKey & "=" & strValue & Chr(10)
    End If
    
    L_stTemp(0) = ""
    For i = LBound(L_stGroup) + 1 To UBound(L_stGroup) '원래 데이터로 치환 시켜 놓음
        L_stTemp(0) = L_stTemp(0) & "[" & L_stGroup(i)
    Next i
    
    
   
    Close #L_stFileNumber
    
    L_stFileNumber = FreeFile

    Open strFileName For Output As #L_stFileNumber '파일 오픈
    Print #L_stFileNumber, L_stTemp(0);
    Close #L_stFileNumber
    
    WriteINIFile = True
    
    Exit Function


WriteINIFile_Error:
    WriteINIFile = False
End Function



