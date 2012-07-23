
DECLARE SUB dnlSetActiveINL (LinkTitle AS STRING)
DECLARE SUB dnlSetINLData (LinkTitle AS STRING, DataField AS INTEGER, dnlData AS STRING)
DECLARE SUB dnlUnlockResource (LinkTitle AS STRING)
DECLARE FUNCTION nQueryDriver (TestString AS STRING, DelayLoop AS INTEGER) AS INTEGER
DECLARE FUNCTION nResourceLocked (LinkTitle AS STRING) AS INTEGER
DECLARE FUNCTION szActiveINL () AS STRING
DECLARE FUNCTION szGetWinClipboard () AS STRING
DECLARE FUNCTION szINLClientID (LinkTitle AS STRING) AS STRING
DECLARE FUNCTION szINLData (LinkTitle AS STRING, DataField AS INTEGER) AS STRING
DECLARE FUNCTION szINLServerID (LinkTitle AS STRING) AS STRING
DECLARE FUNCTION szINLType (LinkTitle AS STRING) AS STRING
DECLARE SUB dnlCreateINL (LinkTitle AS STRING, ConvType AS STRING)
DECLARE SUB dnlSetActiveINL (LinkTitle AS STRING)
DECLARE SUB dnlSetINLData (LinkTitle AS STRING, DataField AS INTEGER, dnlData AS STRING)
DECLARE SUB dnlUnlockResource (LinkTitle AS STRING)
DECLARE SUB lpCommLoop ()
'
'XOS.BAS
'eXtended Operating System
'Operating Environment
'
'Version 6.0
'

'$INCLUDE: '\VBDWSHOP\PROFILE.BI'
'$INCLUDE: 'VBDOS.BI'


' Declarations:
DECLARE SUB YourPrograms ()
DECLARE SUB dnlSetINLClientID (LinkTitle AS STRING, ClientID AS STRING)
DECLARE SUB xosInitWinXOSLink ()
DECLARE SUB dnlCreateINL (LinkTitle AS STRING, ConvType AS STRING)
DECLARE SUB RunAfterShell ()
DECLARE SUB ProfileWrite (IniFile$, IniSection$, IniKey$, ProfileStr$)
DECLARE SUB RunProgram (EXEName AS STRING, ServerID AS STRING, ReloadServer AS STRING)
DECLARE SUB drvLoadDrivers ()
DECLARE SUB FadeOut ()
DECLARE SUB ClearPR ()
DECLARE SUB ViewerInit (File AS STRING)
DECLARE SUB About ()
DECLARE SUB NewSys ()
DECLARE SUB UpdateRHRES ()
DECLARE SUB EncData ()
DECLARE SUB admInit ()
DECLARE SUB LockUp ()
DECLARE SUB SECURITYPLUS ()
DECLARE SUB XSetup ()
DECLARE SUB setInit ()
DECLARE SUB CreateNewUser ()
DECLARE SUB ShutDown ()
DECLARE SUB ErrorStart ()
DECLARE SUB STErrCheck ()
DECLARE SUB EndXOS ()
DECLARE SUB Teletype ()
DECLARE SUB xtInit ()
DECLARE SUB RunRef ()
DECLARE SUB ListRefs ()
DECLARE SUB lkInit ()
DECLARE SUB CreateRef ()
DECLARE SUB EndProc ()
DECLARE SUB StartUp ()
DECLARE SUB UndeleteFile ()
DECLARE SUB DeleteFile ()
DECLARE SUB PrinterInit ()
DECLARE SUB PrintMan ()
DECLARE SUB AddJob (FileName AS STRING)
DECLARE SUB MainGrid ()
DECLARE SUB UVCS ()
DECLARE SUB FList ()
DECLARE SUB XSetup ()
DECLARE SUB CapsOff ()
DECLARE SUB CapsOn ()
DECLARE SUB PromptChange ()
DECLARE SUB CustomPrompt ()
DECLARE SUB SmartCommand ()
DECLARE SUB ShellToDOS ()
DECLARE SUB RunExternal (ProgName AS STRING)
DECLARE SUB CommandSound ()
DECLARE SUB Pause ()
DECLARE SUB ClearScreen ()
DECLARE SUB ExitMenu ()
DECLARE SUB Navigate ()
DECLARE SUB ChangeColors (FColor AS INTEGER, BColor AS INTEGER)
DECLARE SUB MemCheck ()
DECLARE SUB OpenFile (FileName AS STRING, FileNum AS INTEGER)
DECLARE SUB XPrint (InText AS STRING, Horiz AS INTEGER, Vert AS INTEGER)
DECLARE SUB StartBanner ()
DECLARE SUB KeyInit ()
DECLARE SUB ScreenInit (ScreenMode AS INTEGER, FColor AS INTEGER, BColor AS INTEGER)

'Functions
DECLARE FUNCTION WEncrypt (InText AS STRING) AS STRING
DECLARE FUNCTION WDecrypt (InText AS STRING) AS STRING
DECLARE FUNCTION Flags () AS STRING
DECLARE FUNCTION YesOrNo! ()
DECLARE FUNCTION HandleIt (ErrCode AS INTEGER) AS STRING
DECLARE FUNCTION TrimText (InText AS STRING) AS STRING
DECLARE FUNCTION Exists (FileName AS STRING) AS STRING
DECLARE FUNCTION CurDate () AS STRING

'Data Types
TYPE UID
	FName AS STRING * 12
	FLoc AS STRING * 100
	FSize AS LONG
END TYPE
TYPE StartUp
	ErrStart AS STRING * 5
	StdErr AS INTEGER
	SysMsg AS STRING * 300
END TYPE
TYPE RAM
	Conv AS LONG
	EMS AS LONG
	XMS AS LONG
END TYPE
TYPE Set

	'User Info
	Username AS STRING * 11
	Password AS STRING * 8

	'Colors
	FC AS INTEGER 'ForeColor
	BC AS INTEGER 'BackColor

END TYPE
TYPE adm

	'Administrator Password
	admPassword AS STRING * 8

	'Maximum Password Retries
	MaxRetries AS INTEGER

	'Require Username
	admReqUser AS INTEGER

	'Printer Access
	MaxCopies AS INTEGER

END TYPE
COMMON SHARED Mem AS RAM
'XOS Program RPL Word
CONST RPL = "OBSOLETE_FLAG"
'XOS Version
CONST PROG_VERSION = "7.0a"
'OEM Version String
CONST OEM_VERSION_STRING = "eXtended Operating System  [7.0a]"
CONST TRUE = -1
CONST FALSE = 0
'Incinerator
COMMON SHARED Del AS UID
COMMON SHARED regs AS RegType
COMMON SHARED HText AS STRING
TYPE DesktopData
	szDescription AS STRING * 50
	szKey AS STRING * 50
	szEXE AS STRING * 50
END TYPE
TYPE Colors
	cFC AS INTEGER
	cBC AS INTEGER
END TYPE

TYPE SStart
	ShutDownSuccessful AS STRING * 3
	StartUpMessage AS STRING * 100
END TYPE
TYPE Conf
	APM AS STRING * 5
END TYPE
COMMON SHARED Con AS Conf
COMMON SHARED SFile AS INTEGER
COMMON SHARED CommandName AS STRING
COMMON SHARED SS1 AS SStart
COMMON SHARED C AS Colors
COMMON SHARED ShellName AS STRING
COMMON SHARED MyName AS STRING * 11
COMMON SHARED UserLoc AS INTEGER
COMMON SHARED Setup AS Set
COMMON SHARED setFNum AS INTEGER
COMMON SHARED StartTime AS LONG
COMMON SHARED DelFileNum AS INTEGER
COMMON SHARED SMMode AS INTEGER
COMMON SHARED Prompt AS STRING
COMMON SHARED Dummy AS INTEGER
COMMON SHARED Iteration AS LONG
COMMON SHARED Title AS STRING
COMMON SHARED Stdselect AS STRING
COMMON SHARED SYS_MSG AS STRING
COMMON SHARED STD_ERR AS INTEGER
COMMON SHARED FTL_ERR AS STRING
COMMON SHARED admTPassword AS STRING * 8
COMMON SHARED admFile AS adm
COMMON SHARED admLoggedOn AS INTEGER
COMMON SHARED Bypass AS STRING
DIM SHARED ProgName(100) AS DesktopData
DIM SHARED nTotalPrograms AS INTEGER
'End of Declarations



'Startup Procedure Calls
	Stdselect = ProfileRead$("\XOS\XOS.XIF", "Boot", "DynaLinkRun")
	IF Stdselect = "TRUE" THEN
		CALL RunAfterShell
		END
	END IF
	VIEW PRINT 1 TO 25
	COLOR 7, 0
	CLS
	PRINT "ษอออออออออออออออออออออออออออออออออออออออป"
	PRINT "บ XOS Version 6.0, Rev. A               บ"
	PRINT "บ  XOS6 Main Module v2.11               บ"
	PRINT "บ Copyright (C) 1986, 1995  John Willis บ"
	PRINT "ศอออออออออออออออออออออออออออออออออออออออผ"
	PRINT
	PRINT "Please Wait..."
	'CALL xosInitWinXOSLink
	CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeClientApp", "XOS6")
	PRINT
	PRINT
	PRINT
	'CALL drvLoadDrivers
	CALL ClearPR
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "FirstStatement", "SUCCESS")
	ON ERROR RESUME NEXT
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CoreEHLoad", "SUCCESS")
	SCREEN 12
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "Logo", "SUCCESS")
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "InitAppDir")
	SHELL Stdselect + "\DISPLOG.EXE"
	SCREEN 0
	
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "XMS", "SUCCESS")
	regs.ax = &H1
	regs.dx = &HFFFF
	'CALL INTERRUPT(&H2F, regs, regs)
	IF NOT regs.ax = &H1 THEN
		CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "XMS", "FAILED")
		PRINT "Failed."
		PRINT "Program will load into conventional memory."
		PRINT
		PRINT "Press ESC"
		SLEEP
	END IF
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CParmProc", "SUCCESS")
	SELECT CASE TrimText(COMMAND$)
		CASE "/bypass_shutdown_success"
			Bypass = "yes"
	END SELECT
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "AlwaysBypassShutdownSuccess")
	IF Stdselect = "YES" THEN
		Bypass = "yes"
	END IF
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "SBMidInitToStartTime", "SUCCESS")
	StartTime = TIMER
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CURUSERInitToMyName", "SUCCESS")
	MyName = "NEW SESSION"
	CALL StartBanner
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Devices", "DisplayDriver")
	SYS_MSG = ProfileRead$("c:\xos\xos.xif", "Devices", "DispOptions")
	SHELL Stdselect + SYS_MSG
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "PCalls", "SUCCESS")
	CALL PrinterInit
	CALL MemCheck
	CALL ScreenInit(0, 15, 1)
	CALL KeyInit
	CALL CapsOn
	'CALL 'SECURITYPLUS
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "ARun", "SUCCESS")
	Stdselect = ProfileRead$("c:\xos\xos.xif", "AutoRun", "run")
	IF NOT LEN(Stdselect) < 1 THEN
		SHELL Stdselect
	END IF
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "ShellSelect", "SUCCESS")
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "DefShell")
	
	SELECT CASE Stdselect
		CASE "$CENTRAL"
			CALL Navigate
		CASE "$MGRID"
			CALL MainGrid
		CASE "$SCMD"
			CALL SmartCommand
			CALL Navigate
			END
		CASE "$RUNS2"
			SYS_MSG = ProfileRead$("c:\xos\xos.xif", "Boot", "runShell")
			SHELL SYS_MSG
	END SELECT
 'End of procedure calls

