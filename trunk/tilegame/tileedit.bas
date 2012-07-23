DECLARE SUB DrawTrans ()
DECLARE SUB SetTransColor (NewColor AS INTEGER)
DECLARE SUB SaveTile ()
DECLARE SUB LoadTile ()
DECLARE SUB MouseHide ()
DECLARE SUB FatPSET (BYVAL X AS INTEGER, BYVAL Y AS INTEGER, BYVAL PColor AS INTEGER)
DECLARE FUNCTION FatX (TX AS INTEGER) AS INTEGER
DECLARE FUNCTION FatY (TY AS INTEGER) AS INTEGER
DECLARE FUNCTION PointInRect (PtX AS INTEGER, PtY AS INTEGER, ULX AS INTEGER, ULY AS INTEGER, BRX AS INTEGER, BRY AS INTEGER) AS INTEGER
DECLARE SUB DrawTile ()
DECLARE SUB SetColor (NewColor AS INTEGER)
DECLARE SUB DrawChrome ()
DECLARE SUB MousePoll (row%, col%, lButton%, rButton%)
DECLARE SUB MouseInit ()
DECLARE SUB MouseShow ()
DECLARE SUB InitScreen ()
DECLARE SUB Main ()
'
' tileedit
'  tile editor
'
'  Copyright (C) 2011 Coherent Logic Development LLC
'
' Author:  John Willis <john@coherent-logic.com>
' Created: 12/21/2011
'


DIM SHARED row AS INTEGER
DIM SHARED col AS INTEGER
DIM SHARED lButton AS INTEGER
DIM SHARED rButton AS INTEGER
DIM SHARED PaintColor AS INTEGER
OPTION BASE 0
'$INCLUDE: 'FONT.BI'

TYPE TileType
    Tilename AS STRING * 50
    Copyright AS STRING * 50
    TransColor AS INTEGER
    Buffer(32, 32) AS INTEGER
END TYPE

'DIM SHARED Tile(32, 32) AS INTEGER
DIM SHARED Tiles AS TileType

FOR X = 1 TO 32
    FOR Y = 1 TO 32
        Tiles.Buffer(X, Y) = 1
    NEXT
NEXT

DIM SHARED DocSaved AS INTEGER
DocSaved = 0

DIM SHARED FilePath AS STRING
FilePath = ""

DIM SHARED UpdateTrans AS INTEGER
UpdateTrans = 0

InitScreen
Main

SUB DrawChrome ()
    '
    ' DRAW CAPTION
    '
    X% = OutGText(10, 10, "PIGSE Tile Editor")
    LINE (0, 30)-(639, 30), 15

    '
    ' DRAW COLOR PICKER
    '
    DIM cpCol AS INTEGER
    DIM cpRow AS INTEGER

    DIM startX AS INTEGER
    DIM startY AS INTEGER

    DIM boxHeight AS INTEGER
    DIM boxWidth AS INTEGER

    boxHeight = 16
    boxWidth = 79

    startX = 0
    startY = 479 - 32

    DIM nextX AS INTEGER
    DIM nextY AS INTEGER
    nextX = startX
    nextY = startY

    DIM clrIndex AS INTEGER

    clrIndex = 0


    FOR cpRow = 1 TO 2
        FOR cpCol = 1 TO 8
            LINE (nextX, nextY)-(nextX + boxWidth, nextY + boxHeight), clrIndex, BF
            nextX = nextX + boxWidth
            clrIndex = clrIndex + 1
        NEXT cpCol
        nextX = 0
        nextY = nextY + 16
    NEXT cpRow
    

END SUB

SUB DrawTile ()
    DIM X AS INTEGER
    DIM Y AS INTEGER
    DIM TX AS INTEGER
    DIM TY AS INTEGER
    TX = 0
    TY = 0
    MouseHide
    FOR X = 0 TO 31
        FOR Y = 0 TO 31
            IF Tiles.Buffer(X, Y) <> Tiles.TransColor THEN
                PSET (X + 500, Y + 50), Tiles.Buffer(X, Y)
            END IF
            FatPSET X, Y, Tiles.Buffer(X, Y)
        NEXT
    NEXT
    MouseShow

   
END SUB

SUB DrawTrans ()
    X% = OutGText(3, 95, "Transparent:")
    LINE (10, 110)-(40, 135), Tiles.TransColor, BF
END SUB

SUB FatPSET (BYVAL X AS INTEGER, BYVAL Y AS INTEGER, BYVAL PColor AS INTEGER)
    DIM TX AS INTEGER
    DIM TY AS INTEGER

    X = X * 12
    Y = Y * 12
    TX = X + 60
    TY = Y + 60

    LINE (TX, TY)-(TX + 12, TY + 12), PColor, BF


    
