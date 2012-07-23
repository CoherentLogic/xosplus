DECLARE SUB ProfileWrite (IniFile$, IniSection$, IniKey$, ProfileStr$)
'
'exsh
'

'$INCLUDE: '\VBDWSHOP\PROFILE.BI'


DIM Stdselect AS STRING

DIM HistoryBuffer(100) AS STRING

PRINT "exsh rel. 1.0.1"
PRINT

MEInit:
    KEY 1, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F1")
    KEY 2, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F2")
    KEY 3, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F3")
    KEY 4, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F4")
    KEY 5, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F5")
    KEY 6, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F6")
    KEY 7, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F7")
    KEY 8, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F8")
    KEY 9, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F9")
    KEY 10, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F10")
    ON ERROR GOTO ErrorHandler
    
MEProcess:
    CurError$ = "NONE"
    MachineName$ = ProfileRead$("\xos\user\profile", "Environment", "SYSNAME")
    'MachineName$ = MacineName$ + ProfileRead$("\xos\xos.xif", "User", "compname")
    PRINT LCASE$(MachineName$); "["; LCASE$(MID$(CURDIR$, 3)); "]*";
    LINE INPUT " ", CommandName$
Bypass:
    ComNum% = ComNum% + 1
    IF ComNum% = 99 THEN ComNum% = 0
    HistoryBuffer(ComNum%) = CommandName$

    'Command Processor
    SELECT CASE LTRIM$(RTRIM$(CommandName$))
        CASE "s&"
            PRINT "XOS Plus 9.0         Extended Shell"
        CASE "udexl"
            SHELL "DIR /B /S \*.EXE > FLIST.EXL"
            SHELL "DIR /B /S \*.COM >> FLIST.EXL"
            SHELL "DIR /B /S \*.SCR >> FLIST.EXL"
        CASE "pexl"
            ON ERROR RESUME NEXT
            x% = FREEFILE
            OPEN "\TREEDATA.LST" FOR INPUT AS #x%
            PRINT " byte", " KB", " MB", "file"
            DO WHILE NOT EOF(x%)