SUB About ()
	PRINT "        ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
	PRINT "        บ XOS Rel. 6.0, Rev. A                                         บ"
	PRINT "        บ                                                              บ"
	PRINT "        บ eXtended Operating System 7.0a is exclusive property of the  บ"
	PRINT "        บ WillisWare division of John Willis Graphics & Design.        บ"
	PRINT "        บ All rights under U.S. Copyright laws are reserved.           บ"
	PRINT "        บ Publication subsidized by Mission Scribes. Distributed by    บ"
	PRINT "        บ John Willis Graphics & Design. Unauthorized distribution and บ"
	PRINT "        บ reproduction of this program is strictly prohibited.         บ"
	PRINT "        บ                                                              บ"
	PRINT "        บ Copyright (C) 1986, 1995  John Willis                        บ"
	PRINT "        ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
END SUB

SUB admInit ()
	OPEN "ADMIN.XXP" FOR RANDOM AS #14
	GET #14, 1, admFile
	admTPassword = admFile.admPassword

END SUB

 STATIC SUB CapsOff ()            ' Turn Caps Lock off
   DEF SEG = 0
   ' Set Caps Lock off (turn off bit 6 of &H0417).
   POKE &H417, PEEK(&H417) AND &HBF
   DEF SEG
 END SUB

STATIC SUB CapsOn ()             ' Turn Caps Lock on
   EXIT SUB
   ' Set segment to low memory.
   DEF SEG = 0
   ' Set Caps Lock on (turn on bit 6 of &H0417).
   POKE &H417, PEEK(&H417) OR &H40
   ' Restore segment.
   DEF SEG
END SUB

SUB ChangeColors (FColor AS INTEGER, BColor AS INTEGER)
	COLOR FColor, BColor
	CLS
END SUB

SUB ClearPR ()
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "FirstStatement", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CoreEHLoad", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "Logo", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "XMS", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CParmProc", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "SBMidInitToStartTime", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CURUSERInitToMyName", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "PCalls", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "ARun", "FAILED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "ShellSelect", "FAILED")
END SUB

SUB ClearScreen ()
	CLS
END SUB

SUB CommandSound ()
	SOUND 37, .1
	SOUND 32767, .1
	SOUND 50, .1
	SOUND 37, .1
END SUB

SUB CreateNewUser ()
	LINE INPUT "Enter User Name: ", Setup.Username
	LINE INPUT "Enter Password : ", Setup.Password
	PRINT
	PRINT "Saving User Information..."
	CALL EncData
	PUT #setFNum, , Setup
	PRINT "Information Saved."
	PRINT "Please write down your password!"
	PRINT
	PRINT
	PRINT "Press any key to continue..."
	SLEEP
END SUB

FUNCTION CurDate () AS STRING
	CurDate = FORMAT$(NOW, "dddd") + ", " + FORMAT$(NOW, "mmmm") + " " + FORMAT$(NOW, "d") + ", " + FORMAT$(NOW, "yyyy")
END FUNCTION

SUB CustomPrompt ()
	LINE INPUT "Enter Custom Prompt: ", Prompt
	PRINT "New Prompt: "; Prompt
END SUB

