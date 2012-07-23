'
'rfr
'
nForeColor% = 15
nBackColor% = 1
CONST RFR_VER = 2.06

PRINT "rfr rel. 2.0.6"

IF NOT LEN(COMMAND$) > 0 THEN
    PRINT
    PRINT "USAGE:"
    PRINT "rfr filename"
    PRINT
    PRINT "Copyright (C) 1996, J. Willis"
    END
END IF
Restart:
ON ERROR RESUME NEXT
CLOSE #1
OPEN COMMAND$ FOR INPUT AS #1

IF ERR > 0 THEN
    PRINT "rfr_err"; LTRIM$(RTRIM$(STR$(ERR))); ": "; LCASE$(ERROR$(ERR))
    END
END IF

DO WHILE NOT EOF(1)
ReadNext:
    LINE INPUT #1, Temp$

    IF LEFT$(Temp$, 1) = "\" THEN
        Process$ = MID$(Temp$, 2, 3)
        ProcParm$ = MID$(Temp$, 6)
SelC1:

        SELECT CASE Process$

            CASE "vck" 'Version ChecK
                FileVer! = VAL(ProcParm$)
                IF FileVer! > RFR_VER THEN
                    PRINT "this file requires version "; ProcParm$; " of rfr."
                    END
                END IF

            CASE "rxp" 'Run eXternal Program
                SHELL ProcParm$

            CASE "chf" 'CHange Foreground color
                nForeColor% = VAL(ProcParm$)
                
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
                COLOR 7, 0
                PRINT CHR$(13)

            CASE "ptu" 'Print Text Uppercase
                COLOR nForeColor%, nBackColor%
                PRINT UCASE$(ProcParm$);

            CASE "ptl" 'Print Text Lowercase
                COLOR nForeColor%, nBackColor%
                PRINT LCASE$(ProcParm$)

            CASE "cls" 'CLear Screen
                COLOR nForeColor%, nBackColor%
                CLS

            CASE "hln"
                LOCATE VAL(ProcParm$), 1
                COLOR nForeColor%, nBackColor%
                PRINT STRING$(80, 196)

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
LOOP

CLOSE #1

COLOR 15, 0
LOCATE 25, 1
PRINT "Press any key to continue..."
SLEEP





































