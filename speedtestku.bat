@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
color 0A
title NETWORK TOOL PRO - FINAL STABLE v33

:: ================= SPEEDTEST PATH (FIX) =================
set "SPEED=C:\Tools\speedtest.exe"

:: ================= VARIABLE =================
set "SN=-"
set "DNS=-"

:: ================= TIME =================
call :GETTIME
call :GETSN

:MENU
cls
call :GETTIME
call :GETSN

echo ----------------------------------------------------------------------
echo TIME         : %TIME%
echo COM NAME/SN  : %COMPUTERNAME%/!SN!
echo ----------------------------------------------------------------------

echo [1] RUN DASHBOARD
echo [2] TRACEROUTE
echo [0] EXIT
echo ----------------------------------------------------------------------
set /p p=Select :

if "%p%"=="1" goto DASH
if "%p%"=="2" goto TRACE
if "%p%"=="0" exit
goto MENU

:: ================= TIME ENGINE =================
:GETTIME
for /f "tokens=1-3 delims= " %%a in ('date /t') do set "D=%%a %%b %%c"
for /f "tokens=1-2 delims=:" %%a in ('time /t') do set "T=%%a:%%b"
set "TIME=%D% %T%"
exit /b

:: ================= SERIAL NUMBER =================
:GETSN
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-CimInstance Win32_BIOS).SerialNumber"') do set "SN=%%A"
if not defined SN set "SN=UNKNOWN"
exit /b

:: ================= DASHBOARD =================
:DASH
cls
call :GETTIME
call :GETSN

echo ----------------------------------------------------------------------
echo TIME         : %TIME%
echo COM NAME/SN  : %COMPUTERNAME%/!SN!
echo ----------------------------------------------------------------------

echo.
echo WIFI/LAN:

set "SSID=-"
set "MACWIFI=-"
set "SIGNAL=-"
set "DNS=-"

for /f "delims=" %%A in ('netsh wlan show interfaces') do (
    echo %%A | findstr /i "SSID" | findstr /v "BSSID" >nul && (
        for /f "tokens=2 delims=:" %%B in ("%%A") do set "SSID=%%B"
    )

    echo %%A | findstr /i "Physical address" >nul && (
        for /f "tokens=1,* delims=:" %%B in ("%%A") do set "MACWIFI=%%C"
    )

    echo %%A | findstr /i "Signal" >nul && (
        for /f "tokens=2 delims=:" %%B in ("%%A") do set "SIGNAL=%%B"
    )
)

:: ================= NETWORK =================
for /f "tokens=14" %%A in ('ipconfig ^| findstr IPv4') do set "IP=%%A"
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr "Subnet Mask"') do set "SUBNET=%%A"
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr "Default Gateway"') do set "GW=%%A"

:: ================= DNS =================
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-DnsClientServerAddress | Where-Object {$_.ServerAddresses}).ServerAddresses | Select-Object -First 1"') do set "DNS=%%A"

echo SSID        : !SSID!
echo MAC WIFI    : !MACWIFI!
echo Signal      : !SIGNAL!

echo IP          : !IP!
echo SUBNET      : !SUBNET!
echo GATEWAY     : !GW!
echo DNS         : !DNS!

echo.

:: ================= PUBLIC IP =================
for /f %%A in ('powershell -NoProfile -Command "(Invoke-RestMethod https://api.ipify.org)"') do set "PUB=%%A"
echo IP PUBLIC   : !PUB!

echo.
echo ----------------------------------------------------------------------
echo SPEEDTEST:
echo ----------------------------------------------------------------------

if exist "%SPEED%" (
    "%SPEED%" --accept-license --accept-gdpr
) else (
    echo SPEEDTEST NOT FOUND AT %SPEED%
)

echo.
echo ----------------------------------------------------------------------
echo PING:
echo ----------------------------------------------------------------------

call :PING google.com
call :PING epiroc.cde-coal.com
call :PING tixa.yacoonps.com
call :PING nextcloud.cde-coal.com

echo.
pause
goto MENU

:: ================= PING =================
:PING
set "H=%~1"
for /f "delims=" %%A in ('ping -n 1 %H% ^| findstr /i "Reply from time="') do (
    echo %H% = %%A
)
exit /b

:: ================= TRACE =================
:TRACE
cls
set /p target=Masukkan domain/IP:
tracert %target%
pause
goto MENU