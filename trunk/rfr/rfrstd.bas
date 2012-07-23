'
'rfr
'
'$INCLUDE: 'C:\VBDWSHOP\PROFILE.BI'
'$INCLUDE: 'FONT.BI'
ON ERROR RESUME NEXT
SCREEN 12

CurrentX = 1
nForeColor% = 15
nBackColor% = 1
CONST RFR_VER = 2.2
CLS
PRINT "rfr standalone rel. 2.2.0"
PRINT
nStep% = 0
nTrace% = 1
traceport$ = "c:\trace.txt"
OPEN traceport$ FOR OUTPUT AS #2



IF NOT LEN(COMMAND$) > 0 THEN
    PRINT "USAGE:"
    PRINT "rfr sourcefile"
    PRINT
    PRINT "XOS Plus 9.0 xUtilities"
    PRINT "Copyright (C) 1996, J. Willis"
    END
END IF
Restart:
ON ERROR RESUME NEXT
CLOSE #1
IF COMMAND$ <> "-I" THEN
    OPEN COMMAND$ FOR INPUT AS #1
ELSE
    PRINT "Rich File Reader"
    PRINT " Interactive Standalone Interpreter"
    PRINT
END IF

IF ERR > 0 THEN
    PRINT "rfr_err"; LTRIM$(RTRIM$(STR$(ERR))); ": "; LCASE$(ERROR$(ERR))
    END
END IF

DO WHILE NOT EOF(1)
ReadNext:

    IF COMMAND$ = "-I" THEN
        LINE INPUT "rfr> ", Temp$
        IF Temp$ = "quit" THEN
            END
        END IF
    ELSE
        LINE INPUT #1, Temp$
    END IF

    IF LEFT$(Temp$, 1) = "\" THEN
        Process$ = MID$(Temp$, 2, 3)
        ProcParm$ = MID$(Temp$, 6)
    IF nTrace% = 1 THEN
        PRINT #2, Process$, ProcParm$
    END IF

SelC1:

        SELECT CASE Process$

            CASE "vck" 'Version ChecK
                FileVer! = VAL(ProcParm$)
                IF FileVer! > RFR_VER THEN
                    PRINT "this file requires version "; ProcParm$; " of rfr."
                    END
                END IF
            CASE "ptc"

                ScreenCenter% = 640 / 2
                CenterOfText% = GetGTextLen(ProcParm$) / 2
                xpos! = ScreenCenter% - CenterOfText%
                v% = OutGText(xpos!, CurrentY, ProcParm$)
                CurrentY = CurrentY + 10
            CASE "rxp" 'Run eXternal Program
                SHELL ProcParm$

            CASE "chf" 'CHange Foreground color
                nForeColor% = VAL(ProcParm$)
                
            CASE "rfv"
                COLOR nForeColor%, nBackColor%
                PRINT LTRIM$(RTRIM$(STR$(RFR_VER)))
            
            CASE "dnv"
                COLOR nForeColor%, nBackColor%
                PRINT ProfileRead$("C:\XOS\USER\PROFILE", "Environment", ProcParm$);
            
            CASE "chb" 'CHange Background color
                nBackColor% = VAL(ProcParm$)

            CASE "csk"
                CLS

            CASE "pts" 'PRint Text Standard
                COLOR nForeColor%, nBackColor%
                PRINT ProcParm$

            CASE "pnj" 'Print Non Justify
                COLOR nForeColor%, nBackColor%
                PRINT ProcParm$;

            CASE "pcr" 'Print Carriage Return
                CurrentY = CurrentY + 10
            CASE "ptu" 'Print Text Uppercase
                COLOR nForeColor%, nBackColor%
                PRINT UCASE$(ProcParm$);

            CASE "ptl" 'Print Text Lowercase
                COLOR nForeColor%, nBackColor%
                PRINT LCASE$(ProcParm$)

            CASE "cls" 'CLear Screen
                COLOR nForeColor%, nBackColor%
                CLS
            CASE "dcf"
                SELECT CASE ProcParm$
                    CASE "Times New Roman"
                        x% = RegisterFonts("tmsre.fon")
                        Y% = LoadFont("h 24")
                        SelectFont 3
                    CASE "Arial"
                        x% = RegisterFonts%("helve.fon")
                        Y% = LoadFont("h8/h12/h24")
                        SelectFont 2
                END SELECT

            
            CASE "hln"
                
                COLOR nForeColor%, nBackColor%
                x$ = STRING$(80, 196)
                x% = OutGText(1, CurrentY, STRING$(640, 196))
                CurrentY = CurrentY + 10
            CASE "rln" 'Read LiNe
                COLOR nForeColor%, nBackColor%
                PRINT ProcParm$;
                LINE INPUT "", UsrData$

            CASE "pds" 'Print Data Standard
                COLOR nForeColor%, nBackColor%
                PRINT UsrData$
            
            CASE "dnj"  'Data No Justify
                COLOR nForeColor%, nBackColor%
                PRINT UsrData$;

            CASE "rpt"
                SEEK #1, 1
                GOTO Restart

            CASE "dif" 'Do If
                IF UsrData$ = ProcParm$ THEN
                    InADif% = 1
                    DO UNTIL a$ = "\edi"
                        LINE INPUT #1, a$
                        Process$ = MID$(a$, 2, 3)
                        ProcParm$ = MID$(a$, 6)

                        GOTO SelC1
inside:
                    LOOP
                    InADif% = 0
                    Result$ = "FALSE"
                ELSE
                    
                        LINE INPUT #1, a$
                        LINE INPUT #1, a$
                END IF
            CASE "edi"
            CASE "fde"  'Function DElay
                SLEEP VAL(ProcParm$)

            CASE "psc" 'Print Special Character
                COLOR nForeColor%, nBackColor%
                PRINT CHR$(VAL(ProcParm$));

            CASE "bel"
                BEEP

            CASE "mlr" 'Marquee Left to Right
                VIEW PRINT CSRLIN - 1 TO CSRLIN + 1
                CPos% = CSRLIN
                FOR i = 1 TO 80 - LEN(ProcParm$)
                    LOCATE CPos%, i
                    PRINT ProcParm$
                    SOUND 32767, 1
                    CLS
                NEXT
                SLEEP 2
                CLS
                VIEW PRINT 1 TO 25

            CASE "plm" 'PLay Music
                PLAY ProcParm$

            CASE ELSE

        END SELECT
    END IF
    IF InADif% <> 0 GOTO inside
    IF nStep% = 1 THEN
        SLEEP
    END IF

LOOP

CLOSE #1
SCREEN 0



































