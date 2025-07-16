@echo off
title Simple Badge Management Installer

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo ===================================
echo  Badge Management Setup
  echo ===================================
echo.

echo Step 1: Creating installation directory...
if not exist "%ProgramData%\BadgeManagement" (
    mkdir "%ProgramData%\BadgeManagement"
)

cd /d "%ProgramData%\BadgeManagement"

echo Step 2: Copying files...
set "SOURCE=%~dp0"
set "TARGET=%ProgramData%\BadgeManagement"

xcopy /E /I /Y "%SOURCE%*.*" "%TARGET%\"
if %ERRORLEVEL% NEQ 0 (
    echo Error copying files. Make sure the source directory is accessible.
    pause
    exit /b 1
)

cd /d "%TARGET%"

echo Step 3: Installing Node.js modules...
call npm install node-windows --save
if %ERRORLEVEL% NEQ 0 (
    echo Error installing Node.js modules. Make sure Node.js is installed.
    pause
    exit /b 1
)

echo Step 4: Installing service...
node install-service.js
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===================================
    echo  INSTALLATION COMPLETE!
    echo ===================================
    echo.
    echo The Badge Management service has been installed and will
    echo start automatically when Windows starts.
    echo.
    echo Access the application at:
    echo http://localhost:3000
    echo.
    echo To manage the service:
    echo - net start BadgeManagement    (to start)
    echo - net stop BadgeManagement     (to stop)
    echo - sc delete BadgeManagement    (to uninstall)
) else (
    echo.
    echo ===================================
    echo  INSTALLATION FAILED
    echo ===================================
    echo.
    echo Please check the error message above.
    echo Common issues:
    echo 1. Port 3000 might be in use
    echo 2. Node.js might not be installed
    echo 3. Try running this script as Administrator
)

echo.
pause
