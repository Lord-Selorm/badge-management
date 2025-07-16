$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Badge Management.lnk")
$Shortcut.TargetPath = "$PWD\Start-BadgeManagement.bat"
$Shortcut.WorkingDirectory = $PWD
$Shortcut.IconLocation = "$PWD\bmsdl.ico,0"
$Shortcut.Save()

Write-Host "Shortcut created on your desktop"
