Attribute VB_Name = "MINIRead"
Option Explicit

'INI ���Ͽ� ���� �� �ִ´�.
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias _
        "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, _
        ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal _
        lpFileName As String) As Long

'INI ���Ͽ� ���� �о�´�.
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias _
        "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, _
        ByVal lpString As Any, ByVal lpFileName As String) As Long
        
''*************************************************************************************************
''INI ���� Read (strSection:���Ǹ� / strKey:Ű�� / strValue:�����Ȱ� / strFileName:INI���ϰ�θ�)
''Sample : aaa = ReadINI("MEDICOM", "ver", "", app.path & "\mna.ini")
''*************************************************************************************************

Public Function ReadINI(ByVal strSection As String, ByVal strKey As String, _
                        ByVal strValue As String, ByVal strFileName As String) As String

On Error GoTo ReadINI_Error:
    
    Dim iRet As Long                    'API �Լ��� ���ϰ� ����
    Dim strRet As String * 250          'INI �� Read
    
    '���޵� �ĸ����Ϳ� �ش��ϴ� ���� �о���δ�.
    iRet = GetPrivateProfileString(strSection, strKey, strValue, strRet, 250, strFileName)
    
    '25�ڸ��� ��쿡�� �ش�Ǵ� ���� ���³����� �����Ѵ�.
    ''If iRet = 25 Then
    If iRet = 0 Then
        '���� ���� ���
        ReadINI = strValue
    Else
        '���� ���� ���� ���� �����Ѵ�.
        ReadINI = Mid(strRet, 1, InStr(strRet, Chr(0)) - 1)
    End If
    Exit Function

ReadINI_Error:
    ReadINI = strValue
End Function

''*************************************************************************************************
''INI ���� Write (strSection:���Ǹ� / strKey:Ű�� / strValue:�����Ұ� / strFileName:INI���ϰ�θ�)
''Sample : If WriteINI("MEDICOM", "ver", "1.0.5", app.path & "\mna.ini") = False Then
''*************************************************************************************************

Public Function WriteINI(ByVal strSection As String, ByVal strKey As String, _
                    ByVal strValue As String, ByVal strFileName As String) As Boolean
    
On Error GoTo WriteINI_Error

    Dim iRet As Long                    'API �Լ��� ���ϰ� ����

    '���� 25�ڸ����, 1�ڸ��� �ٿ��� �Է��Ѵ�.
    If Len(strValue) = 25 Then
        strValue = strValue & Space(1)
    End If

    'INI ���Ͽ� ���� ����.
    iRet = WritePrivateProfileString(strSection, strKey, strValue, strFileName)

    'ó������ ��������
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
''INI ���� Write (strSection:���Ǹ� / strKey:Ű�� / strValue:�����Ұ� / strFileName:INI���ϰ�θ�)
''Sample : If WriteINI("MEDICOM", "ver", "1.0.5", app.path & "\mna.ini") = False Then
''*************************************************************************************************
Public Function WriteINIFile(ByVal strSection As String, ByVal strKey As String, _
                    ByVal strValue As String, ByVal strFileName As String) As Boolean
On Error GoTo WriteINIFile_Error
Dim L_stFileNumber As String          '���Ϲ�ȣ
Dim L_stRead As String              '������������
Dim L_stGroup() As String           '�з��� ������ �����±׷�
Dim L_stTemp() As String
Dim i, j As Integer
Dim L_bFlag As Boolean

    L_stFileNumber = FreeFile
    L_bFlag = False

    Open strFileName For Input Access Read As #L_stFileNumber '���� ����
    
    'Do While Not EOF(1)   ' ������ ���� ���� ������ �ݺ��մϴ�. �ѹ��� �б� ������ �ʿ� ����
        Erase L_stGroup
        Line Input #L_stFileNumber, L_stRead   ' ������ ������ ���� �о���Դϴ�. ������
        L_stGroup() = Split(L_stRead, "[")  'strSection���� ����
   ' Loop
    
    For i = LBound(L_stGroup) To UBound(L_stGroup)
        If ((Left(L_stGroup(i), Len(strSection)) = strSection)) Then '���� �����̸�
            L_stTemp() = Split(L_stGroup(i), Chr(10)) 'chr(10)���� ����
            For j = LBound(L_stTemp) To UBound(L_stTemp)
                If ((Left(L_stTemp(j), Len(strKey)) = strKey)) Then  '���� ���ǿ� strKey �� ������
                    L_stTemp(j) = strKey & "=" & strValue
                    L_bFlag = True
                End If
                
            Next j
            If (L_bFlag = False) Then '���� ���ǿ� strKey�� ������ add ��Ŵ
                   ReDim L_stTemp(j + 1)
                   L_stTemp(j + 1) = strKey & "=" & strValue
                   L_bFlag = True
            End If
            
            L_stGroup(i) = "" '���� ������ ���
                        
            For j = LBound(L_stTemp) To UBound(L_stTemp)  '���� ������ ����� ���� ������ ����
                L_stGroup(i) = L_stGroup(i) & L_stTemp(j) & Chr(10)
            Next j
           
        End If
        
    Next i
    
    If L_bFlag = False Then '���� ini ȭ�Ͽ� ������ ������ ���� ������ add ��Ŵ
        ReDim L_stGroup(i + 1)
        L_stGroup(i + 1) = strSection & "]" & Chr(10) & strKey & "=" & strValue & Chr(10)
    End If
    
    L_stTemp(0) = ""
    For i = LBound(L_stGroup) + 1 To UBound(L_stGroup) '���� �����ͷ� ġȯ ���� ����
        L_stTemp(0) = L_stTemp(0) & "[" & L_stGroup(i)
    Next i
    
    
   
    Close #L_stFileNumber
    
    L_stFileNumber = FreeFile

    Open strFileName For Output As #L_stFileNumber '���� ����
    Print #L_stFileNumber, L_stTemp(0);
    Close #L_stFileNumber
    
    WriteINIFile = True
    
    Exit Function


WriteINIFile_Error:
    WriteINIFile = False
End Function



