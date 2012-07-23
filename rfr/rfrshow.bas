DECLARE SUB ShowBitmap (FileName$)
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
COMMON SHARED h1 AS BITMAPFILEHEADER
COMMON SHARED h2 AS BITMAPINFOHEADER
LINE INPUT "BMP File? ", Bmp$
CALL ShowBitmap(Bmp$)

SUB ShowBitmap (FileName$)
DIM pic(m, n, 2) AS LONG
SCREEN 12
OPEN FileName$ FOR BINARY AS #1
GET #1, , h1
GET #1, , h2

'h1: Bitmap FHeader      h2: Bitmap IHeader
'h3:  XGF Header
'h4:  16-color XGF       h5: true color XGF


DIM pix AS STRING * 1
DIM RGBentry AS STRING * 3
XRes = h2.biWidth
YRes = h2.biHeight

DIM PALentry AS STRING * 4

FOR i = YRes TO 1 STEP -1
FOR j = 1 TO XRes
   GET #1, , RGBentry
   PosRed = ASC(MID$(RGBentry, 3, 1))
   PosGreen = ASC(MID$(RGBentry, 2, 1))
   PosBlue = ASC(MID$(RGBentry, 1, 1))
   PSET (j, i), RGB(PosRed, PosGreen, PosBlue)
NEXT
    IF INT((XRes * 3) / 4) <> (XRes * 3) / 4 THEN
        FOR kk = 1 TO 4 - ((XRes * 3) MOD 4)
            GET #1, , pix
        NEXT
    END IF
NEXT



END SUB

