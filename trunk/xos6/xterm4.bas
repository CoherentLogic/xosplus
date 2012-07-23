DECLARE FUNCTION xtRetCharsFromCPort (FileNum AS INTEGER) AS STRING
DECLARE SUB xtDisconnectCPort (FileNum AS INTEGER)
DECLARE SUB trmMenu ()
DECLARE SUB xtSendCharToCPort (FileNum AS INTEGER, Char AS STRING)
DECLARE SUB xtInit ()
DECLARE SUB xtEstNewPhone (Number AS STRING)
DECLARE FUNCTION xtRetCPhone () AS STRING
DECLARE SUB xtDialCPhone (CommFileNum AS INTEGER)
DECLARE FUNCTION xtRetCFileNum () AS INTEGER
DECLARE FUNCTION xtRetCharFromCPort (FileNum AS INTEGER) AS STRING
DECLARE FUNCTION xtRetCDevDesc () AS STRING
'
' XOS Communications Subsystem
'  Version 5.1
'

'Declarations

'Includes
'$INCLUDE: '\VBDWSHOP\PROFILE.BI'

'Constants

'Subroutines
DECLARE SUB lpCommLoop ()

'Functions
DECLARE FUNCTION xtRetCPort () AS STRING
DECLARE FUNCTION xtOpenCPort (Mode AS INTEGER, RecLen AS INTEGER) AS INTEGER

'Variables
DIM SHARED Port$
DIM SHARED Desc$
DIM SHARED Service$
DIM SHARED Settings$
DIM SHARED Free%
DIM SHARED Phone AS STRING
DIM SHARED Title AS STRING
DIM SHARED Status AS STRING
'End of Declarations

'
' Sample ANSI Terminal.
' Use only after xtInit has been called.
'
SUB lpCommLoop ()
    CALL xtInit
    CLS
    COLOR 0, 7
    PRINT "WillisWare Terminal 1.0a"
    COLOR 7, 0
    PRINT "CDev    = "; xtRetCDevDesc
    PRINT "Port    = "; xtRetCPort
    PRINT "Service = "; Service$
    SLEEP 5
    COLOR 7, 0
    CLS
    Free% = xtOpenCPort(3, 256)
    LINE INPUT "Phone Number? ", ph$
    CALL xtEstNewPhone(ph$)
    Temp% = xtRetCFileNum
    CALL xtDialCPhone(Temp%)
    DO
            KEY$ = INKEY$
            IF KEY$ = CHR$(27) THEN
                CALL trmMenu
            END IF
            PRINT xtRetCharsFromCPort(xtRetCFileNum);
            CALL xtSendCharToCPort(xtRetCFileNum, KEY$)
    LOOP
EXIT SUB

'Old code...
DO
    Dummy% = 6
    'Cursor Routine
    LOCATE POS(1), CSRLIN
    COLOR 2
    PRINT CHR$(219)
    SOUND 32767, 1
    LOCATE POS(1), CSRLIN
    COLOR 0
    PRINT CHR$(219)
    SOUND 32767, 1
    'End of cursor routine
    KEY$ = INKEY$
    IF KEY$ = CHR$(27) THEN
        PRINT CHR$(13)
        PRINT "---Terminal Menu---"
        PRINT
        PRINT " 1.  Hang Up"
        PRINT
        PRINT " 2.  Exit"
        PRINT
        INPUT "=>", Dummy%
        IF Dummy% = 1 THEN
            PRINT #Free%, "+++ATH"
        ELSE
            CLOSE Free%
            EXIT SUB
        END IF
    END IF
    IF NOT EOF(Free%) THEN Modem$ = INPUT$(LOC(Free%), Free%)
    IF Modem$ <> "" THEN PRINT Modem$;
    IF KEY$ <> "" THEN PRINT #Free%, KEY$;
    Modem$ = ""
LOOP

END SUB

