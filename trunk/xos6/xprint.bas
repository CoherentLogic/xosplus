'$INCLUDE: '\VBDWSHOP\PROFILE.BI'
DECLARE SUB ChangeColors (FColor AS INTEGER, BColor AS INTEGER)
DECLARE SUB ClearJobs ()
'
' XOS Printer
' Version 1.00
'

DECLARE SUB AddJob (FileName AS STRING)
DECLARE FUNCTION TrimText (InText AS STRING) AS STRING
DIM SHARED PrinterName AS STRING
DIM SHARED Port AS STRING * 4
DIM SHARED NumberOfJobs AS INTEGER
DIM SHARED JobFName(1 TO 30) AS STRING * 12
DIM SHARED Dest AS STRING
DIM SHARED ID AS STRING
DIM SHARED Title AS STRING

SUB AddJob (FileName AS STRING)
    STATIC JobNum AS INTEGER
    DIM Stdselect AS STRING
    ON LOCAL ERROR GOTO PrnErr
    VIEW PRINT 22 TO 25
    JobNum = JobNum + 1
    LOCATE 23, 1
    PRINT "ÛÛÛ XOS Printer 2.0 - Job"; JobNum
    PRINT
    PRINT "Adding Job to Buffer, Please Wait."
    PRINT "Job #"; JobNum; " is "; FileName
    Dummy = FREEFILE
    OPEN "XOSPRNT1.JOB" FOR APPEND AS Dummy
    STD_ERR = FREEFILE
    OPEN FileName FOR INPUT AS STD_ERR
    Stdselect = INPUT$(LOF(STD_ERR), STD_ERR)
    PRINT #Dummy, Stdselect
    CLOSE Dummy
    Dummy = FREEFILE
    OPEN "XOSPRNT1.JOB" FOR INPUT AS Dummy
    Stdselect = INPUT$(LOF(Dummy), Dummy)
    PRINT #9, Stdselect
    CLOSE Dummy
    CLOSE STD_ERR
    KILL "XOSPRNT1.JOB"
    PRINT "Job Complete."
    VIEW PRINT 2 TO 25
    EXIT SUB
PrnErr:
    CLS
    PRINT "Printer Error."
    PRINT
    PRINT "'"; ERROR$(ERR); "'"
    PRINT
    PRINT "Press Any Key to Continue..."
    SLEEP
    EXIT SUB
    RESUME NEXT
'Old Printer Code
   ' Dummy = FREEFILE
   ' PRINT "ÛÛÛ XOS Printer 1.1"
   ' PRINT
   ' NumberOfJobs = NumberOfJobs + 1
   ' PRINT "Adding Job "; UCASE$(FileName); "..."
   ' FOR d% = 1 TO NumberOfJobs
   '     PRINT #9, CHR$(7);
   ' NEXT
  '  OPEN "XOSPRNT1.JOB" FOR OUTPUT AS FREEFILE
  '  OPEN FileName FOR INPUT AS #7
  '  Jobs(NumberOfJobs) = INPUT$(LOF(7), 7)
  '  JobFName(NumberOfJobs) = FileName
  '''  OPEN "PRNBUFF2.TMP" FOR APPEND AS #12
  '  PRINT "Size of printer buffer: "; LOF(12) / 1000; " KB"
  ''  IF LOF(12) >= 100000 THEN
  '      PRINT "Clearing Printer Buffer..."
  '''      CLOSE #12
  '      KILL "PRNBUFF2.TMP"
  '      OPEN "PRNBUFF2.TMP" FOR APPEND AS #12
  '  END IF
  '  PRINT #12, "ÛÛÛ XOS Printer 1.00"
  '  PRINT #12, Jobs(NumberOfJobs)
  '  PRINT #12, CHR$(12)
  '  CLOSE #12
  '  PRINT #9, Jobs(NumberOfJobs)
  '  PRINT #9, CHR$(12)
  '  PRINT "Finished Job "; LTRIM$(STR$(NumberOfJobs))
  '  PRINT
  '  CLOSE #7
  '  EXIT SUB

END SUB

SUB ClearJobs ()
    PRINT "Under Construction."
END SUB

SUB PrinterInit ()
    PRINT "Initializing Printer..."
    Stdselect$ = ProfileRead$("c:\xos\xos.xif", "Printer", "PRN1")
    FOR Iteration = 1 TO LEN(Stdselect$)
        SYS_MSG$ = MID$(Stdselect$, Iteration, 1)
        Port = RIGHT$(Stdselect$, 4)
        'Parsing Algorithm
        IF SYS_MSG$ = ";" THEN
            Dummy% = Dummy% + 1
            SELECT CASE Dummy%
                CASE 1
                    ID = Whole$
                CASE 2
                    PrinterName = Whole$
            END SELECT
            Whole$ = ""
        ELSE
            Whole$ = Whole$ + SYS_MSG$
        END IF
    NEXT Iteration
