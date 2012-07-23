'$INCLUDE: 'CONSTANT.BI'
'$INCLUDE: '..\COMMON\PROFILE.BI'

TYPE ProcType
    PName AS STRING * 12
    PLine AS INTEGER
END TYPE

DECLARE FUNCTION RegRead (RegName AS STRING) AS STRING
DECLARE SUB MouseHide ()
DECLARE SUB MousePoll (row%, col%, lButton%, rButton%)
DECLARE SUB MouseShow ()
DECLARE SUB DrawMLDlg (TotalLines AS INTEGER, MTextWidth AS INTEGER, VStart AS INTEGER, MusicStr AS STRING, DelayVal AS INTEGER)
DECLARE SUB PIntEx (PIntStr AS STRING)
DECLARE SUB IntEx (IntStr AS STRING)
DECLARE SUB ParseLine (LDat AS STRING)
DECLARE FUNCTION nExists (FileName AS STRING) AS INTEGER

DIM SHARED xpos AS INTEGER
DIM SHARED ypos AS INTEGER
DIM SHARED clr AS INTEGER
DIM SHARED dstack(10) AS STRING
DIM SHARED sIndex AS INTEGER
DIM SHARED Scratch AS STRING
DIM SHARED Restricts AS STRING
DIM SHARED MLText(10) AS STRING * 60
DIM SHARED zone(80, 25) AS INTEGER
DIM SHARED XOSStack(10) AS STRING
DIM SHARED Procedures(50) AS ProcType
DIM SHARED ParamArray(15) AS STRING
DIM SHARED NCParam AS STRING
DIM SHARED RDLett AS STRING
DIM SHARED KernelLoc$
DIM SHARED IfResult$
DIM PreJump AS INTEGER

ON ERROR RESUME NEXT
RDLett = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "RAMDRIVE")
KernelLoc$ = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "KERNEL")


IF COMMAND$ = "-V" THEN
    PRINT "XOS System Control Language Version 1.0.9 11-28-97 11:50 AM"
    END
END IF

IF COMMAND$ = "" THEN
    PRINT "XOS System Control Language Version 1.0.9 11-28-97 11:50 AM"
    PRINT
    PRINT "Must specify file to run or use the -I option"
    PRINT "for interactive mode."
    END
END IF

CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "CLIENT_LOAD")
CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "Parameters", "C:\XOS\USER\NXSCL.RTC")
SLEEP 1
PRINT
PRINT ProfileRead$("C:\XOS\USER\NXSCL.RTC", "Conversation", "Messages")
IF ProfileRead$("C:\XOS\USER\NXSCL.RTC", "Conversation", "SYSEX") <> "READY" THEN
    PRINT "Server not ready"
END IF


PRINT
SELECT CASE COMMAND$
    CASE "-I"
        PRINT "XOS System Control Language Version 1.0.9 11-28-97 11:50 AM"
        PRINT " Interactive Interpreter"
        PRINT
        GOTO Interpret
    CASE ELSE
        OPEN COMMAND$ FOR INPUT AS #1
        PrimRegion = 5
        LINE INPUT #1, ntag$
        LINE INPUT #1, Propquan$
        PTotal = VAL(MID$(Propquan$, 8))
        FOR i = 1 TO PTotal
            LINE INPUT #1, Propquan$
            Propquan$ = LTRIM$(Propquan$)

            Property$ = LEFT$(Propquan$, 6)
            PVal$ = MID$(Propquan$, 7)
            SELECT CASE Property$
                CASE "PRISEG"
                    PrimRegion = VAL(PVal$)
                CASE "PRGSEG"
                    ProgRegion = VAL(PVal$)
                CASE "EXTERN"

            END SELECT
        NEXT
        SEEK #1, 1
        '
        ' INDEX ALL PROCEDURES
        '
        lIndex = 0
        'PRINT "PROCEDURE", "ADDR (HEX)", "ADDR (DECIMAL)"

        DO WHILE NOT EOF(1)
            lIndex = lIndex + 1
            LINE INPUT #1, nTemp$
            IF LEFT$(nTemp$, 9) = "procedure" THEN
                pIndex = pIndex + 1
                Procedures(pIndex).PName = LTRIM$(RTRIM$(MID$(nTemp$, 11)))
                Procedures(pIndex).PLine = lIndex
                'PRINT Procedures(pIndex).PName, "0x"; LTRIM$(HEX$(Procedures(pIndex).PLine)), ""; LTRIM$(RTRIM$(STR$(Procedures(pIndex).PLine)))

            END IF
        LOOP
        SEEK #1, 1
        lIndex = 0
        '
        'FIND LINE NUMBER OF MAIN PROCEDURE
        '
        MainFlag = FALSE
        FOR i = 1 TO PrimRegion
            IF RTRIM$(Procedures(i).PName) = "main" THEN
                MainFlag = TRUE
                ReadStart = Procedures(i).PLine
                'PRINT "Starting execution at: "; ReadStart
                GOTO DoLines
            END IF
        NEXT
        IF MainFlag = FALSE THEN
            PRINT "FATAL ERROR:"
            PRINT "No main procedure found in primary region of "; COMMAND$
            END
        END IF
        '
        'ENTER THE PROCEDURE
        '
