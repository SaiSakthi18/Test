# Set the input and output file paths
$inputFile = "your_input_file.txt"
$outputFile = "non_ascii_characters.txt"

# Remove the output file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Read the input file line by line
Get-Content $inputFile | ForEach-Object {
    $line = $_
    $nonAsciiChars = ""

    # Loop through each character in the line
    For ($i = 0; $i -lt $line.Length; $i++) {
        $char = [char]$line[$i]

        # Check if the character is non-ASCII
        if ([int]$char -lt 32 -or [int]$char -gt 126) {
            $nonAsciiChars += $char
        }
    }

    # If non-ASCII characters are found, append them to the output file
    if ($nonAsciiChars.Length -gt 0) {
        $nonAsciiChars | Out-File -Append -Encoding utf8 $outputFile
    }
}

Write-Host "Non-ASCII characters have been saved to $outputFile"