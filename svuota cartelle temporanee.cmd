@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows Cleanup Tool - PRO ULTIMATE v2
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

:: LOG FILE
set "LOG=%~dp0cleanup_log.txt"
echo ==== CLEANUP START %date% %time% ==== > "%LOG%"

cls
echo ==========================================
echo   WINDOWS CLEANUP TOOL - PRO ULTIMATE v2
echo ==========================================
echo.

pause


:: ==========================================================
:: OPTIONS
:: ==========================================================
set "choiceWinSxS=N"
set /p choiceWinSxS=WinSxS aggressivo (Y/N)? 
if /i not "%choiceWinSxS%"=="Y" set "choiceWinSxS=N"

set "choiceShader=N"
set /p choiceShader=Cache GPU (Y/N)? 
if /i not "%choiceShader%"=="Y" set "choiceShader=N"


:: ==========================================================
:: STOP SERVICES
:: ==========================================================
for %%S in (wuauserv bits dosvc) do (
    net stop %%S >nul 2>&1
    echo STOP SERVICE: %%S>>"%LOG%"
)


:: ==========================================================
:: CLOSE APPS
:: ==========================================================
for %%P in (
chrome.exe msedge.exe brave.exe opera.exe opera_gx.exe vivaldi.exe firefox.exe steam.exe
) do (
    taskkill /f /im %%P >nul 2>&1
)


:: ==========================================================
:: STOP EXPLORER (SAFE)
:: ==========================================================
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul


:: ==========================================================
:: CORE CLEAN
:: ==========================================================
call :Clean "%TEMP%"
call :Clean "%LOCALAPPDATA%\Temp"
call :Clean "%WINDIR%\Temp"

call :Clean "%LOCALAPPDATA%\D3DSCache"
call :Clean "%LOCALAPPDATA%\FontCache"
call :Clean "%LOCALAPPDATA%\CrashDumps"

call :Clean "%ProgramData%\Microsoft\Windows\WER\Temp"
call :Clean "%ProgramData%\Microsoft\Windows\WER\ReportArchive"
call :Clean "%ProgramData%\Microsoft\Windows\WER\ReportQueue"


:: ==========================================================
:: ADDITIONAL SAFE CLEAN (LOW RISK SYSTEM + CACHE)
:: ==========================================================

call :Clean "%LOCALAPPDATA%\Microsoft\Windows\WebCache"
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\INetCookies"

call :Clean "C:\Windows\System32\LogFiles\WMI"
call :Clean "C:\Windows\Logs\CBS"
call :Clean "C:\Windows\Logs\DISM"
call :Clean "C:\Windows\Minidump"


:: ==========================================================
:: ADDITIONAL SAFE CLEAN (LOW RISK SYSTEM + CACHE)
:: ==========================================================

call :Clean "%LOCALAPPDATA%\Microsoft\Windows\WebCache"
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\INetCookies"

call :Clean "C:\Windows\System32\LogFiles\WMI"
call :Clean "C:\Windows\Logs\CBS"
call :Clean "C:\Windows\Logs\DISM"
call :Clean "C:\Windows\Minidump"


:: ==========================================================
:: GAMES + APPS CACHE CLEAN
:: ==========================================================

call :Clean "%LOCALAPPDATA%\Roblox\logs"
call :Clean "%LOCALAPPDATA%\Roblox\Cache"
call :Clean "%LOCALAPPDATA%\Roblox\Downloads"

call :Clean "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache"
call :Clean "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs"

call :Clean "%PROGRAMFILES(X86)%\Steam\appcache"
call :Clean "%PROGRAMFILES(X86)%\Steam\depotcache"

call :Clean "%LOCALAPPDATA%\Battle.net\Cache"

call :Clean "%APPDATA%\Discord\Cache"
call :Clean "%APPDATA%\Discord\Code Cache"
call :Clean "%APPDATA%\Discord\GPUCache"
call :Clean "%APPDATA%\Discord\Crashpad"

call :Clean "%APPDATA%\Spotify\Storage"
call :Clean "%APPDATA%\Spotify\Cache"

call :Clean "%APPDATA%\.minecraft\logs"
call :Clean "%APPDATA%\.minecraft\crash-reports"

call :Clean "%LOCALAPPDATA%\NVIDIA Corporation\NV_Cache"
call :Clean "%LOCALAPPDATA%\NVIDIA\GLCache"


:: ==========================================================
:: EXTRA APPS CACHE CLEAN (SAFE)
:: ==========================================================

