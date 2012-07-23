
DECLARE FUNCTION nGetNextTile () AS INTEGER
'$INCLUDE: '\VBDOS\CONSTANT.BI'
'$INCLUDE: '\VBDOS\FONT.BI'

'OPTION BASE 1

TYPE XPFILEHEADER
    vs AS INTEGER
    hs AS INTEGER
    dm AS INTEGER
    dw AS INTEGER
    dh AS INTEGER
    pt AS STRING * 25
END TYPE

TYPE XPicRec
    pelmap(32, 32) AS INTEGER
END TYPE
TYPE BGRec
    tilemap(20, 20) AS INTEGER
END TYPE
DIM header AS XPFILEHEADER
DIM prec AS XPicRec

DIM LAND_TILE(32, 32) AS INTEGER
DIM WATER_TILE(32, 32) AS INTEGER
DIM PLAYER_TILE(32, 32) AS INTEGER
DIM TREASURE_TILE(32, 32) AS INTEGER
DIM BOAT_TILE(32, 32) AS INTEGER
DIM CASTLE_TILE(32, 32) AS INTEGER
DIM NAME_MAP(20, 20) AS STRING * 25
DIM TILE_MAP(20, 20) AS INTEGER
DIM BACKGROUND_MAP(20, 20) AS INTEGER
DIM EXPLORED_MAP(20, 20) AS INTEGER
DIM ANIPEL_MAP(20, 20) AS INTEGER

DIM bgmap AS BGRec
r% = RegisterFonts("tmsre.fon")
l% = LoadFont("h8/h12/h24")
SelectFont 2
CLS
PRINT "Master of the Empire"
PRINT "for Intel 386 or higher, VGA 16 color"
PRINT
PRINT
PRINT "Beta Release 0.97.3 (build 3, 12/4/97)"
PRINT "written by John Willis and Chris Till"
PRINT
PRINT
PRINT "Please report any problems to John Willis via e-mail (jwillis@zianet.com)"
PRINT "Telephone calls are welcome, (505) 521-4287 (number for John Willis)"
PRINT
PRINT
PRINT "There should be two utilities included with the program. These are"
PRINT "BMP2TILE.EXE and BKGDEDIT.EXE. The first utility is a converter that"
PRINT "allows you to convert BMP files (used by Windows) to the PEL files used"
PRINT "by the game. This is helpful if you wish to change any of the tiles that"
PRINT "were supplied with the game. They are LAND.PEL, WATER.PEL, PLAYER.PEL,"
PRINT "CASTLE.PEL, BOAT.PEL, and TREASURE.PEL. Any BMP files that you wish to"
PRINT "convert must be stored in non-indexed, RGB-mode true color bitmaps. 256 color"
PRINT "bitmaps will not work. The files must also be 32x32 pixels."
PRINT
PRINT "Have fun!"
LOCATE 25, 1
PRINT "Press ESC to continue...";
SLEEP
CLS
PRINT "Please help support the MOTE project. If you know a faster"
PRINT "programming language than QuickBasic 4.5, please let me know."
PRINT
PRINT "If any of you know C/C++ game programming, I would be greatly"
PRINT "pleased if you would come aboard the project and help rewrite"
PRINT "the existing code to make it faster."
PRINT
PRINT
PRINT "Support your local charities, and remember that"
PRINT "Jesus is the answer."
PRINT
PRINT "Endorsement of the pro-life movement is simply the"
PRINT "endorsement of capital punishment for a crime which was"
PRINT "never committed."
PRINT
PRINT "No orcs or griffins were harmed in the making of this"
PRINT "project."
PRINT
PRINT "Please wait..."

DO
    jind = jind + 1
    IF jind = 3200 THEN EXIT DO
    LOCATE 23, 1
    PRINT "/";
    SOUND 32767, 1
    LOCATE 23, 1
    PRINT "|";
    SOUND 32767, 1
    LOCATE 23, 1
    PRINT "-";
    SOUND 32767, 1

LOOP

CLS
PRINT "< < < M A S T E R   O F   T H E   E M P I R E > > >"
PRINT
PRINT "Initial Configuration"
PRINT
PRINT "level file"
PRINT "use this option to change the default level file."
PRINT "This will only be useful if you have created a new"
PRINT "level file with the BKGDEDIT.EXE program included"
PRINT "on the disk. If you have not done this, just press"
PRINT "ENTER."
PRINT
LINE INPUT "Level File [ENTER for default]? ", lfile$
IF lfile$ = "" THEN
    lfile$ = "c:\xos\default.bg"
END IF

PRINT "< < < M A S T E R   O F   T H E   E M P I R E > > >"
PRINT
PRINT "Game Instructions"


ON ERROR RESUME NEXT
SCREEN 12
'WINDOW SCREEN (1, 1)-(640, 640)

OPEN lfile$ FOR BINARY AS #1
GET #1, , bgmap
CLOSE #1
FOR i = 1 TO 20
FOR j = 1 TO 20
    BACKGROUND_MAP(i, j) = bgmap.tilemap(i, j)
