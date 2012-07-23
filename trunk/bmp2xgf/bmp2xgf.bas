'$INCLUDE: '\VBDWSHOP\PROFILE.BI'
TYPE BITMAPFILEHEADER
    bfType AS INTEGER
    bfSize AS LONG
    bfReserved1 AS INTEGER
    bfReserved2 AS INTEGER
    bfOffBits AS LONG
END TYPE
TYPE BITMAPINFOHEADER
    biSize AS LONG
    biWidth AS LONG
    biHeight AS LONG
    biPlanes AS INTEGER
    biBitCount AS INTEGER
    biCompression AS LONG
    biSizeImage AS LONG
    biXPelsPerMeter AS LONG
    biYPelsPerMeter AS LONG
    biClrUsed AS LONG
    biClrImportant AS LONG
END TYPE
TYPE XGIHEADER
    xhType AS STRING * 3
    xhColors AS INTEGER
    xhPixels AS LONG
END TYPE
TYPE XGIPIXEL '16-color XGF
    xpXLoc AS LONG
    xpYLoc AS LONG
    xpRGBColor AS LONG
END TYPE
TYPE COMPACT
    xpXLoc AS INTEGER
    xpYLoc AS INTEGER
    xpRGBColor AS INTEGER
END TYPE

TYPE WGIPIXEL 'True-Color XGF
    xpXLoc AS INTEGER
    xpYLoc AS INTEGER
    xpPelRed AS INTEGER
    xpPelGreen AS INTEGER
    xpPelBlue AS INTEGER
END TYPE
'TYPE GPH
'    PCol(640, 480) AS INTEGER
'END TYPE

COMMON SHARED h1 AS BITMAPFILEHEADER
COMMON SHARED h2 AS BITMAPINFOHEADER

COMMON SHARED h3 AS XGIHEADER
COMMON SHARED h4 AS XGIPIXEL
COMMON SHARED h5 AS WGIPIXEL
COMMON SHARED h6 AS COMPACT
FileName$ = COMMAND$
DIM pic(m, n, 2) AS LONG
SCREEN 12
OPEN FileName$ FOR BINARY AS #1
GET #1, , h1
GET #1, , h2
PRINT "XOS Graphics Manager 2.0"
PRINT
PRINT "Input information:"
PRINT "Windows Bitmap "; COMMAND$
PRINT "X: "; FORMAT$(h2.biWidth, "####")
PRINT "Y: "; FORMAT$(h2.biHeight, "####")
PRINT "Colors: "; FORMAT$(h2.biBitCount, "##")
PRINT

'h1: Bitmap FHeader      h2: Bitmap IHeader
'h3:  XGF Header
'h4:  16-color XGF       h5: true color XGF

PRINT "Main Menu"
PRINT
PRINT "1.  Output to 16-Color XGF"
PRINT "2.  Output to True Color XGF"
PRINT "3.  Output to old-style WGF"
'PRINT "4.  Output to dot-array GPH"
PRINT "4.  Output to compact 16-Color XGF"
PRINT "5.  Display Format Information"
PRINT
INPUT "->", Sel%
SELECT CASE Sel%
    CASE 1
        Xm$ = "16X"
    CASE 2
        Xm$ = "TCX"
    CASE 3
        Xm$ = "OSW"
    'CASE 4
    '    Xm$ = "GPH"
    CASE 4
        Xm$ = "C16"
    CASE 5
        CLS
        PRINT ""
END SELECT

LINE INPUT "Output file name? ", OutName$
OPEN OutName$ FOR BINARY AS #2

DIM pix AS STRING * 1
DIM RGBentry AS STRING * 3
XRes = h2.biWidth
YRes = h2.biHeight

h3.xhPixels = XRes * YRes
h3.xhType = Xm$
h3.xhColors = 16
IF Xm$ = "16X" OR Xm$ = "TCX" THEN
    PUT #2, , h3
END IF
DIM PALentry AS STRING * 4

FOR i = YRes TO 1 STEP -1
FOR j = 1 TO XRes
   GET #1, , RGBentry
   PosRed = ASC(MID$(RGBentry, 3, 1))
   PosGreen = ASC(MID$(RGBentry, 2, 1))
   PosBlue = ASC(MID$(RGBentry, 1, 1))
   'Handler for 16X
   IF Xm$ = "16X" THEN
        h4.xpXLoc = j
        h4.xpYLoc = i
        h4.xpRGBColor = RGB(PosRed, PosGreen, PosBlue)
        PUT #2, , h4
   END IF
   IF Xm$ = "TCX" OR Xm$ = "OSW" THEN
        h5.xpXLoc = j
        h5.xpYLoc = i
        h5.xpPelRed = PosRed
        h5.xpPelGreen = PosGreen
        h5.xpPelBlue = PosBlue
        PUT #2, , h5
   END IF
   PSET (j, i), RGB(PosRed, PosGreen, PosBlue)
NEXT
    IF INT((XRes * 3) / 4) <> (XRes * 3) / 4 THEN
        FOR kk = 1 TO 4 - ((XRes * 3) MOD 4)
            GET #1, , pix
        NEXT
    END IF
NEXT
SLEEP

