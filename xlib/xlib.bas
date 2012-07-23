DECLARE SUB XosGpiConfigure ()
DECLARE SUB XosGpiRestore (BYVAL FileName AS STRING, StartRow AS INTEGER)
DECLARE SUB XosGpiCapture (BYVAL FileName AS STRING)
'
' XLIB
'  Core routines for XOS
'
'  Copyright (C) 2011
'  Coherent Logic Development LLC
'
 
'$INCLUDE: 'CONSTANT.BI'
'$INCLUDE: 'XLIB.BI'

DIM SHARED GpiScrMode AS INTEGER
DIM SHARED GpiRows AS INTEGER
DIM SHARED GpiCols AS INTEGER
DIM SHARED GpiReady AS INTEGER

FUNCTION XosBase$ ()
    Temp$ = ENVIRON$("XOS")
    IF Temp$ = "" THEN
        PRINT "XLIB: The 'XOS' environment variable must be set to the full path of your XOS installation. Please correct this before attempting to continue."
        END
    END IF
    XosBase$ = Temp$
END FUNCTION

SUB XosGpiCapture (BYVAL FileName AS STRING)
    XosGpiConfigure
    DIM BufSize AS INTEGER

    BufSize = (GpiRows * GpiCols) * 2
    DEF SEG = &HB800
    BSAVE FileName, 0, BufSize
    DEF SEG
    XosXtSetIPC "GpiCurCol", LTRIM$(STR$(POS(1)))
    XosXtSetIPC "GpiCurRow", LTRIM$(STR$(CSRLIN))
END SUB

SUB XosGpiConfigure ()
    DIM XOSProfile AS STRING
    DIM ScrMode AS INTEGER
    DIM ScrCols AS INTEGER
    DIM ScrRows AS INTEGER

    XOSProfile = XosBase$ + "\PROFILE"

    ScrMode = VAL(XosProfileRead$(XOSProfile, "gpi", "mode"))
    ScrCols = VAL(XosProfileRead$(XOSProfile, "gpi", "cols"))
    ScrRows = VAL(XosProfileRead$(XOSProfile, "gpi", "rows"))

    IF ScrMode > 13 THEN
        PRINT "GPI:  Invalid screen mode"
        END
    END IF

    GpiScrMode = ScrMode

    IF ScrCols = 40 OR ScrCols = 80 THEN
        GpiCols = ScrCols
    ELSE
        PRINT "GPI: Invalid screen width"
        END
    END IF

    IF ScrRows = 25 OR ScrRows = 43 OR ScrRows = 50 THEN
        GpiRows = ScrRows
    ELSE
        PRINT "GPI: Invalid screen height"
        END
    END IF

END SUB

SUB XosGpiInit ()
    XosGpiConfigure

    SCREEN GpiScrMode
    WIDTH GpiCols, GpiRows

    GpiReady = 1
END SUB

SUB XosGpiRestore (BYVAL FileName AS STRING, StartRow AS INTEGER)
    DIM MemOffset AS INTEGER
    MemOffset = (StartRow * GpiCols) * 2
    XosGpiConfigure
    DEF SEG = &HB800
    BLOAD FileName, MemOffset
    DEF SEG
    col = VAL(XosXtGetIPC("GpiCurCol"))
    row = VAL(XosXtGetIPC("GpiCurRow"))
    LOCATE row, col
END SUB

FUNCTION XosProfileRead$ (IniFile$, IniSection$, IniKey$)
    TmpSection$ = "[" + IniSection$ + "]"
    ON LOCAL ERROR GOTO BadIniReadFile
    FileNum% = FREEFILE
    OPEN IniFile$ FOR INPUT AS #FileNum%
    DO UNTIL EOF(FileNum%)
        LINE INPUT #FileNum%, A$
        IF LEFT$(A$, 1) = "[" THEN
            IF INSTR(A$, TmpSection$) = 1 THEN
                SectionFlag% = TRUE
            ELSE
                SectionFlag% = FALSE
            END IF
        END IF
        IF SectionFlag% = TRUE THEN
            IF INSTR(A$, IniKey$) = 1 THEN
                A$ = MID$(A$, INSTR(A$, "=") + 1)
                XosProfileRead$ = LTRIM$(RTRIM$(A$))
                EXIT DO
            END IF
        END IF
    LOOP

