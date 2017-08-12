#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

AutoItSetOption("MustDeclareVars", 1)


Func ErrorWrite($txtLine)
	Local $hErrorFile = FileOpen ("error.txt", $FO_APPEND)
	If @error = -1 Then
		MsgBox($MB_ICONERROR, "Error Open File", "Can not opet file!")
		FileClose($hErrorFile)
		Return 1
	EndIf

	Local $Result = FileWriteLine($hErrorFile, $txtLine)
	If $Result = 0 Then
		MsgBox($MB_ICONERROR, "Error File Write", "Can not write to file!")
		Return 2
	EndIf

	Return 0
EndFunc
