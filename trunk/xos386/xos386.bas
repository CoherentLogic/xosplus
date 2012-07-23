DECLARE SUB IntDivide (Dividend AS LONG, Divisor AS LONG)

'$INCLUDE: '\vbdwshop\profile.bi'
'$INCLUDE: '\vbdos\constant.bi'

DECLARE SUB PutReg (RegD AS STRING, ValueD AS STRING)
DECLARE SUB ProfileWrite (IniFile$, IniSection$, IniKey$, ProfileStr$)
'
' XOS386.EXE
' XOS API Implementation for MS-DOS
'

DECLARE FUNCTION szDOSDriveLetter (MountPath AS STRING) AS STRING
DECLARE FUNCTION nDirExists (DirName AS STRING) AS INTEGER
DECLARE FUNCTION nExists (FileName AS STRING) AS INTEGER
DECLARE FUNCTION nFigurePercent (Given AS DOUBLE, Max AS DOUBLE) AS DOUBLE
DECLARE FUNCTION nReadProfileInt (a$, b$, c$) AS INTEGER
DECLARE FUNCTION nYesOrNo (Message AS STRING) AS INTEGER
DECLARE FUNCTION szDecrypt (InData AS STRING) AS STRING
DECLARE FUNCTION szEncrypt (InData AS STRING) AS STRING
DECLARE FUNCTION szGetRootDir (Path AS STRING, File AS STRING) AS STRING
DECLARE FUNCTION szKillChar (InText AS STRING, TrimChar AS STRING, ReplaceWith AS STRING) AS STRING
DECLARE FUNCTION szStringLeft (InText AS STRING, CharFilter AS STRING) AS STRING
DECLARE FUNCTION szStringRight (InText AS STRING, CharFilter AS STRING) AS STRING
DECLARE FUNCTION szStrReplace! ()
DECLARE FUNCTION szTrimText (InText AS STRING) AS STRING
DECLARE SUB ComLine (NumArgs, Args$(), MaxArgs)
DIM SHARED Quotient AS LONG
DIM SHARED Remainder AS LONG
DIM SHARED N$(100)
ON ERROR GOTO ErrHandler
CALL ComLine(100, N$(), 100)

SCREEN VAL(ProfileRead$("C:\XOS\USER\PROFILE", "Register", "rVID"))


Funct = VAL(N$(1))

SELECT CASE Funct
    CASE 1  'szXOSLocation
        CALL PutReg("rA", "C:\XOS")
    CASE 2  'szGetVariableByName
        varval$ = ProfileRead$("C:\XOS\USER\PROFILE", "Environment", UCASE$(N$(2)))
        CALL PutReg("rA", varval$)
    CASE 3  'szGetFunctionByNum
        SELECT CASE VAL(N$(2))
            CASE 1
                Desc$ = "void:XOS386(1/ret=rA) szXOSLocation"
            CASE 2
                Desc$ = "asciiz:XOS386(2/ret=rA) szGetVariableByName"
            CASE 3
                Desc$ = "asciiz:XOS386(3/ret=rA) szGetFunctionByNum"
        END SELECT
        PutReg "rA", Desc$
    CASE 4  'szFTimeSerial
        PutReg "rA", FORMAT$(NOW, N$(2))
    CASE 5 'szSetSystemTime
        TIME$ = N$(2)
    CASE 6 'szSetSystemDate
        DATE$ = N$(2)
    CASE 7 'vSetVidMode
        SCREEN VAL(N$(2))
        PutReg "rVID", N$(2)

    CASE 9 'vDrawLine
        
        LINE (VAL(N$(2)), VAL(N$(3)))-(VAL(N$(4)), VAL(N$(5))), VAL(N$(6))
    CASE 10 'vPause
        SLEEP VAL(N$(2))
    CASE 11 'vDivideInteger
        CALL IntDivide(VAL(N$(2)), VAL(N$(3)))
        PutReg "rA", LTRIM$(RTRIM$(STR$(Quotient)))
        PutReg "rB", LTRIM$(RTRIM$(STR$(Remainder)))
    CASE 12 'nTangent
        PutReg "rA", LTRIM$(RTRIM$(STR$(TAN(VAL(N$(2))))))
    CASE 13 'nArcTangent
        PutReg "rA", LTRIM$(RTRIM$(STR$(ATN(VAL(N$(2))))))
    CASE 14 'nCosine
        PutReg "rA", LTRIM$(RTRIM$(STR$(COS(VAL(N$(2))))))
    CASE 15 'nSine
        PutReg "rA", LTRIM$(RTRIM$(STR$(SIN(VAL(N$(2))))))
    CASE 16 'nAbsolute
        PutReg "rA", LTRIM$(RTRIM$(STR$(ABS(VAL(N$(2))))))
    CASE 17 'nGetDegreesByRadians
        npi = 180 / 3.141593
        nrad = VAL(N$(2)) * npi
        PutReg "rA", LTRIM$(RTRIM$(STR$(nrad)))
    CASE 18 'nGetRadiansByDegress
        npi = 3.141593 / 180
        nrad = VAL(N$(2)) * npi
    CASE 19 'nSquareRoot
        PutReg "rA", LTRIM$(RTRIM$(STR$(SQR(VAL(N$(2))))))
    CASE 20 'nExponent
        PutReg "rA", LTRIM$(RTRIM$(STR$(EXP(VAL(N$(2))))))
    CASE 21 'nNaturalLogarithm
        PutReg "rA", LTRIM$(RTRIM$(STR$(LOG(VAL(N$(2))))))
    CASE 22 'nIncrement
        PutReg "rA", LTRIM$(RTRIM$(STR$(VAL(N$(2)) + 1)))
    CASE 23 'nDecrement
        PutReg "rA", LTRIM$(RTRIM$(STR$(VAL(N$(2)) - 1)))