'
' XOS 7.0a:  Incinerator 1.0 Deletion Subroutine
'
SUB DeleteFile ()
	DelDir$ = UCASE$(ProfileRead$("\XOS\XOS.XIF", "Incinerator", "IncinDir"))
	PRINT "ÛÛÛ XOS Smart Incinerator 1.0"
	PRINT
	PRINT "Using Directory "; DelDir$
	PRINT
	LINE INPUT "Path for File to be Deleted? ", PathName$
	LINE INPUT "Filename to Delete? ", FileName$
	PRINT "Sending "; UCASE$(PathName$ + "\" + FileName$); " To The Incinerator..."
	FOR Iteration = 1 TO LOF(DelFileNum) / LEN(Del)
		GET DelFileNum, Iteration, Del
		IF TrimText(Del.FLoc) = TrimText(FileName$) THEN
			NewLoc$ = UCASE$(TrimText(Del.FLoc))
			Temp$ = Del.FName
			Del.FName = UCASE$(TrimText(FileName$))
			Del.FLoc = UCASE$(TrimText(PathName$))
			Dummy = FREEFILE
			OPEN PathName$ + "\" + FileName$ FOR INPUT AS Dummy
			Del.FSize = LOF(Dummy)
			CLOSE Dummy
			PUT DelFileNum, Iteration, Del
			SHELL "COPY " + UCASE$(PathName$ + "\" + FileName$) + " " + UCASE$(DelDir$)
			KILL PathName$ + "\" + FileName$
			PRINT "File Incinerated."
			EXIT SUB
		END IF
	NEXT
	Del.FName = UCASE$(TrimText(FileName$))
	Del.FLoc = UCASE$(TrimText(PathName$))
	Dummy = FREEFILE
	OPEN PathName$ + "\" + FileName$ FOR INPUT AS Dummy
	Del.FSize = LOF(Dummy)
	CLOSE Dummy
	PUT DelFileNum, , Del
	SHELL "COPY " + UCASE$(PathName$ + "\" + FileName$) + " " + UCASE$(DelDir$)
	KILL PathName$ + "\" + FileName$
	PRINT "File Incinerated."
END SUB

SUB EncData ()
	Setup.Password = WEncrypt(Setup.Password)
END SUB

SUB EndProc ()
			PRINT "Session Time:  "; INT(TIMER - StartTime); "Seconds."
			SLEEP 2

	COLOR 0, 0
	VIEW PRINT 1 TO 25
	FOR i% = 1 TO 25
		FOR j% = 1 TO 80
			LOCATE i%, j%: PRINT CHR$(219)
			SOUND 32767, .1
		NEXT
	NEXT
	COLOR 7, 0
	VIEW PRINT 23 TO 25
	LOCATE 23, 1: PRINT STRING$(80, 196)
	VIEW PRINT 24 TO 25
	PRINT "Unloading XOS..."
	CALL CapsOff
	SLEEP 2
	PRINT "Switching to DOS..."
	VIEW PRINT 1 TO 25
	COLOR 15, 0
	LOCATE 1, 1
	SLEEP 3
	END
END SUB

SUB EndXOS ()
			PRINT "Session Time:  "; INT(TIMER - StartTime); "Seconds."
			SLEEP 2

ON LOCAL ERROR RESUME NEXT
	SCREEN 0
	COLOR 15, 1
	CLS
	

	FOR Iteration = 1 TO 15
		CLOSE Iteration
	NEXT Iteration

	
	
	FOR Iteration = 1 TO 100
		DEF SEG
	NEXT Iteration

   
	
	CALL CapsOff

	

	COLOR 7, 0

	CLS

	

	VIEW PRINT 1 TO 25
	CLS

	
	
	FOR Iteration = 13 TO 0 STEP -1
		SCREEN Iteration
	NEXT
	
	WIDTH 80
	SCREEN 12
	SHELL "GOODBYE"
	END
END SUB

SUB ErrorStart ()
	VIEW PRINT 1 TO 25
	COLOR 7, 0
	KEY OFF
	CLS
	PRINT "Restarting XOS 7.0a..."
	CALL CapsOff
	PLAY "<L16A>"
	SLEEP 1
	CLS
	WIDTH 40
	'FOR Iteration = 1 TO 40
	'    COLOR 12
	'    LOCATE 13, 10: PRINT "WARNING:  System Unstable"
	'    SOUND 900, .1
	'    SLEEP 1
	'    CLS
	'    SOUND 37, .1
	'    SLEEP 1
	'NEXT Iteration
	WIDTH 80
	COLOR 7, 0
	PRINT "Closing Files..."
	CLOSE
	SLEEP 1
	CLS
	CALL StartBanner
	CLS
	PRINT "Initializing Printer..."
	SLEEP 1
	CALL PrinterInit
	CLS
	PRINT "Scanning Conventional Memory..."
	SLEEP 1
	CALL MemCheck
	CLS
	PRINT "Initializing Console..."
	CALL ScreenInit(0, 15, 1)
	CALL KeyInit
	KEY OFF
	SLEEP 1
	CLS
	PRINT "Returning CAPS LOCK State..."
	SLEEP 1
	CALL CapsOn
	CLS
	PRINT "Completing Startup Routine..."
	SLEEP 3
	SHELL "XVGDRV /INIT"
	'SHELL "CLEANUP.EXE"
	'SHELL "GOODBYE"
	'SHELL "DISPLOG"
	CALL SECURITYPLUS
	CALL Navigate
END SUB

FUNCTION Exists (FileName AS STRING) AS STRING
	ON LOCAL ERROR RESUME NEXT
	Dummy = FREEFILE
	OPEN FileName FOR INPUT AS Dummy
	IF ERR = 53 THEN
		Stdselect = "NO"
		Exists = "NO"
	ELSEIF ERR = 76 THEN
		Stdselect = "NO"
		Exists = "NO"
	ELSE
		Exists = "YES"
		Stdselect = "YES"
	END IF
	CLOSE Dummy
END FUNCTION

SUB ExitMenu ()
END SUB

FUNCTION Flags () AS STRING
	Title = ShellName + SYS_MSG + Stdselect + STR$(Dummy) + FTL_ERR + STR$(Iteration) + MyName + STR$(UserLoc) + STR$(C.cFC) + STR$(C.cBC) + STR$(STD_ERR) + STR$(ERDEV) + ERDEV$ + STR$(ERR) + ERROR$(STD_ERR) + STR$(SMMode) + Prompt + Title + STR$( _
admLoggedOn) + admTPassword + PROG_VERSION
	Flags = Title + OEM_VERSION_STRING
END FUNCTION

SUB FList ()
	PRINT "ÛÛÛ XOS File List 6.0"
	PRINT
	LINE INPUT "Enter File Specification (*.*, *.EXE, *.TXT...): ", Stdselect
	FILES Stdselect
	PRINT "List of all "; ProfileRead$("c:\xos\xos.xif", "Extensions", RIGHT$(Stdselect, 3))
END SUB

DEFINT A-Z
FUNCTION HandleIt (ErrCode AS INTEGER) AS STRING
	dnlSetINLData "HANDLEIT", 6, LTRIM$(STR$(ErrCode))
	SOUND 493.88, 1
	SOUND 659.26, 1
	SELECT CASE ErrCode
		CASE 5
			HandleIt = "XOS0001 - Bad Parameter"
			FTL_ERR = "NONFTL"
		CASE 6
			HandleIt = "XOS0002 - Parameter Too Large"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Parameter entered is too large for processing."
		CASE 7
			HandleIt = "XOS0003 - Not Enough Memory"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Insufficient memory to execute the requested instruction."
		CASE 11
			HandleIt = "XOS0004 - Cannot Divide By Zero"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Processor does not understand division by zero."
		CASE 24
			HandleIt = "XOS0005 - Problem with Device"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Device cannot be accessed, or device is damaged."
		CASE 25
			HandleIt = "XOS0006 - Problem with Device"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Device cannot be accessed, or device is damaged."
		CASE 27
			HandleIt = "CORE0001 - Printer Out of Paper"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Printer has run out of paper. Put more paper in the printer."
		CASE 51
			HandleIt = "CORE0002 - System Error"
			HText = CHR$(13) + "EXPLANATION:" + CHR$(13) + "Hardware Error. Contact a service professional."
		CASE 52
			HandleIt = "STRUCTURE0001 - Bad Command or File Name"
		CASE 53
			HandleIt = "STRUCTURE0002 - File Not Found"
		CASE 55
			HandleIt = "STRUCTURE0003 - Sharing Violation" + CHR$(13) + "Specified File is being used by another program."
		CASE 57
			HandleIt = "CORE0003 - Device Input/Output Problem"
		CASE 58
			HandleIt = "STRUCTURE0004 - File Already Exists"
		CASE 61
			HandleIt = "STRUCTURE0005 - Specified Disk is Full"
		CASE 64
			HandleIt = "STRUCTURE0001 - Bad Command or File Name"
		CASE 67
			HandleIt = "STRUCTURE0006 - Too Many Files Open"
		CASE 68
			HandleIt = "CORE0004 - Device Not Available"
		CASE 69
			HandleIt = "COMM0001 - Communications Buffer Overflow"
		CASE 70
			HandleIt = "STRUCTURE0007 - Access Denied"
		CASE 71
			HandleIt = "CORE0005 - Disk Not Ready"
		CASE 72
			HandleIt = "CORE0006 - Disk Error"
		CASE 73
			HandleIt = "XOS0007 - Feature Not Installed on this Computer"
		CASE 74
			HandleIt = "STRUCTURE0008 - Can't Rename With a Different Drive"
		CASE 75
			HandleIt = "STRUCTURE0009 - Path or File Access Problem"
		CASE 76
			HandleIt = "STRUCTURE0010 - Path Not Found"
		CASE 260
			HandleIt = "XOS0008 - No System Timer"
		CASE 271
			HandleIt = "CORE0007 - Screen Mode Not Available"
		CASE ELSE
			HandleIt = "UNKNOWN - Unknown Error" + STR$(ErrCode) + " Occured"
	END SELECT
	SYS_MSG = UCASE$(ERROR$(ErrCode))
	STD_ERR = ErrCode
	FTL_ERR = "NON_FATAL"
END FUNCTION

DEFSNG A-Z
SUB Introduction ()

END SUB

SUB KeyInit ()
	KEY 1, "CLS"
END SUB

SUB LockUp ()
	SCREEN 12
	SHELL "DISPLOG"
	LOCATE 30, 24: PRINT "---Press Any Key to Unlock---"
	SLEEP
	SCREEN 0
	CALL SECURITYPLUS
END SUB

SUB MainGrid ()
	ShellName = "Main"
	ON LOCAL ERROR RESUME NEXT
			COLOR 7, 0
			CLS
			COLOR 12: PRINT "ÛÛÛ"; : COLOR 10: PRINT "ÛÛÛ"; : COLOR 1: PRINT "ÛÛÛ"
			COLOR 15, 0
			PRINT
			PRINT
			PRINT "ษอออออออออออออออออออออออออออออออออป"
			PRINT "บ                                 บ"
			PRINT "บ XOS                             บ"
			PRINT "บ Computer Operating Environment  บ"
			PRINT "บ  Version 7.0a                    บ"
			PRINT "บ                                 บ"
			PRINT "บ                                 บ"
			PRINT "บ Copyright (C) 1996, John Willis บ"
			PRINT "บ                                 บ"
			PRINT "ศอออออออออออออออออออออออออออออออออผ"
	SLEEP 3

	DEF SEG = 0
	VIEW PRINT 1 TO 25
	COLOR 0, 2
	Title = "XOS Rel. 7, MAIN     FREE: " + LTRIM$(RTRIM$(FORMAT$(FRE(-1), "###,###")))
	Title = Title + STRING$(80 - LEN(Title), 219)
	LOCATE 1, 1: PRINT Title
	LOCATE 2, 1: COLOR 2, 0: PRINT STRING$(80, 196)
	VIEW PRINT 3 TO 25
	CLS
	COLOR 2, 0
	CLS
MainGrid:
	LINE INPUT "=>", Stdselect

	'Command Processor
	SELECT CASE TrimText(Stdselect)
		CASE "vcore"
		CASE "print"
			PRINT PEEK(&H417) AND &HBF
		SLEEP
		CASE "write"
			PRINT "ÛÛÛ Memory Write Utility"
			PRINT
			PRINT "CAUTION:"
			PRINT "Use only range 3CB0-FFFF."
			PRINT
			LINE INPUT "Address? ", Stdselect
			INPUT "Byte? ", Dummy
			POKE VAL("&H" + Stdselect), Dummy
			


		CASE "clipboard /copy"
			PRINT "ÛÛÛ Clipboard Copy Utility"
			PRINT
			PRINT
			PRINT "Saving SYS_MSG..."
			FTL_ERR = SYS_MSG
			LINE INPUT "Text to Copy? ", SYS_MSG
			PRINT "Copying"; LEN(SYS_MSG); " bytes..."
			FOR Iteration = VAL("&H3CB0") TO LEN(SYS_MSG)
				Stdselect = MID$(SYS_MSG, Iteration, 1)
				Dummy = ASC(Stdselect)
				POKE Iteration, Dummy
			NEXT
			PRINT "Complete."
			CASE "dump"
			PRINT "ÛÛÛ Memory Dump Utility"
			PRINT
			LINE INPUT "Starting Address? ", Stdselect
			LINE INPUT "Ending Address? ", Stdsel$
			CLS
			VIEW PRINT 3 TO 25
			LOCATE 23, 1: PRINT STRING$(80, 196)
			LOCATE 24, 1: PRINT "Dumping "; TrimText(STR$(VAL("&H" + Stdsel$) - VAL("&H" + Stdselect))); " bytes"
			VIEW PRINT 3 TO 22
			FOR Iteration = VAL("&H" + Stdselect) TO VAL("&H" + Stdsel$)
				PRINT "Address: "; HEX$(Iteration)
				PRINT "Byte   : "; PEEK(Iteration)
				IF NOT PEEK(Iteration) = 7 THEN
					PRINT "Char.  : "; CHR$(PEEK(Iteration))
				END IF
				PRINT
			NEXT Iteration
				VIEW PRINT 3 TO 25
				LOCATE 23, 1: PRINT STRING$(80, 196)
				LOCATE 24, 1: PRINT "COMPLETE.    Press ENTER to Continue..."
				VIEW PRINT 3 TO 22
			SLEEP
			CASE "central"
			CALL Navigate
		CASE "smrtcmd"
			CALL SmartCommand
		CASE "?"
			PRINT "Main Grid Help"
		CASE "vdf"
			CLS
			PRINT "ÛÛÛ VDF 4.0"
			PRINT
			PRINT "Command:"
			LINE INPUT "=>", Stdselect
				
			'Command Processor
			SELECT CASE TrimText(Stdselect)
				CASE "load"
					LINE INPUT "Input VDF Name: ", Stdselect
					SHELL Stdselect + "/INIT"
					PRINT "VDF "; UCASE$(Stdselect); " Initialized"
				CASE "vdfinfo"
					LINE INPUT "Input VDF Name: ", Stdselect
					SHELL Stdselect + "/VDFINFO"
				CASE "about"
				   
			END SELECT
		CASE "rs"
			PRINT "Session Time:  "; INT(TIMER - StartTime); "Seconds."
			CALL CapsOff
			SLEEP 2
			COLOR 7, 0
			DEF SEG
			SCREEN 0
			WIDTH 80, 25
			KEY OFF
			VIEW PRINT 1 TO 25
			CLOSE
			CLS
			END
		CASE "cs"
			CLS
	END SELECT
GOTO MainGrid
END SUB

SUB MemCheck ()
	'CALL INTERRUPT(&H12, regs, regs)
	Mem.Conv = regs.ax
	regs.ax = &H88
	'CALL INTERRUPT(&H15, regs, regs)
	Mem.XMS = regs.ax
	CALL ChangeColors(15, 0)
	FOR Iteration = 1 TO Mem.Conv
		CALL XPrint("Scanning Conventional Memory...", 3, 1)
		CALL XPrint(TrimText(STR$(INT(Iteration))) + " KB OK", 5, 1)
		'Dummy = PEEK(Iteration)
		CALL XPrint("Press ESC to abort Memory Test.", 7, 1)
		IF INKEY$ = CHR$(27) THEN
			EXIT SUB
		END IF
	NEXT Iteration
END SUB

SUB mov (register AS STRING, value AS INTEGER)
SELECT CASE register
CASE "ax"
regs.ax = value
END SELECT

END SUB

SUB Navigate ()
	ShellName = "XOS Central"
	CALL ChangeColors(15, 1)
	KEY OFF
			COLOR 7, 0
			CLS
			COLOR 12: PRINT "ÛÛÛ"; : COLOR 10: PRINT "ÛÛÛ"; : COLOR 1: PRINT "ÛÛÛ"
			COLOR 15, 0
			PRINT
			PRINT
			PRINT "ษอออออออออออออออออออออออออออออออออป"
			PRINT "บ                                 บ"
			PRINT "บ XOS Central                     บ"
			PRINT "บ Computer Navigation System      บ"
			PRINT "บ  Version 2.0 for XOS 7.0a       บ"
			PRINT "บ                                 บ"
			PRINT "บ                                 บ"
			PRINT "บ Copyright (C) 1996, John Willis บ"
			PRINT "บ                                 บ"
			PRINT "ศอออออออออออออออออออออออออออออออออผ"
	SLEEP 3
NavMenu:
	VIEW PRINT 1 TO 25
	
	Title = ""
	Title = "XOS Version 7.0a                  XOS Central                    " + CHR$(254) + " " + MyName + STRING$(80 - LEN(Title) - LEN("Version 1.12"), 255)
	LOCATE 1, 1: COLOR 0, 7: PRINT Title
	' CHR$(254); " "; MyName
	VIEW PRINT 2 TO 24
	
	CALL ChangeColors(C.cFC, C.cBC)
	CLS
	PRINT
	PRINT
	PRINT
	PRINT
	PRINT "     ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
	PRINT "     บÛÛÛ XOS Central                                                    บ"
	PRINT "     ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน"
	PRINT "     บ    1.   SmartCommand    2.  Main             3.  DOS Full Screen  บ"
	PRINT "     บ    4.   XOS 6 Setup     5.  eXTERM           6.  Printer          บ"
	PRINT "     บ    7.   Text Viewer     8.  Picture Viewer   9.  Your Programs    บ"
	PRINT "     บ    10.  Lock Up         11. Shut Down        12. Help             บ"
	PRINT "     ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
	PRINT
	INPUT "                             Enter Your Choice: ", Nav%
	PRINT
	PRINT
	COLOR C.cFC, C.cBC
	PRINT "     "; : COLOR 15, 12: PRINT "ษออออออออออออออออออออป": COLOR C.cFC, C.cBC
	PRINT "     "; : COLOR 15, 12: PRINT "บÛÛÛ Accessing...    บ": COLOR C.cFC, C.cBC
	PRINT "     "; : COLOR 15, 12: PRINT "ศออออออออออออออออออออผ": COLOR C.cFC, C.cBC
	COLOR 15, 1
	SLEEP 1
	SELECT CASE Nav%
		CASE 9
			CALL YourPrograms
		CASE 500 'Undocumented return to VCore
			EXIT SUB
		CASE 1
			CALL SmartCommand
		CASE 2
			CALL MainGrid
		CASE 3
			VIEW PRINT 1 TO 25
			CALL ClearScreen
			CALL ShellToDOS
		CASE 4
			CALL XSetup
		CASE 5
			CALL xtInit
			CALL lpCommLoop
		CASE 6
			CALL PrintMan
		CASE 11
			CALL ShutDown
		CASE 10
			CALL LockUp
		CASE 7
			CLS
			LINE INPUT "File Name? ", Stdselect
			'CALL ViewerInit(Stdselect)
		CASE 32767
			COLOR 7, 0
			CLS
			CALL About
			PRINT "---More---"
			SLEEP
			PRINT
			COLOR 12: PRINT "ÛÛÛ"; : COLOR 10: PRINT "ÛÛÛ"; : COLOR 1: PRINT "ÛÛÛ"
			COLOR 7, 0
			PRINT
			PRINT
			PRINT "ษออออออออAbout XOS Centralออออออออป"
			PRINT "บ                                 บ"
			PRINT "บ XOS Central                     บ"
			PRINT "บ Computer Navigation System      บ"
			PRINT "บ  Version 1.12 for XOS 7.0a      บ"
			PRINT "บ                                 บ"
			PRINT "บ                                 บ"
			PRINT "บ Copyright (C) 1995, John Willis บ"
			PRINT "บ                                 บ"
			PRINT "ศอออออออออออออออออออออออออออออออออผ"
			PRINT
			PRINT
			PRINT "- Color Monitor"
			PRINT "-"; INT(FRE(-1) / 1000); "K Free Memory"
			PRINT
			PRINT
			PRINT
			PRINT "Press ESC to Continue..."
			SLEEP
	END SELECT
GOTO NavMenu
END SUB

SUB NewSys ()
	COLOR 7, 0
	CLS
GOTO NoLogo
	SCREEN 12
	COLOR 12
	CLS
	LOCATE 1, 1
	PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
	PRINT "บ XOS Rel. 6.0, Rev. A                                         บ"
	PRINT "บ                                                              บ"
	PRINT "บ eXtended Operating System 7.0a is exclusive property of the  บ"
	PRINT "บ WillisWare division of John Willis Graphics & Design.        บ"
	PRINT "บ All rights under U.S. Copyright laws are reserved.           บ"
	PRINT "บ                                               Distributed by บ"
	PRINT "บ John Willis Graphics & Design. Unauthorized distribution and บ"
	PRINT "บ reproduction of this program is strictly prohibited.         บ"
	PRINT "บ                                                              บ"
	PRINT "บ Copyright (C) 1986, 1995  John Willis                        บ"
	PRINT "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
	SLEEP 5
	SCREEN 0
	COLOR 7, 0
	CLS
NoLogo:
	ON LOCAL ERROR RESUME NEXT
	CHDRIVE "C"
	Dummy = FREEFILE
	OPEN "SET_GH.ZST" FOR INPUT AS Dummy
	CLOSE Dummy
	PRINT "Please Wait..."
	SLEEP 3
	LOCATE 1, 1
	PRINT UCASE$(OEM_VERSION_STRING)
	'FOR Iteration = 1 TO 20
	'    SOUND 900, 1
	'    SOUND 32767, 2
	'NEXT Iteration
	'SOUND 37, 20
	VIEW PRINT 23 TO 25
NSys:
	LOCATE 25, 1: LINE INPUT "System Ready ", CommandName

	'Command Processor
	SELECT CASE TrimText(CommandName)
		CASE "boot"
			CLS
			LOCATE 25, 1: PRINT "Initializing Boot Sequence on drive "; LEFT$(UCASE$(CURDIR$), 1); "..."
			SLEEP 2
			CLS
			LOCATE 25, 1: PRINT "Shutting Down System..."
			CLOSE
			CALL setInit
			CALL admInit
			SLEEP 5
			VIEW PRINT 1 TO 25
			CLOSE SFile
			OPEN "\SHUTDOWN.DAT" FOR RANDOM AS SFile LEN = LEN(SS1)
			SS1.ShutDownSuccessful = "YES"
			PUT SFile, 1, SS1
			CALL ErrorStart
			EXIT SUB
		CASE "flags"
			VIEW PRINT 1 TO 25
			CLS
			PRINT "System Flag Status:"
			PRINT
			PRINT "SHELLNAME       = "; ShellName
			PRINT "SYS_MSG         = "; SYS_MSG
			PRINT "STDSELECT       = "; Stdselect
			PRINT "DUMMY           ="; Dummy
			PRINT "FTL_ERR         = "; FTL_ERR
			PRINT "ITERATION       ="; Iteration
			PRINT "MYNAME          = "; MyName
			PRINT "USERLOC         ="; UserLoc
			PRINT "C.cFC           ="; C.cFC
			PRINT "C.cBC           ="; C.cBC
			PRINT "---More---"
			SLEEP
			PRINT "STD_ERR         ="; STD_ERR
			PRINT "ERDEV           ="; ERDEV
			PRINT "ERDEV_STR       = "; ERDEV$
			PRINT "ERR             ="; ERR
			PRINT "ERR_STR         = "; ERROR$(STD_ERR)
			PRINT "SETFNUM         ="; setFNum
			PRINT "STARTTIME       ="; StartTime
			PRINT "DELFILENUM      ="; DelFileNum
			PRINT "SMMODE          ="; SMMode
			PRINT "PROMPT          = "; Prompt
			PRINT "TITLE           = "; Title
			PRINT "ADMLOGGEDON     ="; admLoggedOn
			PRINT "ADMTPASSWORD    = "; admTPassword
			PRINT "COMMANDNAME     = "; CommandName
			PRINT "---More---"
			SLEEP
			PRINT "UID Structure:"
			PRINT "DEL.FNAME       = "; Del.FName
			PRINT "DEL.FLOC        = "; Del.FLoc
			PRINT "DEL.FSIZE       ="; Del.FSize
			PRINT "---More---"
			SLEEP
			PRINT "ADM Structure:"
			PRINT "ADMFILE.ADMPASSWORD   = "; WEncrypt(admFile.admPassword)
			PRINT "ADMFILE.MAXRETRIES    ="; admFile.MaxRetries
			PRINT "ADMFILE.ADMREQUSER    ="; admFile.admReqUser
			PRINT "ADMFILE.MAXCOPIES     ="; admFille.MaxCopies
			PRINT "PROG_VERSION          = "; PROG_VERSION
			PRINT "OEM_VERSION_STRING    = "; OEM_VERSION_STRING
			VIEW PRINT 1 TO 23
		CASE "enctest"
			VIEW PRINT 1 TO 25
			CLS
			PRINT "Encryption Test:"
			LINE INPUT "File Name? ", Stdselect
			Dummy = FREEFILE
			OPEN Stdselect FOR INPUT AS #Dummy
			SYS_MSG = INPUT$(LOF(Dummy), Dummy)
			PRINT "Encrypting..."
			PRINT WEncrypt(SYS_MSG)
			PRINT "Decrypting..."
			PRINT WDecrypt(SYS_MSG)
			VIEW PRINT 3 TO 25
		CASE "stopwatch"
			VIEW PRINT 1 TO 25
			CLS
			LOCATE 1, 1: COLOR 0, 2: PRINT "StopWatch v1.00    Press ESC to Continue"; : COLOR 2, 0
			LOCATE 2, 1: PRINT STRING$(80, 196)
			StartT& = CLNG(TIMER)
			VIEW PRINT 3 TO 25
			DO
				COLOR 0, 2: LOCATE 4, 1: PRINT "Seconds Elapsed:  "; TrimText(STR$(INT(TIMER - StartT&))); " "; : COLOR 2, 0
			LOOP UNTIL INKEY$ = CHR$(27)
			VIEW PRINT 23 TO 25
			COLOR 7, 0
			CLS
		CASE "exit"
			PRINT "Closing XOS 7.0a..."
			SLEEP 4
			END

		'
		'More commands to be added later
		'
	END SELECT
GOTO NSys
END SUB

SUB OpenFile (FileName AS STRING, FileNum AS INTEGER)
	IF NOT FileNum > 14 THEN
		OPEN FileName FOR RANDOM AS #FileNum
	ELSE
		PRINT "Fatal Error:"
		PRINT "FATAL0001 - File Cannot Be Accessed"; CHR$(13); "            Further attempts at opening files will fail."
	END IF
END SUB

SUB Pause ()
	PRINT "Press any key to continue."
	SLEEP
END SUB

SUB PromptChange ()
	PRINT "ษอออออออออออออออออออออออออออป"
	PRINT "บÛÛÛ Prompt                 บ"
	PRINT "ฬอออออออออออออออออออออออออออน"
	PRINT "บ  1.  Default Prompt       บ"
	PRINT "บ                           บ"
	PRINT "บ  2.  Custom Prompt        บ"
	PRINT "บ                           บ"
	PRINT "บ                           บ"
	PRINT "บ  3.  Previous Menu        บ"
	PRINT "ศอออออออออออออออออออออออออออผ"
	INPUT "Enter Your Choice: ", Dummy

	'Menu Processor
	SELECT CASE Dummy
		CASE 1
			Prompt = "System Ready."
		CASE 2
			CALL CustomPrompt
		CASE 3
			EXIT SUB
	END SELECT
END SUB

SUB ReadXIF ()

END SUB

SUB RunAfterShell ()
	VIEW PRINT 1 TO 25
	COLOR 7, 0
	CLS
	PRINT "Please Wait..."
	'CALL drvLoadDrivers
	CALL ClearPR
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "FirstStatement", "SUCCESS")
	ON ERROR RESUME NEXT
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CoreEHLoad", "SUCCESS")
	SCREEN 12
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "Logo", "SUCCESS")
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "InitAppDir")
	CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeServerApp", "LINK_CLOSED")
	CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeClientApp", "LINK_CLOSED")
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "XMS", "SUCCESS")
	regs.ax = &H1
	regs.dx = &HFFFF
	'CALL INTERRUPT(&H2F, regs, regs)
	IF NOT regs.ax = &H1 THEN
		CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "XMS", "FAILED")
		PRINT "Failed."
		PRINT "Program will load into conventional memory."
		PRINT
		PRINT "Press ESC"
		SLEEP
	END IF
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CParmProc", "SUCCESS")
	SELECT CASE TrimText(COMMAND$)
		CASE "/bypass_shutdown_success"
			Bypass = "yes"
	END SELECT
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "AlwaysBypassShutdownSuccess")
	IF Stdselect = "YES" THEN
		Bypass = "yes"
	END IF
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "SBMidInitToStartTime", "SUCCESS")
	StartTime = TIMER
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "CURUSERInitToMyName", "SUCCESS")
	MyName = "NEW SESSION"
	ON LOCAL ERROR RESUME NEXT
	SFile = FREEFILE
	OPEN "C:\SHUTDOWN.DAT" FOR RANDOM AS SFile LEN = LEN(SS1)
	GET SFile, 1, SS1
