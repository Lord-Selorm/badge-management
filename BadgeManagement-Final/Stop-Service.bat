@echo off
title Stop Badge Management Service

echo Stopping Badge Management Service...
net stop BadgeManagement >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo Service stopped successfully.
) else (
    echo Could not stop service. It might not be running.
)

echo.
pause