SUB trmMenu ()
    COLOR 15, 1
    CLS
    PRINT "ษMain Menuอออออออออออป"
    PRINT "บ                    บ"
    PRINT "บ 1. Show TX/RX      บ"
    PRINT "บ                    บ"
    PRINT "บ 2. Show Connection บ"
    PRINT "บ                    บ"
    PRINT "บ 3. Show Port       บ"
    PRINT "บ                    บ"
    PRINT "บ 4. Printer Echo    บ"
    PRINT "บ                    บ"
    PRINT "บ 5. Capture Text    บ"
    PRINT "บ                    บ"
    PRINT "บ 6. Hang Up         บ"
    PRINT "บ                    บ"
    PRINT "ศออออออออออออออออออออผ"
    INPUT "=>", Menu%
    COLOR 7, 0
    CLS
    'Menu Processor
    SELECT CASE Menu%
        CASE 1
            PRINT "TX/RX = "; Status
        CASE 2
            PRINT xtRetCPhone
        CASE 3
            PRINT xtRetCPort
        CASE 6
            CALL xtDisconnectCPort(xtRetCFileNum)
    END SELECT
END SUB

SUB xtCloseCPort (FileNum AS INTEGER)
    CLOSE FileNum
END SUB

'
' Dial Current Phone Number.
' Use only after xtInit, xtOpenCPort and
' xtEstNewPhone have been called.
'
SUB xtDialCPhone (CommFileNum AS INTEGER)
    Comm$ = Service$ + Phone + CHR$(10)
    PUT #CommFileNum, , Comm$
END SUB

SUB xtDisconnectCPort (FileNum AS INTEGER)
    PRINT #FileNum, HPrefix$ + HCommand$
END SUB

'
'Establish new Phone Number
'Use only after xtInit has been called.
'
SUB xtEstNewPhone (Number AS STRING)
    Phone = Number
END SUB

'
' Initialize Port/Modem Settings in XOS.XIF
' Call first in a terminal program.
'
SUB xtInit ()
    Port$ = ProfileRead$("c:\xos\xos.xif", "Communications", "Modem")
    Settings$ = ProfileRead$("c:\xos\xos.xif", "Ports", Port$)
    Desc$ = ProfileRead$("c:\xos\xos.xif", "Communications", "CDevDesc")
    Service$ = ProfileRead$("c:\xos\xos.xif", "Communications", "Service")
END SUB

'
' Opens current modem port. Function returns file number.
' Use only after xtInit has been called.
'
FUNCTION xtOpenCPort (Mode AS INTEGER, RecLen AS INTEGER) AS INTEGER
    File% = FREEFILE
    SELECT CASE Mode
        CASE 1 'Input
            OPEN Port$ + ":" + Settings$ FOR INPUT AS #File%
        CASE 2 'Output
            OPEN Port$ + ":" + Settings$ FOR OUTPUT AS #File%
        CASE 3 'Random
            OPEN Port$ + ":" + Settings$ FOR RANDOM AS #File% LEN = RecLen
        CASE ELSE
            PRINT "Invalid Mode."
    END SELECT
    xtOpenCPort = File%
    Free% = File%
END FUNCTION

FUNCTION xtRetCDevDesc () AS STRING
    xtRetCDevDesc = Desc$
END FUNCTION

'
' Return current communications file number.
' Use only after xtInit and xtOpenCPort
' have been called.
'
FUNCTION xtRetCFileNum () AS INTEGER
    xtRetCFileNum = Free%
END FUNCTION

'
' Return One Character from Port
' Call only after xtInit and xtOpenCPort have been called.
'
FUNCTION xtRetCharsFromCPort (FileNum AS INTEGER) AS STRING
    IF NOT EOF(FileNum) THEN
        IF INPUT$(LOC(FileNum)) <> "" THEN
            xtRetCharsFromCPort = INPUT$(LOC(FileNum), FileNum)
        END IF
    END IF
    Status = "RX"
END FUNCTION

'
' Return Current Phone Number
' May be used before xtInit has been called.
'
FUNCTION xtRetCPhone () AS STRING
    xtRetCPhone = Phone
END FUNCTION

'
' Returns current modem port.
' Call only after xtInit has been called.
'
FUNCTION xtRetCPort () AS STRING
    xtRetCPort = Port$
END FUNCTION

'
' Send one character to port.
'  Use only after xtInit and xtOpenCPort have been called.
'
SUB xtSendCharToCPort (FileNum AS INTEGER, Char AS STRING)
    IF Char <> "" THEN
        PRINT #FileNum, Char;
        Status = "TX"
    END IF
END SUB

