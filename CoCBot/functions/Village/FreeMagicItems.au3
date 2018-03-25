; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sImgTrader = @ScriptDir & "\imgxml\FreeMagicItems\TraderIcon"
Global $g_sImgDailyDiscountWindow = @ScriptDir & "\imgxml\FreeMagicItems\DailyDiscount"
Global $g_sImgBuyDealWindow = @ScriptDir & "\imgxml\FreeMagicItems\BuyDeal"

Func CollectFreeMagicItems($bTest = False)

	If Not $g_bChkCollectFreeMagicItems Then Return
	If Not $g_bRunState Then Return

	ClickP($aAway, 1, 0, "#0332") ;Click Away

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village
	If QuickMIS("BC1", $g_sImgTrader, 120, 160, 210, 215, True, False) Then
		SetLog("Trader available... Entering Daily Discounts", $COLOR_SUCCESS)
		Click($g_iQuickMISX + 120, $g_iQuickMISY + 160)
		If _Sleep(1500) Then Return
	Else
		SetLog("Trader unvailable...", $COLOR_INFO)
		Return
	EndIf

	; Check Daily Discounts Window
	If Not QuickMIS("BC1", $g_sImgDailyDiscountWindow, 280, 175, 345, 210, True, False) Then
		ClickP($aAway, 1, 0, "#0332") ;Click Away
		Return
	EndIf

	If Not $g_bRunState Then Return
	Local $aOcrPositions[3][2] = [[200, 439], [390, 439], [580, 439]]
	Local $aResults[3] = ["", "", ""]

	For $i = 0 To 2
		; 5D79C5 ; >Blue Background price
		If _ColorCheck(_GetPixelColor($aOcrPositions[$i][0], $aOcrPositions[$i][1] + 5, True), Hex(0x5D79C5, 6), 5) Then
			$aResults[$i] = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 80, 25, True)
			If Not $bTest Then
				If $aResults[$i] = "FREE" Then
					Click($aOcrPositions[$i][0], $aOcrPositions[$i][1], 2, 500)
					SetLog("Free Magic Item Detected.", $COLOR_INFO)
					ClickP($aAway, 2, 0, "#0332") ;Click Away
					If _Sleep(1000) Then Return
					Return
				Else
					$aResults[$i] = $aResults[$i] & " Gems"
				EndIf
			EndIf
		Else
			$aResults[$i] = "Collected"
		EndIf
		If Not $g_bRunState Then Return
	Next

	SetLog("Daily Discounts: " & $aResults[0] & " | " & $aResults[1] & " | " & $aResults[2])
	SetLog("Nothing Free to collect!", $COLOR_INFO)
	ClickP($aAway, 2, 0, "#0332") ;Click Away
	If _Sleep(1000) Then Return
EndFunc   ;==>CollectFreeMagicItems