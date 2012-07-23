'
' XLIB
'  Core routines for XOS
'
'  Copyright (C) 2011
'  Coherent Logic Development LLC
'
DECLARE FUNCTION XosProfileRead$ (IniFile$, IniSection$, IniKey$)
DECLARE SUB XosProfileWrite (IniFile$, IniSection$, IniKey$, ProfileStr$)
DECLARE FUNCTION XosBase$ ()
DECLARE FUNCTION XosXtGetIPC (TKey AS STRING) AS STRING
DECLARE SUB XosXtSetIPC (TKey AS STRING, TValue AS STRING)
DECLARE SUB XosXtSpawn (TaskPath AS STRING)
DECLARE SUB XosGpiInit ()

