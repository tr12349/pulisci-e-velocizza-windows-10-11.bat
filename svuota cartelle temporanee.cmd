@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows Cleanup Tool - Stable Safe Edition
color 0A

:: ==========================================================
:: ADMIN CHECK
:: ==========================================================
>nul 2>&1 net session
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
cls

echo ==========================================
echo   WINDOWS CLEANUP TOOL - STABLE MODE
echo ==========================================
echo.
echo ATTENZIONE: verranno chiuse alcune app.
pause


:: ==========================================================
:: OPTIONS
:: ==========================================================
set "choiceWinSxS=N"
set /p choiceWinSxS="Pulizia WinSxS aggressiva (Y/N)? "
if /i not "%choiceWinSxS%"=="Y" set "choiceWinSxS=N"

set "choiceShader=N"
set /p choiceShader="Pulizia cache GPU (Y/N)? "
if /i not "%choiceShader%"=="Y" set "choiceShader=N"


:: ==========================================================
:: STOP SERVICES (SAFE)
:: ==========================================================
for %%S in (wuauserv bits dosvc) do net stop %%S >nul 2>&1


:: ==========================================================
:: CLOSE APPS
:: ==========================================================
for %%P in (
chrome.exe msedge.exe brave.exe opera.exe opera_gx.exe vivaldi.exe firefox.exe steam.exe
) do taskkill /f /im %%P >nul 2>&1


:: ==========================================================
:: STOP EXPLORER (CACHE UNLOCK)
:: ==========================================================
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul


:: ==========================================================
:: TEMP CLEANUP (CORE SAFE)
:: ==========================================================
call :Clean "%TEMP%"
call :Clean "%LOCALAPPDATA%\Temp"
call :Clean "%WINDIR%\Temp"


:: ==========================================================
:: SYSTEM CACHE SAFE
:: ==========================================================
call :Clean "%LOCALAPPDATA%\D3DSCache"
call :Clean "%LOCALAPPDATA%\FontCache"
call :Clean "%LOCALAPPDATA%\CrashDumps"

call :Clean "%ProgramData%\Microsoft\Windows\WER\Temp"
call :Clean "%ProgramData%\Microsoft\Windows\WER\ReportArchive"
call :Clean "%ProgramData%\Microsoft\Windows\WER\ReportQueue"


:: ==========================================================
:: EXPLORER CACHE (ICONS / THUMBNAILS)
:: ==========================================================
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\Explorer"

del /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1


:: ==========================================================
:: RECENT FILES (SAFE OPTIONAL)
:: ==========================================================
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.lnk" >nul 2>&1


:: ==========================================================
:: WEB CACHE (SAFE METHOD)
:: ==========================================================
net stop WebCacheManager >nul 2>&1
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\WebCache"
net start WebCacheManager >nul 2>&1


:: ==========================================================
:: WINDOWS UPDATE CACHE (SAFE)
:: ==========================================================
call :Clean "%WINDIR%\SoftwareDistribution\Download"
call :Clean "%WINDIR%\SoftwareDistribution\DeliveryOptimization"
del /f /q "%WINDIR%\SoftwareDistribution\ReportingEvents.log" >nul 2>&1


:: ==========================================================
:: EDGE / RDP CACHE
:: ==========================================================
call :Clean "%LOCALAPPDATA%\Microsoft\Terminal Server Client\Cache"
call :Clean "%ProgramData%\Microsoft\Diagnosis\ETLLogs"


:: ==========================================================
:: BROWSER CACHE (CHROMIUM BASED)
:: ==========================================================
for %%B in (
"Google\Chrome\User Data"
"Microsoft\Edge\User Data"
"BraveSoftware\Brave-Browser\User Data"
"Vivaldi\User Data"
) do (
    if exist "%LOCALAPPDATA%\%%~B" (
        for /d %%P in ("%LOCALAPPDATA%\%%~B\*") do (
            set "n=%%~nxP"
            set "ok=0"
            if "!n!"=="Default" set "ok=1"
            if "!n:~0,7!"=="Profile" set "ok=1"

            if "!ok!"=="1" (
                call :Clean "%%P\Cache"
                call :Clean "%%P\Code Cache"
                call :Clean "%%P\GPUCache"
                call :Clean "%%P\Media Cache"
            )
        )
    )
)


:: ==========================================================
:: FIREFOX
:: ==========================================================
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%F in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        call :Clean "%%F\cache2"
        call :Clean "%%F\startupCache"
    )
)


:: ==========================================================
:: STEAM CACHE
:: ==========================================================
set "STEAM_PATH="
for /f "tokens=2*" %%A in (
'reg query "HKCU\Software\Valve\Steam" /v SteamPath 2^>nul'
) do set "STEAM_PATH=%%B"

if defined STEAM_PATH (
    set "STEAM_PATH=!STEAM_PATH:/=\!"
    call :Clean "!STEAM_PATH!\htmlcache"
)


:: ==========================================================
:: GPU CACHE (OPTIONAL)
:: ==========================================================
if /i "%choiceShader%"=="Y" (
    call :Clean "%LOCALAPPDATA%\NVIDIA\GLCache"
    call :Clean "%LOCALAPPDATA%\NVIDIA\DXCache"
    call :Clean "%APPDATA%\NVIDIA\ComputeCache"
    call :Clean "%LOCALAPPDATA%\AMD\DxCache"

    if defined STEAM_PATH (
        call :Clean "!STEAM_PATH!\appcache"
        call :Clean "!STEAM_PATH!\steamapps\shadercache"
    )
)


:: ==========================================================
:: RECYCLE BIN
:: ==========================================================
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1


:: ==========================================================
:: DISM SAFE MODE
:: ==========================================================
echo.
echo Analisi Component Store...
DISM /Online /Cleanup-Image /AnalyzeComponentStore >nul

if /i "%choiceWinSxS%"=="Y" (
    echo Pulizia aggressiva WinSxS...
    DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
) else (
    echo Pulizia standard WinSxS...
    DISM /Online /Cleanup-Image /StartComponentCleanup
)


:: ==========================================================
:: STORAGE SENSE TRIGGER
:: ==========================================================
schtasks /run /tn "\Microsoft\Windows\StorageSense\StorageSenseTask" >nul 2>&1


:: ==========================================================
:: RESTART SERVICES
:: ==========================================================
for %%S in (bits wuauserv dosvc) do net start %%S >nul 2>&1


:: ==========================================================
:: RESTORE EXPLORER
:: ==========================================================
start explorer.exe >nul 2>&1


cls
echo ==============================
echo   PULIZIA COMPLETATA
echo ==============================
pause
exit


:: ==========================================================
:: CLEAN FUNCTION SAFE
:: ==========================================================
:Clean
if exist "%~1" (
    attrib -h -s "%~1\*" /s /d >nul 2>&1
    del /f /s /q "%~1\*" >nul 2>&1
    for /d %%G in ("%~1\*") do rd /s /q "%%G" >nul 2>&1
)
exit /b