NoPr:
                LINE INPUT #x%, Temp$
                
                OPEN Temp$ FOR INPUT AS #x% + 1
                Test% = LOF(x% + 1)

                PRINT LOF(x% + 1),
                PRINT INT(LOF(x% + 1) / 1000),
                PRINT INT(LOF(x% + 1) / 1000000),
                PRINT LCASE$(LEFT$(Temp$, 30))
                CLOSE #x% + 1
            IF CSRLIN >= 24 THEN
                
                CLS
                COLOR 15, 1: PRINT " byte", " KB", " MB", "file": COLOR 7, 0

            END IF
            LOOP
        CASE "vcf"
            PRINT "SYSSHELL="; SysShell
            PRINT "DOSENV  ="; DOSEnv
            PRINT "LOCALMACHINE="; MachineName$
        CASE "rp"
            LINE INPUT "%1", Stdselect 'INI file name
            LINE INPUT "%2", Parm2$    'Section
            LINE INPUT "%3", Parm3$    'Key
            PRINT ProfileRead$(Stdselect, Parm2$, Parm3$)
        CASE "wp"
            LINE INPUT "%1", Stdselect 'INI file name
            LINE INPUT "%2", Parm2$    'Section
            LINE INPUT "%3", Parm3$    'Key
            LINE INPUT "%4", Parm4$    'Value
            CALL ProfileWrite(Stdselect, Parm2$, Parm3$, Parm4$)
        CASE "ex"
            LINE INPUT "?", name$
            PRINT LTRIM$(STR$(LEN(name$)))
            IF LEN(name$) > 1 THEN
                SHELL name$
            ELSE
                
            END IF
        CASE "gcd"
            PRINT CURDIR$
        CASE "ch"
            LINE INPUT "?", name$
            PRINT CURDIR$; "=>"; name$;
            CHDIR name$
            SLEEP 2
            IF CurError$ <> "YES" THEN
                PRINT " [ok]"
            ELSE
                PRINT " [failed]"
            END IF
        CASE "ma"
            LINE INPUT "?", name$
            PRINT name$;
            MKDIR name$
            SLEEP 2
            IF CurError$ <> "YES" THEN
                PRINT " [ok]"
            ELSE
                PRINT " [failed]"
            END IF
        CASE "rm"
            LINE INPUT "?", name$
            PRINT name$;
            RMDIR name$
            SLEEP 2
            IF CurError$ <> "YES" THEN
                PRINT " [ok]"
            ELSE
                PRINT " [failed]"
            END IF
        CASE "cs"
            CLS
        CASE "szf"
            LINE INPUT "?", name$
            OPEN name$ FOR INPUT AS #1
            PRINT LTRIM$(STR$(LOF(1)))
            CLOSE 1
        CASE "exit"
            END
        CASE "quit"
            END
        CASE "rs"
            END
        CASE "ku"
            KEY 1, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F1")
            KEY 2, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F2")
            KEY 3, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F3")
            KEY 4, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F4")
            KEY 5, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F5")
            KEY 6, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F6")
            KEY 7, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F7")
            KEY 8, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F8")
            KEY 9, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F9")
            KEY 10, ProfileRead$("\XOS\XOS.XIF", "KeyPatch", "F10")
        CASE ELSE
            SELECT CASE LEFT$(CommandName$, 2)
                CASE "%h"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    PRINT "Help - "; CommandName$
                    'Help Processor
                    SELECT CASE CommandName$
                        CASE "szf"
                            PRINT "Size File"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " szf "; EnterKey
                        CASE "rp"
                            PRINT "Read Profile String"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " rp "; EnterKey
                        CASE "ma"
                            PRINT "Make Directory"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " ma "; EnterKey
                        CASE "rm"
                            PRINT "Remove Directory"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " rm "; EnterKey
                        CASE "%r"
                            PRINT "%r(ecall) prefix"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " %r[buffer number]"
                        CASE "%s"
                            PRINT "%s(hell) prefix"
                            PRINT
                            PRINT "USAGE 1:"
                            PRINT " %s[program name]"
                            PRINT "USAGE 2:"
                            PRINT " %s "; EnterKey
                        CASE "%c"
                            PRINT "%c(ase lower) prefix"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " %c[command]"
                        CASE "%l"
                            PRINT "%l(og) prefix"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " %l[command]"
                        CASE "%t"
                            PRINT "%t(ext) prefix"
                            PRINT
                            PRINT " %t[file name]"
                        CASE "%f"
                            PRINT "%f(ile list) prefix"
                            PRINT
                            PRINT "USAGE:"
                            PRINT " %f[wildcard file spec]"
                        CASE "%h"
                            CLS
                            PRINT "%h(elp) prefix"
                            PRINT
                            PRINT "USAGE:"
                            PRINT "%h[topic]"
                        CASE "prefix"
                            PRINT "Prefixes are an extension to VCore 386's environment."
                            PRINT
                            PRINT "Prefix syntax in help, such as %h[topic] implies that you"
                            PRINT "should type the prefix and it's modifier without the"
                            PRINT "brackets."
                            PRINT
                            PRINT "EXAMPLE:"
                            PRINT "This example, when typed into the VC386 prompt, lists all text files"
                            PRINT "in the current directory."
                            PRINT
                            PRINT " %f*.txt                '*.txt' is the modifier for the %f prefix"
                            PRINT
                            PRINT "Modifiers can be in any combination of uppercase and lowercase letters."
                            PRINT
                            PRINT "EXAMPLE:"
                            PRINT
                            PRINT " %f*.TXT"
                            PRINT "Or:"
                            PRINT " %f*.Txt"
                        CASE ELSE
                            PRINT CommandName$; ": topic not found"
                    END SELECT
                    GOTO MEProcess
                CASE "%s"
                    SHELL MID$(CommandName$, 3, LEN(CommandName$) - 2)
                    GOTO MEProcess
                CASE "%c"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    GOTO Bypass
                CASE "%f"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    FILES CommandName$
                    GOTO MEProcess
                CASE "%t"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    SHELL "edit " + CommandName$
                    GOTO MEProcess
                CASE "%g"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    SHELL "DISPGIF " + CommandName$
                    GOTO MEProcess
                CASE "%v"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    SHELL "TYPE " + CommandName$ + " | MORE"
                CASE "%l"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    OPEN "VCECMD.LOG" FOR APPEND AS #5
                    PRINT #5, CommandName$
                    CLOSE #5
                    GOTO Bypass
                CASE "%e"
                    SHELL MID$(CommandName$, 3, LEN(CommandName$) - 2)
                    END
                CASE "%H"
                    PRINT "cmd history"
                    PRINT
                    FOR i = 1 TO 100
                        IF HistoryBuffer(i) <> "" THEN
                            PRINT LTRIM$(RTRIM$(STR$(i))); ".", HistoryBuffer(i)
                        END IF
                    NEXT
                    GOTO MEProcess
                CASE "%r"
                    CommandName$ = LTRIM$(LCASE$(MID$(CommandName$, 3, LEN(CommandName$) - 2)))
                    ComVal% = VAL(CommandName$)
                    CommandName$ = LTRIM$(HistoryBuffer(ComVal%))
                    GOTO Bypass
            END SELECT
            IF LEN(CommandName$) > 0 THEN
              
                    SHELL "SCRPEXEC " + CommandName$
                
            ELSE
                'PRINT "Empty argument invalid."
            END IF
    END SELECT
GOTO MEProcess
ErrorHandler:
    PRINT CommandName$; ": "; LCASE$(ERROR$)
    CurError$ = "YES"
    RESUME NEXT

