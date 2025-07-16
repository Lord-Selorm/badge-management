@echo off
title Start Badge Management Service

echo Starting Badge Management Service...
net start BadgeManagement >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo Service started successfully.
    echo You can access the application at: http://localhost:3000
) else (
    echo Could not start service. It might not be installed.
    echo Try running Install-Service.bat first.
)

echo.
pause