AllDoneRead:
    CLOSE #FileNum%
    EXIT FUNCTION

BadIniReadFile:
    PRINT "XLIB:  Could not read "; IniFile$; "/"; IniSection$; "/"; IniKey$; " ("; ERROR$(ERR); ")"
    RESUME AllDoneRead
END FUNCTION

SUB XosProfileWrite (IniFile$, IniSection$, IniKey$, ProfileStr$)
    REDIM P$(1)

    TmpSection$ = "[" + IniSection$ + "]"
    FileNum% = FREEFILE

    ON LOCAL ERROR GOTO NoIniWriteFile
    OPEN IniFile$ FOR INPUT AS #FileNum%
    DO UNTIL EOF(FileNum%)
        n% = n% + 1
        REDIM PRESERVE P$(n%)
        LINE INPUT #FileNum%, P$(n%)
    LOOP
    CLOSE #FileNum%

AddToIniFile:
    ON LOCAL ERROR GOTO BadIniWriteFile
    FOR i% = 1 TO n%
        IF LEFT$(P$(i%), 1) = "[" THEN
            IF INSTR(P$(i%), TmpSection$) = 1 THEN
                SectionFlag% = TRUE
                SectionFound% = i%
            ELSE
                SectionFlag% = FALSE
            END IF
        END IF
        IF SectionFlag% = TRUE THEN
            IF INSTR(P$(i%), IniKey$) = 1 THEN
                P$(i%) = IniKey$ + "=" + ProfileStr$
                KeyFound% = TRUE
                EXIT FOR
            END IF
        END IF
    NEXT i%
    IF SectionFound% = FALSE THEN
        REDIM PRESERVE P$(n% + 3)
        P$(n% + 2) = "[" + IniSection$ + "]"
        P$(n% + 3) = IniKey$ + "=" + ProfileStr$
        n% = n% + 3
    ELSEIF KeyFound% = FALSE THEN
        NewLine% = SectionFound% + 1
        REDIM PRESERVE P$(n% + 1)
        FOR i% = n% TO NewLine% STEP -1
            P$(i% + 1) = P$(i%)
        NEXT i%
        P$(NewLine%) = IniKey$ + "=" + ProfileStr$
        n% = n% + 1
    END IF

    OPEN IniFile$ FOR OUTPUT AS #FileNum%
    FOR i% = 1 TO n%
        PRINT #FileNum%, P$(i%)
    NEXT i%
    CLOSE #FileNum%

AllDoneWrite:
    CLOSE #FileNum%
    EXIT SUB

NoIniWriteFile:
    OPEN IniFile$ FOR OUTPUT AS #FileNum%
    PRINT #FileNum%, SPACE$(1)
    CLOSE #FileNum%
    RESUME AddToIniFile

BadIniWriteFile:
    RESUME AllDoneWrite
END SUB

SUB XosTestGpiCap ()
    XosGpiInit
    CLS
    PRINT "Hello, World!"
    XosGpiCapture "TEST.CAP"
    SLEEP
    CLS
    PRINT "this screen is not original."
    SLEEP
    XosGpiRestore "TEST.CAP", 0
    SLEEP
END SUB

FUNCTION XosXtGetIPC (TKey AS STRING) AS STRING
    DIM TaskFile AS STRING
    TaskFile = XosBase() + "\XOS.TSK"

    XosXtGetIPC = XosProfileRead$(TaskFile, "IPC", TKey)
END FUNCTION

SUB XosXtSetIPC (TKey AS STRING, TValue AS STRING)
    DIM TaskFile AS STRING
    TaskFile = XosBase() + "\XOS.TSK"

    XosProfileWrite TaskFile, "IPC", TKey, TValue
END SUB

SUB XosXtSpawn (TaskPath AS STRING)
    XosXtSetIPC "OnCloseAction", "SPAWN"
    XosXtSetIPC "OnCloseCmd", TaskPath
    END
END SUB

