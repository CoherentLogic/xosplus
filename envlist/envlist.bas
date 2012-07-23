OPEN "C:\XOS\USER\PROFILE" FOR INPUT AS #1
Qual$ = COMMAND$
DO WHILE NOT EOF(1)
    LINE INPUT #1, Temp$
    IF Temp$ = "[Environment]" THEN
        EXIT DO
    END IF
LOOP

DO WHILE NOT EOF(1)
    LINE INPUT #1, Temp$
    IF Temp$ <> ":_Init" THEN
        IF INSTR(Temp$, Qual$) > 0 THEN
            PRINT Temp$
        END IF
    ELSE
        END
    END IF
LOOP

