
DECLARE SUB Rehash ()
'
' System shell, more P1003.2 like
'
'$INCLUDE: '\VBDWSHOP\PROFILE.BI'
DECLARE FUNCTION szXOSVar (VarName AS STRING) AS STRING
ON ERROR RESUME NEXT
DIM CommandList(1 TO 100) AS STRING
LInd = 1
CLS
PRINT "System Console"
PRINT "80x25 text display"
PRINT "Using Console, 1"
PRINT "True dimensions 80x25"
PRINT
PRINT "XOS Plus 10"
PRINT "Command Processor/4  Version 0.99"
PRINT "Copyright (C) 1997, J. Willis"
PRINT
CALL Rehash
    IF COMMAND$ <> "" THEN
        OPEN COMMAND$ FOR INPUT AS #2
    END IF
Prompt:
    P$ = LCASE$(szXOSVar("SYSNAME")) + "[" + LCASE$(CURDIR$) + "]# "
    PRINT P$;
DO
    IF COMMAND$ <> "" THEN
        LINE INPUT #2, BuildUp$
        GOTO DoCommand
    END IF
        
    NextKey$ = INKEY$
    
    SELECT CASE NextKey$
        CASE ""
            'IF POS(1) + 1 = (LEN(P$) + 1) + LEN(BuildUp$) THEN
                LOCATE CSRLIN, (LEN(P$) + 1) + LEN(BuildUp$)
                PRINT "_";
            'ELSE
            '    LOCATE CSRLIN, POS(1)
            '    PRINT "_";
            '    LOCATE CSRLIN, POS(1) - 1
            'END IF
        CASE CHR$(0) + "K"
            LOCATE CSRLIN, POS(1) - 1
        CASE CHR$(0) + "P" 'Downarrow
            LInd = LInd - 1
            LOCATE CSRLIN, LEN(P$) + 1
            COLOR 0, 7
            PRINT STRING$(LEN(BuildUp$) + 10, 219)
            COLOR 7, 0
            LOCATE CSRLIN - 1, LEN(P$) + 1
            PRINT CommandList(LInd);
            BuildUp$ = CommandList(LInd)
        CASE CHR$(0) + "H" 'Uparrow
            LInd = LInd + 1
            LOCATE CSRLIN, LEN(P$) + 1
            COLOR 0, 7
            PRINT STRING$(LEN(BuildUp$) + 1, 219)
            COLOR 7, 0
            LOCATE CSRLIN - 1, LEN(P$) + 1
            PRINT CommandList(LInd);
            BuildUp$ = CommandList(LInd)
        CASE CHR$(9)  'Tab (Command completion)

            OPEN "C:\XOS\TREEDATA.LST" FOR INPUT AS #1
            DO WHILE NOT EOF(1)
                LINE INPUT #1, LineData$
                IF INSTR(LCASE$(LineData$), LCASE$(BuildUp$)) = 1 THEN
                    'PRINT LineData$;
                    CLOSE #1
                    EXIT DO
                
                END IF
            LOOP
            CLOSE #1
            IF LTRIM$(RTRIM$(LineData$)) = "" THEN
                BEEP
                PRINT BuildUp$;
            ELSE

                BuildUp$ = LCASE$(LEFT$(LineData$, INSTR(LineData$, ".") - 1))


                LOCATE CSRLIN, LEN(P$) + 1
                COLOR 0, 7
                PRINT STRING$(LEN(BuildUp$) + 1, 219)
                COLOR 7, 0
                LOCATE CSRLIN - 1, LEN(P$) + 1
                PRINT LCASE$(BuildUp$);
            END IF
            
        CASE CHR$(8)
            IF NOT POS(1) <= LEN(P$) + 1 THEN
                LOCATE CSRLIN, POS(1) - 1
                COLOR 0, 7
                PRINT CHR$(219);
                LOCATE CSRLIN, POS(1) - 1
                COLOR 7, 0
                BuildUp$ = LEFT$(BuildUp$, LEN(BuildUp$) - 1)
            ELSE
                BEEP
            END IF
        CASE CHR$(13)
            LOCATE CSRLIN, POS(1) - 1
            COLOR 0, 7
            PRINT CHR$(219);
            COLOR 7, 0

            ComIndex = ComIndex + 1
            CommandList(ComIndex) = BuildUp$
            IF INSTR(BuildUp$, " ") <> 0 THEN
                ComName$ = LEFT$(BuildUp$, INSTR(BuildUp$, " ") - 1)
                ComParm$ = MID$(BuildUp$, INSTR(BuildUp$, " ") + 1)
               

                
            ELSE
                ComName$ = BuildUp$
            END IF
            BuildUp$ = ""
