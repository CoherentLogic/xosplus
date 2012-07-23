DECLARE FUNCTION GetVideoCap () AS INTEGER
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

'
' SYSLVL.BAS
'
'$INCLUDE: 'vbdos.bi'
'$INCLUDE: 'constant.bi'

 ON ERROR RESUME NEXT

 DIM regs AS RegType                    ' Define registers
							 ' Clear the screen
 SCREEN 0
 
 VidCaps = GetVideoCap
badcom:


 LOCATE 25, 1
 LINE INPUT "System Ready. ", sysr$
	SELECT CASE sysr$
		CASE "boot"
			CLS
			GOTO boot
		CASE ELSE
			GOTO badcom

	END SELECT

boot:

 PRINT "XOS Plus 10 load in progress..."
 BEEP
 PRINT
 PRINT "The date and time are "; DATE$; " "; TIME$
 regs.ax = &H4300
 interrupt &H2F, regs, regs
 IF regs.ax MOD 256 = &H80 THEN
	PRINT "XMS support is loaded through an external driver. "
	PRINT "XOS will be unable to access extended memory."
	PRINT "syslvl error #1: Extended memory locked by external driver."
 ELSE
	PRINT "Extended memory area available through interrupt 15h, function 8800h. Good."
 END IF
 interrupt &H12, regs, regs
 low = regs.ax
 regs.ax = &H8800
 
 interrupt &H15, regs, regs
 high = regs.ax

 PRINT "Testing base memory..."
 FOR i = 1 TO low
	LOCATE 9, 1

	PRINT i; "kilobytes OK...";
	SOUND 32767, .1
	'SOUND 32767, .1
 NEXT

 PRINT RTRIM$(STR$(low)); "/"; LTRIM$(STR$(high)); " kbytes main/extended system memory"

 SLEEP 1

 PRINT
 PRINT "JWSD XOS Plus Version 10.5.3 "; DATE$; " "; TIME$
 PRINT " Copyright (c) 1997,  J. Willis"
 PRINT " All rights reserved."
 PRINT

 PRINT "Supported filesystems:"
'Get current drive information; set up input and do system call
 PRINT "boot=";
 regs.ax = &H3305
 CALL interrupt(&H21, regs, regs)
 
 SELECT CASE regs.dx
	CASE 1
		PRINT "A:"
	CASE 2
		PRINT "B:"
	CASE 3
		PRINT "C:"
	CASE 4
		PRINT "D:"
 END SELECT


 regs.ax = &H1900
 CALL interrupt(&H21, regs, regs)
 DIM Totalspace AS CURRENCY
' Convert drive information to readable form
 drive$ = CHR$((regs.ax AND &HFF) + 65) + ":"
 
 PRINT "hd1="; drive$
' Get disk free space; set up input values and do system call
 regs.ax = &H3600
 regs.dx = ASC(UCASE$(drive$)) - 64
 CALL interrupt(&H21, regs, regs)
 
' Decipher the results
 SectorsInCluster = regs.ax
 BytesInSector = regs.cx
 IF regs.dx >= 0 THEN
		 ClustersInDrive = regs.dx
 ELSE
		 ClustersInDrive = regs.dx + 65536
 END IF
 IF regs.bx >= 0 THEN
		 ClustersAvailable = regs.bx
 ELSE
		 ClustersAvailable = regx.bx + 65536
 END IF
 Freespace = ClustersAvailable * SectorsInCluster * BytesInSector

' Report results
								   ' Clear the screen
 PRINT STR$(regs.ax); " sectors per cluster"
 PRINT STR$(regs.bx); " free clusters"
 PRINT STR$(regs.cx); " bytes per sector in "; drive$
 PRINT STR$(CDBL(Freespace)); " bytes free on "; drive$
 regs.ax = &H3300
 CALL interrupt(&H21, regs, regs)
 PRINT
 PRINT "extended break=";
 SHELL "break > break.txt"
 OPEN "break.txt" FOR INPUT AS #1
 LINE INPUT #1, break$
 CLOSE #1
 PRINT MID$(break$, INSTR(break$, "o"))


 SELECT CASE regs.dx
 CASE &H0
	'PRINT "off"
 CASE &H1
	'PRINT "on"
 CASE ELSE
	'PRINT "unknown"
 END SELECT

 regs.ax = &H800

 CALL interrupt(&H2F, regs, regs)

 SELECT CASE regs.ax
	CASE &H0
		PRINT "all FDC support in BIOS. Good."
	CASE &H1
		PRINT "all FDC support in BIOS. Good."
	CASE &HFF
		PRINT "BIOS FDC support present through external driver."
		PRINT "Drives accessed with this driver will not show under XOS."
	CASE ELSE
		PRINT "BIOS FDC support is indeterminate. Some drives may not be accessible"
 END SELECT

 regs.ax = &H3000
 interrupt &H21, regs, regs

 Major% = regs.ax MOD 256
 Minor% = regs.ax \ 256
 DOSVersion = Major% + Minor% / 100!
 PRINT "Interrupt 21h support compatible through "; FORMAT$(DOSVersion, "0.00")
 
 regs.ax = &H1600
 interrupt &H2F, regs, regs
 IF ENVIRON$("windir") <> "" THEN
	 PRINT "Windows 3.x/95 is running. Do not use the 'pin' command."
 ELSE
	 PRINT "Windows 3.x/95 is not running. Good."
 END IF

 SELECT CASE regs.ax
	CASE &H0
		PRINT "Windows 2.x is not active. Good."
	CASE &H1
		PRINT "Windows 2.x is running. Some XOS features may conflict with Windows."
	CASE &HFF
		PRINT "Windows 2.x is running. Some XOS features may conflict with Windows"
	CASE ELSE
		PRINT "Cannot determine Windows 2.x activity. "
		PRINT "Some XOS features may conflict with Windows."
 END SELECT
'   0   Monochrome text display
'   1   CGA graphics display
'   2   EGA graphics display
'   3   VGA graphics display
'   4   Hercules display adapter
'   5   AT&T/Olivetti adapter

 SELECT CASE VidCaps
	CASE 0
		PRINT "Monochrome text display adapter"
	CASE 1
		PRINT "640x200 CGA graphics adapter"
	CASE 2
		PRINT "640x350 EGA graphics adapter"
	CASE 3
		PRINT "640x480 VGA graphics adapter"
	CASE 4
		PRINT "720x348 Hercules graphics adapter"
	CASE 5
		PRINT "640x400 AT&T/Olivetti display adapter"
 END SELECT
 IF nExists("C:\XOS\USER\PROFILE") = FALSE THEN
	PRINT "profile file does not exist"
 ELSE
	PRINT "profile file exists"
 END IF

' GetVideoCap
'  Get display capabilities
'  Return Values:
'   0   Monochrome text display
'   1   CGA graphics display
'   2   EGA graphics display
'   3   VGA graphics display
'   4   Hercules display adapter
'   5   AT&T/Olivetti adapter
FUNCTION GetVideoCap () AS INTEGER

	cap = 0

	ON LOCAL ERROR RESUME NEXT
	SCREEN 1
	IF ERR = 0 THEN
		cap = 1
	END IF

	SCREEN 9
	IF ERR = 0 THEN
		cap = 2
	END IF

	SCREEN 12
	IF ERR = 0 THEN
		cap = 3
	END IF
	
	SCREEN 3
	IF ERR = 0 THEN
		cap = 4
	END IF

	SCREEN 4
	IF ERR = 0 THEN
		cap = 5
	END IF

	SCREEN 0
	WIDTH 80
	GetVideoCap = cap


	
END FUNCTION

