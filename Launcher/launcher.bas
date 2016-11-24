nomainwin

dim info$(10, 10)
CSIDL.APPDATA = hexdec("1a")
CSIDL.COMMONAPPDATA = hexdec("23")
LBFolderName$ = "Liberty BASIC v4.5.0"

LBAppData$ = GetSpecialFolder$(CSIDL.APPDATA) + "\" + LBFolderName$
pathToINI$ = LBAppData$ + "\lbasic450.ini"
if fileExists(pathToINI$) then [checkINI]

'Form created with the help of Freeform 3 v07-15-08
'Generated on Oct 31, 2016 at 19:15:24


[setup.m.Window]

    '-----Begin code for #m

    nomainwin
    WindowWidth = 370
    WindowHeight = 205
    UpperLeftX=int((DisplayWidth-WindowWidth)/2)
    UpperLeftY=int((DisplayHeight-WindowHeight)/2)


    '-----Begin GUI objects code

    statictext #m.statictext1, "Preparing Liberty BASIC v4.5.0 first-time launch",  35,  42, 285,  20
    statictext #m.statictext2, "Please wait...", 130,  77,  78,  20

    '-----End GUI objects code

    open "untitled" for dialog_popup as #m
    print #m, "font ms_sans_serif 10"
    'print #m, "trapclose [quit.m]"


[m.inputLoop]   'wait here for input event

LBCommonData$ = GetSpecialFolder$(CSIDL.COMMONAPPDATA) + "\" + LBFolderName$

a = CopyFolder(LBCommonData$, LBAppData$)

close #m

[checkINI]

open pathToINI$ for input as #ini
ini$ = input$(#ini, lof(#ini))
close #ini

badValue$ = "-32000 -32000"
badInStr = instr(ini$, badValue$)

if badInStr > 0 then
    start$ = left$(ini$, badInStr - 1)

    'This is to get the rest of the string past the position.  I've just
    'had different values come up in my testing, so I can't hard-code them.
    end$ = right$(ini$, len(ini$) - badInStr - len(badValue$) - 6)
    newINI$ = start$ + "75 45 1214 730" + end$

    open pathToINI$ for output as #ini
    print #ini, newINI$;
    close #ini
end if

'ShellExecute is used instead of just 'run "liberty.exe"' because using
'the RUN command causes LB to open a blank window, instead of following
'the user settings on what to first open.  (By default, LB opens on
'welcome.bas.  This doesn't happen when using 'run "liberty.exe"'.
'
'However, manually running it incorrectly is better than it not running
'at all.  We fall back on it if ShellExecute() fails.

if (ShellExecute("liberty.exe") < 33) then run "liberty.exe"


end

Function ShellExecute(lpFile$)
    CallDLL #shell32, "ShellExecuteA",_
    0 as ulong,_
    0 as ulong,_
    lpFile$ as ptr,_
    0 as ulong,_
    0 as ulong,_
    _SW_SHOWNORMAL as long,_
    ShellExecute as long
End Function

'return a true if the file in fullPath$ exists, else return false
function fileExists(fullPath$)
    files pathOnly$(fullPath$), filenameOnly$(fullPath$), info$()
    fileExists = val(info$(0, 0)) > 0
end function

'return just the directory path from a full file path
function pathOnly$(fullPath$)
    pathOnly$ = fullPath$
    while right$(pathOnly$, 1) <> "\" and pathOnly$ <> ""
        pathOnly$ = left$(pathOnly$, len(pathOnly$)-1)
    wend
end function

'return just the filename from a full file path
function filenameOnly$(fullPath$)
    pathLength = len(pathOnly$(fullPath$))
    filenameOnly$ = right$(fullPath$, len(fullPath$)-pathLength)
end function

Function GetSpecialFolder$(CSIDL)
    struct IDL, _
        cb   As uLong, _
        abID As short
    calldll #shell32, "SHGetSpecialFolderLocation",_
        0     as ulong, _
        CSIDL as ulong, _
        IDL   as struct,_
        ret   as ulong
    if ret=0 then
        Path$ = Space$(_MAX_PATH)
        id = IDL.cb.struct
        calldll #shell32, "SHGetPathFromIDListA",_
            id    as ulong, _
            Path$ as ptr, _
            ret   as ulong
        GetSpecialFolder$ = trim$(Path$)
    end if
    if GetSpecialFolder$ = "" then GetSpecialFolder$ = "Not Applicable"
End Function

Function CopyFolder(src$, dest$)
    FO.COPY = 2
    FOF.SILENT = 4
    FOF.NOCONFIRMATION = 16
    FOF.NOERRORUI = hexdec("400")
    FOF.NOCONFIRMMKDIR = hexdec("200")
    FOF.NO.UI = FOF.SILENT or FOF.NOCONFIRMATION _
        or FOF.NOERRORUI or FOF.NOCONFIRMMKDIR

    option = FOF.NOCONFIRMATION or FOF.NOERRORUI or FOF.NOCONFIRMMKDIR

    struct SHFILEOPSTRUCT,_
        hWnd as ulong,_
        wFunc as ulong,_
        pFrom$ as ptr,_
        pTo$ as ptr,_
        fFlags as long,_
        fAnyOperationsAborted as long,_
        hNameMappings as long,_
        lpszProgressTitle$ as long

    SHFILEOPSTRUCT.hWnd.struct = 0
    SHFILEOPSTRUCT.wFunc.struct = FO.COPY
    SHFILEOPSTRUCT.pFrom$.struct = src$ + chr$(0) + chr$(0)
    SHFILEOPSTRUCT.pTo$.struct = dest$ + chr$(0) + chr$(0)
    SHFILEOPSTRUCT.fFlags.struct = option
    SHFILEOPSTRUCT.hNameMappings.struct = 0
    SHFILEOPSTRUCT.lpszProgressTitle$.struct = ""

    CallDLL #shell32, "SHFileOperationA",_
    SHFILEOPSTRUCT as struct,_
    CopyFolder as long
End Function
