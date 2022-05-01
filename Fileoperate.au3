#NoTrayIcon

#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <WinAPIFiles.au3>
#include <String.au3>

if $CmdLine[0] = 0 Then
	$var1 = 'Fileoperate.exe "Drive | Open | Save | Folder | Replace | StripWS | FileFill | SRBInFile | PeChecksum | Str2Hex | Hex2Str |InputBox | SelectMenu | SetFileTime" "...."'
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

	Case $gvar = "STR2HEX"
		Switch $CmdLine[0]
		Case 2
			Local $strs = Stringstripws($CmdLine[2], 3)
			Local $pCase = StringTrimLeft(_String2Binary($strs), 2)
			ConsoleWrite($pCase )
		Case Else
			MsgBox(4096, "Parameters Error", 'Fileoperate.exe "Str2Hex" "[ANSI] | [UTF16LE] | [UTF16BE] | [UTF8]Strings" ')
			Exit(1)
		EndSwitch

	Case $gvar = "HEX2STR"
		Switch $CmdLine[0]
		Case 3
			Local $strs = Stringstripws($CmdLine[2], 3)
			Local $pCase = Stringstripws($CmdLine[3], 3)
			ConsoleWrite(_Binary2String($strs, $pCase) )
		Case Else
			MsgBox(4096, "Parameters Error", 'Fileoperate.exe "Hex2Str" "Hex" "[ANSI] | [UTF16LE] | [UTF16BE] | [UTF8]" ')
			Exit(1)
		EndSwitch

	Case $gvar = "INPUTBOX"
		Switch $CmdLine[0]
		Case 1
			Local $result = InputBox("Modify Bootmgr.exe", "Input 9 Chars", "\Boot\BCD" )
			If Not @error Then ConsoleWrite(StringLeft($result, 9))
		Case 2
			Local $strs = Stringstripws($CmdLine[2], 3)
			Local $result = InputBox("Modify Bootmgr.exe", "Input 9 Chars", $strs )
			If Not @error Then ConsoleWrite(StringLeft($result, 9))
		Case Else
			MsgBox(4096, "Parameters Error", 'Fileoperate.exe "InputBox" ["Default"] ')
			Exit(1)
		EndSwitch

	Case $gvar = "SELECTMENU"
		Switch $CmdLine[0]
		Case 3
			Local $title = Stringstripws($CmdLine[2], 3)
			Local $items = Stringstripws($CmdLine[3], 3)
            ConsoleWrite(wSelect($title, $items) )
		Case Else
			MsgBox(4096, "Parameters Error", 'Fileoperate.exe "SelectMenu" "Title" "item1|iteme2|..." ')
			Exit(1)
		EndSwitch

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

	Case $gvar = "SRBInFile"
		Switch $CmdLine[0]
		Case 4
			Local $hFile = FileGetLongName(Stringstripws($CmdLine[2], 3), 1)
			Local $tSource = _String2Binary($CmdLine[3])
			Local $iSize = BinaryLen($tSource)
			Local $tReplace = _String2Binary($CmdLine[4])
			If BinaryLen($tReplace) > $iSize Then $tReplace = BinaryMid($tReplace , 1, $iSize)
			Local $iFileSize = FileGetSize($hFile)
			Local $ReadData = ""
			$tFile = FileOpen($hFile, 17)
			Local $FilePos = 0
			While $FilePos < $iFileSize - $iSize
				FileSetPos($tFile, $FilePos, 0)
				$ReadData = FileRead($tFile, $iSize)
				If @error Then ExitLoop
				If Binary($ReadData) = $tSource Then
					FileSetPos($tFile, $FilePos, 0)
					FileWrite($tFile, $tReplace)
					If @error Then ExitLoop
					$FilePos = FileGetPos($tFile)
				Else
					$FilePos += 1
				EndIf
			WEnd
			FileClose($tFile)

		Case Else
			$var1 = 'Fileoperate.exe "SRBInFile" "FilePath" "[type]Source" "[type]Replace"'
			MsgBox(4096, "Parameter Error", $var1 & @CRLF & "[Type] = [ANSI] | [UTF16LE] | [UTF16BE] | [UTF8] | Space", 10)
			Exit(1)
		EndSwitch

	Case $gvar = "PeChecksum"
		If $CmdLine[0] < 2 Then
			$var1 = 'Fileoperate.exe "PeChecksum" "FilePath"(allow relative paths) '
			MsgBox(4096, "Parameter Error", $var1, 10)
			Exit(1)
		EndIf

		Local $hFile = FileGetLongName(Stringstripws($CmdLine[2], 3), 1)
		PECheckSum($hFile)

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


Func wSelect($title, $items)
	Local $lists = StringSplit($items, "|")
	Local $Fontsize = 9

	Local $high = $lists[0] * $Fontsize *3.8

	Local $width = 222, $strlen
	For $i = 1 To $lists[0]
		$strlen = StringLen($lists[$i]) * $Fontsize * 0.8
		$width = ($width > $strlen) ? ($width) : ($strlen)
	Next

	Local $sFont = "Segoe UI"
	GUICreate($title, $width, $high)
	GUISetFont($Fontsize, 400, 0, $sFont) ; will display underlined characters

	Local $id_Select = GUICtrlCreateButton("Select", 10, $high - 22, 50, 20)
	GUICtrlSetFont($id_Select, 10, 300, "")

	Local $id_Abort = GUICtrlCreateButton("Abort", 80, $high - 22, 50, 20)
	GUICtrlSetFont($id_Abort, 10, 500, "")

	Local $idMylist = GUICtrlCreateList($lists[1], 0, 10, $width - 2, $high - 30)
	GUICtrlSetLimit(-1, $width -12) ; to limit horizontal scrolling
	For $i = 1 To $lists[0]
		GUICtrlSetData(-1, $lists[$i])
	Next

	Local $mslect = ""
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
		Case -3
			ExitLoop
		Case $id_Select
			$mslect = GUICtrlRead($idMylist)
		    GUIDelete()
			Return $mslect
		Case $id_Abort
			ExitLoop
		EndSwitch
	WEnd
    GUIDelete()
	Return SetError(1)
