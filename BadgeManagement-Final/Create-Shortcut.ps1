# Create WScript Shell object
$WshShell = New-Object -comObject WScript.Shell

# Path to the shortcut
$desktop = [System.Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path -Path $desktop -ChildPath "Badge Management.lnk"

# Get the current directory with proper escaping
$currentDir = $PWD.Path

# Create shortcut
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "$currentDir\StartApp.vbs"
$Shortcut.WorkingDirectory = $currentDir
$Shortcut.Description = "Badge Management System"

# Find an icon - first use bmsdl.ico, then look for others
$iconPath = $null
$possibleIcons = @(
    "$PWD\bmsdl.ico",
    "$PWD\build\favicon.ico",
    (Get-ChildItem -Path "$PWD\build" -Recurse -Include *.ico,*.png | Select-Object -First 1 -ExpandProperty FullName)
)

foreach ($icon in $possibleIcons) {
    if ($icon -and (Test-Path $icon)) {
        $iconPath = $icon
        break
    }
}

if ($iconPath) {
    $Shortcut.IconLocation = "$iconPath,0"
    Write-Host "Using icon: $iconPath"
} else {
    Write-Host "No icon found, using default"
}

$Shortcut.Save()

Write-Host "Shortcut created on your desktop: $ShortcutPath"
Write-Host "You can now start the application by double-clicking 'Badge Management' on your desktop."

# Open the desktop folder
Start-Process (Join-Path $env:USERPROFILE "Desktop")
