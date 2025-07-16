@echo off
title Badge Management Service Manager

:menu
cls
echo ================================
echo    Badge Management Service    
echo ================================
echo.

:: Check if service exists
sc query BadgeManagement >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    :: Service exists, check if running
    sc query BadgeManagement | find "RUNNING" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Status: [RUNNING]
        echo 1. Stop Service
        echo 2. Restart Service
    ) else (
        echo Status: [STOPPED]
        echo 1. Start Service
    )
    echo.
    echo 3. Disable Auto-Start
    echo 4. Enable Auto-Start
    echo 5. Check Status
    echo 6. Uninstall Service
) else (
    echo Service is not installed.
    echo.
    echo 1. Install Service
)

echo.
echo 0. Exit
echo.
set /p choice=Enter your choice: 

if "%choice%"=="1" (
    if exist "%ProgramFiles%\nodejs\node.exe" (
        if exist "%ProgramData%\BadgeManagement\server.js" (
            cd /d "%ProgramData%\BadgeManagement"
            node install-service.js
            net start BadgeManagement
        ) else (
            echo Service files not found. Please reinstall.
        )
    ) else (
        net start BadgeManagement
    )
    pause
    goto menu
) else if "%choice%"=="2" (
    net stop BadgeManagement
    timeout /t 2 /nobreak >nul
    net start BadgeManagement
    pause
    goto menu
) else if "%choice%"=="3" (
    sc config BadgeManagement start= disabled
    echo Auto-start disabled. The service will not start with Windows.
    pause
    goto menu
) else if "%choice%"=="4" (
    sc config BadgeManagement start= auto
    echo Auto-start enabled. The service will start with Windows.
    pause
    goto menu
) else if "%choice%"=="5" (
    sc query BadgeManagement
    pause
    goto menu
) else if "%choice%"=="6" (
    echo WARNING: This will completely remove the service.
    set /p confirm=Are you sure? (y/n): 
    if /i "%confirm%"=="y" (
        net stop BadgeManagement
        sc delete BadgeManagement
        echo Service has been uninstalled.
    )
    pause
    goto menu
) else if "%choice%"=="0" (
    exit /b 0
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 /nobreak >nul
    goto menu
)
