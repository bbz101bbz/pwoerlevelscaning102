@echo off
setlocal
cd /d "%~dp0"
echo OmniScale dev launcher
echo Folder: %CD%
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js not found. Install Node 20+ LTS from https://nodejs.org/ then double-click run.bat again.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo [ERROR] npm not found. Reinstall Node.js LTS.
  pause
  exit /b 1
)

if not exist "package.json" (
  echo [ERROR] package.json not found. You double-clicked run.bat outside the project folder.
  echo Expected: %~dp0package.json
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo node_modules missing - running npm install first...
  call npm install
  if errorlevel 1 (
    echo [ERROR] npm install failed. See messages above.
    pause
    exit /b 1
  )
)

echo Checking port 3001...
netstat -ano | findstr ":3001" | findstr "LISTENING" >nul
if not errorlevel 1 (
  echo [WARN] Something is already on port 3001. Opening it in browser...
  start "" "http://localhost:3001"
  echo If that page is not OmniScale, close the other program and run again.
  pause
  exit /b 0
)

echo Starting dev server on http://localhost:3001 ...
echo A browser window will open. Keep this window open. Press Ctrl+C to stop.
start "" "http://localhost:3001"
call npm run dev
echo.
echo Dev server stopped with exit code %ERRORLEVEL%.
pause
