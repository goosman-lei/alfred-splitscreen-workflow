on resizeApp(positionX, positionY, sizeX, sizeY)
  log "input args: position = {" & positionX & ", " & positionY & "} size = {" & sizeX & ", " & sizeY & "}"
  tell application "System Events"
    tell first application process whose frontmost is true
        tell first window whose value of attribute "AXMain" is true
            if positionX is equal to -999999 or positionY is equal to -999999 then
                set size to {sizeX, sizeY}
            else if sizeX is equal to -999999 or sizeY is equal to -999999 then
                set position to {positionX, positionY}
            else
                set {position, size} to {{positionX, positionY}, {sizeX, sizeY}}
                delay 0.05
                set {position, size} to {{positionX, positionY}, {sizeX, sizeY}}
            end if
        end tell
    end tell
    tell first application process whose frontmost is true
        set afterPosition to position of first window whose value of attribute "AXMain" is true
        set afterSize to size of first window whose value of attribute "AXMain" is true
        if positionX is equal to -999999 or positionY is equal to -999999 then
            log "resize to: {" & item 1 of afterSize & ", " & item 2 of afterSize & "}"
        else if sizeX is equal to -999999 or sizeY is equal to -999999 then
            log "move to: {" & item 1 of afterPosition & ", " & item 2 of afterPosition & "}"
        else
            log "move to: {" & item 1 of afterPosition & ", " & item 2 of afterPosition & "}"
            log "resize to: {" & item 1 of afterSize & ", " & item 2 of afterSize & "}"
        end if
    end tell
  end tell
end resizeApp

