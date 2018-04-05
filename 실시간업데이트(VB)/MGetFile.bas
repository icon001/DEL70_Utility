Attribute VB_Name = "MGetFile"
'****************************************************************
'
' Live Program Update Code
'
' Written by:  Blake B. Pell
'              blakepell@hotmail.com
'              bpell@indiana.edu
'              http://www.blakepell.com
'              December 7, 2000
'
' This code is open source, I would appreciate that anybody using
' this is a released application to e-mail or get in contact with
' me.  I hope this makes someone's day easier or helps them learn
' a bit.
'
'
'****************************************************************

Global myVer As String
Global status$
Global UpdateTime As Integer

Const FLAG_ICC_FORCE_CONNECTION = &H1
Public Declare Function InternetCheckConnection Lib "wininet.dll" Alias "InternetCheckConnectionA" (ByVal lpszUrl As String, ByVal dwFlags As Long, ByVal dwReserved As Long) As Long

Public Function isconnected(pingURL As String) As Boolean
'KPD-Team 2001
'URL: http://www.allapi.net/
'E-Mail: KPDTeam@Allapi.net
If InternetCheckConnection(pingURL, FLAG_ICC_FORCE_CONNECTION, 0&) = 0 Then
     isconnected = False
Else
     isconnected = True
End If
End Function


Public Function GetInternetFile(Inet1 As Inet, myURL As String, DestDIR As String) As Boolean
    ' Written by: Blake Pell
    
    On Local Error GoTo 100
    
    Dim myData() As Byte
    
    GetInternetFile = False
    If Inet1.StillExecuting = True Then Exit Function
    
    If isconnected(myURL) = False Then Exit Function
  
    myData() = Inet1.OpenURL(myURL, icByteArray)


    For X = Len(myURL) To 1 Step -1
        If Left$(Right$(myURL, X), 1) = "/" Then RealFile$ = Right$(myURL, X - 1)
    Next X
    myFile$ = DestDIR + "\" + RealFile$
    Open myFile$ For Binary Access Write As #1
    Put #1, , myData()

    Close #1
    
    If CStr(myData) = "" Then
        Exit Function
    End If
    
    If InStr(1, myData, "Not Found") > 0 Then
        Exit Function
    End If
    
        
    GetInternetFile = True
    Exit Function

' error handler
' X = MsgBox("An error has occured in the file transfer or write.  Please try again later.", vbInformation)
100    GetInternetFile = False
    Resume 105
105 End Function

