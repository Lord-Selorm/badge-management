@echo off
cd /d "%~dp0"
start "" "%ProgramFiles%\Internet Explorer\iexplore.exe" http://localhost:3000
node server.js
