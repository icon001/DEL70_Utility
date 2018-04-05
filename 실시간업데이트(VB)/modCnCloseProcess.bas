Attribute VB_Name = "modCnCloseProcess"
Option Explicit

Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function CreateToolhelp32Snapshot Lib "kernel32" (ByVal lFlags As Long, ByVal lProcessID As Long) As Long
Private Declare Function Process32First Lib "kernel32" (ByVal hSnapShot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Function Process32Next Lib "kernel32" (ByVal hSnapShot As Long, uProcess As PROCESSENTRY32) As Long
Private Const TH32CS_SNAPPROCESS As Long = &H2
Private Type PROCESSENTRY32
  dwSize As Long
  cntUsage As Long
  th32ProcessID As Long
  th32DefaultHeapID As Long
  th32ModuleID As Long
  cntThreads As Long
  th32ParentProcessID As Long
  pcPriClassBase As Long
  dwFlags As Long
  szExeFile As String * 260
End Type


'#####################################################################################
'#  The missing CloseProcess() API (modCnCloseProcess.bas)
'#      By: Nick Campbeln
'#
'#      Revision History:
'#          1.0 (Nov 16, 2002):
'#              Initial Release
'#
'#      Copyright © 2002 Nick Campbeln (opensource@nick.campbeln.com)
'#          This source code is provided 'as-is', without any express or implied warranty. In no event will the author(s) be held liable for any damages arising from the use of this source code. Permission is granted to anyone to use this source code for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
'#          1. The origin of this source code must not be misrepresented; you must not claim that you wrote the original source code. If you use this source code in a product, an acknowledgment in the product documentation would be appreciated but is not required.
'#          2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original source code.
'#          3. This notice may not be removed or altered from any source distribution.
'#              (NOTE: This license is borrowed from zLib.)
'#
'#  Please remember to vote on PSC.com if you like this code!
'#  Code URL: http://www.planetsourcecode.com/vb/scripts/ShowCode.asp?txtCodeId=40776&lngWId=1
'#####################################################################################

    '#### Functions/Consts used for CloseProcess()
'Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessID As Long) As Long
Private Declare Sub CloseHandle Lib "kernel32" (ByVal hPass As Long)
Private Const WM_CLOSE As Long = &H10
Private Const WM_DESTROY As Long = &H2
'Private Const WM_QUERYENDSESSION = &H11
Private Const WM_ENDSESSION = &H16
Private Const PROCESS_TERMINATE As Long = &H1
Public Const PROCESS_QUERY_INFORMATION = &H400

    '#### Functions/Consts/Types used for GetVersionEx() API
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Type OSVERSIONINFO
    OSVSize As Long
    dwVerMajor As Long
    dwVerMinor As Long
    dwBuildNumber As Long           '#### NT: Build Number, 9x: High-Order has Major/Minor ver, Low-Order has build
    PlatformID As Long
    szCSDVersion As String * 128    '#### NT: ie- "Service Pack 3", 9x: 'arbitrary additional information'
End Type
'Private Const VER_PLATFORM_WIN32s = 0
Private Const VER_PLATFORM_WIN32_WINDOWS = 1
Private Const VER_PLATFORM_WIN32_NT = 2

    '#### Functions/Consts used for CloseAll()
Private Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Private Declare Function GetDesktopWindow Lib "user32" () As Long
Private Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Private Const GW_HWNDNEXT = 2
Private Const GW_CHILD = 5

    '#### Required local vars
Private g_bIsInit As Boolean
Private g_bIs9x As Boolean



'#####################################################################################
'# Public Functions
'#####################################################################################
'#########################################################
'# Ends a process according to the passed eMode
'#########################################################

Public Function GetPidByImage(ByVal image As String) As Long '

  On Local Error GoTo ErrOut:

  Dim hSnapShot As Long

  Dim uProcess As PROCESSENTRY32

  Dim r As Long, L As Long

                                                          

  hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0&)

  If hSnapShot = 0 Then Exit Function

  uProcess.dwSize = Len(uProcess)

  r = Process32First(hSnapShot, uProcess)

  L = Len(image)

  Do While r

    If LCase(Left(uProcess.szExeFile, L)) = LCase(image) Then '

      GetPidByImage = uProcess.th32ProcessID

      Exit Do

    End If

    r = Process32Next(hSnapShot, uProcess)

  Loop

  Call CloseHandle(hSnapShot)