on run args
    -- 处理比例数据
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
        set percentX to -999999
        set percentY to -999999
        set percentW to item 3 of args as real
        set percentH to item 4 of args as real
    else if command as string is equal to "move" then
        set positionType to ""
        set percentX to item 3 of args as real
        set percentY to item 4 of args as real
        set percentW to -999999
        set percentH to -999999
    end if

    -- 获取屏幕边界坐标
    tell application "Finder" to set screenBound to get bounds of window of desktop
    set screenBoundX to item 1 of screenBound
    set screenBoundY to item 2 of screenBound
    set screenBoundW to item 3 of screenBound
    set screenBoundH to item 4 of screenBound

    -- 获取屏幕大小
    set numOfScreen to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | wc -l | awk '{print $1}'") as integer
    if numOfScreen <= 1 then
        set mainScreenX to 0
        set mainScreenY to 0
        set mainScreenW to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $2}'") as integer
        set mainScreenH to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $4}'") as integer
        set dualScreenX to 0
        set dualScreenY to 0
        set dualScreenW to mainScreenW
        set dualScreenH to mainScreenH
    else
        set mainScreenX to 0
        set mainScreenY to 0
        set mainScreenW to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $2}'") as integer
        set mainScreenH to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $4}'") as integer
        set dualScreenX to mainScreenW
        set dualScreenY to screenBoundY
        set dualScreenW to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==2{print $2}'") as integer
        set dualScreenH to (do shell script "system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==2{print $4}'") as integer
    end if

    log "---- bounds position & size"
    log "globalScreenBound: " & screenBoundX & ", " & screenBoundY & ", " & screenBoundW & ", " & screenBoundH
    log "mainScreenSize: " & mainScreenW & ", " & mainScreenH
    log "dualScreenSize: " & dualScreenW & ", " & dualScreenH

    -- height of menubar
    set heightOfMenubar to 25
    set mainScreenY to mainScreenY + heightOfMenubar
    set dualScreenY to dualScreenY + heightOfMenubar
    set mainScreenH to mainScreenH - heightOfMenubar
    set dualScreenH to dualScreenH - heightOfMenubar

    log "---- actual position & size"
    log "ActualMainBound: " & mainScreenX & ", " & mainScreenY & ", " & mainScreenW & ", " & mainScreenH
    log "ActualDualBound: " & dualScreenX & ", " & dualScreenY & ", " & dualScreenW & ", " & dualScreenH


    -- 计算相对比例
    if positionType as string is equal to "left" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 49.00, 100.00}
    else if positionType as string is equal to "right" then
        set {percentX, percentY, percentW, percentH} to {51.00, 0.00, 49.00, 100.00}
    else if positionType as string is equal to "top" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 100.00, 49.00}
    else if positionType as string is equal to "bottom" then
        set {percentX, percentY, percentW, percentH} to {0.00, 51.00, 100.00, 49.00}
    else if positionType as string is equal to "full" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 100.00, 100.00}
    else if positionType as string is equal to "large" then
        set {percentX, percentY, percentW, percentH} to {10.00, 10.00, 80.00, 80.00}
    else if positionType as string is equal to "large.left" then
        set {percentX, percentY, percentW, percentH} to {0.00, 10.00, 80.00, 80.00}
    else if positionType as string is equal to "large.right" then
        set {percentX, percentY, percentW, percentH} to {20.00, 10.00, 80.00, 80.00}
    else if positionType as string is equal to "medium" then
        set {percentX, percentY, percentW, percentH} to {15.00, 15.00, 70.00, 70.00}
    else if positionType as string is equal to "medium.left" then
        set {percentX, percentY, percentW, percentH} to {0.00, 15.00, 70.00, 70.00}
    else if positionType as string is equal to "medium.right" then
        set {percentX, percentY, percentW, percentH} to {30.00, 15.00, 70.00, 70.00}
    else if positionType as string is equal to "small" then
        set {percentX, percentY, percentW, percentH} to {20.00, 20.00, 60.00, 60.00}
    else if positionType as string is equal to "small.left" then
        set {percentX, percentY, percentW, percentH} to {0.00, 20.00, 60.00, 60.00}
    else if positionType as string is equal to "small.right" then
        set {percentX, percentY, percentW, percentH} to {40.00, 20.00, 60.00, 60.00}
    else if positionType as string is equal to "tiny" then
        set {percentX, percentY, percentW, percentH} to {25.00, 25.00, 50.00, 50.00}
    else if positionType as string is equal to "tiny.left" then
        set {percentX, percentY, percentW, percentH} to {0.00, 25.00, 50.00, 50.00}
    else if positionType as string is equal to "tiny.right" then
        set {percentX, percentY, percentW, percentH} to {50.00, 25.00, 50.00, 50.00}
    else if positionType as string is equal to "1/4" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 50.00, 50.00}
    else if positionType as string is equal to "2/4" then
        set {percentX, percentY, percentW, percentH} to {50.00, 0.00, 50.00, 50.00}
    else if positionType as string is equal to "3/4" then
        set {percentX, percentY, percentW, percentH} to {0.00, 50.00, 50.00, 50.00}
    else if positionType as string is equal to "4/4" then
        set {percentX, percentY, percentW, percentH} to {50.00, 50.00, 50.00, 50.00}
    else if positionType as string is equal to "4.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 70.00, 70.00}
    else if positionType as string is equal to "4.2" then
        set {percentX, percentY, percentW, percentH} to {10.00, 10.00, 70.00, 70.00}
    else if positionType as string is equal to "4.3" then
        set {percentX, percentY, percentW, percentH} to {20.00, 20.00, 70.00, 70.00}
    else if positionType as string is equal to "4.4" then
        set {percentX, percentY, percentW, percentH} to {30.00, 30.00, 70.00, 70.00}
    else if positionType as string is equal to "3.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 80.00, 80.00}
    else if positionType as string is equal to "3.2" then
        set {percentX, percentY, percentW, percentH} to {10.00, 10.00, 80.00, 80.00}
    else if positionType as string is equal to "3.3" then
        set {percentX, percentY, percentW, percentH} to {20.00, 20.00, 80.00, 80.00}
    else if positionType as string is equal to "5.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 72.00, 72.00}
    else if positionType as string is equal to "5.2" then
        set {percentX, percentY, percentW, percentH} to {7.00, 7.00, 72.00, 72.00}
    else if positionType as string is equal to "5.3" then
        set {percentX, percentY, percentW, percentH} to {14.00, 14.00, 72.00, 72.00}
    else if positionType as string is equal to "5.4" then
        set {percentX, percentY, percentW, percentH} to {21.00, 21.00, 72.00, 72.00}
    else if positionType as string is equal to "5.5" then
        set {percentX, percentY, percentW, percentH} to {28.00, 28.00, 72.00, 72.00}
    else if positionType as string is equal to "7.1" then
        set {percentX, percentY, percentW, percentH} to {0.00, 0.00, 64.00, 64.00}
    else if positionType as string is equal to "7.2" then
        set {percentX, percentY, percentW, percentH} to {6.00, 6.00, 64.00, 64.00}
    else if positionType as string is equal to "7.3" then
        set {percentX, percentY, percentW, percentH} to {12.00, 12.00, 64.00, 64.00}
    else if positionType as string is equal to "7.4" then
        set {percentX, percentY, percentW, percentH} to {18.00, 18.00, 64.00, 64.00}
    else if positionType as string is equal to "7.5" then
        set {percentX, percentY, percentW, percentH} to {24.00, 24.00, 64.00, 64.00}
    else if positionType as string is equal to "7.6" then
        set {percentX, percentY, percentW, percentH} to {30.00, 30.00, 64.00, 64.00}
    else if positionType as string is equal to "7.7" then
        set {percentX, percentY, percentW, percentH} to {36.00, 36.00, 64.00, 64.00}
    else if positionType as string is equal to "r3.1" then
        set {percentX, percentY, percentW, percentH} to {20.00, 0.00, 80.00, 80.00}
    else if positionType as string is equal to "r3.2" then
        set {percentX, percentY, percentW, percentH} to {10.00, 10.00, 80.00, 80.00}
    else if positionType as string is equal to "r3.3" then
        set {percentX, percentY, percentW, percentH} to {0.00, 20.00, 80.00, 80.00}
    else if positionType as string is equal to "r5.1" then
        set {percentX, percentY, percentW, percentH} to {30.00, 0.00, 70.00, 70.00}
    else if positionType as string is equal to "r5.2" then
        set {percentX, percentY, percentW, percentH} to {0.23, 0.07, 0.70, 0.70}
    else if positionType as string is equal to "r5.3" then
        set {percentX, percentY, percentW, percentH} to {0.15, 0.15, 0.70, 0.70}
    else if positionType as string is equal to "r5.4" then
        set {percentX, percentY, percentW, percentH} to {0.07, 0.23, 0.70, 0.70}
    else if positionType as string is equal to "r5.5" then
        set {percentX, percentY, percentW, percentH} to {0.00, 30.00, 70.00, 70.00}
    else if positionType as string is equal to "r7.3" then
        set {percentX, percentY, percentW, percentH} to {24.00, 12.00, 64.00, 64.00}
    else if positionType as string is equal to "r7.4" then
        set {percentX, percentY, percentW, percentH} to {18.00, 18.00, 64.00, 64.00}
    else if positionType as string is equal to "r7.5" then
        set {percentX, percentY, percentW, percentH} to {12.00, 24.00, 64.00, 64.00}
    else if positionType as string is equal to "r7.6" then
        set {percentX, percentY, percentW, percentH} to {6.00, 30.00, 64.00, 64.00}
    else if positionType as string is equal to "r7.7" then
        set {percentX, percentY, percentW, percentH} to {0.00, 36.00, 64.00, 64.00}
    else if positionType as string is equal to "omnifocus" then
        set {percentX, percentY, percentW, percentH} to {60.00, 0.00, 40.00, 30.00}
    else if positionType as string is equal to "talk" then
        set {percentX, percentY, percentW, percentH} to {0.00, 60.00, 40.00, 40.00}
    else if positionType as string is equal to "huge" then
        set {percentX, percentY, percentW, percentH} to {5.00, 5.00, 90.00, 90.00}
    else if positionType as string is equal to "mini" then
        set {percentX, percentY, percentW, percentH} to {32.50, 32.50, 35.00, 35.00}
    end if

    if whichScreen as string is equal to "current" then
        tell application "System Events"
            tell first application process whose frontmost is true
                set currPosition to position of first window whose value of attribute "AXMain" is true
                if item 1 of currPosition < mainScreenW then
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
                if item 1 of currPosition <= mainScreenW then
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
        if percentX is equal to -999999 then
            set newSizeX to -999999
        else
            set newSizeX to dualScreenW * percentX + dualScreenX
        end if
        if percentY is equal to -999999 then
            set newSizeY to -999999
        else
            set newSizeY to dualScreenH * percentY + dualScreenY
        end if
        if percentW is equal to -999999 then
            set newSizeW to -999999
        else
            set newSizeW to dualScreenW * percentW
        end if
        if percentH is equal to -999999 then
            set newSizeH to -999999
        else
            set newSizeH to dualScreenH * percentH
        end if
    else
        if percentX is equal to -999999 then
            set newSizeX to -999999
        else
            set newSizeX to mainScreenW * percentX + mainScreenX
        end if
        if percentY is equal to -999999 then
            set newSizeY to -999999
        else
            set newSizeY to mainScreenH * percentY + mainScreenY
        end if
        if percentW is equal to -999999 then
            set newSizeW to -999999
        else
            set newSizeW to mainScreenW * percentW
        end if
        if percentH is equal to -999999 then
            set newSizeH to -999999
        else
            set newSizeH to mainScreenH * percentH
        end if
    end if

    log "---- action"
    log "command = " & command & "; whichScreen = " & whichScreen & "; positionType = " & positionType
    resizeApp(newSizeX as integer, newSizeY as integer, newSizeW as integer, newSizeH as integer)
end run
