@echo off
title Setup Badge Management Auto-Start

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges
) else (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo Installing required modules...
call npm install node-windows

if not exist "%ProgramData%\BadgeManagement" (
    echo Creating application directory...
    mkdir "%ProgramData%\BadgeManagement"
)

echo Copying files...
xcopy /E /I /Y "%~dp0*" "%ProgramData%\BadgeManagement\"

cd /d "%ProgramData%\BadgeManagement"

echo Installing Windows Service...
node install-service.js

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo   Badge Management Service installed successfully!
    echo   The application will now start automatically on system startup.
    echo.
    echo   Access the application at:
    echo   http://localhost:3000
    echo ==========================================
) else (
    echo.
    echo Error installing the service. Please check the error messages above.
)

pause
