@echo off
title Change Server Port

set /p NEW_PORT=Enter new port number (e.g., 3001): 

if "%NEW_PORT%"=="" (
    echo No port specified. Using default port 3000.
    set NEW_PORT=3000
)

echo Changing port to %NEW_PORT%...

:: Create backup of server.js
copy "server.js" "server.js.bak" >nul

:: Replace the port in server.js
powershell -Command "(Get-Content 'server.js') -replace 'const PORT = .*', 'const PORT = %NEW_PORT%;' | Set-Content 'server.js'"

if exist "C:\ProgramData\BadgeManagement\server.js" (
    cd /d "C:\ProgramData\BadgeManagement"
    copy "server.js.bak" "server.js.old" >nul
    powershell -Command "(Get-Content 'server.js') -replace 'const PORT = .*', 'const PORT = %NEW_PORT%;' | Set-Content 'server.js'"
)

echo.
echo Port changed to %NEW_PORT%.
echo You'll need to reinstall the service for changes to take effect.
echo.
pause