DoCommand:
            IF ProfileRead$("C:\XOS\USER\CONFIG\GENERAL", "Alias", ComName$) <> "[Alias]" THEN
                ComName$ = ProfileRead$("C:\XOS\USER\CONFIG\GENERAL", "Alias", ComName$)
            END IF
            PRINT
            PRINT "=========================="
            PRINT "Command Line Summary"
            PRINT "Name: "; ComName$
            PRINT "Params: "; ComParm$
            PRINT
            PRINT "=========================="
            SELECT CASE ComName$
                CASE "rehash"
                    CALL Rehash
                CASE "pwd", "gcd"
                    PRINT
                    PRINT CURDIR$
                CASE "denv"
                    PRINT
                    PRINT szXOSVar(ComParm$)
                CASE "alias"
                    TgtCmd$ = LEFT$(ComParm$, INSTR(ComParm$, " ") - 1)
                    AliasName$ = MID$(ComParm$, INSTR(ComParm$, " ") + 1)
                    CALL ProfileWrite("C:\XOS\USER\CONFIG\GENERAL", "Alias", TgtCmd$, AliasName$)


                CASE "cs"
                    CLS
                    GOTO Prompt
                CASE "cd"
                    CHDIR ComParm$
                CASE "exit", "rs", "quit", "bye", "q"
                    END
                CASE "history"
                    PRINT
                    nIndex = 0
                    DO WHILE NOT nIndex >= 100
                        nIndex = nIndex + 1
                        IF CommandList(nIndex) <> "" THEN
                            PRINT RTRIM$(STR$(nIndex)); ":  "; CommandList(nIndex)
                            ComsListed = nIndex
                        END IF
                    LOOP
                    IF ComsListed = 1 THEN
                        PRINT "No old command."
                    END IF

                CASE ELSE
                    IF LEFT$(ComName$, 1) = "!" THEN
                        nIndex = 0
                        PRINT
                        DO WHILE NOT nIndex >= 100
                            nIndex = nIndex + 1
                            IF INSTR(CommandList(nIndex), MID$(ComName$, 2)) THEN
                                
                                PRINT CommandList(nIndex);
                                IF CommandList(nIndex) <> "history" THEN
                                    ComName$ = CommandList(nIndex)
                                    GOTO DoCommand
                                ELSE
                                    ComName$ = ""
                                END IF
                                EXIT DO
                            END IF
                        LOOP
                    END IF
                    PRINT
                    SHELL ComName$ + " " + ComParm$
            END SELECT
            PRINT
            GOTO Prompt
        CASE ELSE
            BuildUp$ = BuildUp$ + NextKey$
            LOCATE CSRLIN, POS(1) - 1
            PRINT NextKey$;
    END SELECT
    


LOOP

SUB Rehash ()
EXIT SUB
'***********************'
' Build the "hash list" '
'***********************'
OPEN "C:\XOS\USER\CONFIG\PATH" FOR INPUT AS #1
KILL "C:\XOS\TREEDATA.LST"

DO WHILE NOT EOF(1)

    'Read a line of the file
    LINE INPUT #1, NextDir$

    'Get a directory listing of that directory
    SHELL "ECHO EXIT.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO CS.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO RS.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO LS.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO QUIT.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO BYE.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO CD.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO HISTORY.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO REHASH.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO DENV.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO SVAR.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO DENV.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO GCD.INT >> C:\XOS\TREEDATA.LST"
    SHELL "ECHO PWD.INT >> C:\XOS\TREEDATA.LST"




    
    SHELL "DIR /B " + NextDir$ + "\*.EXE >> C:\XOS\TREEDATA.LST"
    SHELL "DIR /B " + NextDir$ + "\*.COM >> C:\XOS\TREEDATA.LST"
    SHELL "DIR /B " + NextDir$ + "\*.BAT >> C:\XOS\TREEDATA.LST"

LOOP
CLOSE #1

END SUB

FUNCTION szXOSVar (VarName AS STRING) AS STRING
    szXOSVar = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", UCASE$(VarName))
END FUNCTION