'Code for shutdown success check bypass ONLY.
BPass:
	'I may want some bypass processing code here later.
BNorm:
		Stdselect = ProfileRead$("c:\xos\xos.xif", "XOS", "APMEnabled")
		IF Stdselect = "TRUE" THEN
			Con.APM = "TRUE"
			regs.ax = &H5308
			regs.bx = &HFFFF
			regs.cx = &H1
			'CALL INTERRUPT(&H15, regs, regs)
		ELSE
			Con.APM = "FALSE"
			regs.ax = &H5308
			regs.bx = &HFFFF
			regs.cx = &H0
			'CALL INTERRUPT(&H15, regs, regs)
		END IF
		SS1.ShutDownSuccessful = "NO"
		PUT SFile, 1, SS1
	ON LOCAL ERROR RESUME NEXT
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "InitAppDir")
	CHDIR Stdselect
	DelFileNum = FREEFILE

	'Initialize Incinerator
		DelDir$ = UCASE$(ProfileRead$("\XOS\XOS.XIF", "Incinerator", "IncinDir"))
		OPEN "\" + DelDir$ + "\UDDATA_1.UID" FOR RANDOM AS DelFileNum LEN = LEN(Del)
	'End of incinerator initialization

	SMMode = 80
	CALL admInit
	CALL setInit
	CALL STErrCheck
	CALL StartUp
	'CALL lkInit
	
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Devices", "DisplayDriver")
	SYS_MSG = ProfileRead$("c:\xos\xos.xif", "Devices", "DispOptions")
	SHELL Stdselect + SYS_MSG
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "PCalls", "SUCCESS")
	CALL PrinterInit
	CALL MemCheck
	CALL ScreenInit(0, 15, 1)
	CALL KeyInit
	CALL CapsOn
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "ARun", "SUCCESS")
	Stdselect = ProfileRead$("c:\xos\xos.xif", "AutoRun", "run")
	IF NOT LEN(Stdselect) < 1 THEN
		SHELL Stdselect
	END IF
	CALL ProfileWrite("c:\xos\xos.xif", "ProgLoad", "ShellSelect", "SUCCESS")
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "DefShell")
	SELECT CASE Stdselect
		CASE "$CENTRAL"
			C.cFC = 15
			C.cBC = 1
			CALL Navigate
		CASE "$MGRID"
			CALL MainGrid
		CASE "$SCMD"
			CALL SmartCommand
			C.cFC = 15
			C.cBC = 1
			CALL Navigate
			END
		CASE "$RUNS2"
			SYS_MSG = ProfileRead$("c:\xos\xos.xif", "Boot", "runShell")
			SHELL SYS_MSG
	END SELECT
 'End of procedure calls

