#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <WinAPIFiles.au3>

if $CmdLine[0] = 0 Then
	$var1 = 'Fileoperate.exe "Drive | Open | Save | Folder | Replace | StripWS | FileFill | SetFileTime" "...."'
	MsgBox(4096, "Parameter Error", $var1, 10)
	Exit(1)
EndIf

Local $gvar = StringUpper(Stringstripws($CmdLine[1], 3))
Local $var1 = ""

RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinPE", "")
If Not @error Then
	If Not FileExists(@SystemDir & "\config\systemprofile\Desktop") Then DirCreate(@SystemDir & "\config\systemprofile\Desktop")
EndIf

Select
	Case $gvar = "DRIVE"
		Switch $CmdLine[0]
		Case 1 to 3
			Local $prefix = "", $title = ""
			If $CmdLine[0] >= 2 Then $prefix = $CmdLine[2]
			If $CmdLine[0] >= 3 Then $title = $CmdLine[3]
			$var1 = mySelectDrive($prefix, $title)
		Case Else
			MsgBox(4096, "Parameter Error", 'Fileoperate.exe "Drive" "prefix" "title" >Temp.bat', 10)
			Exit(1)
		EndSwitch
		Local $outstring = $CmdLine[2] & Stringstripws($var1, 3)
		ConsoleWrite($outstring)

	Case $gvar = "OPEN"
		Switch $CmdLine[0]
		Case 5
			$var1 = FileOpenDialog($CmdLine[3], $CmdLine[4], $CmdLine[5])
		Case 6
			$var1 = FileOpenDialog($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6])
		Case 7
			$var1 = FileOpenDialog($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6], $CmdLine[7])
		Case 8
			$var1 = FileOpenDialog($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6], $CmdLine[7], $CmdLine[8])
		Case Else
			$var1 = 'Fileoperate.exe "Open" "prefix" "title" "init dir" "(filter)" [options ["default name" [hwnd]]] >Temp.bat|.txt'
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndSwitch
		If @error Then Exit(1)
		Local $outstring = ""
		If Not StringInStr($var1, "|") Then
			$outstring = $CmdLine[2] & Stringstripws($var1, 3)
		ElseIf BitAND(Number($CmdLine[6]), 4) = 4 Then
			$aArray = StringSplit($var1, "|", 1)
			Local $Head = '"' & $aArray[1]
			For $i = 2 To $aArray[0]
				$outstring &= $Head & "\" & $aArray[$i] & '"' & @CRLF
			Next
		EndIf
		ConsoleWrite($outstring)

	Case $gvar = "SAVE"
		Switch $CmdLine[0]
		Case 5
			$var1 = FileSaveDialog($CmdLine[3], $CmdLine[4], $CmdLine[5])
		Case 6
			$var1 = FileSaveDialog($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6])
		Case 7
			$var1 = FileSaveDialog($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6], $CmdLine[7])
		Case 8
			$var1 = FileSaveDialog($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6], $CmdLine[7], $CmdLine[8])
		Case Else
			$var1 = 'Fileoperate.exe "Save" "prefix" "title" "init dir" "(filter)" [options ["default name" [hwnd]]] >Temp.bat'
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndSwitch
		If @error Then Exit(1)
		Local $outstring = $CmdLine[2] & Stringstripws($var1, 3)
		ConsoleWrite($outstring)

	Case $gvar = "FOLDER"
		Switch $CmdLine[0]
		Case 4
			$var1 = FileSelectFolder($CmdLine[3], $CmdLine[4])
		Case 5
			$var1 = FileSelectFolder($CmdLine[3], $CmdLine[4], $CmdLine[5])
		Case 6
			$var1 = FileSelectFolder($CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6])
		Case Else
			$var1 = 'Fileoperate.exe "Folder" "prefix" "title" "root dir" [ flag [ "initial dir" [, hwnd]]] >Temp.bat'
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndSwitch
		If @error Then Exit(1)
		Local $outstring = $CmdLine[2] & Stringstripws($var1, 3)
		ConsoleWrite($outstring)

	Case $gvar = "REPLACE"
		Switch $CmdLine[0]
		Case 5
			ReplaceInFile($CmdLine[2], $CmdLine[3], $CmdLine[4], $CmdLine[5])
		Case 6
			ReplaceInFile($CmdLine[2], $CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6])
		Case 7
			ReplaceInFile($CmdLine[2], $CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6], $CmdLine[7])
		Case Else
			Local $var1 = 'Fileoperate.exe "Replace" "FilePath" "SearchString" "ReplaceString" type=0;RegExp [Count or CaseSensitive=0, [curance=1]]'
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndSwitch

	Case $gvar = "STRIPWS"
		Switch $CmdLine[0]
		Case 3
			ReplaceInFile($CmdLine[2], "", "", Number($CmdLine[3]))
		Case Else
			MsgBox(4096, "Parameters Error", 'Fileoperate.exe "StripWS" "file.txt" [1|+2|+4|+8]')
			Exit(1)
		EndSwitch

	Case $gvar = "FILEFILL"
		Switch $CmdLine[0]
		Case 4 To 6
			Local $hFile = FileGetLongName(Stringstripws($CmdLine[3], 3), 1)
			Local $Count = Int(Number($CmdLine[4]))
			If $Count < 2 Then Exit(1)
			Local $aArray[$Count], $fchar = chr(32), $icode = 0
			If $CmdLine[0] >= 5 Then $fchar = String($CmdLine[5])
			If $CmdLine[0] > 5 Then $fchar = Number($CmdLine[6])
			For $i = 0 To $Count -1
				$aArray[$i] = $fchar
			Next
			FileWrite($hFile, StringFromASCIIArray($aArray, 0, -1, $icode))	; 0 = UTF-16 (Default)	1 = ANSI	2 = UTF-8
		Case Else
			$var1 = 'Fileoperate.exe "FileFill" "FilePath" "RepeatTimes" ["char(Default=space)" ["code(0=UTF-16 Default,1=ANSI,2=UTF-8)]]"'
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndSwitch
		If @error Then Exit(1)
		Local $outstring = $CmdLine[2] & Stringstripws($var1, 3)
		ConsoleWrite($outstring)

	Case $gvar = "SETFILETIME"
		Local $sFile = Stringstripws($CmdLine[2], 3)
		Switch $CmdLine[0]
		Case 2
			SetFileTime($sFile)
		Case 3
			SetFileTime($sFile, $CmdLine[3])
		Case 8
			SetFileTime($sFile, $CmdLine[3], $CmdLine[4], $CmdLine[5], $CmdLine[6], $CmdLine[7], $CmdLine[8])
		Case Else
			$var1 = 'Fileoperate.exe "SetFileTime" "FilePath" [ -1=SystemTime|Year [MON, MDAY, HOUR, MIN, SEC]]"'
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndSwitch

	Case Else
		$var1 = 'Fileoperate.exe "Drive | Open | Save | Folder | Replace |StripWS" "...."'
		MsgBox(4096, "Parameter Error", $var1, 10)
		Exit(1)
