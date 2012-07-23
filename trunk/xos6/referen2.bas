DECLARE SUB RunExternal (ProgName AS STRING)
DECLARE SUB ListRefs ()
TYPE Reference
    lkFName AS STRING * 12
    lkFLoc AS STRING * 100
    lkFDesc AS STRING * 254
END TYPE
TYPE RefDb
    rdbFName AS STRING * 12
END TYPE
DIM SHARED Ref AS Reference
DIM SHARED DB AS RefDb

DIM SHARED lkLength AS INTEGER
DIM SHARED rdbLength AS INTEGER

DIM SHARED rdbFNum AS INTEGER

SUB CreateRef ()
    CLS
    LINE INPUT "Reference Name? ", rfname$
    nrFNum% = FREEFILE
    DB.rdbFName = LEFT$(rfname$, 8) + ".REF"
    rfname$ = LEFT$(rfname$, 8) + ".REF"
    OPEN "\REFRENCE.XOS\" + rfname$ FOR RANDOM AS nrFNum% LEN = lkLength
    PRINT
    LINE INPUT "File Path? ", Ref.lkFLoc
    LINE INPUT "File Name? ", Ref.lkFName
    LINE INPUT "Description? ", Ref.lkFDesc
    PUT #nrFNum%, , Ref
    PUT #rdbFNum, , DB
    CLOSE nrFNum%
END SUB

SUB ListRefs ()
STATIC Free%
    CLS
    PRINT "References:"
    PRINT
    FOR TRs% = 1 TO LOF(rdbFNum) / LEN(DB)
        GET #rdbFNum, TRs%, DB
        Free% = FREEFILE
        OPEN "\REFRENCE.XOS\" + RTRIM$(LTRIM$(DB.rdbFName)) FOR RANDOM AS Free% LEN = LEN(Ref)
        GET Free%, , Ref
        PRINT UCASE$(DB.rdbFName); "     Description:  "; LTRIM$(RTRIM$(Ref.lkFDesc))
        CLOSE Free%
    NEXT
    PRINT
    PRINT "Total References:   "; LTRIM$(STR$(TRs% - 1))
    PRINT
    PRINT "Press ESC to continue..."
    SLEEP
END SUB

SUB lkInit ()
    lkLength = LEN(Ref)
    rdbLength = LEN(DB)
    rdbFNum = FREEFILE
    OPEN "\REFRENCE.XOS\REF_LIST.RLS" FOR RANDOM AS rdbFNum LEN = rdbLength
END SUB

'
' Reference Interpreter
'
SUB RunRef ()
    CLS
    CALL ListRefs
    LINE INPUT "Reference Name? ", rfname$
    Free% = FREEFILE
    OPEN "\REFRENCE.XOS\" + rfname$ FOR RANDOM AS Free% LEN = LEN(Ref)
    GET Free%, 1, Ref
    PRINT "Description :  ", LTRIM$(RTRIM$(Ref.lkFDesc))
    PRINT
    PRINT "Program Name:  ", LTRIM$(RTRIM$(Ref.lkFName))
    PRINT "Program Path:  ", LTRIM$(RTRIM$(Ref.lkFLoc))
    PRINT
    LINE INPUT "Command Line Parameters? ", Params$
    RunName$ = RTRIM$(LTRIM$(Ref.lkFLoc)) + "\" + LTRIM$(RTRIM$(Ref.lkFName)) + " " + Params$
    PRINT "Program '"; RTRIM$(Ref.lkFDesc); "'"
    PRINT "Press any key to continue..."
    SLEEP
    CALL RunExternal(RunName$)
    PRINT "Press ESC to continue..."
    SLEEP
    CLOSE Free%
END SUB

SUB ShowDesktop ()

END SUB