END SUB

'
' RunExtXOSProc API
'  Runs an external XOS Program.
'  ProgID is the DynaLink name of the program
'  The EXE name is stored in the [DynaLink] section of XOS.XIF
'
' This routine will use the ProgID parameter in a decision structure
' to find out what program the user is attempting to run.
'
' If the user attempts to run the program, but the program
' does not return the value of the ProgID parameter in the
' key xdeClientApp= in DYNALINK.XDE, XOS will cancel the DynaLink
' once the client application has terminated.
'
' DynaLink is simply an extension to command line parameters.
'
SUB RunExtXOSProc (ProgID AS STRING)

END SUB

'
' RunProgram API
'  uses VC386 to load a program and reloads XOS if
'  ReloadServer=reload_server
'
SUB RunProgram (EXEName AS STRING, ServerID AS STRING, ReloadServer AS STRING)
	CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeStrData", TrimText(EXEName))
	CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeCommand", ReloadServer)
	'Set up the condition to return directly to CENTRAL.
	CALL ProfileWrite("c:\xos\xos.xif", "Boot", "DynaLinkRun", "TRUE")
	END 'XOS will be reloaded
END SUB

SUB ScreenInit (ScreenMode AS INTEGER, FColor AS INTEGER, BColor AS INTEGER)
	SCREEN ScreenMode
	COLOR FColor, BColor
	CLS
	KEY ON
END SUB

SUB SECURITYPLUS ()
C.cFC = 15
C.cBC = 1
EXIT SUB
ON LOCAL ERROR RESUME NEXT
STATIC Retries AS INTEGER
STATIC numUsers AS INTEGER
STD_ERR = admFile.MaxRetries
			KEY OFF
			COLOR 7, 0
			CLS
			COLOR 12: PRINT "ÛÛÛ"; : COLOR 10: PRINT "ÛÛÛ"; : COLOR 1: PRINT "ÛÛÛ"
			COLOR 15, 0
			PRINT
			PRINT
			PRINT "ษออออออออออออออออออออออออออออออออออออป"
			PRINT "บ    WillisWare General Software     บ"
			PRINT "บ                                    บ"
			PRINT "บ Security+                          บ"
			PRINT "บ Computer Security System           บ"
			PRINT "บ  Version 5.21 for XOS 7.0a         บ"
			PRINT "บ                                    บ"
			PRINT "บ                                    บ"
			PRINT "บ Copyright (C) 1986, 1995 J. Willis บ"
			PRINT "บ                                    บ"
			PRINT "ศออออออออออออออออออออออออออออออออออออผ"
	SLEEP 3
Retry:
STD_ERR = admFile.MaxRetries
IF Retries > STD_ERR THEN
	CLS
	PRINT "Password retry limit exceeded."
	PRINT "Access Denied, program terminating."
	PRINT
	PRINT
	PRINT "Press any key to continue..."
	SLEEP
	END
END IF
	VIEW PRINT 1 TO 25
	Title = ""
	Title = "XOS Version 7.0a                    Security+" + STRING$(80 - LEN(Title) - LEN("Version 1.12"), 255)
	LOCATE 1, 1: COLOR 0, 7: PRINT Title
	VIEW PRINT 2 TO 25
	CALL ChangeColors(15, 1)
	CLS
	PRINT "Date         :  "; CurDate
	PRINT "Time         :  "; FORMAT$(NOW, "h:mm AM/PM")
	PRINT "Retry Limit  :  "; LTRIM$(STR$(STD_ERR))
	PRINT "Current Retry:  "; LTRIM$(STR$(Retries))
	PRINT "Current User :  "; UCASE$(MyName)
	PRINT "Total Users  : "; LOF(15) / LEN(Setup) + 1
	PRINT
	LINE INPUT "Enter User Name: ", Stdselect
	IF TrimText(Stdselect) = "administrator" THEN
		MyName = "ADMIN000"
		admLoggedOn = TRUE
		LINE INPUT "Administrative Password? ", Stdselect
		IF NOT TrimText(Stdselect) = TrimText(admTPassword) THEN
			CLS
			PRINT "Administrator Password Invalid."
			PRINT "Access Denied."
			PRINT
			PRINT
			PRINT "Press ESC to continue..."
			SLEEP
			Retries = Retries + 1
			GOTO Retry
		END IF
		CLS
		admLoggedOn = TRUE
		INPUT "Foreground Color? ", C.cFC
		INPUT "Background Color? ", C.cBC
		PRINT "Current User Database:"
		PRINT
		PRINT TAB(5); "USER NAME:      PASSWORD:"
		DO WHILE NOT EOF(setFNum)
			GET #setFNum, , Setup
			IF NOT TrimText(Setup.Username) = "*del*" THEN
				PRINT TAB(5); TrimText(Setup.Username); "    "; TrimText(WDecrypt(Setup.Password))
				Dummy = Dummy + 1
			ELSE
				Dummy = Dummy - 1
			END IF
		LOOP
		PRINT
		PRINT TAB(2); "TOTAL USERS: "; TrimText(STR$(Dummy - 2))
		PRINT
		PRINT
		PRINT "Press ESC to Continue..."
		SLEEP
		EXIT SUB
	END IF
	'Verify User...
	FOR Iteration = 1 TO LOF(15) / LEN(Setup)

		GET #15, Iteration, Setup

		IF TrimText(LEFT$(TrimText(Stdselect), 11)) = TrimText(Setup.Username) THEN
			UserLoc = Iteration
			LINE INPUT "Enter Password : ", SYS_MSG
				IF NOT TrimText(SYS_MSG) = TrimText(WDecrypt(Setup.Password)) THEN
					Retries = Retries + 1
					PRINT "Access Denied."
					PRINT
					PRINT
					PRINT "Press ESC to continue..."
					SLEEP
					GOTO Retry
				ELSE
					MyName = UCASE$(Setup.Username)
					admLoggedOn = FALSE
					C.cFC = Setup.FC
					C.cBC = Setup.BC
					CLS
					PRINT "Welcome, "; UCASE$(TrimText(Setup.Username)); "!"
					PRINT
					PRINT "Security+ Access Information:"
					PRINT " Login Status    :  Accepted"
					PRINT " User Number     :  "; LTRIM$(STR$(UserLoc))
					PRINT " Login Time      :  "; FORMAT$(NOW, "h:mm AM/PM")
					PRINT
					PRINT "User's Colors:"
					PRINT " Foreground Color: "; C.cFC
					PRINT " Background Color: "; C.cBC
					PRINT
					PRINT
					PRINT "Press ESC to continue..."
					SLEEP
					CLS
					PRINT "Security+ Verification Complete!"
					EXIT SUB
				END IF
		ELSE
			numUsers = numUsers + 1
		END IF

	NEXT Iteration
				PRINT "User does not exist."
				PRINT "Access Denied."
				PRINT
				PRINT "Press ESC to continue..."
				Retries = Retries + 1
				SLEEP
				GOTO Retry
END SUB

SUB setInit ()
	setFNum = 15
	OPEN "XSYSTEM.XXP" FOR RANDOM AS setFNum LEN = LEN(Setup)
END SUB

SUB ShutDown ()
	CLS
	PRINT "ษออออออออออออออออออป"
	PRINT "บÛÛÛ Shut Down     บ"
	PRINT "ฬออออออออออออออออออน"
	PRINT "บ 1. Shut Down     บ"
	PRINT "บ                  บ"
	PRINT "บ 2. Exit          บ"
	PRINT "บ                  บ"
	PRINT "บ 3. Switch Users  บ"
	PRINT "บ                  บ"
	PRINT "บ 4. VCore Shell   บ"
	PRINT "ศออออออออออออออออออผ"
	INPUT "=> ", Dummy
	SELECT CASE Dummy
		CASE 1
			SCREEN 12
			SS1.ShutDownSuccessful = "YES"
			PUT SFile, 1, SS1
			CALL EndXOS
		CASE 2
			CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeCommand", "terminate_server")
			CALL ProfileWrite("C:\XOS\XOS.XIF", "Boot", "DynaLinkRun", "FALSE")
			END
		CASE 3
			CALL SECURITYPLUS
		CASE 4
			CALL ProfileWrite("\XOS\DYNALINK.XDE", "DataExchange", "xdeCommand", "rintproc_mainenv")
			END
		CASE 5
			EXIT SUB
	END SELECT
END SUB

SUB SmartCommand ()


'Error Handler Initialization
	ON LOCAL ERROR GOTO ErrorHandler
	
	KEY(16) ON
	
	Prompt = "System Ready."
	CALL ClearScreen

'Title Bar
	WIDTH SMMode
StartUp:
			COLOR 7, 0
			CLS
			COLOR 12: PRINT "ÛÛÛ"; : COLOR 10: PRINT "ÛÛÛ"; : COLOR 1: PRINT "ÛÛÛ"
			COLOR 15, 0
			PRINT
			PRINT
			PRINT "ษอออออออออออออออออออออออออออออออออป"
			PRINT "บ                                 บ"
			PRINT "บ XOS SmartCommand                บ"
			PRINT "บ Command Prompt System           บ"
			PRINT "บ  Version 4.1 for XOS 7.0a       บ"
			PRINT "บ                                 บ"
			PRINT "บ                                 บ"
			PRINT "บ Copyright (C) 1995, John Willis บ"
			PRINT "บ                                 บ"
			PRINT "ศอออออออออออออออออออออออออออออออออผ"
			SLEEP 2
	KEY 3, ProfileRead$("c:\xos\xos.xif", "SmartCommand", "LastKey") + CHR$(13)
	KEY ON
	VIEW PRINT 1 TO 24
	Title$ = ""
	Title$ = "XOS Version 7.0a       SmartCommand 4 User Shell        EXIT = " + ShellName + STRING$(80 - LEN(Title$), 255)
	LOCATE 1, 1: COLOR 0, 7: PRINT Title$
	VIEW PRINT 2 TO 24
		CALL ChangeColors(C.cFC, C.cBC)
	PRINT "RAM Summary:"
	PRINT TrimText(STR$(Mem.Conv)); " KB Conventional"
	IF RTRIM$(Con.APM) = "TRUE" THEN
		PRINT "Advanced Power Management Enabled."
	ELSE
		PRINT "Advanced Power Management Disabled."
	END IF

'Command Line
CommandLine:
	
	PRINT "ÛÛÛ SmartCommand 4.1  "; UCASE$(CURDIR$); " "; DATE$; " "; FORMAT$(NOW, "h:mm AM/PM")
	PRINT Prompt;
	LINE INPUT " ", CommandName
	CALL CommandSound
	IF NOT TrimText(CommandName) = "exit" THEN
		KEY 3, UCASE$(CommandName) + CHR$(13)
		CALL ProfileWrite("c:\xos\xos.xif", "SmartCommand", "LastKey", UCASE$(CommandName) + CHR$(13))
	END IF
	'Bypass for command