EndFunc


Func _String2Binary($pData)
	Local $tData = ""
	Select
	Case StringRegExp($pData, "^(?|\[ANSI\])")
		$tData = StringToBinary(StringReplace($pData, "[ANSI]", "", 1, 1) , 1)
	Case StringRegExp($pData, "^(?|\[UTF16LE\])")
		$tData = StringToBinary(StringReplace($pData, "[UTF16LE]", "", 1, 1) , 2)
	Case StringRegExp($pData, "^(?|\[UTF16BE\])")
		$tData = StringToBinary(StringReplace($pData, "[UTF16BE]", "", 1, 1) , 3)
	Case StringRegExp($pData, "^(?|\[UTF8\])")
		$tData = StringToBinary(StringReplace($pData, "[UTF8]", "", 1, 1) , 4)
	Case Else
		$tData = $pData
	EndSelect
	Return SetError(0, 0, $tData)
EndFunc ; _String2Binary


Func _Binary2String($pData, $pCase)
	Local $iSelect
	Select
	Case StringRegExp($pCase, "^(?|\[ANSI\])" )
		$iSelect = 1
	Case StringRegExp($pCase, "^(?|\[UTF16LE\])" )
		$iSelect = 2
	Case StringRegExp($pCase, "^(?|\[UTF16BE\])" )
		$iSelect = 3
	Case StringRegExp($pCase, "^(?|\[UTF8\])" )
		$iSelect = 4
	Case Else
		$iSelect = 0
	EndSelect
	If $iSelect = 0 Then Return SetError(0, 1, $pData)
	Return SetError(0, 0, BinaryToString($pData, $iSelect))
EndFunc ; _Binary2String


Func PECheckSum($hFile)
	Local $FilePos, $ReadData = ""
	Local $rHeaderSum, $rCheckSum
	MapFileAndCheckSum($hFile, $rHeaderSum, $rCheckSum)
	If @error Then
		ConsoleWrite("Error occurred when CheckSum" & @CRLF)
		Return
	EndIf
	Local $CorrectChecksum = BinaryMid($rCheckSum, 1, 4)
;	MsgBox(4096, $rCheckSum, "Correct: " & $CorrectChecksum)

	If $rHeaderSum = $rCheckSum Then Return

	Local $tFile = FileOpen($hFile, 17)

	FileSetPos($tFile, 0, 0)
	$ReadData = FileRead($tFile, 2)
	If $ReadData <> "0x4D5A" Then ; DOS Header "MZ"- Mark Zbikowski
		ConsoleWrite('Not Found Magic DOS signature "MZ"' & @CRLF)
		Return SetError(1, 0 , "")
	EndIf

	FileSetPos($tFile, 0x3c, 0)
	$ReadData = FileRead($tFile, 4)
	Local $ioffset = Binary2UINT($ReadData)
;	MsgBox(4096, $ReadData, "PE-Offset: " & $ioffset)

	FileSetPos($tFile, $ioffset, 0)
	$ReadData = FileRead($tFile, 4)

	If $ReadData <> "0x50450000" Then ;	PE Magic Value
		ConsoleWrite('Not Found Magic PE signature "PE"' & @CRLF)
		Return SetError(1, 0 , "")
	EndIf

	FileSetPos($tFile, $ioffset + 0x58, 0)
;	MsgBox(4096, "FileGetPos", FileGetPos($tFile))

	FileWrite($tFile, $CorrectChecksum)
	FileClose($tFile)
	ConsoleWrite('Finish Correct Checksum' & @CRLF)
EndFunc	; ==>PECheckSum


Func Binary2UINT($Binary)
	Local $Buffer = DllStructCreate("byte[4]")
	DllStructSetData($Buffer, 1, Binary($Binary))
	Return DllStructGetData(DllStructCreate("UINT", DllStructGetPtr($Buffer)), 1)
EndFunc


Func MapFileAndCheckSum($sFile, ByRef $rHeaderSum, ByRef $rCheckSum)
    Local $aResult[3]
	Local $HeaderSum = DLLStructCreate("dword")
	Local $CheckSum = DLLStructCreate("dword")
    $aResult = DllCall("imagehlp.dll", "long" , "MapFileAndCheckSum" , "str" ,$sFile , "ptr" ,DllStructGetPtr($HeaderSum), "ptr" ,DllStructGetPtr($CheckSum))
    If $aResult[0] <> 0 Then
		ConsoleWrite("File CheckSum Error code: " & $aResult[0] & @CRLF)
		Return SetError(1, 0, "")
	EndIf
	$rHeaderSum = Binary(DllStructGetData($HeaderSum, 1))
    $rCheckSum = Binary(DllStructGetData($CheckSum,1))
    Return SetError(0)
EndFunc	; ==> MapFileAndCheckSum
