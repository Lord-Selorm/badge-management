@echo off
title Check Application Structure
echo ===================================
echo   Checking Application Structure
echo ===================================
echo.

echo [1/4] Current Directory:
cd /d "%~dp0"
echo %CD%

echo.
echo [2/4] Checking for required files:
if exist "package.json" (
    echo [FOUND] package.json
) else (
    echo [MISSING] package.json
)

if exist "server.js" (
    echo [FOUND] server.js
) else (
    echo [MISSING] server.js
)

echo.
echo [3/4] Checking build directory:
if exist "build" (
    echo [FOUND] build directory
    echo.
    echo Contents of build directory:
    dir /b "build"
    
    echo.
    if exist "build\index.html" (
        echo [FOUND] build/index.html
    ) else (
        echo [MISSING] build/index.html
    )
    
    if exist "build\static" (
        echo [FOUND] build/static directory
    ) else (
        echo [MISSING] build/static directory
    )
) else (
    echo [MISSING] build directory
    echo.
    echo To fix this, run: npm run build
)

echo.
echo [4/4] Node.js Information:
node -v
npm -v

echo.
echo ===================================
echo   Structure Check Complete
echo ===================================
echo.
pause