DoLines:
        lIndex = 0
        SEEK #1, 1
        'PRINT "Jumping to: "; ReadStart
        FOR i = 1 TO ReadStart
            LINE INPUT #1, nTemp$
            lIndex = lIndex + 1
        NEXT
        '
        ' EXECUTE THE MAIN PROCEDURE
        '
        DO WHILE NOT EOF(1)
            LINE INPUT #1, NLine$
            'PRINT "Executing "; NLine$
            'SLEEP
            lIndex = lIndex + 1
            IF LEFT$(NLine$, 4) = "goto" THEN
                LLabel$ = MID$(NLine$, 6)
                SEEK #1, 1
                DO
                    LINE INPUT #1, nTemp$
                    IF nTemp$ = LLabel$ THEN EXIT DO
                LOOP
            ELSE
                
                IF LEFT$(NLine$, 2) <> "//" THEN
                    IF LEFT$(LTRIM$(NLine$), 6) = "doproc" THEN
                        'PRINT "Jumping to procedure  '"; MID$(LTRIM$(RTRIM$(NLine$)), 8); "'"
                        'Find the line of the specified procedure
                        PreJump = lIndex
                        'PRINT "Pre doproc address: "; PreJump
                        FOR i = 1 TO ProgRegion
                            
                            IF LTRIM$(RTRIM$(Procedures(i).PName)) = MID$(LTRIM$(RTRIM$(NLine$)), 8) THEN
                                
                                ReadStart = Procedures(i).PLine
                                SEEK #1, 1
                                GOTO DoLines
                            END IF
                        NEXT
                    ELSEIF INSTR(NLine$, "doif") > 0 THEN
                        'PRINT "DO IF"
                        'PRINT "If Result: '"; IfResult$; "'"
                        'SLEEP
                        IF INSTR(IfResult$, "true") > 0 THEN
                            'Find the line of the specified procedure
                            PreJump = lIndex
                            'PRINT "Target name: "; MID$(LTRIM$(RTRIM$(NLine$)), 6)
                            FOR i = 1 TO ProgRegion
                              
                                ProcName$ = RTRIM$(Procedures(i).PName)

                                IF ProcName$ = LTRIM$(RTRIM$(MID$(LTRIM$(RTRIM$(NLine$)), 6))) THEN
                                    ReadStart = Procedures(i).PLine
                                    SEEK #1, 1
                                    GOTO DoLines
                                END IF
                            NEXT
                        ELSE
                            
                        END IF
                    ELSEIF LEFT$(NLine$, 7) = "endproc" THEN
                        
                        ReadStart = PreJump
                        SEEK #1, 1
                        GOTO DoLines
                    ELSEIF LEFT$(NLine$, 7) = "endprog" THEN
                        CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "CLIENT_RELEASE")
                        END
                    ELSE
                        CALL ParseLine(LTRIM$(NLine$))
                    END IF
                END IF
            END IF
        LOOP
        END
END SELECT

Interpret:
'IF nExists(KernelLoc$ + "XOS386.EXE") = FALSE THEN
'    PRINT "XOS kernel missing. Please insert kernel disk."
'    PRINT "Press any key to continue..."
'    SLEEP
'    KernelLoc$ = "A:\"
'    GOTO Interpret
'END IF

LINE INPUT ">>> ", LineData$

IF LineData$ = "setstack" THEN
    
    FOR i = 1 TO 10
        PRINT i;
        LINE INPUT "> "; dstack(i)
    NEXT
END IF

