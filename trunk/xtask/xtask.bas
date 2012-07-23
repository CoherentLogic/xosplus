DECLARE SUB XosGpiCapture (BYVAL FileName AS STRING)
DECLARE SUB Banner ()
'
' XTASK
' XOS Task Stub
'
' Copyright (C) 2011 Coherent Logic Development LLC
'

'$INCLUDE: 'XLIB.BI'

DIM XOSLoc AS STRING
DIM TaskerFile AS STRING
DIM XOSProfile AS STRING
DIM XOSShell AS STRING
DIM OnCloseAction AS STRING
DIM OnCloseCmd AS STRING
DIM PreserveGPI AS STRING

Banner

XOSLoc = XosBase()
XOSProfile = XOSLoc + "\PROFILE"
XOSShell = UCASE$(XosProfileRead$(XOSProfile, "system", "shell"))

XosXtSetIPC "XtMemFree", LTRIM$(STR$(INT(FRE(-1) / 1024)))

DO
    SHELL XOSShell
    
    OnCloseAction = XosXtGetIPC("OnCloseAction")
    OnCloseCmd = XosXtGetIPC("OnCloseCmd")

    SELECT CASE OnCloseAction
        CASE "SPAWN"
            SHELL OnCloseCmd

            XosXtSetIPC "RestoreGPI", "TRUE"
            XosGpiCapture XOSLoc + "\SHELL.GRB"
        CASE "EXIT"
            END
        CASE ELSE
            PRINT "XTASK:  Re-launch "; XOSShell; "? (y/n) ";
            LINE INPUT Response$
            IF Response$ = "n" THEN
                END
            END IF
    END SELECT

LOOP

SUB Banner ()
    PRINT "XTASK IPC Runtime v0.1"
    PRINT " Copyright (C) 2011 Coherent Logic Development LLC"
    PRINT
    SLEEP 2

END SUB

