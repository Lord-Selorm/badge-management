@echo off
setlocal enabledelayedexpansion
title Badge Management Installation
color 0A

:: Configuration
set PROJECT_DIR=%~dp0badge-management
set LOG_FILE=%TEMP%\badge_management_install.log

echo =========================================== > "%LOG_FILE%"
echo Installation started at: %date% %time% >> "%LOG_FILE%"
echo =========================================== >> "%LOG_FILE%"

:check_admin
:: Check if running as admin
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [STATUS] Running with administrator privileges. >> "%LOG_FILE%"
) else (
    echo [ERROR] Please run this script as Administrator. >> "%LOG_FILE%"
    echo Please right-click on this file and select "Run as administrator"
    pause
    exit /b 1
)

:check_node
:: Check Node.js and npm
echo.
echo [1/6] Checking system requirements...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed. Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm is not found. Please reinstall Node.js
    pause
    exit /b 1
)

echo [OK] Node.js version: %NODE_VERSION%
echo [OK] npm version: %NPM_VERSION%

:install_deps
echo.
echo [2/6] Installing dependencies...
cd /d "%PROJECT_DIR%"
call npm install >> "%LOG_FILE%" 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies. Check %LOG_FILE% for details.
    pause
    exit /b 1
)

:build_app
echo.
echo [3/6] Building the application...
call npm run build >> "%LOG_FILE%" 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Build failed. Check %LOG_FILE% for details.
    pause
    exit /b 1
)

:install_electron_builder
echo.
echo [4/6] Setting up electron-builder...
if not exist "%PROJECT_DIR%\node_modules\.bin\electron-builder.cmd" (
    call npm install --save-dev electron-builder >> "%LOG_FILE%" 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install electron-builder. Check %LOG_FILE% for details.
        pause
        exit /b 1
    )
)

:create_installer
echo.
echo [5/6] Creating installer...
call npx electron-builder --win --x64 --ia32 >> "%LOG_FILE%" 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create installer. Check %LOG_FILE% for details.
    pause
    exit /b 1
)

:install_app
echo.
echo [6/6] Installing the application...
start "" /wait "%PROJECT_DIR%\dist\Badge Management Setup.exe" /S
if %errorlevel% neq 0 (
    echo [WARNING] Installation completed with warnings. The application might still work.
) else (
    echo [SUCCESS] Installation completed successfully!
)

:create_shortcut
echo Creating desktop shortcut...
echo [InternetShortcut] > "%USERPROFILE%\Desktop\Badge Management.URL"
echo URL=file:///%APPDATA%/badge-management/Badge%20Management.exe >> "%USERPROFILE%\Desktop\Badge%20Management.URL"
echo IconIndex=0 >> "%USERPROFILE%\Desktop\Badge%20Management.URL"
echo IconFile=%APPDATA%\badge-management\resources\app\build\logo192.ico >> "%USERPROFILE%\Desktop\Badge%20Management.URL"

:launch_app
echo.
echo Launching Badge Management...
start "" "%APPDATA%\badge-management\Badge Management.exe"

echo.
echo ===========================================
echo    Installation complete!
echo    A shortcut has been placed on your desktop.
echo    You can now launch the app from there.
echo ===========================================

echo.
echo Installation log: %LOG_FILE%
timeout /t 10
endlocal
