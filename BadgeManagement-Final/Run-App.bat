@echo off
title Badge Management
cd /d "%~dp0"

:: Start the server
start "" node server.js

:: Wait a moment for server to start
timeout /t 2 /nobreak >nul

:: Open browser
start "" http://localhost:3000

echo Badge Management is now running in your browser.
echo To close the application, close this window and any browser windows.
pause
