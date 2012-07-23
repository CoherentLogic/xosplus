'
' vf
' View File
'
DECLARE FUNCTION getchar () AS STRING
'ON ERROR RESUME NEXT
DIM Pages(1 TO 1000) AS STRING
DIM CurrentPage AS INTEGER

OPEN COMMAND$ FOR INPUT AS #1

VIEW PRINT 1 TO 1
COLOR 0, 7
CLS
VIEW PRINT 1 TO 25
LOCATE 1, 1


PRINT "Paginating..."
VIEW PRINT 2 TO 25
COLOR 0, 0
CLS
CurrentPage = 0
DO WHILE NOT EOF(1)
    LINE INPUT #1, L$
    PRINT L$
    Temp$ = Temp$ + L$ + CHR$(13)

    IF CSRLIN >= 22 THEN
        CurrentPage = CurrentPage + 1
        Pages(CurrentPage) = Temp$
        Temp$ = ""
        IF ERR > 0 THEN
            CurrentPage = CurrentPage - 1
            EXIT DO
        END IF
        CLS
    END IF

LOOP
VIEW PRINT 1 TO 25
COLOR 7, 0
CLS
FOR Iteration = 1 TO CurrentPage
Init:
    IF Iteration < 1 THEN
        BEEP
        Iteration = 1
        GOTO Init
    END IF
    IF Iteration > CurrentPage THEN
        BEEP
        Iteration = CurrentPage
        GOTO Init
    END IF
    PRINT Pages(Iteration)
    LOCATE 23, 1
    COLOR 0, 7
    PRINT "Page "; LTRIM$(RTRIM$(STR$(Iteration))); " of "; LTRIM$(RTRIM$(STR$(CurrentPage))); : COLOR 7, 0: PRINT STRING$(60, " ")
    COLOR 7, 0
    
Gett:
    Act$ = getchar()
    
    
    SELECT CASE Act$
        CASE CHR$(0) + "H"
            CLS
            Iteration = Iteration - 1
            GOTO Init
        CASE CHR$(0) + "P"
            CLS
            Iteration = Iteration + 1
            GOTO Init
        CASE CHR$(13)
            CLS
            Iteration = Iteration + 1
            GOTO Init
        CASE "g"
            PRINT "vf> ";
            PRINT "g";
            INPUT "", GTO%
            CLS
            Iteration = GTO%
            GOTO Init
        CASE "f"
            PRINT "vf> ";
            PRINT "f";
            LINE INPUT "", FindStr$
        CASE "q"
            PRINT "vf> quit";
            LOCATE 24, 1
            END
        CASE "t"
            Iteration = 1
            CLS
            GOTO Init
        CASE "m"
            
            Iteration = CurrentPage / 2
            CLS
            GOTO Init
        CASE "b"
            Iteration = CurrentPage
            CLS
            GOTO Init
        CASE ELSE
            BEEP
            GOTO Gett
    END SELECT
    COLOR 7, 0
    CLS
NEXT

FUNCTION getchar () AS STRING
    
    DO WHILE x$ = ""
        x$ = INKEY$
    LOOP

    getchar = x$
END FUNCTION