ErrOut:

End Function


Public Function CloseProcess(ByVal lProcessID As Long, Optional ByVal uExitCode As Long = 0) As Boolean
    Dim lTemp As Long

        '#### If we have not yet been initilized, call InitCloseProcess()
    If (Not g_bIsInit) Then Call InitCloseProcess

        '#### If we're running under Win95 or Win98 (WinME seems to process the other method correctly)
'    If (g_bIs9x) Then
            '#### If we successfully send the 'Windows is closing' message to the lProcessID
        If (CloseAll(lProcessID, WM_ENDSESSION, True)) Then
                '#### Since the window has accepted the 'Windows is closing' message, we can now safely terminate the process
                '#### Collect a process handle in lTemp for lProcessID
            lTemp = OpenProcess(PROCESS_TERMINATE, False, lProcessID)

                '#### If lTemp is invalid, return false
            If (lTemp = 0) Then
                CloseProcess = False

                '#### Else the collected process handle is valid
            Else
                    '#### TerminateProcess() returns non-zero (true) on success and zero (false) on failure
                CloseProcess = CBool(TerminateProcess(lTemp, uExitCode))

                    '#### Close the open lTemp
                Call CloseHandle(lTemp)
            End If

            '#### Else we could not communicate with the process
        Else
            CloseProcess = False
        End If

        '#### Else we're under a system that correctly handles the WM_CLOSE message
'    Else
'        CloseProcess = CloseAll(lProcessID, WM_CLOSE)
'    End If
End Function



'#####################################################################################
'# Private Functions
'#####################################################################################
'#########################################################
'# Initilizes the module variables
'#########################################################
Private Sub InitCloseProcess()
    Dim uOSInfo As OSVERSIONINFO

        '#### Setup the uOSInfo UDT to determine the value of g_bIsNT4
    With uOSInfo
        .OSVSize = Len(uOSInfo)
        .szCSDVersion = Space(128)

            '#### Get the OS info, setting g_bIs9x accordingly
        Call GetVersionEx(uOSInfo)
        g_bIs9x = (.PlatformID = VER_PLATFORM_WIN32_WINDOWS) And (.dwVerMajor > 4) Or (.dwVerMajor = 4 And .dwVerMinor > 0) Or _
         (.PlatformID = VER_PLATFORM_WIN32_WINDOWS And .dwVerMajor = 4 And .dwVerMinor = 0) 'Or _
'!' WinME         (.PlatformID = VER_PLATFORM_WIN32_WINDOWS And .dwVerMajor = 4 And .dwVerMinor = 90)
    End With

        '#### Set g_bIsInit to true
    g_bIsInit = True
End Sub


'#########################################################
'# Posts the eMessage to all of the windows with the matching lProcessID
'#########################################################
Private Function CloseAll(ByVal lProcessID As Long, Optional ByVal eMessage As Long = WM_CLOSE, Optional ByVal wParam As Long = 0) As Boolean
    Dim hWndChild As Long
    Dim lThreadProcessID As Long

        '#### Get the Desktop handle while getting the first child under the Desktop and default the return value
    hWndChild = GetWindow(GetDesktopWindow(), GW_CHILD)
    CloseAll = False

        '#### While we still have hWndChild(en) to look at
    Do While (hWndChild <> 0)
            '#### If this is a parent window
        If (GetParent(hWndChild) = 0) Then
                '#### Get the lThreadProcessID of the window
            Call GetWindowThreadProcessId(hWndChild, lThreadProcessID)

                '#### If we have a match with the ProcessIDs
            If (lProcessID = lThreadProcessID) Then
                    '#### Post the message to the process and set the return value to true
                Call PostMessage(hWndChild, eMessage, wParam, 0&)
                CloseAll = True
            End If
        End If

            '#### Move onto the next hWndChild
        hWndChild = GetWindow(hWndChild, GW_HWNDNEXT)
    Loop
End Function