EndSelect
Exit(0)

#CS
(1) = strip leading white space
(2) = strip trailing white space
(4) = strip double (or more) spaces between words
(8) = strip all spaces (over-rides all other flags)
#CE


Func mySelectDrive($prefix, $title0)
	Local $aData, $iString = "", $Drvid = "", $Label, $FsType, $BusType, $Diskid, $Partid
	Local $Drive = DriveGetDrive("Fixed")
	If @error Then
		MsgBox(4096, "", "Get disk information have an error occurred.")
	Else
		For $i = 1 To $Drive[0]
			$Label = DriveGetLabel($Drive[$i] & "\")
			$FsType = DriveGetType($Drive[$i] & "\", 1)	
			$BusType = DriveGetType($Drive[$i] & "\", 3)			
			$Diskid = ""
			$Partid = ""
			$aData = _WinAPI_GetDriveNumber($Drive[$i])
			If IsArray($aData) Then
				$Diskid = $aData[1]
				$Partid = (Number($aData[2])=-1) ? ("") : ($aData[2])
			EndIf	
			$iString &= StringFormat('%2s  %1s.%1s:   %-16.14s\t%-18.16s\t%-22.20s |', _
				StringUpper($Drive[$i]), $Diskid, $Partid, $Label, $FsType, $BusType)
		Next		
		Local $String = StringTrimRight($iString, 1)
	EndIf

	$title = StringIsSpace($title0) ? ("GetDiskDrive") : ($title0)
	Local $hGUI = GUICreate($title, 360, 50)
	$Combo = GUICtrlCreateCombo("", 10, 10, 300, 20)
	GUICtrlSetData(-1, $String, $Drvid)
	$Ok = GUICtrlCreateButton("OK", 320, 10, 30, 22)
	GUISetState()

	While 1
		Switch GUIGetMsg()
		Case -3
			$String = ""
			ExitLoop
		Case $Ok
			$String = StringLeft(GUICtrlRead($Combo), 2)
			ExitLoop
		EndSwitch
	WEnd
    GUIDelete($hGUI)
	Return $String
EndFunc


Func ReplaceInFile($sFile, $sSearchString, $sReplaceString, $itype, $iCaseSensitive = 0, $iOccurance = 1)
	Local $sFilePath = FileGetLongName(Stringstripws($sFile, 3), 1)
	If StringInStr(FileGetAttrib($sFilePath), "R") Then Return SetError(1, 0, -1)
	If $iCaseSensitive = Default Then $iCaseSensitive = 0
	If $iOccurance = Default Then $iOccurance = 1

	Local $aArray = FileReadToArray($sFilePath)
	Local $iLineCount = @extended
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error) ; An error occurred reading the current script file.
		Return SetError(1, 0, -1)
	EndIf
	$oFile = FileOpen($sFilePath, 2)
	Local $isSpace =  StringIsSpace($sSearchString)
	For $i = 0 To $iLineCount - 1 ; Loop through the array. UBound($aArray) can also be used.
		; Replace strings
		if $isSpace Then
			$sFileRead  = StringStripWS($aArray[$i], $itype)
		ElseIf $itype = 0 Then
			$sFileRead = StringRegExpReplace($aArray[$i], $sSearchString, $sReplaceString, $iCaseSensitive)
		Else
			$sFileRead = StringReplace($aArray[$i], $sSearchString, $sReplaceString, 1 - $iOccurance, $iCaseSensitive)
		EndIf
		FileWriteLine($oFile, $sFileRead)
	Next
	FileClose($oFile)
EndFunc


Func SetFileTime($sFile, $sYEAR=@YEAR, $sMON=@MON, $sMDAY=@MDAY, $sHOUR=@HOUR, $sMIN=@MIN, $sSEC=@SEC)
    Local $hFile, $tFile
    $hFile = _WinAPI_CreateFile($sFile, 2, 4)
    If $hFile = 0 Then Exit(1)
	If Number($sYEAR) < 0 Then
		Local $tSystem = _Date_Time_GetSystemTime()
		$tFile = _Date_Time_SystemTimeToFileTime($tSystem)
	Else
		$tFile = _Date_Time_EncodeFileTime($sMON, $sMDAY, $sYEAR, $sHOUR, $sMIN, $sSEC)
	EndIf
	_Date_Time_SetFileTime($hFile, $tFile, $tFile, $tFile)
    _WinAPI_CloseHandle($hFile)
EndFunc