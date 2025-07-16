@echo off
title Badge Management Service Manager

:menu
cls
echo ================================
echo    Badge Management Service    
echo ================================
echo.

:: Check if service exists
sc query "BadgeManagement" >nul 2>&1
set service_exists=%errorlevel%

if %service_exists% EQU 0 (
    sc query "BadgeManagement" | find "RUNNING" >nul 2>&1
    if %errorlevel% EQU 0 (
        echo Status: [RUNNING]
        echo 1. Stop Service
        echo 2. Restart Service
    ) else (
        echo Status: [STOPPED]
        echo 1. Start Service
    )
) else (
    echo Service not installed
    echo 1. Install Service
)

echo.
echo 0. Exit

echo.
set /p choice=Enter your choice: 

if "%choice%"=="1" (
    if %service_exists% EQU 0 (
        sc query "BadgeManagement" | find "RUNNING" >nul 2>&1
        if %errorlevel% EQU 0 (
            net stop "BadgeManagement"
            echo Service has been stopped.
        ) else (
            net start "BadgeManagement"
            echo Service has been started.
        )
    ) else (
        call "%~dp0Setup-AutoStart.bat"
    )
    pause
    goto menu
) else if "%choice%"=="2" (
    if %service_exists% EQU 0 (
        echo Restarting service...
        net stop "BadgeManagement"
        timeout /t 2 >nul
        net start "BadgeManagement"
        echo Service has been restarted.
        pause
    )
    goto menu
) else if "%choice%"=="0" (
    exit /b 0
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto menu
)
