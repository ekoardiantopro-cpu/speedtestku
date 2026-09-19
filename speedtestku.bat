@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
color 0A
title SPEEDTEST INSTALLER - AUTO SETUP

echo ======================================
echo   SPEEDTEST INSTALLER (ONE CLICK)
echo ======================================
echo.

:: ================= FOLDER =================
set "TOOLS=C:\Tools"
set "SPEED=%TOOLS%\speedtest.exe"

echo [1/4] Creating folder...
if not exist "%TOOLS%" mkdir "%TOOLS%"

:: ================= DOWNLOAD =================
echo [2/4] Downloading Speedtest...

curl -L -o "%SPEED%" https://raw.githubusercontent.com/ekoardiantopro-cpu/speedtestku/main/speedtest.exe >nul

:: ================= CHECK FILE =================
if exist "%SPEED%" (
    echo [OK] Download successful
) else (
    echo [ERROR] Download failed
    echo Check internet connection or GitHub link
    pause
    exit /b
)

:: ================= PATH SETUP =================
echo [3/4] Setting system PATH...

setx PATH "%PATH%;%TOOLS%" >nul

:: ================= FINISH =================
echo [4/4] DONE!
echo.
echo ======================================
echo INSTALLATION COMPLETE
echo ======================================
echo.
echo NOW YOU CAN USE:
echo   speedtest.exe
echo   C:\Tools\speedtest.exe
echo.
echo NOTE:
echo - Restart CMD if command not found
echo.
pause
exit