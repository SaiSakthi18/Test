powershell -command "& { (Get-Item 'filename.ext').LastWriteTime = (Get-Date).AddDays(-1); (Get-Item 'filename.ext').CreationTime = (Get-Date).AddDays(-1) }"