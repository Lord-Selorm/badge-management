@echo off
title Badge Management Auto-Launcher
color 0A

echo ===========================================
echo    Badge Management Application
    
    Starting up...
echo ===========================================

echo.
echo [1/3] Checking for existing installation...

:: Check if the application is already installed in AppData
if exist "%APPDATA%\badge-management\Badge Management.exe" (
    echo Found existing installation. Launching...
    start "" "%APPDATA%\badge-management\Badge Management.exe"
    exit /b
)

echo [2/3] No existing installation found. Setting up...

:: Check if we're running from the project directory
if exist "%~dp0badge-management" (
    cd /d "%~dp0badge-management"
) else if exist "%~dp0..\badge-management" (
    cd /d "%~dp0..\badge-management"
)

:: Check if we're in the right directory
if not exist "package.json" (
    echo Error: Could not find the Badge Management project.
    echo Please place this launcher in the same folder as the badge-management folder.
    pause
    exit /b 1
)

echo [3/3] Building and launching the application...

:: Check if node_modules exists
if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo Failed to install dependencies.
        pause
        exit /b 1
    )
)

:: Build the React app
echo Building the application (this may take a few minutes)...
call npm run build
if %errorlevel% neq 0 (
    echo Failed to build the application.
    pause
    exit /b 1
)

:: Install electron-builder if not present
if not exist "node_modules\.bin\electron-builder.cmd" (
    echo Installing electron-builder...
    call npm install --save-dev electron-builder
)

:: Build the Windows installer
echo Creating the installer...
npx electron-builder --win --x64 --ia32
if %errorlevel% neq 0 (
    echo Failed to create the installer.
    pause
    exit /b 1
)

:: Run the installer silently
echo Installing the application...
start "" /wait "dist\Badge Management Setup.exe" /S

:: Create desktop shortcut
echo Creating desktop shortcut...
set SHORTCUT="%USERPROFILE%\Desktop\Badge Management.lnk"
set TARGET="%APPDATA%\badge-management\Badge Management.exe"
set ICON="%APPDATA%\badge-management\resources\app\build\logo192.ico"

echo [InternetShortcut] > %USERPROFILE%\Desktop\Badge Management.URL
echo URL=file:///%APPDATA%\badge-management\Badge%20Management.exe >> %USERPROFILE%\Desktop\Badge%20Management.URL
echo IconIndex=0 >> %USERPROFILE%\Desktop\Badge%20Management.URL
echo IconFile=%APPDATA%\badge-management\resources\app\build\logo192.ico >> %USERPROFILE%\Desktop\Badge%20Management.URL

:: Launch the application
start "" "%APPDATA%\badge-management\Badge Management.exe"

echo.
echo ===========================================
echo    Installation complete!
echo    The application should now be running.
echo    A shortcut has been placed on your desktop.
echo ===========================================

timeout /t 5
exit /b
