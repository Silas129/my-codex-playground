; ===== Rock-Perfect Gold Macro =====
; F1 = Start loop
; F2 = Stop and exit

; Pixel coordinates and colors for reference
rockX := 1242
rockY := 862
rockColor := 0xD2D0C0
waterColor := 0x4AD8F1

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

; === VERIFY START POSITION ON ROCK ===
PixelSearch, foundX, foundY, rockX-2, rockY-2, rockX+2, rockY+2, rockColor, 10, Fast RGB
if (ErrorLevel != 0) {
    ToolTip, ❌ Rock not found - attempting realign
    Loop, 20 {
        PixelSearch, foundX, foundY, rockX-2, rockY-2, rockX+2, rockY+2, rockColor, 10, Fast RGB
        if (ErrorLevel = 0)
            break
        ; nudge left and right
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
    ToolTip
    ; if still not aligned abort this loop
    PixelSearch, foundX, foundY, rockX-2, rockY-2, rockX+2, rockY+2, rockColor, 10, Fast RGB
    if (ErrorLevel != 0)
        return
}

; === DIGGING ===
Loop, 12 {
    Click down left
    Sleep, 645
    Click up left
    Sleep, 300
}

; === WALK RIGHT UNTIL IN WATER ===
Loop, 20 {
    PixelSearch, foundX, foundY, 2050, 900, 2150, 1000, waterColor, 40, Fast RGB
    if (ErrorLevel = 0)
        break
    Send {d down}
    Sleep, 100
    Send {d up}
    Sleep, 100
}

; === RINSE IF IN WATER ===
PixelSearch, foundX, foundY, 2050, 900, 2150, 1000, waterColor, 40, Fast RGB
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

; === WALK LEFT BACK TO ROCK ===
Loop, 20 {
    PixelSearch, foundX, foundY, rockX-2, rockY-2, rockX+2, rockY+2, rockColor, 10, Fast RGB
    if (ErrorLevel = 0)
        break
    Send {a down}
    Sleep, 100
    Send {a up}
    Sleep, 100
}

; === FINAL ALIGNMENT CHECK ===
PixelSearch, foundX, foundY, rockX-2, rockY-2, rockX+2, rockY+2, rockColor, 10, Fast RGB
if (ErrorLevel = 0) {
    ToolTip, ✅ Alignment Correct
    Sleep, 500
    ToolTip
} else {
    ToolTip, ⚠️ Unable to realign
    Sleep, 500
    ToolTip
    return
}

; === OPEN INVENTORY & SELL ===
Send !+f
Sleep, 300
Click, 1154, 1034
Sleep, 300
Send !+f
Sleep, 300
return
