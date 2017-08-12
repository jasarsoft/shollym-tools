
Func LineComment($strLine)
   Local $intComment = StringInStr($strLine, "#", 0, 1, 1, 1)
   If $intComment = 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func LineBlank($strLine)
   Local $intResult = StringLen($strLine)
   If $intResult >= 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func LineCorrect($strLine)
   Local $intResult = StringInStr($strLine, '"', 0, 1, 1, 1)
   If $intResult = 1 Then
	  Local $strResult = StringTrimLeft($strLine, StringLen($strLine) - 1)
	  If $strResult = '"' Then

	  Else
		 Return False
	  EndIf
   Else
	  Return False
   EndIf
EndFunc


Func BallsTitle($strLine)
   Local $intResult = StringInStr($strLine, '"', 0, 1, 1, 1)
   If $intResult = 1 Then
	  $intResult = StringInStr($strLine, '","', 0, 1, 2)
	  Local $strResult = StringMid($strLine, 2, $intResult - 2)
	  Return $strResult
   EndIf
   Return ""
EndFunc

Func BallsFileName($strLine)
   Local $intResult = StringInStr($strLine, '","')
   If Not $intResult = 0 Then
	  Local $strResult = StringMid($strLine, $intResult + 3)
	  $intResult = StringInStr($strResult, '","')
	  If Not $intResult = 0 Then
		 $strResult = StringMid($strResult, 1, $intResult - 1)
		 If StringLower(StringTrimLeft($strResult, StringLen($strResult) - 4)) = StringLower(".bin") Then
			Return $strResult
		 EndIf
	  EndIf
   EndIf
   Return ""
EndFunc

Func BallsImage($strLine)
   Local $intResult = StringInStr($strLine, '","')
   If Not $intResult = 0 Then
	  Local $strResult = StringMid($strLine, $intResult + 3)
	  $intResult = StringInStr($strResult, '","')
	  If Not $intResult = 0 Then
		 $strResult = StringMid($strResult, $intResult + 3)
		 If StringLower(StringTrimLeft($strResult, StringLen($strResult) - 5)) = StringLower('.png"') Or StringLower(StringTrimLeft($strResult, StringLen($strResult) - 5)) = StringLower('.bmp"') Then
			$strResult = StringTrimRight($strResult, 1)
			Return $strResult
		 EndIf
	  EndIf
   EndIf
   Return ""
EndFunc