call :Clean "%APPDATA%\WhatsApp\Cache"
call :Clean "%APPDATA%\WhatsApp\Code Cache"
call :Clean "%APPDATA%\WhatsApp\GPUCache"
call :Clean "%APPDATA%\WhatsApp\Logs"
call :Clean "%LOCALAPPDATA%\WhatsApp\Temp"

call :Clean "%APPDATA%\Microsoft\Teams\Cache"
call :Clean "%APPDATA%\Microsoft\Teams\Code Cache"
call :Clean "%APPDATA%\Microsoft\Teams\GPUCache"

call :Clean "%LOCALAPPDATA%\Microsoft\EdgeWebView\Cache"
call :Clean "%LOCALAPPDATA%\Microsoft\EdgeWebView\Code Cache"
call :Clean "%LOCALAPPDATA%\Microsoft\EdgeWebView\GPUCache"

call :Clean "%LOCALAPPDATA%\Packages\*\LocalCache"
call :Clean "%LOCALAPPDATA%\Packages\*\TempState"

call :Clean "%LOCALAPPDATA%\Riot Games\Riot Client\Cache"
call :Clean "%LOCALAPPDATA%\EA Desktop\Cache"


:: ==========================================================
:: EXPLORER CACHE
:: ==========================================================
call :Clean "%LOCALAPPDATA%\Microsoft\Windows\Explorer"
del /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1


:: ==========================================================
:: RECENT FILES
:: ==========================================================
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.lnk" >nul 2>&1


:: ==========================================================
:: WINDOWS UPDATE CACHE
:: ==========================================================
call :Clean "%WINDIR%\SoftwareDistribution\Download"
call :Clean "%WINDIR%\SoftwareDistribution\DeliveryOptimization"


:: ==========================================================
:: DIAGNOSTIC
:: ==========================================================
call :Clean "%ProgramData%\Microsoft\Diagnosis\ETLLogs"


:: ==========================================================
:: BROWSER CACHE
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
:: STEAM (SAFE FIXED)
:: ==========================================================
set "STEAM_PATH="
for /f "tokens=2*" %%A in (
'reg query "HKCU\Software\Valve\Steam" /v SteamPath 2^>nul'
) do set "STEAM_PATH=%%B"

if defined STEAM_PATH (
    set "STEAM_PATH=!STEAM_PATH:/=\!"
    if exist "!STEAM_PATH!\htmlcache" call :Clean "!STEAM_PATH!\htmlcache"
)


:: ==========================================================
:: GPU CACHE (OPTIONAL)
:: ==========================================================
if /i "%choiceShader%"=="Y" (
    call :Clean "%LOCALAPPDATA%\NVIDIA\GLCache"
    call :Clean "%LOCALAPPDATA%\NVIDIA\DXCache"
    call :Clean "%APPDATA%\NVIDIA\ComputeCache"
    call :Clean "%LOCALAPPDATA%\AMD\DxCache"
)


:: ==========================================================
:: RECYCLE BIN
:: ==========================================================
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1


:: ==========================================================
:: DISM
:: ==========================================================
echo.
echo ANALISI COMPONENT STORE...
DISM /Online /Cleanup-Image /AnalyzeComponentStore >> "%LOG%" 2>&1

if /i "%choiceWinSxS%"=="Y" (
    echo AGGRESSIVE CLEANUP>>"%LOG%"
    DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase >> "%LOG%" 2>&1
) else (
    echo STANDARD CLEANUP>>"%LOG%"
    DISM /Online /Cleanup-Image /StartComponentCleanup >> "%LOG%" 2>&1
)


:: ==========================================================
:: RESTART SERVICES
:: ==========================================================
for %%S in (bits wuauserv dosvc) do (
    net start %%S >nul 2>&1
    echo START SERVICE: %%S>>"%LOG%"
)


:: ==========================================================
:: RESTORE EXPLORER
:: ==========================================================
start explorer.exe >nul 2>&1


:: ==========================================================
:: END
:: ==========================================================
cls
echo ==============================
echo   CLEANUP COMPLETED (PRO)
echo ==============================
echo Log saved:
echo %LOG%
pause
exit /b


:: ==========================================================
:: CLEAN FUNCTION (SAFE + LOG)
:: ==========================================================
:Clean
if not exist "%~1" (
    echo SKIP: %~1>>"%LOG%"
    exit /b
)

echo CLEAN: %~1>>"%LOG%"

attrib -h -s "%~1\*" /s /d >nul 2>&1
del /f /s /q "%~1\*" >nul 2>&1
for /d %%G in ("%~1\*") do rd /s /q "%%G" >nul 2>&1

exit /b
