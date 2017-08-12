#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\icon\icon.ico
#AutoIt3Wrapper_Outfile=spt-boots.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Tools for extracting mapped boots
#AutoIt3Wrapper_Res_Description=Shollym Patch Tools - Boots
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Edin Jašarević (jasarsoft)
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

#include "..\balls\error.au3"


Global $InputFile
Global $LineNumber = 1
Global $LineNumberMax = 0
Global $FileName = ""

Global $ProgressStep = 0
Global $ProgressValue = 0
Global $ProgressPercent = 0


ProgressOn("Shollym Patch Tools - Boots", "Reading the map file...", "0%")

If Not FileExists("map.txt") Then
	ProgressOff()
	MsgBox($MB_ICONERROR, "Error MAP File", "Map file does not exist!")
	Exit
EndIf

$InputFile = FileOpen ("map.txt", $FO_READ)
If @error = -1 Then
	ProgressOff()
	MsgBox($MB_ICONERROR, "Error Map File", "Map file can not be opened!")
	Exit
EndIf

While 1
	Local $LineText = FileReadLine ($InputFile, $LineNumber)
	If @error = -1 Then
		ExitLoop
	EndIf
	$LineNumber += 1
	ProgressSet(0, "Line number: " & $LineNumber)
WEnd

ProgressSet($ProgressValue, "Completed reading the map file...")
$LineNumberMax = $LineNumber
$ProgressStep = Ceiling($LineNumberMax / 100)
$LineNumber = 1
DirCreate("#Boots")

ProgressSet(0, "Copying boots files...", "Copying boots files...")
While 1
	Local $LineText = FileReadLine ($InputFile, $LineNumber)
	If @error = -1 Then
		FileClose($InputFile)
		ExitLoop
	EndIf

	Local $StringComment = StringInStr($LineText, "#", 0, 1, 1, 1)
	Local $LineLenght = StringLen($LineText)
	If $StringComment = 1 Or $LineLenght = 0 Then
		If $ProgressValue = $ProgressStep Then
			$ProgressValue = 0
			$ProgressPercent += 1
		EndIf
		ProgressSet($ProgressPercent, $LineNumber & "/" & $LineNumberMax & " | " & StringTrimLeft($FileName, 25))
		$LineNumber += 1
		$ProgressValue += 1
		ContinueLoop
	EndIf

	Local $CommaPosition = StringInStr ($LineText, ',"')
	If not $CommaPosition = 0 Then
		$FileName = StringMid ($LineText, $CommaPosition + 2)
		$CommaPosition = StringInStr($FileName, '"')
		If $CommaPosition = 0 or @error = 1 Then
			ProgressOff()
			MsgBox($MB_ICONERROR, "Error CommaPosition2", "Map format is not correct." & @CRLF & $LineNumber & ". " & $LineText)
			ErrorWrite("MapFormat CommaPostion2: " & $LineNumber & ". " & $LineText)
			ProgressOn("Shollym Patch Tools - Boots", "Copying boots files...", $LineNumber & "/" & $LineNumberMax & " | " & StringTrimLeft($FileName, 25))
		Else
			$FileName = StringMid($FileName, 1, $CommaPosition - 1)
		EndIf

		If Not FileExists($FileName) Then
			ProgressOff()
			MsgBox($MB_ICONERROR, "Error Exist File", "The file does not exist." & @CRLF & $LineNumber & ". " & $LineText)
			ErrorWrite("FileExist: " & $LineNumber & ". " & $LineText)
			ProgressOn("Shollym Patch Tools - Boots", "Copying boots files...", $LineNumber & "/" & $LineNumberMax & " | " & StringTrimLeft($FileName, 25))
		Else
			If FileCopy($FileName, "#Boots\" & $FileName, 9) = 0 Then
				ProgressOff()
				MsgBox(0, "Error File Copy", "File not copied!" & @CRLF & "File: " & $FileName & @CRLF & $LineNumber & ". " & $LineText)
				ErrorWrite("FileCopy: " & $LineNumber & ". " & $LineText)
				ProgressOn("Shollym Patch Tools - Boots", "Copying boots files...", $LineNumber & "/" & $LineNumberMax & " | " & StringTrimLeft($FileName, 25))
			EndIf
		EndIf
	ElseIf @error = 1 Then
		ProgressOff()
		MsgBox($MB_ICONERROR, "Error CommaPostion1", "Map format is not correct." & @CRLF & $LineNumber & ". " & $LineText)
		ErrorWrite("MapFormat CommaPostion1: " & $LineNumber & ". " & $LineText)
		ProgressOn("Shollym Patch Tools - Boots", "Copying boots files...", $LineNumber & "/" & $LineNumberMax & " | " & StringTrimLeft($FileName, 25))
	EndIf

	If $ProgressValue = $ProgressStep Then
		$ProgressValue = 0
		$ProgressPercent += 1
	EndIf
	ProgressSet($ProgressPercent, $LineNumber & "/" & $LineNumberMax & " | " & StringTrimLeft($FileName, 25))
	$LineNumber += 1
	$ProgressValue += 1
WEnd


ProgressOff()
MsgBox($MB_ICONINFORMATION, "Finised", "The process was completed.")
Exit