CommandLineBypass:

	'Command Processor
	SELECT CASE TrimText(CommandName)
		CASE "winrun"
			LINE INPUT "Windows Application? ", Stdselect
			'dnlSetINLData "MAINLINK", 1, DNL_SHELLWINAPP
			dnlSetINLData "MAINLINK", 2, Stdselect
			dnlSetActiveINL "MAINLINK"
		CASE "cwclip"
			PRINT "Windows Clipboard:"
			PRINT szGetWinClipboard
			LINE INPUT "Copy Windows clipboard to? ", Stdselect
			Dummy = FREEFILE
			OPEN Stdselect FOR OUTPUT AS Dummy
			PRINT #Dummy, szGetWinClipboard
			CLOSE Dummy
		CASE "graphics"
		PRINT "ÛÛÛ VDF 386 Version 5.21"
		PRINT
		LINE INPUT "Switch to Graphics Mode? ", Stdselect
		IF TrimText(Stdselect) = "y" THEN
			Dummy = VAL(ProfileRead$("c:\xos\xos.xif", "Devices", "DispValue"))
			SCREEN Dummy
		END IF
		CASE "video"
			PRINT "Video Information:"
			PRINT
			PRINT "Resolution : "; ProfileRead$("c:\xos\xos.xif", "Devices", "resHoriz"); "x"; ProfileRead$("c:\xos\xos.xif", "Devices", "resVert")
			PRINT "Colors     : "; ProfileRead$("c:\xos\xos.xif", "Devices", "Colors")
			PRINT "Mode #     : "; ProfileRead$("c:\xos\xos.xif", "Devices", "DispValue")
			PRINT "Driver     : "; ProfileRead$("c:\xos\xos.xif", "Devices", "DisplayDriver")
			PRINT "Parameters : "; ProfileRead$("c:\xos\xos.xif", "Devices", "DispOptions")
			PRINT "Text Driver: "; ProfileRead$("c:\xos\xos.xif", "Devices", "TextDriver")
		CASE "run"
			LINE INPUT "Program Name? ", Stdselect
			CALL RunProgram(Stdselect, "XOS6", "reload_server")
		CASE "suspend"
			IF RTRIM$(Con.APM) = "TRUE" THEN
				DO
				FOR Iteration = 1 TO 2
					regs.ax = &H5307
					regs.bx = &H1
					regs.cx = &H2
					CALL INTERRUPT(&H15, regs, regs)
				NEXT Iteration
				LOOP UNTIL INKEY$ <> ""
			ELSE
				PRINT "APM Unavailible."
			END IF
		CASE "standby"
			IF RTRIM$(Con.APM) = "TRUE" THEN
				regs.ax = &H5307
				regs.bx = &H1
				regs.cx = &H1
				CALL INTERRUPT(&H15, regs, regs)
			ELSE
				PRINT "APM Unavailible."
			END IF
		CASE "user"
			CLS
			PRINT "Security+"
			PRINT "User Info:"
			PRINT
			PRINT "Administrator Logged On: ";
			SELECT CASE admLoggedOn
				CASE TRUE
					PRINT "Yes"
				CASE FALSE
					PRINT "No"
			END SELECT
			PRINT "User Name              : "; MyName
			PRINT
		CASE "xifread"
			LINE INPUT "XIF Name? ", Stdselect
			LINE INPUT "Section?  ", Section$
			LINE INPUT "Key?      ", Key$
			SYS_MSG = ProfileRead$(Stdselect, Section$, Key$)
			PRINT Key$; "="; SYS_MSG
		CASE "about"
			CALL About
		CASE "sys_access_validate /a:adm /stc"
			PRINT "SYS_ACCESS_VALIDATE:"
			PRINT
			PRINT "ACCESS = ADM"
			PRINT "COLOR  = STC"
			PRINT "SYS_MSG= "; SYS_MSG
			PRINT "STD_ERR="; STD_ERR
			PRINT "FTL_ERR= "; FTL_ERR
			PRINT "C.cFC  ="; C.cFC
			PRINT "C.cBC  ="; C.cBC
			SYS_MSG = "PRESS ANY KEY TO CONTINUE"
			PRINT SYS_MSG
			SLEEP
			admLoggedOn = TRUE
			C.cFC = 15: C.cBC = 1
			CLS
		CASE "sys_access_validate /a:user /stc"
			PRINT "SYS_ACCESS_VALIDATE:"
			PRINT
			PRINT "ACCESS = USER"
			PRINT "COLOR  = STC"
			PRINT "SYS_MSG= "; SYS_MSG
			PRINT "STD_ERR="; STD_ERR
			PRINT "FTL_ERR= "; FTL_ERR
			PRINT "C.cFC  ="; C.cFC
			PRINT "C.cBC  ="; C.cBC
			SYS_MSG = "PRESS ANY KEY TO CONTINUE"
			PRINT SYS_MSG
			SLEEP
			admLoggedOn = FALSE
			C.cFC = 15: C.cBC = 1
			CLS
		CASE ":"
			PRINT "Change Drives 7.0a"
			PRINT
			PRINT "Current Drive: "; LEFT$(CURDIR$, 1); ":"
			LINE INPUT "Drive Letter? ", Stdselect
			CHDRIVE Stdselect
		CASE "flags"
			CLS
			PRINT "System Flag Status:"
			PRINT
			PRINT "SHELLNAME       = "; ShellName
			PRINT "SYS_MSG         = "; SYS_MSG
			PRINT "STDSELECT       = "; Stdselect
			PRINT "DUMMY           ="; Dummy
			PRINT "FTL_ERR         = "; FTL_ERR
			PRINT "ITERATION       ="; Iteration
			PRINT "MYNAME          = "; MyName
			PRINT "USERLOC         ="; UserLoc
			PRINT "C.cFC           ="; C.cFC
			PRINT "C.cBC           ="; C.cBC
			PRINT "---More---"
			SLEEP
			PRINT "STD_ERR         ="; STD_ERR
			PRINT "ERDEV           ="; ERDEV
			PRINT "ERDEV_STR       = "; ERDEV$
			PRINT "ERR             ="; ERR
			PRINT "ERR_STR         = "; ERROR$(STD_ERR)
			PRINT "SETFNUM         ="; setFNum
			PRINT "STARTTIME       ="; StartTime
			PRINT "DELFILENUM      ="; DelFileNum
			PRINT "SMMODE          ="; SMMode
			PRINT "PROMPT          = "; Prompt
			PRINT "TITLE           = "; Title
			PRINT "ADMLOGGEDON     ="; admLoggedOn
			PRINT "ADMTPASSWORD    = "; admTPassword
			PRINT "COMMANDNAME     = "; CommandName
			PRINT "---More---"
			SLEEP
			PRINT "UID Structure:"
			PRINT "DEL.FNAME       = "; Del.FName
			PRINT "DEL.FLOC        = "; Del.FLoc
			PRINT "DEL.FSIZE       ="; Del.FSize
			PRINT "---More---"
			SLEEP
			PRINT "ADM Structure:"
			PRINT "ADMFILE.ADMPASSWORD   = "; WEncrypt(admFile.admPassword)
			PRINT "ADMFILE.MAXRETRIES    ="; admFile.MaxRetries
			PRINT "ADMFILE.ADMREQUSER    ="; admFile.admReqUser
			PRINT "ADMFILE.MAXCOPIES     ="; admFille.MaxCopies
			PRINT "PROG_VERSION          = "; PROG_VERSION
			PRINT "OEM_VERSION_STRING    = "; OEM_VERSION_STRING
			PRINT "COM1                  = "; ProfileRead$("c:\xos\xos.xif", "Ports", "COM1")
			PRINT "COM2                  = "; ProfileRead$("c:\xos\xos.xif", "Ports", "COM2")
			PRINT "LPT1                  = "; ProfileRead$("c:\xos\xos.xif", "Ports", "LPT1")
			
			CASE "cls"
			CALL ClearScreen
		CASE "restart"
			PRINT "ษอออออออออออออออออออออออออป"
			PRINT "บÛÛÛ Restart Menu         บ"
			PRINT "ฬอออออออออออออออออออออออออน"
			PRINT "บ                         บ"
			PRINT "บ 1. Restart SmartCommand บ"
			PRINT "บ                         บ"
			PRINT "บ 2. Restart XOS          บ"
			PRINT "บ                         บ"
			PRINT "บ 3. Restart Computer     บ"
			PRINT "บ                         บ"
			PRINT "บ 4. Cancel               บ"
			PRINT "ศอออออออออออออออออออออออออผ"
			INPUT "=> ", Dummy
			SELECT CASE Dummy
				CASE 1
					GOTO StartUp
				CASE 2
					CALL ErrorStart
					EXIT SUB
			END SELECT
		CASE "exit"
			KEY OFF
			VIEW PRINT 1 TO 25
			WIDTH 80
			EXIT SUB
		CASE "rintcmdproc"
			PRINT "PROC RIntCmdProc"
			PRINT "PR1_INPUT"
			INPUT ""; CommandName
			PRINT "STRASSIGNVAR ("
			PRINT "   STDGOTO"
			PRINT "   COMMANDLINEBYPASS)"
			PRINT "END"
			PRINT
			PRINT "SSR ("
			PRINT "   STRASSIGNVAR ("
			PRINT "   RINTCMDPROC)"
			PRINT "   PR1_GOTO)"
			PRINT "END"
			PRINT
			PRINT "STRASSIGNVAR ("
			PRINT "   KB_BUFFER"
			PRINT "   13OR10)"
			PRINT "END"
			PRINT
			PRINT "SUB (H: KEYBSL"
			PRINT "        FNASSIGN"
			PRINT "        CHARTOANSI"
			PRINT "        KB_BUFFER"
			PRINT "    OUT)"
			PRINT "END"
			PRINT "PEND"
		CASE "ss"
			PRINT "XOS Screen Saver"
			PRINT
			PRINT "Press any key to stop the screen saver..."
			SLEEP 5
			CALL RunExternal("SCRNSAVE.EXE")
			CommandName = "RESTART"
			GOTO CommandLineBypass
		CASE "createref"
			CALL CreateRef
		CASE "listrefs"
			CALL ListRefs
		CASE "run"
			CALL RunRef
		CASE "format"
			PRINT "ÛÛÛ XOS DiskDK"
			PRINT
			PRINT "Format Utility 1.0"
			PRINT
			LINE INPUT "Drive to Format? ", Stdselect
			IF NOT LEFT$(TrimText(Stdselect), 1) = "c" THEN
			PRINT "Formatting A:"
			CHDRIVE "A:"
			MKDIR "A:\DELETED.XOS"
			Dummy = FREEFILE
			OPEN "A:\DELETED.XOS\UDDATA_1.UID" FOR RANDOM AS Dummy LEN = LEN(Del)
			PRINT "Incinerator Subsystem Transferred."
			CLOSE Dummy
			CHDRIVE "C:"
			PRINT "Copying DOS Core to A:..."
			SHELL "SYS A:"
			CHDRIVE "A:"
			PRINT "DOS Core Transferred."
			Dummy = FREEFILE
			OPEN "A:\DRVINF.XXP" FOR RANDOM AS Dummy
			PRINT "Drive Information Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\_XDKCFG.XXP" FOR RANDOM AS Dummy
			PRINT "Disk Configuration Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\_RHRESXI.XXP" FOR RANDOM AS Dummy
			PRINT "Driver Addressing Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\USER.XXP" FOR RANDOM AS Dummy
			PRINT "User Security Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\ADMIN.XXP" FOR RANDOM AS Dummy
			PRINT "Administration Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\SETUP.XXP" FOR RANDOM AS Dummy
			PRINT "Setup Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\_SYSINF.XXP" FOR RANDOM AS Dummy
			PRINT "PCInfo Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\_XDBTLOG.XXP" FOR RANDOM AS Dummy
			PRINT "Boot Log Subsystem Transferred."
			CLOSE Dummy
			Dummy = FREEFILE
			OPEN "A:\_XDKPROC.XXP" FOR RANDOM AS Dummy
			PRINT "Disk Processor Subsystem Transferred."
			CLOSE Dummy
			SLEEP 2
			CLS
			SHELL "COPY XVGDRV.EXE A:"
			PRINT "Video Subsystem Transferred."
			SLEEP 2
			CHDRIVE "C:"
			CLS
			PRINT "Copying Essential System Files..."
			SHELL "COPY DISPLOG.EXE A:"
			SHELL "COPY VGALOGO.GIF A:"
			SHELL "COPY XOS6.EXE A:"
			PRINT "Diskette Formatted."
			END IF
		CASE "flstring"
			CALL UpdateRHRES
		CASE "ver"
			PRINT
			PRINT OEM_VERSION_STRING
			PRINT
		CASE "dosver"
			PRINT
			CALL RunExternal("VER")
			PRINT
		CASE "prompt"
			CALL PromptChange
		CASE "dir"
			CALL FList
		CASE "ue"
			PRINT "UE is no longer available."
		CASE "xsch"
			PRINT "XSCH functionality is now in command CD."
		CASE "xsma"
			PRINT "XSMA/MAKE functionality is now in command MD."
		CASE "quit"
			PRINT "RS functionality is now in the XOS Rel. 6, MAIN area."
			PRINT "QUIT functionality is now in command EXIT."
		CASE "cs"
			PRINT "CS functionality is now in command CLS."
		CASE "uvcs"
			PRINT "UVCS is now under XOS Central/XOS 6 Setup/Video"
		CASE "larcsa"
			PRINT "LarcSA functionality is now in command COLOR."
		CASE "cd"
		CASE "invert"
			'PRINT "Initiating User Scheme (C.cFC, C.cBC)..."
			'SLEEP 3
			'COLOR C.cFC, C.cBC
			'CLS
			'PRINT "Inverting Colors..."
			'PRINT "Foreground (C.cFC) to TEMP..."
			'TEMP% = C.cFC
			'SLEEP 1
			'PRINT "Background (C.cBC) to Foreground (C.cFC)..."
			'C.cFC = C.cBC
			'SLEEP 1
			'PRINT "TEMP (TEMP%) to Background (C.cBC)..."
			'C.cBC = TEMP%
			'SLEEP 1
			'PRINT "Initiating Sequence..."
			'SLEEP 10
			SWAP C.cFC, C.cBC
			COLOR C.cFC, C.cBC
			CLS
		CASE "color"
			PRINT "ÛÛÛ XOS Color"
			PRINT
			INPUT "Foreground Color Number? ", Dummy
			INPUT "Background Color Number? ", BColor%
			PRINT
			PRINT "Change Color to scheme "; TrimText(STR$(Dummy)); "B"; TrimText(STR$(BColor%)); "?";
			LINE INPUT " "; Stdselect
			IF TrimText(Stdselect) = "y" THEN
				CALL ChangeColors(Dummy, BColor%)
				C.cFC = Dummy
				C.cBC = BColor%
			END IF
		CASE "help"
			PRINT "ÛÛÛ XOS Help! 6.0"
			PRINT
			INPUT "Enter Error Code: ", Dummy
			PRINT HandleIt(Dummy)
			PRINT HText
			HText = ""
		CASE "large"
			WIDTH 40
			CLS
			PRINT "ÛÛÛ Text Mode DDF 5.0"
			PRINT "    Large Size"
			PRINT
			PRINT "Copyright (C) 1995, John Willis"
			PRINT
			SLEEP 3
			GOTO StartUp
		CASE "small"
			WIDTH 80
			CLS
			PRINT "ÛÛÛ Text Mode DDF 5.0"
			PRINT "    Standard Size"
			PRINT
			PRINT "Copyright (C) 1995, John Willis"
			PRINT
			SLEEP 3
			GOTO StartUp
		CASE "del"
			CALL DeleteFile
		CASE "undel"
			CALL UndeleteFile
		CASE ELSE
			IF NOT TrimText(CommandName) = "" THEN
				CALL RunProgram(TrimText(CommandName), "XOS6", "reload_server")
			END IF
	END SELECT 'End of command processor
