(net group "GroupName" /domain) |
Where-Object { $_ -match "^\s+\S" -and $_ -notmatch "command completed" } |
ForEach-Object { $_.Trim() -split "\s+" } |
Measure-Object | Select-Object -ExpandProperty Count
