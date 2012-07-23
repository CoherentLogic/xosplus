'
' unbacon
'
IF VAL(COMMAND$) <> 0 THEN
    PRINT "Raw Bacon:    "; COMMAND$
    PRINT "Cooked Bacon: "; ERROR$(VAL("&H" + COMMAND$))
ELSE
    PRINT "usage:  unbacon error-code"
END IF

