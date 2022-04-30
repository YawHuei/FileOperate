The Program is compiled with AutoIt, x64 is compreesed with Upx, It can Run on Windows PE

The Program x86 Version may be marked as a virus.
See  https://www.autoitscript.com/wiki/AutoIt_and_Malware


On Windows PE, Will Add Folder "\Windows\System32\config\systemprofile\Desktop"

Fileoperate.exe "Drive | Open | Save | Folder | Replace | StripWS | FileFill | SRBInFile | PeChecksum | Str2Hex | InputBox | SelectMenu | SetFileTime" "...."'

1.
Fileoperate.exe "Drive" "prefix" "title" >Temp.bat
rem set "prefix" as "set drv="  
call Temp.bat
Or
Fileoperate.exe "Drive" "" "title" >Temp.txt
set /p drv=<Temp.txt

Example:
Fileoperate.exe "Drive" "set drvid=" "GetWindowsDiskDrive" >%temp%\temp.bat
if %errorlevel% EQU 1 goto :eof
call %temp%\temp.bat

Or
Fileoperate.exe "Drive" "" "GetWindowsDiskDrive" >%temp%\temp.txt
if %errorlevel% EQU 1 goto :eof
set /p drvid=<%temp%\temp.txt
DrivegetId.exe RV2UUID "%drvid%" >tmp.txt
set /p var=<tmp.txt
Result -> A0E0FD73E0FD5050


2.
Fileoperate.exe "Open" "prefix" "title" "init dir" "(filter)" [options ["default name" [hwnd]]] >Temp.bat|.txt 
For detailed usage, please refer to https://www.autoitscript.com/autoit3/docs/functions/FileOpenDialog.htm

Example:
%~dp0Fileoperate.exe "Open" "@set vhdfilef=" "select a VHDx File" "" "(*.vhd;*.vhdx)" 1 >%~dp0temp.bat
if %errorlevel% equ 1 (
	set "vhdfilef="
	goto :continue
)
call %~dp0temp.bat
for %%I in (%vhdfilef%) do (set "vhddrv=%%~dI") & (set "vhdpath=%%~pI") & (set "vhdfile=%%~nI") & (set "vhdfext=%%~xI")


3.
Fileoperate.exe "Save" "prefix" "title" "init dir" "(filter)" [options ["default name" [hwnd]]] >Temp.bat|.txt
For detailed usage, please refer to https://www.autoitscript.com/autoit3/docs/functions/FileSaveDialog.htm


4.
Fileoperate.exe "Folder" "prefix" "title" "root dir" [ flag [ "initial dir" [, hwnd]]] >Temp.bat|.txt
For detailed usage, please refer to https://www.autoitscript.com/autoit3/docs/functions/FileSelectFolder.htm
Example:
Fileoperate.exe "Folder" "" "Select a Folder" "" >%~dp0temp.txt
set /p tcd=<%~dp0temp.txt
if not [%tcd%]==[] %ComSpec% /k cd /d %tcd%


5.
Fileoperate.exe "Replace" "FilePath" "SearchString" "ReplaceString" type(Default=0,RegExp) [Count or CaseSensitive=0, [curance=1]]
"FilePath" can have relative 
For detailed usage, please refer to: 
https://www.autoitscript.com/autoit3/docs/functions/StringReplace.htm
https://www.autoitscript.com/autoit3/docs/functions/StringRegExpReplace.htm


6.
Fileoperate.exe "StripWS" "file.txt" [1|+2|+4|+8]
String Strip Space, Line by Line in file. 
For detailed usage, please refer to https://www.autoitscript.com/autoit3/docs/functions/StringStripWS.htm 
Example:
strip leading and trailing white space in file.txt by every line 
Fileoperate.exe "StripWS" "file.txt" 3


7.
Fileoperate.exe "FileFill" "FilePath" "RepeatTimes" ["char(Default=space)" ["code(0=UTF-16 (Default), 1=ANSI, 2=UTF-8)]]"
"FilePath" can have relative 
For detailed usage, please refer to https://www.autoitscript.com/autoit3/docs/functions/StringFromASCIIArray.htm

Example:
set file.txt have 200 space word
Fileoperate.exe "FileFill" "file.txt" "200"
Or
set file.txt have 200 ":" , code = ANSI
Fileoperate.exe "FileFill" "file.txt" "200" ":" 1


8.
Fileoperate.exe "Str2Hex" "[type]Strings"
Example:
Fileoperate.exe "Str2Hex" "[UTF16LE]\XBCD\XPE" >tmp.txt
The Contents of the file tmp.txt = 5C0058004200430044005C00580050004500
[type] are as follows:
[ANSI]	ANSI
[UTF16LE]	UTF16 Little Endian
[UTF16BE]	UTF16 Big Endian
[UTF8]	UTF8


8.1
Fileoperate.exe Hex2Str" "Strings" "[type]"


9.
Fileoperate.exe "InputBox" ["Default"]
Example:
Fileoperate.exe "InputBox" "\XBCD\XPE" >tmp.txt
The Contents of the file tmp.txt = {input first 9 characters}


10.
Fileoperate.exe "SelectMenu" "Title" "item1|iteme2|..." >out.txt
The Contents of the file out.txt = ITEM of SelectMenu


11.
Fileoperate.exe "SRBInFile" FilePath "[type]Source" "[type]Replace"
Method is Find "Search" in File then Set File pos to start write "Replace" step by step.
Binary File is the same Size before and after modification.
[type] are as follows:
[ANSI]	ANSI
[UTF16LE]	UTF16 Little Endian
[UTF16BE]	UTF16 Big Endian
[UTF8]	UTF8