NEXT
NEXT

OPEN "C:\XOS\CASTLE.PEL" FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1
FOR i = 1 TO 32
    FOR j = 1 TO 32
        CASTLE_TILE(i, j) = prec.pelmap(i, j)
    NEXT
NEXT


OPEN "C:\XOS\LAND.PEL" FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1

FOR i = 1 TO 20
FOR j = 1 TO 20
    ANIPEL_MAP(i, j) = 0
NEXT
NEXT
FOR i = 1 TO 32
    FOR j = 1 TO 32
        LAND_TILE(i, j) = prec.pelmap(i, j)
    NEXT
NEXT

OPEN "C:\XOS\BOAT.PEL" FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1

FOR i = 1 TO 32
    FOR j = 1 TO 32
        BOAT_TILE(i, j) = prec.pelmap(i, j)
    NEXT
NEXT


OPEN "C:\XOS\TREASURE.PEL" FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1

FOR i = 1 TO 32
    FOR j = 1 TO 32
        TREASURE_TILE(i, j) = prec.pelmap(i, j)
    NEXT
NEXT

OPEN "C:\XOS\WATER.PEL" FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1

FOR i = 1 TO 32
    FOR j = 1 TO 32
        WATER_TILE(i, j) = prec.pelmap(i, j)
    NEXT
NEXT

OPEN "C:\XOS\PLAYER.PEL" FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1

FOR i = 1 TO 32
    FOR j = 1 TO 32
        PLAYER_TILE(i, j) = prec.pelmap(i, j)
    NEXT
NEXT


FOR i = 1 TO 20
    FOR j = 1 TO 20
        TILE_MAP(i, j) = 1
    NEXT
NEXT

FOR i = 1 TO 20
    FOR j = 1 TO 20
        TILE_MAP(i, j) = TILE_MAP(i - 1, j) + 32
    NEXT
NEXT
CLS
FOR i = 1 TO 20
    FOR j = 1 TO 20
        'PSET (TILE_MAP(i, j), TILE_MAP(j, i)), 15

        ';PRINT j, i, TILE_MAP(i, j), TILE_MAP(j, i)
        ';IF CSRLIN >= 24 THEN
        ';    SLEEP
        ';    CLS
        ';END IF


    NEXT
NEXT
'SLEEP

FOR g = 1 TO 20
FOR h = 1 TO 20
FOR i = 1 TO 32
    FOR j = 1 TO 32
        SELECT CASE BACKGROUND_MAP(g, h)
            CASE 1, 4
                PSET (i + TILE_MAP(g, h), j + TILE_MAP(h, g)), WATER_TILE(i, j)
                NAME_MAP(g, h) = "Water"

            CASE 2
                hpos = g
                vpos = h
                PSET (i + TILE_MAP(g, h), j + TILE_MAP(h, g)), LAND_TILE(i, j)
                NAME_MAP(g, h) = "Land"


            CASE 7
                PSET (i + TILE_MAP(g, h), j + TILE_MAP(h, g)), CASTLE_TILE(i, j)
                NAME_MAP(g, h) = "Castle"

            CASE 3
                PSET (i + TILE_MAP(g, h), j + TILE_MAP(h, g)), TREASURE_TILE(i, j)
                NAME_MAP(g, h) = "Treasure"
            CASE 1000
                
                ANIPEL_MAP(BACKGROUND_MAP(g, h), BACKGROUND_MAP(h, g)) = 1
                shpos = BACKGROUND_MAP(g, h)
                svpos = BACKGROUND_MAP(h, g)
                PSET (i + TILE_MAP(g, h), j + TILE_MAP(h, g)), BOAT_TILE(i, j)
        END SELECT
    NEXT
    NEXT
NEXT
NEXT
shpos = 6
svpos = 9
            FOR i = 2 TO 19
                FOR j = 2 TO 19
                    IF BACKGROUND_MAP(j, i) = 2 THEN
                        hpos = i
                        vpos = j
                        EXIT FOR
                    END IF
                NEXT
            NEXT
            FOR i = 1 TO 32
                FOR j = 1 TO 32
                    PSET (i + TILE_MAP(hpos, vpos), j + TILE_MAP(vpos, hpos)), PLAYER_TILE(i, j)

                NEXT
            NEXT
SetGTextDir (1)
OStr$ = "Master Of The Empire"
SelectFont 3
SetGTextColor (12)
textlen% = OutGText(0, 480, OStr$)
SetGTextDir (0)
SelectFont 2

DO
    FOR i = 1 TO 20
        FOR j = 1 TO 20
            IF BACKGROUND_MAP(i, j) = 1 THEN
                PSET (i + 300, j), 1
            ELSE
                PSET (i + 300, j), 10
            END IF
            IF i = hpos AND j = vpos THEN
                PSET (i + 300, j), 12
                PSET (i + 299, j), 12
                PSET (i + 301, j), 12
                PSET (i + 300, j - 1), 12
                PSET (i + 300, j + 1), 12

            END IF

        NEXT
    NEXT
    
    gloop = gloop + 1
        IF gloop >= 100 THEN
            gloop = 0
