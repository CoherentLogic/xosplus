DECLARE SUB dnlCreateINL (LinkTitle AS STRING, ConvType AS STRING)
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
'
'DLINK2.BAS
'DynaLink 2.0
'
'$INCLUDE: '\VBDWSHOP\PROFILE.BI'
'$INCLUDE: '\VBDOS\CONSTANT.BI'



DIM SHARED dnlAppRegName AS STRING

SUB dnlAcknowledgeINL (LinkTitle AS STRING)
    CALL ProfileWrite("\XOS\DLCONV.DNL", "Messages", "Acknowledge", LinkTitle)
    DO UNTIL ProfileRead$("\XOS\DLCONV.DNL", "Messages", "Accept") = LinkTitle
    LOOP
END SUB

SUB dnlClearINLResources (LinkTitle AS STRING, nFirst AS INTEGER, nLast AS INTEGER)
    DIM Iter AS INTEGER
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    IF Temp$ = "dnlTrue" THEN
        FOR Iter = nFirst TO nLast
            CALL dnlSetINLData(LinkTitle, Iter, "")
        NEXT Iter
        'FUCK!dnlSetINLType APP_REGNAME, ""
    ELSE
        
    END IF
END SUB

SUB dnlCreateINL (LinkTitle AS STRING, ConvType AS STRING)
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    IF Temp$ = "dnlTrue" THEN
        CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlShare", "dnlTrue")
        CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlConvType", ConvType)
    ELSE
        
    END IF
END SUB

SUB dnlLockResource (LinkTitle AS STRING)
    CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlShare", "dnlFalse")
END SUB

SUB dnlSetActiveINL (LinkTitle AS STRING)
    CALL ProfileWrite("\XOS\DLCONV.DNL", "Conversations", "dnlActive", LinkTitle)
END SUB

SUB dnlSetINLClientID (LinkTitle AS STRING, ClientID AS STRING)
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    IF Temp$ = "dnlTrue" THEN
        CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlClientID", ClientID)
    ELSE
        
    END IF
END SUB

SUB dnlSetINLData (LinkTitle AS STRING, DataField AS INTEGER, dnlData AS STRING)
    ON LOCAL ERROR RESUME NEXT
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    IF Temp$ = "dnlTrue" THEN
        Temp$ = "dnlStrData"
        Temp$ = Temp$ + LTRIM$(RTRIM$(STR$(DataField)))
        DO
            CALL ProfileWrite("C:\XOS\DLCONV.DNL", LinkTitle, Temp$, dnlData)
        LOOP UNTIL szINLData(LinkTitle, DataField) = dnlData
    ELSE
        
    END IF
END SUB

SUB dnlSetINLServerID (LinkTitle AS STRING, ServerID AS STRING)
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    IF Temp$ = "dnlTrue" THEN
        CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlServerID", ServerID)
    ELSE
        
    END IF
END SUB

SUB dnlSetINLType (LinkTitle AS STRING, INLType AS STRING)
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    IF Temp$ = "dnlTrue" THEN
        CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlConvType", INLType)
    ELSE
        
    END IF
END SUB

SUB dnlSetWinClipboard (SourceData AS STRING)
    ON LOCAL ERROR RESUME NEXT
    DO
        OPEN "\XOS\DL2CBDBF.TFD" FOR OUTPUT AS #5
        IF ERR = 55 THEN
            S$ = "NO"
        ELSE
            S$ = "YES"
            PRINT #5, SourceData
            CLOSE #5
            EXIT DO
        END IF
        CLOSE #5
    LOOP
END SUB

SUB dnlUnlockResource (LinkTitle AS STRING)
    CALL ProfileWrite("\XOS\DLCONV.DNL", LinkTitle, "dnlShare", "dnlTrue")
END SUB

FUNCTION nQueryDriver (TestString AS STRING, DelayLoop AS INTEGER) AS INTEGER
    Active$ = "PROHIBITED"
    CALL dnlUnlockResource(Active$)
    CALL dnlCreateINL(Active$, "XTD")
    Start! = TIMER
    DO WHILE NOT TIMER - Start! > DelayLoop

        CALL dnlUnlockResource(Active$)
        CALL dnlSetINLData(Active$, 32700, TestString)
        CALL dnlSetINLData(Active$, 1, "qdrv")
        CALL dnlUnlockResource(Active$)
        CALL dnlSetActiveINL(Active$)

        IF LTRIM$(RTRIM$(szINLData(Active$, 32701))) = "receive" THEN
            
            nQueryDriver = TRUE
            PRINT "DLINK2:  "; szINLData(Active$, 32701)
            dnlSetINLData Active$, 32701, ""
            EXIT FUNCTION
        ELSE
            nQueryDriver = FALSE
        END IF
    LOOP
    nQueryDriver = FALSE
END FUNCTION

FUNCTION nResourceLocked (LinkTitle AS STRING) AS INTEGER
    Temp$ = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlShare")
    SELECT CASE LCASE$(Temp$)
        CASE "dnltrue"
            nResourceLocked = FALSE
        CASE "dnlfalse"
            nResourceLocked = TRUE
    END SELECT
END FUNCTION

FUNCTION szActiveINL () AS STRING
    szActiveINL = ProfileRead$("\XOS\DLCONV.DNL", "Conversations", "dnlActive")
END FUNCTION

FUNCTION szGetWinClipboard () AS STRING
    ON LOCAL ERROR RESUME NEXT
    DO
        OPEN "\XOS\DL2CBDBF.TFD" FOR INPUT AS #5
        IF ERR = 55 THEN
            S$ = "NO"
        ELSE
            S$ = "YES"
            szGetWinClipboard = INPUT$(LOF(5), 5)
            CLOSE #5
            EXIT DO
        END IF
        CLOSE #5
    LOOP
END FUNCTION

FUNCTION szINLClientID (LinkTitle AS STRING) AS STRING
END FUNCTION

FUNCTION szINLData (LinkTitle AS STRING, DataField AS INTEGER) AS STRING
    Temp$ = "dnlStrData"
    Temp$ = Temp$ + LTRIM$(RTRIM$(STR$(DataField)))
    szINLData = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, Temp$)
END FUNCTION

FUNCTION szINLServerID (LinkTitle AS STRING) AS STRING
    szINLServerID = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlServerID")
END FUNCTION

FUNCTION szINLType (LinkTitle AS STRING) AS STRING
    szINLType = ProfileRead$("\XOS\DLCONV.DNL", LinkTitle, "dnlConvType")
END FUNCTION

