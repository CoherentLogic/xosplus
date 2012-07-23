'$INCLUDE: '\VBDWSHOP\PROFILE.BI'
'$INCLUDE: 'WSTDFNCT.BI'
'$INCLUDE: 'CONSTANT.BI'

DECLARE SUB ComLine (NumArgs, Args$(), MaxArgs)

DIM a$(1 TO 10)
CALL ComLine(3, a$(), 3)

IF a$(1) = "-h" THEN
    PRINT
    PRINT "USAGE:"
    PRINT "encmod infile outfile -e"
    PRINT "encmod infile outfile -d"
    PRINT
    PRINT "Copyright (C) 1997, J. Willis"
    END
END IF

OPEN a$(1) FOR INPUT AS #1
x$ = INPUT$(LOF(1), 1)
CLOSE
OPEN a$(2) FOR OUTPUT AS #1
SELECT CASE a$(3)
    CASE "-e"
        PRINT #1, szEncrypt(x$)
    CASE "-d"
        PRINT #1, szDecrypt(x$)
END SELECT