END SUB

FUNCTION FatX (TX AS INTEGER) AS INTEGER

    FatX = (TX / 12) - (60 / 12)


END FUNCTION




FUNCTION FatY (TY AS INTEGER) AS INTEGER
    'TY = TY - 65 'compensate for offset from screen edge
    FatY = (TY / 12) - (60 / 12)

END FUNCTION

SUB InitScreen ()
    SCREEN 12
    UnregisterFonts
    reg% = RegisterFonts("HELVE.FON")
    lodstr$ = "h14"
    lod% = LoadFont(lodstr$)
    
    MouseInit
    MouseShow
    CLS
    DrawChrome
    DrawTile
    SetColor 15
    'SetTransColor 7
END SUB

SUB LoadTile ()
    SCREEN 0
    VIEW PRINT 1 TO 2
    COLOR 1, 15
    CLS
    PRINT "Load Tile"
    VIEW PRINT 2 TO 25
    COLOR 15, 1
    CLS
    LOCATE 10, 10
    LINE INPUT "Filename? ", FilePath
    OPEN FilePath FOR BINARY AS #1
    GET #1, , Tiles
    CLOSE #1
    UpdateTrans = 1
    'SetTransColor Tiles.TransColor
    InitScreen

END SUB

SUB Main ()
    DO
        SELECT CASE INKEY$
            CASE CHR$(27), "q", "Q"
                EXIT DO
            CASE "s", "S"
                'save
                SaveTile
            CASE "l", "L"
                'load
                LoadTile
            CASE "r", "R"
                'refresh
                DrawTile
        END SELECT

        DrawTrans

        IF UpdateTrans = 1 THEN
            SetTransColor Tiles.TransColor
            UpdateTrans = 0
        END IF

        MousePoll row, col, lButton, rButton

        ccolor% = POINT(col - 1, row - 1)
         
        'LINE (60, 65)-(317, 322), 7, B

        IF PointInRect(col, row, 61, 64, 512, 446) THEN
            CurCoord$ = "X: " + RTRIM$(STR$(FatX(col))) + "  Y: " + LTRIM$(STR$(FatY(row))) + " "
            LINE (500, 10)-(639, 23), 0, BF
            X% = OutGText(500, 10, CurCoord$)
        ELSE
            LINE (500, 10)-(639, 23), 0, BF
        END IF


        IF lButton = -1 THEN
            IF row > (479 - 32) THEN
                SetColor ccolor%
            END IF
            IF PointInRect(col, row, 61, 64, 512, 446) THEN
                Tiles.Buffer(FatX(col), FatY(row)) = PaintColor
                DocSaved = 0
                DrawTile
            END IF
        END IF
        IF rButton = -1 THEN
            IF row > (479 - 32) THEN
                SetTransColor ccolor%
            END IF
            IF PointInRect(col, row, 61, 64, 512, 446) THEN
                FOR i = 0 TO 31
                    FOR j = 0 TO 31
                        Tiles.Buffer(i, j) = PaintColor
                        DocSaved = 0
                    NEXT
                NEXT
                DrawTile
            END IF

        END IF
    LOOP

    
END SUB

FUNCTION PointInRect (PtX AS INTEGER, PtY AS INTEGER, ULX AS INTEGER, ULY AS INTEGER, BRX AS INTEGER, BRY AS INTEGER) AS INTEGER
    IF PtX >= ULX AND PtX <= BRX AND PtY >= ULY AND PtY <= BRY THEN
        PointInRect = 1
    ELSE
        PointInRect = 0
    END IF
END FUNCTION

SUB SaveTile ()
    SCREEN 0
    VIEW PRINT 1 TO 2
    COLOR 1, 15
    CLS
    PRINT "Save Tile"
    VIEW PRINT 2 TO 25
    COLOR 15, 1
    CLS
    LOCATE 10, 10
    LINE INPUT "Filename? ", FilePath
    LOCATE 11, 10
    LINE INPUT "Tile name? ", Tiles.Tilename
    LOCATE 12, 10
    LINE INPUT "Copyright? ", Tiles.Copyright
    OPEN FilePath FOR BINARY AS #1
    PUT #1, , Tiles
    CLOSE #1
    DocSaved = 1
    InitScreen

END SUB

SUB SetColor (NewColor AS INTEGER)
    PaintColor = NewColor
    X% = OutGText(3, 55, "Color:")
    LINE (10, 70)-(40, 90), PaintColor, BF
END SUB

SUB SetTransColor (NewColor AS INTEGER)
    ON LOCAL ERROR RESUME NEXT
    Tiles.TransColor = NewColor

END SUB

