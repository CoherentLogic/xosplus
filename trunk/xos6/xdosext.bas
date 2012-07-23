DECLARE SUB CapsOff ()
DECLARE SUB CapsOn ()
DECLARE SUB ChangeColors (FColor AS INTEGER, BColor AS INTEGER)
DECLARE FUNCTION TrimText (InText AS STRING) AS STRING



SUB RunExternal (ProgName AS STRING)
    PRINT "Running "; UCASE$(TrimText(ProgName)); "..."
    SHELL ProgName
END SUB

SUB ShellToDOS ()
    CALL ChangeColors(7, 0)
    CALL CapsOff
    CLS
    PRINT
    PRINT "Type EXIT to return to XOS."
    PRINT
    SHELL
    CALL CapsOn
END SUB

