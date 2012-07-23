'
' xh
'
'$INCLUDE: 'C:\VBDWSHOP\PROFILE.BI'
'$INCLUDE: 'C:\VBDOS\WSTDFNCT.BI'

DIM SHARED N$(10)

DECLARE SUB ComLine (NumArgs, Args$(), MaxArgs)

CALL ComLine(2, N$(), 2)

IF N$(2) <> "" THEN
    szFileName$ = N$(2)
ELSE
    szFileName$ = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "DEFAULT_XMF")
END IF

OPEN szFileName$ FOR INPUT AS #1

IF LEFT$(COMMAND$, 2) = "-D" THEN
    CFile$ = MID$(COMMAND$, 4)
    CALL ProfileWrite("C:\XOS\USER\PROFILE", "Environment", "DEFAULT_XMF", CFile$)
    END
END IF
IF COMMAND$ = "-S" THEN
    COLOR 15, 0: PRINT "Help Contents:": COLOR 7, 0

    DO WHILE NOT EOF(1)
    
        LINE INPUT #1, Temp$

        IF LEFT$(Temp$, 1) = "$" THEN
            PRINT TAB(2); MID$(Temp$, 2)
            IF CSRLIN >= 24 THEN
                PRINT "Press ESC to continue"
                SLEEP
                CLS
            END IF
        END IF
    LOOP
    
    END
END IF
               
DO WHILE NOT EOF(1)

    'Read a line from the file
    LINE INPUT #1, Temp$
    
    IF LEFT$(Temp$, 1) = "$" THEN
        IF UCASE$(MID$(Temp$, 2)) = UCASE$(N$(1)) THEN
            TopicFound$ = "yes"
            LINE INPUT #1, Temp$
            COLOR 15, 0: PRINT Temp$: COLOR 7, 0
            PRINT
        END IF
    ELSE
        IF TopicFound$ = "yes" THEN
            IF Temp$ = "*END" THEN
                EXIT DO
            ELSE
                IF UCASE$(Temp$) = "USAGE:" OR UCASE$(Temp$) = "PURPOSE:" OR UCASE$(Temp$) = "EXAMPLE:" OR UCASE$(Temp$) = "NOTES:" THEN
                    COLOR 10, 0
                    PRINT Temp$
                    COLOR 7, 0
                ELSE
                    PRINT Temp$
                END IF
            END IF
        END IF
    END IF

LOOP

IF TopicFound$ <> "yes" THEN
    PRINT "xh:  topic not found"
END IF




