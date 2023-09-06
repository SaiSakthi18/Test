# Set the input and output file paths
$inputFile = "your_input_file.txt"
$outputFile = "cleaned_output_file.txt"
$logFile = "non_ascii_removal_log.txt"

# Remove the output files if they exist
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}
if (Test-Path $logFile) {
    Remove-Item $logFile
}

# Initialize line number
$lineNumber = 0

# Initialize log content
$logContent = @()

# Read the input file line by line
Get-Content $inputFile | ForEach-Object {
    $lineNumber++
    $line = $_
    $position = 0
    $cleanedLine = ""
    $logLine = ""

    # Loop through each character in the line
    ForEach ($char in $line.ToCharArray()) {
        $position++
        if ([int][char]$char -ge 32 -and [int][char]$char -le 126) {
            $cleanedLine += $char
        } else {
            # Log non-ASCII character removal
            $logLine = "Line $lineNumber, Position $position: Removed non-ASCII character '$char'"
            $logContent += $logLine
        }
    }

    # Append the cleaned line to the output file
    $cleanedLine | Out-File -Append -Encoding utf8 $outputFile
}

# Write the log to the log file
$logContent | Out-File -Encoding utf8 $logFile

Write-Host "Non-ASCII characters have been removed and cleaned content has been saved to $outputFile"
Write-Host "Log of removed non-ASCII characters has been saved to $logFile"
