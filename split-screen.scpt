on resizeApp(positionX, positionY, sizeX, sizeY)
  log "resize: x = " & positionX & ", y = " & positionY & ", width = " & sizeX & ", height = " & sizeY
  tell application "System Events"
    tell first application process whose frontmost is true
        set position of first window whose value of attribute "AXMain" is true to {positionX, positionY}
        delay 0.2
        set size of first window whose value of attribute "AXMain" is true to {sizeX, sizeY}
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
    if positionType as string is equal to "topleft" then
        set percentX to 0.0
        set percentY to 0.0
        set percentW to 0.5
        set percentH to 0.5
    else if positionType as string is equal to "topright" then
        set percentX to 0.5
        set percentY to 0.0
        set percentW to 0.5
        set percentH to 0.5
    else if positionType as string is equal to "bottomleft" then
        set percentX to 0.0
        set percentY to 0.5
        set percentW to 0.5
        set percentH to 0.5
    else if positionType as string is equal to "bottomright" then
        set percentX to 0.5
        set percentY to 0.5
        set percentW to 0.5
        set percentH to 0.5
    else if positionType as string is equal to "left" then
        set percentX to 0.0
        set percentY to 0.0
        set percentW to 0.5
        set percentH to 1.0
    else if positionType as string is equal to "right" then
        set percentX to 0.5
        set percentY to 0.0
        set percentW to 0.5
        set percentH to 1.0
    else if positionType as string is equal to "top" then
        set percentX to 0.0
        set percentY to 0.0
        set percentW to 1.0
        set percentH to 0.5
    else if positionType as string is equal to "bottom" then
        set percentX to 0.0
        set percentY to 0.5
        set percentW to 1.0
        set percentH to 0.5
    else if positionType as string is equal to "full" then
        set percentX to 0.0
        set percentY to 0.0
        set percentW to 1.0
        set percentH to 1.0
    else if positionType as string is equal to "medium" then
        set percentX to 0.1
        set percentY to 0.1
        set percentW to 0.8
        set percentH to 0.8
    else if positionType as string is equal to "small" then
        set percentX to 0.2
        set percentY to 0.2
        set percentW to 0.6
        set percentH to 0.6
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
                if item 1 of currPosition < widthOfMainScreen then
                    set whichScreen to "dual"
                else
                    set whichScreen to "main"
                end if
            end tell
        end tell
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