IF LineData$ = "dostack" THEN
    FOR i = 1 TO 10
        CALL ParseLine(dstack(i))
    NEXT
END IF

IF LineData$ = "quit" OR LineData$ = "quit;" THEN
    CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "CLIENT_RELEASE")
    END                     'Exit interpreter
ELSE
    CALL ParseLine(LineData$)
END IF


GOTO Interpret

SUB DrawMLDlg (TotalLines AS INTEGER, MTextWidth AS INTEGER, VStart AS INTEGER, MusicStr AS STRING, DelayVal AS INTEGER)
    HCenter = INT(80 / 2)
    VCenter = INT(25 / 2)
    TLen = MTextWidth
    TWidth = TLen + 4
    LineWidth = TWidth - 2

    HalfTWidth = TWidth / 2
    HStart = HCenter - HalfTWidth
    THeight = 3
    LOCATE VStart - 1, HStart
    COLOR 4, 7
    PRINT CHR$(218); STRING$(LineWidth, 196); CHR$(191)
    dIndex = 0
    FOR i = 1 TO TotalLines
        LOCATE VStart + dIndex, HStart: PRINT CHR$(179); " "; : COLOR 0: PRINT MLText(i); : COLOR 4: PRINT " "; CHR$(179); : COLOR 0: PRINT STRING$(2, 219): COLOR 4
        dIndex = dIndex + 1
    NEXT

    LOCATE VStart + dIndex, HStart: PRINT CHR$(192); STRING$(LineWidth, 196); CHR$(217); : COLOR 0: PRINT STRING$(2, 219): COLOR 4
    COLOR 0
    LOCATE VStart + dIndex + 1, HStart + 1: PRINT STRING$(TWidth + 1, 219)
    PLAY MusicStr
    IF DelayVal = 32000 THEN
        DO
        IF INKEY$ <> "" THEN
            EXIT SUB
        END IF
        CALL MousePoll(c%, r%, lb%, rb%)
        IF lb% = TRUE THEN
            EXIT SUB
        END IF
        LOOP
    ELSEIF DelayVal = 0 THEN
        EXIT SUB
    ELSE
        SLEEP DelayVal
    END IF

END SUB

SUB IntEx (IntStr AS STRING)
    SHELL KernelLoc$ + "XOS386.EXE " + IntStr
END SUB

