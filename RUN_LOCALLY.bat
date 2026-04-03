@echo off
REM Kuber Timesheet - Local Test Script

echo.
echo ====================================
echo  Kuber Timesheet Local Test
echo ====================================
echo.

cd /d "frontend"

echo Checking Node.js installation...
node --version
if errorlevel 1 (
    echo ERROR: Node.js not found!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo.
echo Checking if node_modules exists...
if not exist "node_modules" (
    echo Installing dependencies (this may take a few minutes)...
    where npm >nul 2>nul
    if errorlevel 1 (
        echo Using npx to install...
        call npx npm install
    ) else (
        call npm install
    )
)

echo.
echo ====================================
echo  Starting development server...
echo ====================================
echo.
echo Access the app at: http://localhost:3000
echo.
echo Press Ctrl+C to stop the server
echo.

where npm >nul 2>nul
if errorlevel 1 (
    call npx next dev
) else (
    call npm run dev
)

pause