' To convert values from degrees to radians, multiply the angle (in
 '  degrees) by pi/180 (or .0174532925199433), where pi = 3.141593.
 '
 ' To convert radian values to degrees, multiply radians by 180/pi (or
 '  57.2957795130824), where pi = 3.141593.
    CASE 24 'StdDivide
        PutReg "rA", LTRIM$(RTRIM$(STR$(VAL(N$(2)) / VAL(N$(3)))))
    CASE 25 'GetCurDir
        PutReg "rA", CURDIR$
    CASE 33 'ChangeCurDir
        CHDIR N$(2)
    CASE 34 'ChangeCurDrive
        CHDRIVE N$(2)
    CASE 26 'MakeNewDir
        MKDIR N$(2)
    CASE 27 'RemoveDir
        RMDIR N$(2)
    CASE 28 'RemoveFile
        KILL N$(2)
    CASE 29 'FileExists
        SELECT CASE nExists(N$(2))
            CASE TRUE
                PutReg "rA", "TRUE"
            CASE FALSE
                PutReg "rA", "FALSE"
        END SELECT
    CASE 30 'DirExists
        SELECT CASE nDirExists(N$(2))
            CASE TRUE
                PutReg "rA", "TRUE"
            CASE FALSE
                PutReg "rA", "FALSE"
        END SELECT
    CASE 31 'RenameFile
        NAME N$(2) AS N$(3)
    CASE 32 'LoadExec
        SHELL N$(2)


    CASE 50 'Beep
        BEEP
    CASE 51 'vPlaySound
        SOUND VAL(N$(2)), VAL(N$(3))
    CASE 52 'vPlayMusic
        PLAY N$(2)



    CASE 80  'Input
        LINE INPUT "", temp$
        PutReg "rA", temp$






END SELECT
END

ErrHandler:
    ErrCode = ERR
    PutReg "rEC", LTRIM$(RTRIM$(STR$(ErrCode)))
    PutReg "rEE", ERROR$(ErrCode)
    RESUME NEXT

SUB IntDivide (Dividend AS LONG, Divisor AS LONG)
    ON LOCAL ERROR GOTO NONE
    DivRes = Dividend / Divisor
    IF INSTR(STR$(DivRes), ".") = 0 THEN
        GOTO NONE
    END IF
    WholePart = VAL(LEFT$(STR$(DivRes), INSTR(STR$(DivRes), ".") - 1))
    DecRemainder = VAL(MID$(STR$(DivRes), INSTR(STR$(DivRes), ".")))
NONE:
    'PRINT "Std. Div. Result:  "; DivRes
    'PRINT "Whole part:  "; WholePart
    'PRINT "Decimal Remainder:  "; DecRemainder
    'PRINT "Result:  "; WholePart; "r"; CLNG(DecRemainder * Divisor)
    Quotient = WholePart
    Remainder = CLNG(DecRemainder * Divisor)
    RESUME NEXT
END SUB

SUB PutReg (RegD AS STRING, ValueD AS STRING)
    CALL ProfileWrite("C:\XOS\USER\PROFILE", "Register", RegD, ValueD)


END SUB

