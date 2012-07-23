'
' TCAPI Server
'

'$INCLUDE: '\vbdwshop\profile.bi'
DIM ClientName AS STRING
DIM EXEName AS STRING
DIM EXEPath AS STRING
DIM EXESize AS LONG
DIM TFunction AS STRING
DIM TParam AS STRING

ON ERROR RESUME NEXT
Use$ = LEFT$(COMMAND$, INSTR(COMMAND$, ",") - 1)

Extra$ = MID$(COMMAND$, INSTR(COMMAND$, ",") + 1)


COLOR 7, 0
CLS
PRINT "XOS Plus Version 10.5.1  11-20-97  5:40 PM MST"
PRINT "tcapi.exe version 2.0.3"
PRINT
ClientName = ProfileRead(Use$, "Config", "ClientName")
IF ClientName = "" THEN ClientName = "XOSPLUS"
EXEName = ProfileRead(Use$, "Config", "EXEName")
EXEPath = ProfileRead(Use$, "Config", "EXEPath")
OPEN EXEPath + EXEName FOR INPUT AS #1
EXESize = LOF(1)
CLOSE
restart:
    CALL ProfileWrite(Use$, "Conversation", "Function", "")
    SHELL EXEPath + EXEName + " " + Extra$

    TFunction = ProfileRead(Use$, "Conversation", "Function")
    TParam = ProfileRead(Use$, "Conversation", "Param1")
DoFunction:
    SELECT CASE TFunction
        CASE "APP_RESTART"
            PRINT
            PRINT "TCAPI Server - Restart", TIME$
            PRINT
            GOTO restart
        
        CASE "APP_SPAWN"
            'PRINT
            'PRINT "TCAPI Server - Spawn "; TParam, TIME$
            'PRINT
            SHELL TParam
            CALL ProfileWrite(Use$, "Conversation", "FirstRun", "FALSE")

            'PRINT
            'PRINT TParam; " Terminated", TIME$
            'PRINT
            GOTO restart
        CASE "KILL_SERVER"
            PRINT
            PRINT "TCAPI Server - Kill", TIME$
            CALL ProfileWrite(Use$, "Conversation", "Function", "")
            END
        CASE ""
            PRINT ClientName; " is not a TCAPI client."
            PRINT
            PRINT
            LINE INPUT "R)estart program, S)pawn external, K)ill server? ", Choice$
            SELECT CASE LCASE$(Choice$)
                CASE "r"
                    TFunction = "APP_RESTART"
                CASE "s"
                    LINE INPUT "Program to spawn? ", TParam
                    TFunction = "APP_SPAWN"
                CASE "k"
                    TFunction = "KILL_SERVER"
            END SELECT
            GOTO DoFunction
                    
    END SELECT


            





