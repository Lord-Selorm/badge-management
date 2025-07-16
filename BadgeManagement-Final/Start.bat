@echo off
title Badge Management App
echo Starting Badge Management...
echo.
echo If browser doesn't open automatically, go to:
echo http://localhost:3000
echo.
node server.js

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: Failed to start the server.
    echo Please make sure Node.js is installed and try again.
    echo Download Node.js from: https://nodejs.org/
    pause
    exit /b 1
)