Stdselect$ = ProfileRead$("c:\xos\xos.xif", "Printer", "ShowPrinterSettings")
IF Stdselect$ = "YES" THEN
    PRINT "Printer ID    : "; ID
    PRINT "Printer Name  : "; PrinterName
    PRINT "Printer Port  : "; Port
    Stdselect$ = ProfileRead$("c:\xos\xos.xif", "Ports", Port)
    PRINT "Port Settings : "; Stdselect$
    PRINT
    PRINT "Press ESC"
    SLEEP
END IF
END SUB

SUB PrintMan ()
ON LOCAL ERROR RESUME NEXT
PrintMan:
    VIEW PRINT 1 TO 25
    Title = ""
    Title = "XOS Version 6.0                  XOS Printer                " + LTRIM$(RTRIM$(STR$(NumberOfJobs))) + " Jobs Pending" + STRING$(80 - LEN(Title), 255)
    LOCATE 1, 1: COLOR 0, 7: PRINT Title
    VIEW PRINT 2 TO 25
    CALL ChangeColors(15, 1)
    CLS
    LOCATE 3, 1
    PRINT
    PRINT "ษอออออออออออออออออออออป"
    PRINT "บÛÛÛ Printer Menu     บ"
    PRINT "ฬอออออออออออออออออออออน"
    PRINT "บ  1. Show All Jobs   บ"
    PRINT "บ                     บ"
    PRINT "บ  2. Print a File    บ"
    PRINT "บ                     บ"
    PRINT "บ  3. Clear All Jobs  บ"
    PRINT "บ                     บ"
    PRINT "บ  4. Exit            บ"
    PRINT "ศอออออออออออออออออออออผ"
    INPUT "=>", Dummy

    'Menu Processor
    SELECT CASE Dummy
        CASE 1
            CLS
            PRINT "Current Jobs:"
            FOR Iteration = 1 TO NumberOfJobs
                PRINT TAB(6); UCASE$(JobFName(Iteration))
            NEXT Iteration
            PRINT
            PRINT
            PRINT "Press any key to continue..."
            SLEEP
        CASE 2
            CLS
            LINE INPUT "Document to Print? ", Docname$
            PRINT
            PRINT "Print to:"
            PRINT
            PRINT "1.  Default ("; Port; ")"
            PRINT
            PRINT "2.  COM1"
            PRINT
            PRINT "3.  File"
            PRINT
            INPUT "=>", PrDest%
            
            'Menu Processor
            SELECT CASE PrDest%
                CASE 1
                    SELECT CASE LEFT$(Port, 3)
                        CASE "LPT"
                            OPEN Port FOR OUTPUT AS #9
                        CASE "COM"
                            Stdselect$ = ProfileRead$("c:\xos\xos.xif", "Ports", Port)
                            OPEN Port$ + ":" + Stdselect$ FOR OUTPUT AS #9
                    END SELECT
                CASE 2
                    OPEN "COM1" FOR OUTPUT AS #9
                CASE 3
                    LINE INPUT "Destination File: ", Desfile$
                    OPEN Desfile$ FOR OUTPUT AS #9
            END SELECT
            INPUT "Number of Copies? ", Copies%
            LINE INPUT "Condense? ", Desfile$
            IF LEFT$(TrimText(Desfile$), 1) = "y" THEN
                PRINT #9, CHR$(15)
            ELSE
                PRINT #9, CHR$(27); CHR$(18)
            END IF
            LINE INPUT "Double Strike? ", Desfile$
            IF LEFT$(TrimText(Desfile$), 1) = "y" THEN
                PRINT #9, CHR$(27); "G"
            ELSE
                PRINT #9, CHR$(27); "H"
            END IF
            LINE INPUT "Emphasized? ", Desfile$
            IF LEFT$(TrimText(Desfile$), 1) = "y" THEN
                PRINT #9, CHR$(14)
            ELSE
                PRINT #9, CHR$(27); CHR$(20)
            END IF
            LINE INPUT "Double Width? ", Desfile$
            IF LEFT$(TrimText(Desfile$), 1) = "y" THEN
                PRINT #9, CHR$(27); "G"
            ELSE
                PRINT #9, CHR$(27); "H"
            END IF
            STD_ERR = FREEFILE
            OPEN "PRINTER.XXP" FOR INPUT AS STD_ERR
            PrinterName = INPUT$(LOF(STD_ERR), STD_ERR)
            CLS
            PRINT "Printing"; Copies%; " Copies Of "; UCASE$(Docname$); " To The "; PrinterName
            FOR Iteration = 1 TO Copies%
                CALL AddJob(Docname$)
            NEXT Iteration
            LOCATE 25, 1
            MSGBOX "Job Complete.", 0, PrinterName
        CASE 3
            CALL ClearJobs
        CASE 4
            EXIT SUB
    END SELECT
CLS
CLOSE #9
GOTO PrintMan
END SUB

