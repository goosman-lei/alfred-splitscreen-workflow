on resizeApp(positionX, positionY, sizeX, sizeY)
  log "resize: x = " & positionX & ", y = " & positionY & ", width = " & sizeX & ", height = " & sizeY
  tell application "System Events"
    tell first application process whose frontmost is true
        tell first window whose value of attribute "AXMain" is true
            set {position, size} to {{positionX, positionY}, {sizeX, sizeY}}
        end tell
        -- set position of first window whose value of attribute "AXMain" is true to {positionX, positionY}
        -- delay 0.2
        -- set size of first window whose value of attribute "AXMain" is true to {sizeX, sizeY}
    end tell
    tell first application process whose frontmost is true
        set afterPosition to position of first window whose value of attribute "AXMain" is true
        set afterSize to size of first window whose value of attribute "AXMain" is true
        log "after resize postion: " & item 1 of afterPosition & ", " & item 2 of afterPosition
        log "after resize size: " & item 1 of afterSize & ", " & item 2 of afterSize
    end tell
  end tell
end resizeApp

on run args
    set widthOfMainScreen to 2560
    set heightOfMainScreen to 1600
    set command to item 1 of args as string
    set whichScreen to item 2 of args as string
    set positionType to item 3 of args as string
    if command as string is equal to "custom" then
        set positionType to ""
        set percentX to item 3 of args as real
        set percentY to item 4 of args as real
        set percentW to item 5 of args as real
        set percentH to item 6 of args as real
    end if

    tell application "Finder" to set screenBound to get bounds of window of desktop
    set screenBoundX to item 1 of screenBound
    set screenBoundY to item 2 of screenBound
    set screenBoundW to item 3 of screenBound
    set screenBoundH to item 4 of screenBound
    if widthOfMainScreen = screenBoundW then -- 只有一个屏幕
        set mainScreenX to 0
        set mainScreenY to 0
        set mainScreenW to widthOfMainScreen
        set mainScreenH to heightOfMainScreen
        set dualScreenX to 0
        set dualScreenY to 0
        set dualScreenW to widthOfMainScreen
        set dualScreenH to heightOfMainScreen
    else
        set mainScreenX to 0
        set mainScreenY to 0
        set mainScreenW to widthOfMainScreen
        set mainScreenH to heightOfMainScreen
        set dualScreenX to mainScreenW
        set dualScreenY to screenBoundY
        -- set dualScreenW to screenBoundW - mainScreenW
        -- set dualScreenH to screenBoundH - screenBoundY
        set dualScreenW to (do shell script "system_profiler SPDisplaysDataType | ggrep -oP '(?<=Resolution: )\\d++ x \\d++(?! Retina)' | awk '{print $1}'") as integer
        set dualScreenH to (do shell script "system_profiler SPDisplaysDataType | ggrep -oP '(?<=Resolution: )\\d++ x \\d++(?! Retina)' | awk '{print $3}'") as integer
    end if
    log "whichScreen: " & whichScreen & ", positionType: " & positionType
    log "mainBound: " & mainScreenX & ", " & mainScreenY & ", " & mainScreenW & ", " & mainScreenH
    log "dualBound: " & dualScreenX & ", " & dualScreenY & ", " & dualScreenW & ", " & dualScreenH

    -- height of menubar
    set heightOfMenubar to 25
    set mainScreenY to mainScreenY + heightOfMenubar
    set dualScreenY to dualScreenY + heightOfMenubar

    -- 计算相对比例
    if positionType as string is equal to "left" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 0.48, 1.00}
    else if positionType as string is equal to "right" then
        set {percentX, percentY, percentW, percentH} to {0.52, 0.00, 0.48, 1.00}
    else if positionType as string is equal to "top" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 1.00, 0.50}
    else if positionType as string is equal to "bottom" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.50, 1.00, 0.50}
    else if positionType as string is equal to "full" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 1.00, 1.00}
    else if positionType as string is equal to "medium" then
        set {percentX, percentY, percentW, percentH} to {0.15, 0.10, 0.80, 0.80}
    else if positionType as string is equal to "small" then
        set {percentX, percentY, percentW, percentH} to {0.20, 0.20, 0.60, 0.60}
    else if positionType as string is equal to "4.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 50.00, 50.00}
    else if positionType as string is equal to "4.2" then
        set {percentX, percentY, percentW, percentH} to {50.00, 0.00, 50.00, 50.00}
    else if positionType as string is equal to "4.3" then
        set {percentX, percentY, percentW, percentH} to {0.00, 50.00, 50.00, 50.00}
    else if positionType as string is equal to "4.4" then
        set {percentX, percentY, percentW, percentH} to {50.00, 50.00, 50.00, 50.00}
    else if positionType as string is equal to "3.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 80.00, 80.00}
    else if positionType as string is equal to "3.2" then
        set {percentX, percentY, percentW, percentH} to {10.00, 10.00, 80.00, 80.00}
    else if positionType as string is equal to "3.3" then
        set {percentX, percentY, percentW, percentH} to {20.00, 20.00, 80.00, 80.00}
    else if positionType as string is equal to "l5.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 70.00, 70.00}
    else if positionType as string is equal to "l5.2" then
        set {percentX, percentY, percentW, percentH} to {7.50, 7.50, 70.00, 70.00}
    else if positionType as string is equal to "l5.3" then
        set {percentX, percentY, percentW, percentH} to {15.00, 15.00, 70.00, 70.00}
    else if positionType as string is equal to "l5.4" then
        set {percentX, percentY, percentW, percentH} to {22.50, 22.50, 70.00, 70.00}
    else if positionType as string is equal to "l5.5" then
        set {percentX, percentY, percentW, percentH} to {0.30, 0.30, 0.70, 0.70}
    else if positionType as string is equal to "r3.1" then
        set {percentX, percentY, percentW, percentH} to {0.20, 0.00, 0.80, 0.80}
    else if positionType as string is equal to "r3.2" then
        set {percentX, percentY, percentW, percentH} to {0.10, 0.10, 0.80, 0.80}
    else if positionType as string is equal to "r3.3" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.20, 0.80, 0.80}
    else if positionType as string is equal to "r5.1" then
        set {percentX, percentY, percentW, percentH} to {0.30, 0.00, 0.70, 0.70}
    else if positionType as string is equal to "r5.2" then
        set {percentX, percentY, percentW, percentH} to {0.23, 0.07, 0.70, 0.70}
    else if positionType as string is equal to "r5.3" then
        set {percentX, percentY, percentW, percentH} to {0.15, 0.15, 0.70, 0.70}
    else if positionType as string is equal to "r5.4" then
        set {percentX, percentY, percentW, percentH} to {0.07, 0.23, 0.70, 0.70}
    else if positionType as string is equal to "r5.5" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.30, 0.70, 0.70}
    end if

    if whichScreen as string is equal to "current" then
        tell application "System Events"
            tell first application process whose frontmost is true
                set currPosition to position of first window whose value of attribute "AXMain" is true
                if item 1 of currPosition < widthOfMainScreen then
                    set whichScreen to "main"
                else
                    set whichScreen to "dual"
                end if
            end tell
        end tell
    else if whichScreen as string is equal to "other" then
        tell application "System Events"
            tell first application process whose frontmost is true
                set currPosition to position of first window whose value of attribute "AXMain" is true
                if item 1 of currPosition <= widthOfMainScreen then
                    set whichScreen to "dual"
                else
                    set whichScreen to "main"
                end if
            end tell
        end tell
    end if

    -- 单位转换
    if percentX > 1 then
        set percentX to percentX / 100
    end if
    if percentY > 1 then
        set percentY to percentY / 100
    end if
    if percentW > 1 then
        set percentW to percentW / 100
    end if
    if percentH > 1 then
        set percentH to percentH / 100
    end if


    -- 计算实际位置大小
    if whichScreen as string is equal to "dual" then
        set newSizeX to dualScreenW * percentX + dualScreenX
        set newSizeY to dualScreenH * percentY + dualScreenY
        set newSizeW to dualScreenW * percentW
        set newSizeH to dualScreenH * percentH
    else
        set newSizeX to mainScreenW * percentX
        set newSizeY to mainScreenH * percentY
        set newSizeW to mainScreenW * percentW
        set newSizeH to mainScreenH * percentH
    end if
    resizeApp(newSizeX as integer, newSizeY as integer, newSizeW as integer, newSizeH as integer)
end run
