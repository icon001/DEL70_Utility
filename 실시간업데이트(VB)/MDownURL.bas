Attribute VB_Name = "MDownURL"
Option Explicit

Const scUserAgent As String = "API-Guide test program"

Private Const INTERNET_OPEN_TYPE_PRECONFIG As Long = 0
Private Const INTERNET_FLAG_RELOAD As Long = &H80000000
Private Const INTERNET_FLAG_KEEP_CONNECTION As Long = &H400000
Private Const INTERNET_FLAG_NO_CACHE_WRITE As Long = &H4000000

Private Declare Function InternetOpen Lib "wininet" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Private Declare Function InternetCloseHandle Lib "wininet" (ByVal hInet As Long) As Integer
Private Declare Function InternetReadFile Lib "wininet" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Private Declare Function InternetOpenUrl Lib "wininet" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal lpszUrl As String, ByVal lpszHeaders As String, ByVal dwHeadersLength As Long, ByVal dwFlags As Long, ByVal dwContext As Long) As Long


Function OpenURL(sURL As String, Optional bufSize As Long = 1000) As String
       
    Dim hOpen As Long, hFile As Long, sBuffer As String, ret As Long
    
    sBuffer = Space$(bufSize)
    
    hOpen = InternetOpen(scUserAgent, INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0): DoEvents
    hFile = InternetOpenUrl(hOpen, sURL, vbNullString, ByVal 0&, INTERNET_FLAG_RELOAD Or INTERNET_FLAG_KEEP_CONNECTION Or INTERNET_FLAG_NO_CACHE_WRITE, ByVal 0&): DoEvents
    
    InternetReadFile hFile, sBuffer, bufSize, ret: DoEvents
    
    InternetCloseHandle hFile
    InternetCloseHandle hOpen
    
    OpenURL = Left$(sBuffer, ret)
    
End Function



