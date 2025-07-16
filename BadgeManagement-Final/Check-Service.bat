@echo off
title Check Badge Management Service

echo Checking service status...
echo ===========================

:: Check if service exists
sc query BadgeManagement 2>nul | find "STATE" >nul
if %ERRORLEVEL% EQU 0 (
    echo Service is installed.
    sc query BadgeManagement | find "STATE"
    
    echo.
echo Attempting to start the service...
    net start BadgeManagement
    
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo Service started successfully!
        echo You can access the application at:
        echo http://localhost:3000
    ) else (
        echo.
        echo Failed to start service. Trying to reinstall...
        echo.
        cd /d "C:\ProgramData\BadgeManagement"
        node install-service.js
        net start BadgeManagement
    )
) else (
    echo Service is not installed.
    echo.
    echo Please run Simple-Install.bat as Administrator to install the service.
)

echo.
pause