GOTO CommandLine

'Error Handler Calling Code
ErrorHandler:
	PRINT
	PRINT "Error:"
	PRINT HandleIt(ERR)
	PRINT
	
	PRINT "SYS_MSG = "; SYS_MSG
	PRINT "STD_ERR = "; TrimText(STR$(STD_ERR))
	PRINT "FTL_ERR = "; : COLOR 12: PRINT FTL_ERR
	COLOR C.cFC, C.cBC
	LINE INPUT "A)bort, R)etry, I)gnore, F)lags? ", Stdselect
	SELECT CASE LEFT$(TrimText(Stdselect), 1)
		CASE "a"
			RESUME NEXT
		CASE "i"
			RESUME
		CASE "r"
			RESUME
		CASE "f"
			PRINT "System Flag Status:"
			PRINT
			PRINT "SHELLNAME       = "; ShellName
			PRINT "SYS_MSG         = "; SYS_MSG
			PRINT "STDSELECT       = "; Stdselect
			PRINT "DUMMY           ="; Dummy
			PRINT "FTL_ERR         = "; FTL_ERR
			PRINT "ITERATION       ="; Iteration
			PRINT "MYNAME          = "; MyName
			PRINT "USERLOC         ="; UserLoc
			PRINT "C.cFC           ="; C.cFC
			PRINT "C.cBC           ="; C.cBC
			PRINT "---More---"
			SLEEP
			PRINT "STD_ERR         ="; STD_ERR
			PRINT "ERDEV           ="; ERDEV
			PRINT "ERDEV_STR       = "; ERDEV$
			PRINT "ERR             ="; ERR
			PRINT "ERR_STR         = "; ERROR$(STD_ERR)
			PRINT "SETFNUM         ="; setFNum
			PRINT "STARTTIME       ="; StartTime
			PRINT "DELFILENUM      ="; DelFileNum
			PRINT "SMMODE          ="; SMMode
			PRINT "PROMPT          = "; Prompt
			PRINT "TITLE           = "; Title
			PRINT "ADMLOGGEDON     ="; admLoggedOn
			PRINT "ADMTPASSWORD    = "; admTPassword
			PRINT "COMMANDNAME     = "; CommandName
			PRINT "---More---"
			SLEEP
			PRINT "UID Structure:"
			PRINT "DEL.FNAME       = "; Del.FName
			PRINT "DEL.FLOC        = "; Del.FLoc
			PRINT "DEL.FSIZE       ="; Del.FSize
			PRINT "---More---"
			SLEEP
			PRINT "ADM Structure:"
			PRINT "ADMFILE.ADMPASSWORD   = "; WEncrypt(admFile.admPassword)
			PRINT "ADMFILE.MAXRETRIES    ="; admFile.MaxRetries
			PRINT "ADMFILE.ADMREQUSER    ="; admFile.admReqUser
			PRINT "ADMFILE.MAXCOPIES     ="; admFille.MaxCopies
			PRINT "PROG_VERSION          = "; PROG_VERSION
			PRINT "OEM_VERSION_STRING    = "; OEM_VERSION_STRING
	END SELECT
	COLOR 15
	PRINT
	
EXIT SUB
END SUB

'
' XOS 7.0a Initialization Routine
'
SUB StartBanner ()
	
	ON LOCAL ERROR RESUME NEXT
	IF Bypass = "yes" THEN
		GOTO Pass
	END IF
	SFile = FREEFILE
	OPEN "C:\SHUTDOWN.DAT" FOR RANDOM AS SFile LEN = LEN(SS1)
	GET SFile, 1, SS1
	IF UCASE$(TrimText(SS1.ShutDownSuccessful)) = "YES" THEN
		GOTO Norm
	ELSE
		CALL NewSys
		EXIT SUB
	END IF
'Code for shutdown success check bypass ONLY.
Pass:
	'I may want some bypass processing code here later.
Norm:
		Stdselect = ProfileRead$("c:\xos\xos.xif", "XOS", "APMEnabled")
		IF Stdselect = "TRUE" THEN
			Con.APM = "TRUE"
			regs.ax = &H5308
			regs.bx = &HFFFF
			regs.cx = &H1
			'CALL INTERRUPT(&H15, regs, regs)
		ELSE
			Con.APM = "FALSE"
			regs.ax = &H5308
			regs.bx = &HFFFF
			regs.cx = &H0
			'CALL INTERRUPT(&H15, regs, regs)
		END IF

		
		Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "ShowBanner")
		SYS_MSG = ProfileRead$("c:\xos\xos.xif", "Boot", "beep")
		IF SYS_MSG = Stdselect THEN
			PRINT "Please Wait..."
		END IF
		IF Stdselect = "TRUE" THEN
			CALL XPrint("ÛÛÛ XOS " + PROG_VERSION, 1, 1)
		END IF
		Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "beep")
		IF Stdselect = "TRUE" THEN
			PLAY "<L16A"
		END IF
		SS1.ShutDownSuccessful = "NO"
		PUT SFile, 1, SS1
	ON LOCAL ERROR RESUME NEXT
	Stdselect = ProfileRead$("c:\xos\xos.xif", "Boot", "InitAppDir")
	CHDIR Stdselect
	DelFileNum = FREEFILE

	'Initialize Incinerator
		DelDir$ = UCASE$(ProfileRead$("\XOS\XOS.XIF", "Incinerator", "IncinDir"))
		OPEN "\" + DelDir$ + "\UDDATA_1.UID" FOR RANDOM AS DelFileNum LEN = LEN(Del)
	'End of incinerator initialization

	SMMode = 80
	CALL admInit
	CALL setInit
	CALL STErrCheck
	CALL StartUp
	CALL lkInit
END SUB

SUB StartUp ()
END SUB

SUB STErrCheck ()
	IF Exists("\DELETED.XOS\UDDATA_1.UID") = "NO" THEN
		CLS
		PLAY "P4l4A>a>a"
		PRINT "FATAL ERROR:"
		PRINT
		PRINT "Incinerator Directory Does Not Exist."
		PRINT
		LINE INPUT "Do you want to fix the problem? ", Stdselect
		CLS
		IF TrimText(Stdselect) = "y" THEN
			PRINT "Creating Directory..."
			MKDIR "\DELETED.XOS"
			CALL ErrorStart
			EXIT SUB
		END IF
		PRINT "Cannot Continue."
		'END
	END IF
END SUB

FUNCTION TrimText (InText AS STRING) AS STRING
	TrimText = LTRIM$(RTRIM$(LCASE$(InText)))
END FUNCTION

