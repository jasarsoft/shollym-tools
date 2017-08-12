#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\icon\icon.ico
#AutoIt3Wrapper_Outfile=spt-balls.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Tools for extracting mapped balls
#AutoIt3Wrapper_Res_Description=Shollym Patch Tools - Balls
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Edin Jašarević (jasarsoft)
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

#include "func.au3"
#include "error.au3"

AutoItSetOption("MustDeclareVars", 1)

Global $Error = False
Global $InputFile
Global $LineNumber = 1

Global $BallsTitle = ""
Global $BallsFileName = ""
Global $BallsImage = ""

If Not FileExists("map.txt") Then
	MsgBox($MB_ICONERROR, "Error MAP File", "Map file does not exist!")
	Exit
EndIf

$InputFile = FileOpen ("map.txt", $FO_READ)
If @error = -1 Then
   MsgBox($MB_ICONERROR, "Error Open MAP File", "Map file can not be opened!")
   Exit
EndIf

DirCreate("#Balls")

While 1
   Local $LineText = FileReadLine ($InputFile, $LineNumber)
   If @error = -1 Then
	  FileClose($InputFile)
	  ExitLoop
   EndIf

   Local $StringComment = StringInStr($LineText, "#", 0, 1, 1, 1)
   Local $StringStart = StringInStr($LineText, '"', 0, 1, 1, 1)
   If $StringComment = 1 Or $StringStart = 0 Then
	  $LineNumber += 1
	  ContinueLoop
   EndIf

   $BallsTitle = BallsTitle($LineText)
   $BallsFileName = BallsFileName($LineText)
   $BallsImage = BallsImage($LineText)

   If $BallsTitle = "" Then
	  MsgBox(0, "Error Balls Title", $LineText)
	  ErrorWrite("BallTitle: " & $LineText)
	  $LineNumber += 1
	  $Error = True
	  ContinueLoop
   EndIf
   If $BallsFileName = "" Then
	  MsgBox(0, "Error Balls File Name", $LineText)
	  ErrorWrite("BallFileName: " & $LineText)
	  $LineNumber += 1
	  $Error = True
	  ContinueLoop
   EndIf
   If $BallsImage = "" Then
	  MsgBox(0, "Error Balls Image", $LineText)
	  ErrorWrite("BallImage: " & $LineText)
	  $LineNumber += 1
	  $Error = True
	  ContinueLoop
   EndIf

   Local $Result = FileExists("mdl\" & $BallsFileName)
   If $Result = 0 Then
	   MsgBox(0, "Error Exists MDL File", "Line Number: " & $LineNumber & @CRLF & "File Name: " & $BallsFileName &  @CRLF & "Line Text: " & $LineText)
	   ErrorWrite("BallMdlFile Exist: " & $LineText)
	   $LineNumber += 1
	   $Error = True
	   ContinueLoop
   Else
	  $Result = FileExists("#Balls\mdl\" & $BallsFileName)
	  If $Result = 0 Then
		 $Result = FileCopy("mdl\" & $BallsFileName, "#Balls\mdl\" & $BallsFileName, 8)
		 If $Result = 0 Then
			MsgBox(0, "Error Balls File Name Copy", $LineText)
			ErrorWrite("BallMdlFile Copy: " & $LineText)
			$LineNumber += 1
			$Error = True
			ContinueLoop
		 EndIf
	  EndIf
   EndIf

   $Result = FileExists($BallsImage)
   If $Result = 0 Then
	   MsgBox(0, "Error Exist Ball Image", $LineText)
	   ErrorWrite("BallImage Exist: " & $LineText)
	   $LineNumber += 1
	   $Error = True
	   ContinueLoop
   Else
	  $Result = FileExists("#Balls\" & $BallsImage)
	  If $Result = 0 Then
		 $Result = FileCopy($BallsImage, "#Balls\" & $BallsImage, 8)
		 If $Result = 0 Then
			MsgBox(0, "Error Balls Image Copy", $LineText)
			ErrorWrite("BallImage Copy: " & $LineText)
			$LineNumber += 1
			$Error = True
			ContinueLoop
		 EndIf
	  EndIf
   EndIf

   $LineNumber = $LineNumber + 1
WEnd

If $Error Then
	MsgBox($MB_ICONERROR, "Error", "The process ended with an error.")
Else
	MsgBox($MB_ICONINFORMATION, "Finised", "The process was completed.")
EndIf

Exit