; ===== Rock-Perfect Gold Macro =====
; F1 = Start loop
; F2 = Stop and exit

toggle := false

F1::
if (!toggle) {
    toggle := true
    SetTimer, GoldLoop, 10
    ToolTip, ✅ Macro Started
}
return

F2::
toggle := false
SetTimer, GoldLoop, Off
ToolTip, ❌ Macro Stopped. Exiting...
Sleep, 1000
ToolTip
ExitApp
return

GoldLoop:
if (!toggle)
    return

; === DIGGING ===
Loop, 12 {
    Click down left
    Sleep, 645
    Click up left
    Sleep, 300
}

; === WALK RIGHT UNTIL IN WATER ===
Loop, 20 {
    PixelSearch, foundX, foundY, 2050, 900, 2150, 1000, 0x4AD8F1, 40, Fast RGB
    if (ErrorLevel = 0)
        break
    Send {d down}
    Sleep, 100
    Send {d up}
    Sleep, 100
}

; === RINSE IF IN WATER ===
PixelSearch, foundX, foundY, 2050, 900, 2150, 1000, 0x4AD8F1, 40, Fast RGB
if (ErrorLevel = 0) {
    Click
    Sleep, 100
    Click down left
    Sleep, 9000
    Click up left
} else {
    ToolTip, ⚠️ Skipping rinse — no water detected
    Sleep, 1000
}

; === OPEN INVENTORY & SELL ===
Send !+f
Sleep, 300
Click, 1154, 1034
Sleep, 300
Send !+f
Sleep, 300

; === ALIGN BACK TO THE ROCK (X:1242, Y:862, Color: 0xD2D0C0) ===
Loop, 20 {
    PixelSearch, foundX, foundY, 1242, 862, 1242, 862, 0xD2D0C0, 10, Fast RGB
    if (ErrorLevel = 0) {
        ToolTip, ✅ Alignment Correct
        Sleep, 500
        ToolTip
        break
    }

    ; Alternate nudging left/right
    if (A_Index & 1) {
        Send {a down}
        Sleep, 100
        Send {a up}
    } else {
        Send {d down}
        Sleep, 100
        Send {d up}
    }

    Sleep, 150
}

return
