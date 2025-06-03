@echo off
setlocal enabledelayedexpansion

:: === Set your group name and output file path ===
set "GROUP_NAME=YourGroupName"
set "OUTPUT_FILE=group_users.txt"

:: === Temporary file for storing net group output ===
set "TEMP_FILE=%TEMP%\group_raw.txt"
net group "%GROUP_NAME%" /domain > "%TEMP_FILE%"

:: === Clear output file if it exists ===
if exist "%OUTPUT_FILE%" del "%OUTPUT_FILE%"

:: === Initialize counter ===
set "USER_COUNT=0"

:: === Extract and flatten usernames ===
for /f "tokens=* delims=" %%A in ('findstr /r "^[ ]*[A-Za-z0-9]" "%TEMP_FILE%"') do (
    set "LINE=%%A"
    for %%U in (!LINE!) do (
        echo %%U >> "%OUTPUT_FILE%"
        set /a USER_COUNT+=1
    )
)

:: === Append total user count at the end ===
echo. >> "%OUTPUT_FILE%"
echo Total users: %USER_COUNT% >> "%OUTPUT_FILE%"

:: === Cleanup ===
del "%TEMP_FILE%"
echo Saved user list and total count to: %OUTPUT_FILE%
endlocal
pause
