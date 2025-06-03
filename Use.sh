@echo off
setlocal enabledelayedexpansion

:: Set your group name here
set "GROUP_NAME=YourGroupName"

:: Temp file to store net group output
set "TEMP_FILE=%TEMP%\group_users.txt"
net group "%GROUP_NAME%" /domain > "%TEMP_FILE%"

set "USER_COUNT=0"

for /f "tokens=* delims=" %%A in ('findstr /r "^[ ]*[A-Za-z0-9]" "%TEMP_FILE%"') do (
    set "LINE=%%A"
    :: Trim leading/trailing spaces and count words (usernames) on the line
    for %%U in (!LINE!) do (
        set /a USER_COUNT+=1
    )
)

:: Output result
echo Total users in group "%GROUP_NAME%": %USER_COUNT%

:: Cleanup
del "%TEMP_FILE%"
endlocal
pause
