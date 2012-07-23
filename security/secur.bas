'$INCLUDE: '\VBDWSHOP\PROFILE.BI'

DECLARE SUB Redraw ()
DECLARE SUB DrawDlg (DialogText AS STRING, MusicStr AS STRING, DelayVal AS INTEGER)
DECLARE FUNCTION IDlg (Prompt AS STRING, MaxLen AS INTEGER, TColor AS INTEGER) AS STRING
'
'  Security Plus PassDisk reader
'
DECLARE FUNCTION szDecrypt (InData AS STRING) AS STRING
DECLARE FUNCTION szEncrypt (InData AS STRING) AS STRING
DIM SHARED SLength
SLength = 80 * 25 - 1
PDrive$ = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "POLICY_PASSDISK")
PFile$ = PDrive$ + "\PASSDISK.CNF"

CALL Redraw
DrawDlg "Please insert your personal information disk", "", 32000
CALL Redraw

DrawDlg "Reading your personal information disk", "", 0
InPWord$ = szDecrypt(ProfileRead$(PFile$, "User", "password"))
Retry:
CALL Redraw
x$ = IDlg("Password:", 10, 0)
CALL Redraw
IF LTRIM$(RTRIM$(x$)) = LTRIM$(RTRIM$(InPWord$)) THEN
    CALL DrawDlg("Correct Password", "L16CDECDECDE", 1)
    CALL Redraw
    CALL DrawDlg("Welcome " + ProfileRead$(PFile$, "User", "usertitle") + " " + ProfileRead$(PFile$, "User", "lastname"), "", 2)

    GOTO Pass
ELSE
    CALL DrawDlg("Incorrect Password", "L32EC", 1)
    GOTO Retry
END IF
Pass:
COLOR 7, 0
CLS
FullName$ = ProfileRead$(PFile$, "User", "usertitle") + " " + ProfileRead$(PFile$, "User", "firstname") + " " + ProfileRead$(PFile$, "User", "middlename") + " " + ProfileRead$(PFile$, "User", "lastname")

TimeForm$ = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "LOCALE_TIMEFORMAT")

DrawDlg "User '" + FullName$ + "' logged on at " + FORMAT$(NOW, TimeForm$) + "  " + DATE$, "", 2
COLOR 7, 0
CLS
DrawDlg "XOS Plus '97", "", 2
COLOR 7, 0
CLS

DrawDlg "XOS Plus Release 10 System Ready", "L32EC", 0

COLOR 10, 0
LOCATE 20, 1: PRINT STRING$(80, 196)
COLOR 7, 0

SUB DrawDlg (DialogText AS STRING, MusicStr AS STRING, DelayVal AS INTEGER)
    HCenter = INT(80 / 2)
    VCenter = INT(25 / 2)
    TLen = LEN(DialogText)
    TWidth = TLen + 4
    LineWidth = TWidth - 2

    HalfTWidth = TWidth / 2
    HStart = HCenter - HalfTWidth
    THeight = 3
    LOCATE VCenter - 1, HStart
    COLOR 4, 7
    PRINT CHR$(218); STRING$(LineWidth, 196); CHR$(191)
    LOCATE VCenter, HStart: PRINT CHR$(179); " "; : COLOR 0: PRINT DialogText; : COLOR 4: PRINT " "; CHR$(179); : COLOR 0: PRINT STRING$(2, 219): COLOR 4
    LOCATE VCenter + 1, HStart: PRINT CHR$(192); STRING$(LineWidth, 196); CHR$(217); : COLOR 0: PRINT STRING$(2, 219): COLOR 4
    COLOR 0
    LOCATE VCenter + 2, HStart + 1: PRINT STRING$(TWidth + 1, 219)
    PLAY MusicStr
    IF DelayVal = 32000 THEN
        SLEEP
    ELSEIF DelayVal = 0 THEN
        EXIT SUB
    ELSE
        SLEEP DelayVal
    END IF
END SUB

FUNCTION IDlg (Prompt AS STRING, MaxLen AS INTEGER, TColor AS INTEGER) AS STRING
    VStart = 10
    Vend = 12
    HCenter = 80 / 2

    LOCATE ((VStart + Vend) / 2 + 2.5), HCenter - 9 - LEN(Prompt) + 1
    COLOR 15, 1
    PRINT Prompt; " ";
    TStart% = POS(1)
    COLOR 0, 0
    PRINT STRING$(38 - (LEN(Prompt) + 2), 219);
    LOCATE CSRLIN, TStart%
    COLOR 15, 0


    DO
        s$ = INKEY$
        IF s$ = CHR$(8) THEN
            IF POS(1) = TStart% THEN
                BEEP
                GOTO NoGo
            END IF

            LOCATE (VStart + Vend) / 2 + 2.5, POS(1) - 1
            COLOR 0, 0
            PRINT CHR$(219);
            LOCATE (VStart + Vend) / 2 + 2.5, POS(1) - 1
            COLOR 15
            BuildUp$ = LEFT$(BuildUp$, LEN(BuildUp$) - 1)
        ELSEIF s$ = CHR$(13) THEN
            GOTO NoGo2
NoGo:
        ELSE
            IF LEN(BuildUp$) >= 26 THEN
                BEEP
                BuildUp$ = LEFT$(BuildUp$, LEN(BuildUp$) - 1)
                GOTO NoGo2
            END IF
            IF s$ <> "" THEN
                'LOCATE (VStart + VEnd) / 2 + 2.5, POS(1) - 1
                PRINT s$;
                BuildUp$ = BuildUp$ + s$
            END IF
        END IF
    LOOP
NoGo2:
    IDlg = BuildUp$
END FUNCTION

SUB Redraw ()
CLS
COLOR 11, 0
PRINT STRING$(SLength + 1, 176);
COLOR 15, 1
LOCATE 2, 5: PRINT "ีออออออออออออออธ";
LOCATE 3, 5: COLOR 15: PRINT "ณ XOS PassDisk ณ"; : COLOR 0: PRINT STRING$(2, 219)
LOCATE 4, 5: COLOR 15: PRINT "ิออออออออออออออพ"; : COLOR 0: PRINT STRING$(2, 219)
COLOR 0
LOCATE 5, 6: PRINT STRING$(17, 219)

END SUB