SUB UndeleteFile ()
	DelDir$ = UCASE$(ProfileRead$("\XOS\XOS.XIF", "Incinerator", "IncinDir"))
	CLS
	PRINT "ÛÛÛ XOS Smart Incinerator 1.0"
	OldDir$ = CURDIR$
	CHDIR DelDir$
	PRINT "Undeletable Files..."
	PRINT
	FOR Iteration = 2 TO LOF(DelFileNum) / LEN(Del)
	'DO WHILE NOT EOF(DelFileNum)
		GET DelFileNum, Iteration, Del
		IF NOT TrimText(Del.FName) = "*undel*" THEN
			PRINT Del.FName; "   Size:  "; LTRIM$(STR$(Del.FSize))
			TotalSize& = TotalSize& + Del.FSize
			TFs = TFs + 1
		END IF
	NEXT Iteration
	PRINT
	PRINT "Total Files    :  "; LTRIM$(STR$(TFs))
	PRINT "Total File Size:  "; LTRIM$(STR$(TotalSize&))
	PRINT
	TotalSize& = 0
	LINE INPUT "File to Undelete? ", FileName$
	PRINT
	YN$ = "y"
	IF LEFT$(TrimText(YN$), 1) = "y" THEN
	FOR Iteration = 1 TO LOF(DelFileNum) / LEN(Del)
		GET DelFileNum, Iteration, Del
		IF TrimText(Del.FName) = TrimText(FileName$) THEN
			NewLoc$ = UCASE$(TrimText(Del.FLoc))
			Temp$ = Del.FName
			Del.FName = "*UNDEL*"
			Del.FLoc = Temp$
			Del.FSize = 0
			PUT DelFileNum, Iteration, Del
			EXIT FOR
		END IF
	NEXT
		PRINT "Undeleting "; UCASE$(FileName$); " to "; UCASE$(NewLoc$); "..."
		SHELL "COPY " + "\" + DelDir$ + "\" + FileName$ + " " + NewLoc$
		KILL "\" + DelDir$ + "\" + FileName$
		PRINT "File Undeleted."
	ELSE
		PRINT "File cannot be undeleted."
	END IF
	CHDIR OldDir$
END SUB

SUB UpdateRHRES ()
Dummy = FREEFILE
OPEN "_RHRESXI.XXP" FOR APPEND AS #Dummy
PRINT #Dummy, Flags
CLOSE #Dummy
END SUB

FUNCTION WDecrypt (InText AS STRING) AS STRING

FOR Iteration = 1 TO LEN(InText)
	Stdselect = MID$(InText, Iteration, 1)
	STD_ERR = ASC(Stdselect)
	STD_ERR = STD_ERR + 1
	WHOLE$ = WHOLE$ + CHR$(STD_ERR)
NEXT Iteration
WDecrypt = WHOLE$
END FUNCTION

FUNCTION WEncrypt (InText AS STRING) AS STRING
ON LOCAL ERROR RESUME NEXT
FOR Iteration = 1 TO LEN(InText)
	Stdselect = MID$(InText, Iteration, 1)
	STD_ERR = ASC(Stdselect)
	STD_ERR = STD_ERR - 1
	WHOLE$ = WHOLE$ + CHR$(STD_ERR)
NEXT Iteration
WEncrypt = WHOLE$
END FUNCTION

SUB xosInitWinXOSLink ()
	CALL dnlUnlockResource("MAINLINK")
	CALL dnlCreateINL("MAINLINK", "DTW")
	CALL dnlSetINLData("MAINLINK", 1, "ras")
	dnlSetActiveINL ("MAINLINK")
	DO UNTIL Stdselect = "LinkOpened"
		Stdselect = szINLData("MAINLINK", 3)
	LOOP
	DO:  LOOP UNTIL LEN(szINLData("MAINLINK", 4)) > 1
	dnlUnlockResource "XSCENTRAL"
	dnlCreateINL "XSCENTRAL", "DTW"
	dnlUnlockResource "SECURITYPLUS"
	dnlCreateINL "SECURITYPLUS", "DTW"
	dnlUnlockResource "HANDLEIT"
	dnlCreateINL "HANDLEIT", "DTW"
	dnlUnlockResource "XSSCMD"
	dnlCreateINL "XSSCMD", "DTW"
	dnlCreateINL "XSMAIN", "DTW"
END SUB

SUB XPrint (InText AS STRING, Horiz AS INTEGER, Vert AS INTEGER)
	LOCATE Horiz, Vert
	PRINT InText
END SUB

SUB XSetup ()
	CLS
	PRINT
	PRINT "ษออออออออออออออออออออป"
	PRINT "บ Setup Menu         บ"
	PRINT "บ                    บ"
	PRINT "บ 1.  User Info      บ"
	PRINT "บ                    บ"
	PRINT "บ 2.  Session Colors บ"
	PRINT "บ                    บ"
	PRINT "บ 3.  Printers       บ"
	PRINT "บ                    บ"
	PRINT "บ 4.  Ports          บ"
	PRINT "บ                    บ"
	PRINT "บ 5.  Modem          บ"
	PRINT "บ                    บ"
	PRINT "บ 6.  Your Settings  บ"
	PRINT "บ                    บ"
	PRINT "บ 7.  Add Program    บ"
	PRINT "ศออออออออออออออออออออผ"
	PRINT
	INPUT "=> ", Dummy
	
	'Menu Processor
	SELECT CASE Dummy
		CASE 7
			CALL RunProgram("\XOS\ASA\ANPR_ASA.EXE", "XOS6", "reload_server")
		CASE 6
			GOTO UserSetup
		CASE 3
			STD_ERR = FREEFILE
			OPEN "PRINTER.XXP" FOR OUTPUT AS STD_ERR
			LINE INPUT "Printer Name? "; St$
			PRINT #STD_ERR, St$
			CLOSE STD_ERR
			EXIT SUB
		CASE 4
			LINE INPUT "Port? ", Stdselect
			SELECT CASE TrimText(LEFT$(Stdselect, 3))
				CASE "lpt"
					LINE INPUT "Paralell Port ID? ", SYS_MSG
					CALL ProfileWrite("c:\xos\xos.xif", "Ports", UCASE$(TrimText(Stdselect)), SYS_MSG)
				CASE "com"
					LINE INPUT "Speed? ", Speed$
					LINE INPUT "Parity? ", Parity$
					LINE INPUT "Data Bits? ", DBits$
					LINE INPUT "Stop Bits? ", SBits$
					CALL ProfileWrite("c:\xos\xos.xif", "Ports", UCASE$(TrimText(Stdselect)), Speed$ + Parity$ + DBits$ + SBits$)
			END SELECT
		CASE 1
			IF NOT admLoggedOn = TRUE THEN
				CLS
				PRINT "You cannot alter user information."
				PRINT "Access Denied."
				PRINT
				PRINT
				PRINT "Press ESC to continue..."
				SLEEP
				EXIT SUB
			END IF
			CLS
			PRINT "User Manager 1.0"
			PRINT
			PRINT "1. Create New User"
			PRINT
			PRINT "2. Delete a User"
			PRINT
			PRINT "3. Edit a User"
			PRINT
			PRINT "4. View User's Report"
			PRINT
			PRINT "5. Cancel"
			PRINT
			INPUT "=> ", Dummy

			'Menu Processor
			SELECT CASE Dummy
				CASE 1
					CALL CreateNewUser
					EXIT SUB
				CASE 2
					LINE INPUT "User to Delete? ", Stdselect

					'Find the user...
					FOR Iteration = 1 TO LOF(setFNum) / LEN(Setup)

						'Read the information...
						GET #setFNum, Iteration, Setup

						'Scan information...
						IF TrimText(Stdselect) = TrimText(Setup.Username) THEN
							PRINT "Deleting User "; UCASE$(Stdselect); "..."
							Setup.Username = "*DEL*"
							Setup.Password = "*DEL*"
							Setup.FC = 15
							Setup.BC = 1
							PUT #15, Iteration, Setup
							PRINT "User Deleted."
							EXIT SUB
						END IF

					NEXT Iteration
				CASE 4
					'
					' View User Report
					'
					CLS
					LINE INPUT "User Name? ", Stdselect
					PRINT "Searching for "; UCASE$(Stdselect)
					Dummy = FREEFILE
					OPEN "\" + Stdselect FOR INPUT AS Dummy
					CLS
					PRINT "User Report:"
					PRINT
					PRINT INPUT$(LOF(Dummy), Dummy)
					PRINT "---More---"
					SLEEP
				CASE 3
					LINE INPUT "User to Edit? ", Stdselect
			
					'Find the user...
					FOR Iteration = 1 TO LOF(setFNum) / LEN(Setup)

				'Read the information...
				GET #setFNum, Iteration, Setup

				'Scan information...
				IF TrimText(Stdselect) = TrimText(Setup.Username) THEN
					'Save user's location in file...
					UserLoc = Iteration
					PW$ = Setup.Password
					'Verify User...
					IF NOT TrimText(PW$) = TrimText(Setup.Password) THEN
						CLS
						PRINT "Access Denied."
						PRINT
						PRINT
						PRINT "Press any key to continue..."
						SLEEP
						EXIT SUB
					END IF

					PRINT "Selected User Number: "; Iteration
					EXIT FOR
				
				END IF

			NEXT Iteration
		END SELECT
		CASE 2
			INPUT "Foreground Color Number? ", C.cFC
			INPUT "Background Color Number? ", C.cBC
	END SELECT
	EXIT SUB
UserSetup:
	INPUT "Foreground Color Number? ", Setup.FC
	INPUT "Background Color Number? ", Setup.BC
	LINE INPUT "Change Username? ", Stdselect
	IF TrimText(Stdselect) = "y" THEN
		LINE INPUT "New Username? ", Setup.Username
	END IF
	LINE INPUT "Change Password? ", Stdselect
	IF TrimText(Stdselect) = "y" THEN
		LINE INPUT "New Password? ", Setup.Password
		CALL EncData
	END IF
	PUT #setFNum, UserLoc, Setup
END SUB

FUNCTION YesOrNo ()
	'CALL Pause
	'YesOrNo = LEFT$(TrimText(INKEY$), 1)
END FUNCTION

SUB YourPrograms ()
	ON LOCAL ERROR RESUME NEXT
	Dummy = FREEFILE
	OPEN "\XOS\NAVIGATE\YOURPROG.XRF" FOR INPUT AS #Dummy

	CLS
	LOCATE 3

	PRINT "Your Programs"
	PRINT

	'Initialize the loop counter
	Iteration = 0

	'Initialize the DesktopData array
	DO WHILE NOT EOF(Dummy)

		'Increment the iteration variable
		Iteration = Iteration + 1

		'Read a line from the file
		LINE INPUT #Dummy, Stdselect

		'Assign it to the ProgName() array (Element determined by Iteration)
		ProgName(Iteration).szKey = TrimText(Stdselect)
		'Read the application's EXE file path and name
		Temp$ = TrimText(ProfileRead$("\XOS\XOS.XIF", Stdselect, "AppDir")) + "\"
		ProgName(Iteration).szEXE = Temp$ + TrimText(ProfileRead$("\XOS\XOS.XIF", Stdselect, "EXEName"))

		'Read the application's description
		ProgName(Iteration).szDescription = ProfileRead$("\XOS\XOS.XIF", Stdselect, "AppName")
	LOOP
	nTotalPrograms = Iteration

	'Display the menu
	FOR Iteration = 1 TO nTotalPrograms
		
		'Print the menu item's number and description
		PRINT TrimText(STR$(Iteration)); ". "; ProgName(Iteration).szDescription
	NEXT Iteration
	PRINT "200. Exit"

	'Set up a command prompt
	PRINT
	INPUT "Enter a Menu Item's Number: ", STD_ERR

	'Check to see if the user wants to exit
	IF STD_ERR = 200 THEN
		EXIT SUB
	END IF

	'Run the EXE name contained in the szEXE element
	'of the element of the ProgName array entered by the user
	'corresponding to the menu item on screen
	CALL RunProgram(TrimText(ProgName(STD_ERR).szEXE), "XOS6", "reload_server")

	'Close the reference database.
	CLOSE #Dummy
END SUB

