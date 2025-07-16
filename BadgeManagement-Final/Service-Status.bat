@echo off
title Badge Management Service Status

echo Checking Badge Management Service status...
echo ===================================
echo.

:: Check if service exists
sc query "BadgeManagement" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    :: Service exists, check if running
    sc query "BadgeManagement" | find "RUNNING" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Status: [RUNNING]
        echo To stop the service, run Stop-Service.bat
    ) else (
        echo Status: [STOPPED]
        echo To start the service, run Start-Service.bat
    )
) else (
    echo Service is not installed.
    echo To install the service, run Install-Service.bat
)

echo.
echo ===================================
pause
