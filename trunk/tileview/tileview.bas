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

DIM header AS XPFILEHEADER
DIM prec AS XPicRec
ttop:
ON ERROR RESUME NEXT
 FileName$ = COMMAND$
'INPUT "Screen mode override? ", so%
'IF so% <> 32767 THEN header.dm = so%

OPEN FileName$ FOR BINARY AS #1
GET #1, , header
GET #1, , prec
CLOSE #1
SCREEN header.dm

WIDTH header.dw, header.dh
FOR i = 1 TO 32
    FOR j = 1 TO 32
        PSET (i + header.hs, j + header.vs), prec.pelmap(i, j)
    NEXT
NEXT
LOCATE 22, 1
PRINT header.pt
SLEEP

