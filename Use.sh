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

:: === Process only the lines with actual usernames ===
set "IN_USERS=0"

for /f "usebackq tokens=* delims=" %%A in ("%TEMP_FILE%") do (
    set "LINE=%%A"
    
    :: Start capturing after the blank line following the header
    if "!LINE!"=="" (
        if !IN_USERS! EQU 0 (
            set "IN_USERS=1"
        ) else (
            :: If another blank line appears after users start, stop
            set "IN_USERS=2"
        )
    )

    if !IN_USERS! EQU 1 (
        :: Exclude blank lines and footer
        echo !LINE! | findstr /r /v "^[ ]*$" | findstr /v "command completed" >nul
        if !errorlevel! == 0 (
            for %%U in (!LINE!) do (
                echo %%U >> "%OUTPUT_FILE%"
                set /a USER_COUNT+=1
            )
        )
    )
)

:: === Append total user count at the end ===
echo. >> "%OUTPUT_FILE%"
echo Total users: %USER_COUNT% >> "%OUTPUT_FILE%"

:: === Cleanup ===
del "%TEMP_FILE%"
echo Saved cleaned user list and count to: %OUTPUT_FILE%
endlocal
pause
