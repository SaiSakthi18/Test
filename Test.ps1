# Set the input and output file paths
$inputFile = "your_input_file.txt"
$outputFile = "non_ascii_characters.txt"

# Remove the output file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Read the input file line by line
$lineNumber = 0
Get-Content $inputFile | ForEach-Object {
    $lineNumber++
    $line = $_
    $position = 0
    $nonAsciiChars = @()

    # Loop through each character in the line
    ForEach ($char in $line.ToCharArray()) {
        $position++
        if ([int][char]$char -lt 32 -or [int][char]$char -gt 126) {
            $nonAsciiChars += "Line $lineNumber, Position $position: $char"
        }
    }

    # If non-ASCII characters are found, append them to the output file
    if ($nonAsciiChars.Count -gt 0) {
        $nonAsciiChars | Out-File -Append -Encoding utf8 $outputFile
    }
}

Write-Host "Non-ASCII characters and their positions have been saved to $outputFile"
