DECLARE SUB XosGpiCapture (BYVAL FileName AS STRING)
DECLARE SUB XosGpiRestore (BYVAL FileName AS STRING, StartRow AS INTEGER)
DECLARE FUNCTION GetCommand () AS STRING
DECLARE SUB ExecuteCommand (CmdLine AS STRING)
DECLARE SUB Initialize ()
'
' SHELL
' The XOS command shell
'
' Copyright (C) 2011 Coherent Logic Development LLC
'

'$INCLUDE: 'XLIB.BI'

COMMON SHARED ForeColor AS INTEGER
COMMON SHARED BackColor AS INTEGER
COMMON SHARED XOSLoc AS STRING
COMMON SHARED Prof AS STRING

CALL Initialize

DO
    CALL ExecuteCommand(GetCommand())
LOOP

SUB ExecuteCommand (CmdLine AS STRING)
    IF LCASE$(CmdLine) = "exit" THEN
        XosXtSetIPC "OnCloseAction", "EXIT"
        XosXtSetIPC "RestoreGPI", "FALSE"
        END
    END IF

    CALL XosXtSpawn(CmdLine)
END SUB

FUNCTION GetCommand () AS STRING
    PRINT CURDIR$; "> ";
    LINE INPUT TempCommand$
    GetCommand = TempCommand$
END FUNCTION

SUB Initialize ()
    DIM XTaskMemFree AS INTEGER
    DIM XTaskMemUsed AS INTEGER
    DIM RestoreGPI AS STRING


    XOSLoc = XosBase$()
    Prof = XOSLoc + "\PROFILE"
    ForeColor = VAL(XosProfileRead$(Prof, "shell", "forecolor"))
    BackColor = VAL(XosProfileRead$(Prof, "shell", "backcolor"))
    XosGpiInit
    VIEW PRINT 1 TO 2
    COLOR 15, 1: CLS
    PRINT "XOS Plus";
    VIEW PRINT 2 TO 25
    COLOR ForeColor, BackColor: CLS

    XTaskMemFree = VAL(XosXtGetIPC("XtMemFree"))
    XTaskMemUsed = INT(XTaskMemFree - (FRE(-1) / 1024))


    PRINT
    PRINT "XOS Shell Version 0.01"
    PRINT " Copyright (C) 2011 Coherent Logic Development LLC"
    PRINT
    PRINT
    PRINT "Free Memory"
    PRINT " Conventional   : "; STR$(INT(FRE(-1) / 1024)); "KB"
    PRINT " Stack Space    : "; STR$(INT(FRE(-2) / 1024)); "KB"
    PRINT " XTASK Footprint: "; STR$(xtmu); "KB"

    PRINT
    PRINT "XOS Configuration"
    PRINT " Base Directory :  "; XosBase$
    PRINT

    RestoreGPI = XosXtGetIPC("RestoreGPI")
    IF RestoreGPI = "TRUE" THEN
        XosGpiRestore XosBase$ + "\SHELL.GRB", 1
    END IF
END SUB