SUB ParseLine (LDat AS STRING)
    IF INSTR(LDat, ";") > 0 THEN
        LDat = LEFT$(LDat, INSTR(LDat, ";"))
    ELSE
        IF INSTR(LDat, "//") = 0 THEN

            'PRINT "Missing terminator ';' after statement "; LDat
        END IF
    END IF
    'IF INSTR(LDat, Restricts) > 0 THEN
    '    PRINT "Restricted statement"
    '    EXIT SUB
    'END IF
    'CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "NULL")
    '
    '
    'CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "ADDTOLIST")
    'CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "Parameters", LDat)
    
    InStrPar% = FALSE
    IF RIGHT$(LDat, 1) <> ";" THEN
        EXIT SUB
    END IF




    FOR Iteration = 1 TO LEN(LDat)
        
        'Read one character from the statement
        CChar$ = MID$(LDat, Iteration, 1)
        IF CChar$ = " " OR CChar$ = "," OR CChar$ = ";" OR CChar$ = "(" OR CChar$ = ")" THEN
            nIndex% = nIndex% + 1
            ParamArray(nIndex%) = BuildUp$
            'PRINT ParamArray(nIndex%)
            BuildUp$ = ""
        ELSEIF CChar$ = "'" THEN
            'PRINT "Found a string param: ";
            FOR j = Iteration + 1 TO LEN(LDat)
                Char2$ = MID$(LDat, j, 1)
                'PRINT Char2$;
                IF Char2$ = "'" THEN
                    nIndex% = nIndex% + 1
                    ParamArray(nIndex%) = BuildUp2$
                    Iteration = Iteration + LEN(ParamArray(nIndex%)) + 2
                    'PRINT Iteration
                    'PRINT ParamArray(nIndex%)
                    EXIT FOR
                ELSE
                    BuildUp2$ = BuildUp2$ + Char2$
                END IF
            NEXT j

        ELSE
            BuildUp$ = BuildUp$ + CChar$
        END IF

    NEXT Iteration
    'PRINT "1", "2", "3", "4"
    'PRINT "1:"; ParamArray(1), "2:"; ParamArray(2), "3:"; ParamArray(3), "4:"; ParamArray(4)
    FOR i = 2 TO 15
        IF LEFT$(ParamArray(i), 1) = "$" THEN
            ParamArray(i) = ProfileRead$(RDLett + "\NXSCL", "Environment", MID$(ParamArray(i), 2))
            'PRINT ParamArray(i)
        END IF
    NEXT
    IF LEFT$(ParamArray(1), 1) = "$" THEN
        CALL ProfileWrite(RDLett + "\NXSCL", "Environment", MID$(ParamArray(1), 2), ParamArray(2))
    END IF
    CALL MousePoll(r%, c%, lb%, rb%)

    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "console_row", LTRIM$(RTRIM$(STR$(CSRLIN))))
    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "console_col", LTRIM$(RTRIM$(STR$(POS(1)))))
    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_row", LTRIM$(RTRIM$(STR$(c%))))
    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_col", LTRIM$(RTRIM$(STR$(r%))))
    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_lbutton", LTRIM$(RTRIM$(STR$(lb%))))
    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_rbutton", LTRIM$(RTRIM$(STR$(rb%))))
    
    SELECT CASE ParamArray(1)
        CASE "for"
            fp% = LOF(1)
            LINE INPUT #1, temp$  ' "{" character
            
            FOR fit = VAL(ParamArray(2)) TO VAL(ParamArray(3)) STEP VAL(ParamArray(4))
                    
                    DO
                        
                        LINE INPUT #1, temp$

                        IF LTRIM$(RTRIM$(temp$)) = "}" THEN
                            SEEK #1, fp%
                            EXIT DO
                        ELSE
                            FOR i = 1 TO 15
                                ParamArray(i) = ""
                            NEXT

                            CALL ParseLine(LTRIM$(temp$))
                            FOR i = 1 TO 15
                                ParamArray(i) = ""
                            NEXT

                        END IF
                    LOOP
                    SEEK #1, fp%
            NEXT
        CASE "if"
            first$ = ParamArray(2)
            oper$ = ParamArray(3)
            second$ = ParamArray(4)

            state% = FALSE
            SELECT CASE oper$
                CASE "==" 'is equal to
                    IF first$ = second$ THEN
                        state% = TRUE
                    ELSE
                        state% = FALSE
                    END IF
                CASE "!=" 'not equal to
                    IF first$ <> second$ THEN
                        state% = TRUE
                    ELSE
                        state% = FALSE
                    END IF
                CASE ">"  'greater than
                    IF VAL(first$) > VAL(second$) THEN
                        state% = TRUE
                    ELSE
                        state% = FALSE
                    END IF
                CASE "<"  'less than
                    IF VAL(first$) < VAL(second$) THEN
                        state% = TRUE
                    ELSE
                        state% = FALSE
                    END IF
                CASE "<=" 'less than or equal to
                    IF VAL(first$) <= VAL(second$) THEN
                        state% = TRUE
                    ELSE
                        state% = FALSE
                    END IF
                CASE "=>" 'equal to or greater than
                    IF VAL(first$) >= VAL(second$) THEN
                        state% = TRUE
                    ELSE
                        state% = FALSE
                    END IF
            END SELECT
            
            SELECT CASE state%
                CASE TRUE
                    LINE INPUT #1, temp$  ' "{" character
                    DO
                        LINE INPUT #1, temp$
                        
                        IF LTRIM$(RTRIM$(temp$)) = "}" THEN
                            EXIT DO
                        ELSE
                            FOR i = 1 TO 15
                                ParamArray(i) = ""
                            NEXT

                            CALL ParseLine(LTRIM$(temp$))
                            FOR i = 1 TO 15
                                ParamArray(i) = ""
                            NEXT

                        END IF
                    LOOP
                CASE FALSE
                    DO
                        LINE INPUT #1, temp$
                        IF LTRIM$(RTRIM$(temp$)) = "}" THEN EXIT DO
                    LOOP
                       
            END SELECT
                    FOR i = 1 TO 15
                        ParamArray(i) = ""
                    NEXT

        CASE "vswap"
        'CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), ParamArray(3))
        CASE "dlquery"
            CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "NULL")
            CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "Parameters", ParamArray(3))
            CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", ParamArray(2))
            SLEEP 1
            CALL ProfileWrite("C:\XOS\USER\DYNALINK", "Conversation", "CURRENT_QUERY", "NULL")
        CASE "clr"
            clr = VAL(ParamArray(2))
        CASE "x"
            xpos = VAL(ParamArray(2))
        CASE "y"
            ypos = VAL(ParamArray(2))
        CASE "xy"
            xpos = VAL(ParamArray(2))
            ypos = VAL(ParamArray(3))
        CASE "up"
            FOR i = ypos TO ypos - VAL(ParamArray(2)) STEP -1
                PSET (xpos, i), clr
            NEXT
            ypos = i
        CASE "down"
            FOR i = ypos TO ypos + VAL(ParamArray(2))
                PSET (xpos, i), clr
            NEXT
            ypos = i
        CASE "left"
            FOR i = xpos TO xpos - VAL(ParamArray(2)) STEP -1
                PSET (i, ypos), clr
            NEXT
            xpos = i
        CASE "right"
            FOR i = xpos TO xpos + VAL(ParamArray(2))
                PSET (i, ypos), clr
            NEXT
            xpos = i
        CASE "mouse"
            SELECT CASE ParamArray(2)
                CASE "SHOW"
                    CALL MouseShow
                CASE "HIDE"
                    CALL MouseHide
                CASE "POLL"
                    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_row", LTRIM$(RTRIM$(STR$(c%))))
                    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_col", LTRIM$(RTRIM$(STR$(r%))))
                    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_lbutton", LTRIM$(RTRIM$(STR$(lb%))))
                    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "mouse_rbutton", LTRIM$(RTRIM$(STR$(rb%))))
                CASE "LIVE_ZONE"
                    FOR i = VAL(ParamArray(3)) TO VAL(ParamArray(4))
                    FOR j = VAL(ParamArray(5)) TO VAL(ParamArray(6))
                        zone(i, j) = VAL(ParamArray(7))
                    NEXT
                    NEXT
                CASE "ADD_ACCELERATOR"
                    Accel$ = Accel$ + ParamArray(3)
                CASE "LEFT_CLICKED"
                    'FOR i = 1 TO 79
                    'FOR j = 1 TO 24
                    '    LOCATE j, i
                    '    IF Zone(i, j) > 0 THEN
                    '        COLOR Zone(i, j)
                    '    ELSE
                    '        COLOR 7
                    '    END IF
                    '    PRINT LTRIM$(RTRIM$(STR$(Zone(i, j))));
                    'NEXT
                    'NEXT
                    DO
                        IF INSTR(INKEY$, Accel$) > 0 THEN
                            EXIT DO
                        END IF
                        CALL MousePoll(r%, c%, lb%, rb%)
                        IF lb% = TRUE THEN
                            lb% = FALSE
                            'PRINT "Clicked"
                            IF zone(c%, r%) > 0 THEN
                                CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "zone", LTRIM$(RTRIM$(STR$(zone(c%, r%)))))
                                'PRINT "Clicked in zone "; Zone(c%, r%)
                                EXIT DO
                            END IF
                        END IF
                   
                    LOOP

            END SELECT
        CASE "mapzone"
                    FOR i = 1 TO 79
                    FOR j = 1 TO 24
                        LOCATE j, i
                        IF zone(i, j) > 0 THEN
                            COLOR zone(i, j)
                        ELSE
                            COLOR 7
                        END IF
                        PRINT LTRIM$(RTRIM$(STR$(zone(i, j))));
                    NEXT
                    NEXT
                    SLEEP
        CASE "curloc"
            LOCATE VAL(ParamArray(2)), VAL(ParamArray(3))
        CASE "concat"
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), ParamArray(3) + " " + ParamArray(4))
        CASE "econcat"
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), ParamArray(3) + ParamArray(4))
        CASE "procaddr"
            FOR i = 1 TO 20
                IF INSTR(Procedures(i).PName, ParamArray(2)) > 0 THEN
                    PRINT "0x" + LTRIM$(HEX$(Procedures(i).PLine))
                END IF
            NEXT
        CASE "eof"
            IF EOF(VAL(ParamArray(2))) THEN
                IfResult$ = "true"
            ELSE
                IfResult$ = "false"
            END IF
        CASE "between"
            IF VAL(ParamArray(2)) > VAL(ParamArray(3)) AND VAL(ParamArray(2)) < VAL(ParamArray(4)) THEN
                IfResult$ = "true"
            ELSE
                IfResult$ = "false"
            END IF
        CASE "equals"
            IF ParamArray(2) = ParamArray(3) THEN
                IfResult$ = "true"
            ELSE
                IfResult$ = "false"
            END IF
        CASE "notequals"
            IF ParamArray(2) <> ParamArray(3) THEN
                IfResult$ = "true"
            ELSE
                IfResult$ = "false"
            END IF
        CASE "greater"
            IF VAL(ParamArray(2)) > VAL(ParamArray(3)) THEN
                IfResult$ = "true"
            ELSE
                IfResult$ = "false"
            END IF
        CASE "less"
            IF VAL(ParamArray(2)) < VAL(ParamArray(3)) THEN
                IfResult$ = "true"
            ELSE
                IfResult$ = "false"
            END IF

        CASE "setif"
            IfResult$ = ParamArray(2)
        CASE "exprint"
            PFColor = VAL(ParamArray(2))
            PBColor = VAL(ParamArray(3))
            Justify$ = ParamArray(4)
            StartRow = VAL(ParamArray(5))
            StartCol = VAL(ParamArray(6))
            Conversion$ = ParamArray(7)
            EOLAction$ = ParamArray(8)
            PrintData$ = ParamArray(9)
            COLOR PFColor, PBColor
            SELECT CASE UCASE$(Justify$)
                CASE "JX_ROWCOL"
                    LOCATE StartRow, StartCol
                CASE "JX_HCENTER"
                    HCenter = 80 / 2
                    StartPos = HCenter - (LEN(PrintData$) / 2)
                    LOCATE StartRow, StartPos
                CASE "JX_ABSCENTER"
                    HCenter = 80 / 2
                    StartPos = HCenter - (LEN(PrintData$) / 2)
                    LOCATE 25 / 2, StartPos
                CASE "JX_RIGHT"
                    StartPos = 80 - LEN(PrintData$)
                    LOCATE StartRow, StartPos
                CASE "JX_STANDARD"
            END SELECT
            SELECT CASE Conversion$
                CASE "CX_UPPERCASE"
                    PrintData$ = UCASE$(PrintData$)
                CASE "CX_LOWERCASE"
                    PrintData$ = LCASE$(PrintData$)
                CASE "CX_INSTR"
                
                CASE "CX_HEXADECIMAL"
                    PrintData$ = HEX$(VAL(PrintData$))
                CASE "CX_GETCHR"
                    PrintData$ = CHR$(VAL(PrintData$))
             END SELECT
             
            SELECT CASE EOLAction$
                CASE "EOL_NEWLINE"
                    PRINT PrintData$
                CASE "EOL_NEXTZONE"
                    PRINT PrintData$,
                CASE "EOL_CONTINUE"
                    PRINT PrintData$;
            END SELECT
        CASE "pstr"
            PRINT STRING$(VAL(ParamArray(2)), VAL(ParamArray(3)))
        CASE "viewport"
            VIEW PRINT VAL(ParamArray(2)) TO VAL(ParamArray(3))
        CASE "setdline"
            MLText(VAL(ParamArray(2))) = ParamArray(3)
        CASE "dialog"
            CALL DrawMLDlg(VAL(ParamArray(2)), VAL(ParamArray(3)), VAL(ParamArray(4)), ParamArray(5), VAL(ParamArray(6)))
            FOR i = 1 TO 10
                MLText(i) = ""
            NEXT
        CASE "print"
            FOR i = 2 TO 15
                IF LEFT$(ParamArray(i), 1) = "\" THEN
                    SELECT CASE MID$(ParamArray(i), 2, 1)
                        CASE "c"
                            PRINT ,

                        CASE "n"
                            PRINT
                        CASE "b"
                            BEEP
                    END SELECT
                ELSE
                    IF ParamArray(i) <> "" THEN
                        FOR j = 1 TO LEN(ParamArray(i))
                            temp$ = MID$(ParamArray(i), j, 1)
                            IF temp$ = "\" THEN
                                j = j + 1
                                t2$ = MID$(ParamArray(i), j, 1)
                                'j = j + 1
                                SELECT CASE t2$
                                    CASE "n"
                                        PRINT
                                    CASE "c"
                                        PRINT ,
                                    CASE "b"
                                        BEEP
                                END SELECT
                            ELSE
                                PRINT temp$;
                            END IF
                        NEXT
                    END IF
                END IF
            NEXT

        CASE "data"
            Scratch = ParamArray(2)
        CASE "killd"
            Scratch = ""
        CASE "pprint"
            PRINT
            FOR i = 1 TO 10
                
                PRINT XOSStack(i)
                
            NEXT
        CASE "pcall"
            CALL PIntEx(ParamArray(2) + " " + ParamArray(3) + " " + ParamArray(4) + " " + ParamArray(5))
        CASE "call"
            CALL IntEx(ParamArray(2) + " " + ParamArray(3) + " " + ParamArray(4) + " " + ParamArray(5) + " " + ParamArray(6))
        CASE "push"
            sIndex = sIndex + 1
            SELECT CASE ParamArray(2)
                CASE "DATA"
                    XOSStack(sIndex) = Scratch
                CASE "HCENTER"
                    textlen% = VAL(ParamArray(3))
                    halftext% = textlen% / 2
                    startpoint% = 80 - halftext%
                    XOSStack(sIndex) = LTRIM$(RTRIM$(STR$(startpoint%)))
                CASE "TEXTLEN"
                    XOSStack(sIndex) = STR$(LEN(ParamArray(3)))
                CASE "TOLOWER"
                    XOSStack(sIndex) = LCASE$(ParamArray(3))
                CASE "TOUPPER"
                    XOSStack(sIndex) = UCASE$(ParamArray(3))
                CASE "MIDCHAR"
                    XOSStack(sIndex) = MID$(ParamArray(3), VAL(ParamArray(4)), VAL(ParamArray(5)))
                CASE "ACODE"
                    XOSStack(sIndex) = STR$(ASC(ParamArray(3)))
                CASE "CHAR"
                    XOSStack(sIndex) = CHR$(VAL(ParamArray(3)))
                CASE "ENVIRON"
                    XOSStack(sIndex) = RDLett + "\NXSCL"
                CASE "REGISTER"
                    XOSStack(sIndex) = RegRead(ParamArray(3))


                CASE ELSE
                    XOSStack(sIndex) = ParamArray(2)
            END SELECT
        CASE "pop"
            
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), XOSStack(sIndex))
            sIndex = sIndex - 1
        CASE "scrcol"
            LOCATE VAL(ParamArray(2)), VAL(ParamArray(3))

       
        CASE "readcon"
            LINE INPUT "", TData$
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), TData$)
        CASE "of"
            dummy = FREEFILE
            SELECT CASE ParamArray(3)
                CASE "io_input"
                    OPEN ParamArray(2) FOR INPUT AS #dummy
                CASE "io_output"
                    OPEN ParamArray(2) FOR OUTPUT AS #dummy
                CASE "io_output_append"
                    OPEN ParamArray(2) FOR APPEND AS #dummy
                CASE "io_binary"
                    OPEN ParamArray(2) FOR BINARY AS #dummy
                CASE ELSE
                    PRINT "Invalid file mode."
                    dummy = 0
            END SELECT

            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "CURRENTFILE", LTRIM$(RTRIM$(STR$(dummy))))
        CASE "rl"
            LINE INPUT #VAL(ParamArray(2)), temp$
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(3), temp$)
        CASE "wd"
            SELECT CASE ParamArray(4)
                CASE "write_normal"
                    PRINT #VAL(ParamArray(2)), ParamArray(3);
                CASE "write_crlf"
                    PRINT #VAL(ParamArray(2)), ParamArray(3)
                CASE "write_nextcol"
                    PRINT #VAL(ParamArray(2)), ParamArray(3),
                CASE ELSE
                    PRINT "Invalid write mode."
            END SELECT
        CASE "fseek"
            SEEK #VAL(ParamArray(2)), VAL(ParamArray(3))
        CASE "fclose"
            CLOSE #VAL(ParamArray(2))

        CASE "readseq"

        CASE "loadseqf"
            OPEN ParamArray(2) FOR INPUT AS #3
            DO WHILE NOT EOF(3)
                nIndex% = nIndex% + 1
                KeyName$ = "seq" + LTRIM$(RTRIM$(STR$(nIndex%)))
                LINE INPUT #3, nTemp$
                CALL ProfileWrite(RDLett + "\NXSCL", "Environment", KeyName$, nTemp$)
            LOOP
            CLOSE #3
        CASE "execvar"
            CALL ParseLine(ParamArray(2))
        CASE "popdr"
            CHDRIVE XOSStack(sIndex)
            sIndex = sIndex - 1
        CASE "popdir"
            CHDIR XOSStack(sIndex)
            sIndex = sIndex - 1
        CASE "pull"
            NAME ParamArray(2) AS RDLett + "\NXSCL"
        CASE "shove"
            NAME RDLett + "\NXSCL" AS ParamArray(2)

        CASE "run"
            OPEN ParamArray(2) FOR INPUT AS #1
            DO WHILE NOT EOF(1)
                LINE INPUT #1, TempDat$
                CALL ParseLine(TempDat$)
            LOOP
            CLOSE #1
        CASE "varcopy" 'copy internal variable to environment
            VarV$ = ProfileRead$(RDLett + "\NXSCL", "Environment", ParamArray(2))
            CALL ProfileWrite("C:\XOS\USER\PROFILE", "Environment", ParamArray(2), VarV$)
        CASE "envcopy" 'copy environment variable to the internal variable table
            VarV$ = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", ParamArray(2))
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), VarV$)

        CASE "pwrite"
            CALL ProfileWrite(ParamArray(2), ParamArray(3), ParamArray(4), ParamArray(5))
        CASE "setvar"
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), ParamArray(3))
        CASE "addvar"
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), STR$(VAL(ParamArray(3)) + VAL(ParamArray(4))))
        CASE "incvar"
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), STR$(VAL(ParamArray(3)) + 1))
        CASE "decvar"
            CALL ProfileWrite(RDLett + "\NXSCL", "Environment", ParamArray(2), STR$(VAL(ParamArray(3)) - 1))



        CASE "setscr"
            ON LOCAL ERROR RESUME NEXT
            SCREEN VAL(ParamArray(4))
            WIDTH VAL(ParamArray(5)), VAL(ParamArray(6))

            COLOR VAL(ParamArray(2)), VAL(ParamArray(3))
            CLS
       CASE "clrscr"
            CLS
       CASE "setpel"
            PSET (VAL(ParamArray(2)), VAL(ParamArray(3))), VAL(ParamArray(4))
       CASE "lndraw"
            SELECT CASE ParamArray(7)
                CASE "filled-box"
                    LINE (VAL(ParamArray(2)), VAL(ParamArray(3)))-(VAL(ParamArray(4)), VAL(ParamArray(5))), VAL(ParamArray(6)), BF
                CASE "empty-box"
                    LINE (VAL(ParamArray(2)), VAL(ParamArray(3)))-(VAL(ParamArray(4)), VAL(ParamArray(5))), VAL(ParamArray(6)), B
                CASE ELSE
                    LINE (VAL(ParamArray(2)), VAL(ParamArray(3)))-(VAL(ParamArray(4)), VAL(ParamArray(5))), VAL(ParamArray(6))


            END SELECT
       CASE "areafill"
            PAINT (VAL(ParamArray(2)), VAL(ParamArray(3))), VAL(ParamArray(4))

       CASE "crdraw"
            CIRCLE (VAL(ParamArray(2)), VAL(ParamArray(3))), VAL(ParamArray(4)), VAL(ParamArray(5)), VAL(ParamArray(7)), VAL(ParamArray(8))

       CASE "delay"
            SLEEP VAL(ParamArray(2))
       CASE "extern", "_extern"
            CALL ProfileWrite(RDLett + "\NXSCL", "Exports", ParamArray(2), ParamArray(3) + "," + ParamArray(4))

       CASE ELSE
            
            temp$ = ProfileRead$(RDLett + "\NXSCL", "Exports", ParamArray(1))

            module$ = LEFT$(temp$, INSTR(temp$, ",") - 1)
            funct$ = MID$(temp$, INSTR(temp$, ",") + 1)

            SHELL "C:\XOS\" + module$ + " " + funct$ + " " + ParamArray(2) + " " + ParamArray(3)
   END SELECT
    CALL ProfileWrite(RDLett + "\NXSCL", "Environment", "ifstate", IfResult$)

   FOR i = 1 TO 15
        ParamArray(i) = ""
   NEXT
END SUB

SUB PIntEx (PIntStr AS STRING)
    SHELL "C:\XOS\PRINT386.EXE " + PIntStr
END SUB

FUNCTION RegRead (RegName AS STRING) AS STRING
    RegRead = ProfileRead$("C:\XOS\USER\PROFILE", "Register", "r" + RegName)

END FUNCTION

