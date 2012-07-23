'
' xoscore 9.0
'                          '
'$INCLUDE: 'C:\VBDWSHOP\PROFILE.BI'
COLOR 15, 1
CLS
LOCATE 2, 1
PRINT " XOS Plus 10                     System Startup"
COLOR 10
LOCATE 4, 1
PRINT STRING$(80, 196)
VIEW PRINT 5 TO 25
COLOR 15
PRINT
PRINT "XOS Plus"
PRINT
PRINT "XOS Plus release 10"
PRINT "Utilities and operations environment"
PRINT "XOS 10 graphical universal capability/interface"
PRINT
PRINT "Encryption/decryption model AM1-S4, U.S. only."
PRINT "Enhanced content generation package RFR 5.02/RSEE2"
PRINT "Graphics storage 16X, WGF, C16, DIB, TCX"

PRINT "NATIVE FORMATS:"
PRINT "Format", "Colors", "Header", "Palette"

PRINT "16X", "16", "TRUE", "0-15 scaled, combined RGB source"
PRINT "C16", "16", "TRUE", "0-15 scaled, combined RGB source"
PRINT "OSW", "16.7M", "FALSE", "3 channel seperate long integer RGB"
PRINT "TCX", "16.7M", "TRUE", "3 channel seperate integer RGB"
PRINT
PRINT "Standard configuration model"
VIEW PRINT 24 TO 25
COLOR 0, 7
CLS
PRINT "Press ESC to bypass this screen"
SLEEP 3

VIEW PRINT 5 TO 25
COLOR 15, 1
CLS







CHDIR "C:\XOS\SYSTEM"
SHELL "C:\XOS\SYSTEM\ENCMOD C:\XOS\USER\CONFIG\PROFENC C:\XOS\USER\PROFILE -D"

IF ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "INIT_SHOWMENU") = "TRUE" THEN
    m$ = "MENU"

    CLS
    Temp$ = "XOS Plus Startup Menu"
    PRINT
    PRINT
    PRINT Temp$
    PRINT STRING$(LEN(Temp$), 205)
    PRINT
    PRINT "1.   Execute PROFILE"
    PRINT "2.   XOS Standard Shell"
    PRINT "3.   XOS Extended Shell"
    PRINT "4.   DOS Command Line"
    PRINT "5.   Execute PROFILE with step-by-step confirmation"
    PRINT "6.   Core Shell"
    IF ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "INIT_SHOWWINBOOT") = "TRUE" THEN
        PRINT "7.   Windows Graphical Interface"
        PRINT "8.   XOS Graphical Interface"
    END IF
    PRINT
    PRINT
    INPUT "=> ", s%

    SELECT CASE s%
        CASE 1
            SHELL ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "INIT_RUNPROFILE") + " C:\XOS\USER\PROFILE NO"
            GOTO Cleanup
            END
        CASE 2
            SHELL "C:\XOS\SYSTEM\STDSH.EXE"
            GOTO Cleanup
            END
        CASE 3
            SHELL "C:\XOS\SYSTEM\EXSH.EXE"
            GOTO Cleanup
            END
        CASE 4
            COLOR 7, 0
            CLS
            PRINT
            PRINT "Type XOSCORE to start XOS again."
            PRINT
            END
        CASE 5
            SHELL ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "INIT_RUNPROFILE") + " C:\XOS\USER\PROFILE -I"
        CASE 6
            COLOR 7, 0
            CLS
            PRINT "Starting XOS..."
            PRINT " eXtended Operating Shell Release 10"

            DO
                LINE INPUT "System Ready. ", Temp$
                IF Temp$ = "rs" THEN
                    END
                END IF
                SHELL Temp$

            LOOP

        CASE 7
            CHDIR "C:\WINDOWS"
            SHELL "WIN.COM"
            GOTO Cleanup
            END
    END SELECT
END IF

IF m$ = "MENU" THEN END


SHELL ProfileRead$("C:\XOS\USER\PROFILE", "Environment", "INIT_RUNPROFILE") + " C:\XOS\USER\PROFILE NO"
Cleanup:

KILL "C:\XOS\USER\CONFIG\PROFENC"

CHDIR "\XOS\SYSTEM"
SHELL "C:\XOS\SYSTEM\ENCMOD C:\XOS\USER\PROFILE C:\XOS\USER\CONFIG\PROFENC -E"

KILL "C:\XOS\USER\PROFILE"


END

