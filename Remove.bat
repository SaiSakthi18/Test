@echo off
setlocal enabledelayedexpansion

rem Set the input and output file paths
set "input_file=your_input_file.txt"
set "output_file=non_ascii_characters.txt"

rem Remove the output file if it exists
if exist "%output_file%" del "%output_file%"

rem Loop through each line in the input file
for /f "usebackq delims=" %%A in ("%input_file%") do (
    set "line=%%A"
    set "non_ascii_chars="

    rem Check each character in the line
    for /l %%B in (0,1,9999) do (
        set "char=!line:~%%B,1!"
        
        rem Check if the character is non-ASCII
        for %%C in (!char!) do (
            if %%C lss 32 (
                set "non_ascii_chars=!non_ascii_chars!!char!"
            )
        )
    )

    rem If non-ASCII characters are found, append them to the output file
    if defined non_ascii_chars (
        echo !non_ascii_chars!>>"%output_file%"
    )
)

echo Non-ASCII characters have been saved to %output_file%

endlocal