redo:
            IF NOT BACKGROUND_MAP(shpos + 1, svpos) = 2 AND direction <> 2 THEN
                direction = 1'right
            ELSE
                direction = 2'left
            END IF
            SELECT CASE direction
                CASE 1
                    shpos = shpos + 1
                    FOR i = 1 TO 32
                    FOR j = 1 TO 32
                    PSET (i + TILE_MAP(shpos - 1, svpos), j + TILE_MAP(svpos, shpos - 1)), WATER_TILE(i, j)
                    NEXT
                    NEXT
                CASE 2
                    IF BACKGROUND_MAP(shpos - 1, svpos) = 2 THEN
                        direction = 1
                        GOTO redo
                    END IF

                    shpos = shpos - 1
                    FOR i = 1 TO 32
                    FOR j = 1 TO 32

                    PSET (i + TILE_MAP(shpos + 1, svpos), j + TILE_MAP(svpos, shpos - 1)), WATER_TILE(i, j)
                    NEXT
                    NEXT
                    
            END SELECT
            FOR i = 1 TO 32
                FOR j = 1 TO 32
                    PSET (i + TILE_MAP(shpos, svpos), j + TILE_MAP(svpos, shpos)), BOAT_TILE(i, j)
                NEXT
            NEXT
        END IF
            

                    
    LOCATE 1, 1
    OStr$ = "SCORE: " + FORMAT$(score, "###,###") + "   " + NAME_MAP(hpos, vpos)

    PRINT "                       ";
    'textlen% = OutGText(1, 1, "                       ")
    SetGTextDir (0)
    textlen% = OutGText(1, 1, OStr$)

    LOCATE 2, 1
    PRINT "ITEM";
    In$ = INKEY$

    IF In$ <> "" THEN
            lasth = hpos
            lastv = vpos
        'SOUND 37, .1
        moves = moves + 1
        SELECT CASE In$
            CASE CHR$(27)
                END
            CASE CHR$(0) + "M" 'Right Arrow
                lasth = hpos
                lastv = vpos
                IF NOT BACKGROUND_MAP(hpos + 1, vpos) = 1 THEN
                    IF NOT hpos = 19 THEN hpos = hpos + 1
                END IF
            CASE CHR$(0) + "K" 'Left arrow
                lasth = hpos
                lastv = vpos

                IF NOT BACKGROUND_MAP(hpos - 1, vpos) = 1 THEN
                    IF NOT hpos = 1 THEN hpos = hpos - 1
                END IF
            CASE CHR$(0) + "H" 'Up arrow
                lasth = hpos
                lastv = vpos
                IF NOT BACKGROUND_MAP(hpos, vpos - 1) = 1 THEN
                    IF NOT vpos = 1 THEN vpos = vpos - 1
                END IF
            CASE CHR$(0) + "P" 'Down arrow
                lasth = hpos
                lastv = vpos
                IF NOT BACKGROUND_MAP(hpos, vpos + 1) = 1 THEN
                    IF NOT vpos = 19 THEN vpos = vpos + 1
                END IF
        END SELECT
            IF EXPLORED_MAP(hpos, vpos) = 0 THEN
                EXPLORED_MAP(hpos, vpos) = 1
                score = score + 10
            END IF
            IF BACKGROUND_MAP(hpos, vpos) = 3 THEN
                ITEM_HAVESHIP = TRUE
                score = score + 1000
                FOR i = 1 TO 32
                    FOR j = 1 TO 32
                        PSET (i, j + 50), TREASURE_TILE(i, j)
                    NEXT
                NEXT
                PLAY "L32EC"
                BACKGROUND_MAP(hpos, vpos) = 2
            END IF

            FOR i = 1 TO 32
                FOR j = 1 TO 32
                    PSET (i + TILE_MAP(hpos, vpos), j + TILE_MAP(vpos, hpos)), PLAYER_TILE(i, j)

                NEXT
            NEXT
            IF lasth <> hpos OR lastv <> vpos THEN
            FOR i = 1 TO 32
                FOR j = 1 TO 32
                    SELECT CASE BACKGROUND_MAP(lasth, lastv)
                        CASE 1
                            PSET (i + TILE_MAP(lasth, lastv), j + TILE_MAP(lastv, lasth)), WATER_TILE(i, j)
                        CASE 2
                            PSET (i + TILE_MAP(lasth, lastv), j + TILE_MAP(lastv, lasth)), LAND_TILE(i, j)
                        CASE 3
                            PSET (i + TILE_MAP(lasth, lastv), j + TILE_MAP(lastv, lasth)), TREASURE_TILE(i, j)
                        CASE 7
                            PSET (i + TILE_MAP(lasth, lastv), j + TILE_MAP(lastv, lasth)), CASTLE_TILE(i, j)

                        

                    END SELECT
                NEXT
            NEXT
            END IF

    END IF
LOOP

FUNCTION nGetNextTile () AS INTEGER

END FUNCTION

