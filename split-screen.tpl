on resizeApp(positionX, positionY, sizeX, sizeY)
  log "input args: position = {" & positionX & ", " & positionY & "} size = {" & sizeX & ", " & sizeY & "}"
  tell application "System Events"
    tell first application process whose frontmost is true
        tell first window whose value of attribute "AXMain" is true
            if positionX is less than 0 or positionY is less than 0 then
                set size to {sizeX, sizeY}
            else if sizeX is less than 0 or sizeY is less than 0 then
                set position to {positionX, positionY}
            else
                set {position, size} to {{positionX, positionY}, {sizeX, sizeY}}
            end if
        end tell
    end tell
    tell first application process whose frontmost is true
        set afterPosition to position of first window whose value of attribute "AXMain" is true
        set afterSize to size of first window whose value of attribute "AXMain" is true
        if positionX is less than 0 or positionY is less than 0 then
            log "resize to: {" & item 1 of afterSize & ", " & item 2 of afterSize & "}"
        else if sizeX is less than 0 or sizeY is less than 0 then
            log "move to: {" & item 1 of afterPosition & ", " & item 2 of afterPosition & "}"
        else
            log "move to: {" & item 1 of afterPosition & ", " & item 2 of afterPosition & "}"
            log "resize to: {" & item 1 of afterSize & ", " & item 2 of afterSize & "}"
        end if
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
    else if command as string is equal to "resize" then
        set positionType to ""
        set percentX to -1
        set percentY to -1
        set percentW to item 3 of args as real
        set percentH to item 4 of args as real
    else if command as string is equal to "move" then
        set positionType to ""
        set percentX to item 3 of args as real
        set percentY to item 4 of args as real
        set percentW to -1
        set percentH to -1
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
----TPL_REPLACE_WITH_CONFIG

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
