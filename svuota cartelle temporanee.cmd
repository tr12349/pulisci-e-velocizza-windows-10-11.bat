@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Pulizia Completa Windows 10/11 + Hardware (Edizione Finale Corretta)
color 0A

:: ==========================================================
:: PULIZIA COMPLETA WINDOWS (Versione Internazionale Blindata)
:: ==========================================================

:: Elevazione privilegi
>nul 2>&1 net session
if %errorlevel% neq 0 (
 powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
 exit /b
)

cd /d "%~dp0"
cls

echo ==========================================
echo      PULIZIA COMPLETA WINDOWS E BROWSER
echo ==========================================
echo.

:: Servizi
echo Arresto servizi in corso...
for %%S in (wuauserv bits dosvc) do net stop %%S >nul 2>&1

timeout /t 2 /nobreak >nul

echo Chiusura Explorer...
tasklist | find /i "explorer.exe" >nul
if not errorlevel 1 taskkill /f /im explorer.exe /t >nul 2>&1

:: Chiusura Browser per sbloccare i file di cache
echo Chiusura Google Chrome e Microsoft Edge...
tasklist | find /i "chrome.exe" >nul
if not errorlevel 1 taskkill /f /im chrome.exe /t >nul 2>&1
tasklist | find /i "msedge.exe" >nul
if not errorlevel 1 taskkill /f /im msedge.exe /t >nul 2>&1

:: Chiusura Steam per sbloccare i file di cache applicazione
echo Chiusura Steam Launcher...
tasklist | find /i "steam.exe" >nul
if not errorlevel 1 taskkill /f /im steam.exe /t >nul 2>&1

echo Pulizia file in corso...

:: Cache icone e miniature
del /f /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*" >nul 2>&1
del /f /q "%USERPROFILE%\AppData\Local\IconCache.db" >nul 2>&1

:: Temp utente
del /f /s /q "%USERPROFILE%\AppData\Local\Temp\*" >nul 2>&1
for /d %%G in ("%USERPROFILE%\AppData\Local\Temp\*") do rd /s /q "%%G" >nul 2>&1

:: Temp Windows
del /f /s /q "%windir%\Temp\*" >nul 2>&1
for /d %%G in ("%windir%\Temp\*") do rd /s /q "%%G" >nul 2>&1

:: Windows Update
del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%G in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%G" >nul 2>&1

:: Delivery Optimization
del /f /s /q "%windir%\SoftwareDistribution\DeliveryOptimization\*" >nul 2>&1
for /d %%G in ("%windir%\SoftwareDistribution\DeliveryOptimization\*") do rd /s /q "%%G" >nul 2>&1

:: DirectX Cache
del /f /s /q "%USERPROFILE%\AppData\Local\D3DSCache\*" >nul 2>&1
for /d %%G in ("%USERPROFILE%\AppData\Local\D3DSCache\*") do rd /s /q "%%G" >nul 2>&1

:: Compute Index
del /f /s /q "%USERPROFILE%\AppData\Local\LocalComputeIndex\*" >nul 2>&1
for /d %%G in ("%USERPROFILE%\AppData\Local\LocalComputeIndex\*") do rd /s /q "%%G" >nul 2>&1

:: WER
del /f /s /q "%ProgramData%\Microsoft\Windows\WER\ReportArchive\*" >nul 2>&1
for /d %%G in ("%ProgramData%\Microsoft\Windows\WER\ReportArchive\*") do rd /s /q "%%G" >nul 2>&1
del /f /s /q "%ProgramData%\Microsoft\Windows\WER\ReportQueue\*" >nul 2>&1
for /d %%G in ("%ProgramData%\Microsoft\Windows\WER\ReportQueue\*") do rd /s /q "%%G" >nul 2>&1

:: CBS
del /f /q "%windir%\Logs\CBS\*.log" >nul 2>&1

:: Defender
del /f /s /q "%ProgramData%\Microsoft\Windows Defender\Scans\History\Service\*" >nul 2>&1

:: Crash dump
del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
del /f /q "%SystemRoot%\Minidump\*" >nul 2>&1

:: Recenti
del /f /q "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Recent\*.lnk" >nul 2>&1

:: DNS
ipconfig /flushdns >nul

:: Microsoft Store Cache
del /f /s /q "%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache\*" >nul 2>&1

:: ==========================================================
:: PULIZIA COMPLETA SELETTIVA PROFILI BROWSER
:: ==========================================================

:: Google Chrome (Pulisce chirurgicamente solo Default e Profile *)
for /d %%P in ("%USERPROFILE%\AppData\Local\Google\Chrome\User Data\*") do (
    set "isValid=0"
    set "folderName=%%~nxP"
    if "!folderName!"=="Default" set "isValid=1"
    if "!folderName:~0,7!"=="Profile" set "isValid=1"
    
    if "!isValid!"=="1" (
        if exist "%%P\Cache" (
            del /f /s /q "%%P\Cache\*" >nul 2>&1
            for /d %%G in ("%%P\Cache\*") do rd /s /q "%%G" >nul 2>&1
        )
        if exist "%%P\Code Cache" (
            del /f /s /q "%%P\Code Cache\*" >nul 2>&1
            for /d %%G in ("%%P\Code Cache\*") do rd /s /q "%%G" >nul 2>&1
        )
    )
)

:: Microsoft Edge (Pulisce chirurgicamente solo Default e Profile *)
for /d %%P in ("%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\*") do (
    set "isValid=0"
    set "folderName=%%~nxP"
    if "!folderName!"=="Default" set "isValid=1"
    if "!folderName:~0,7!"=="Profile" set "isValid=1"
    
    if "!isValid!"=="1" (
        if exist "%%P\Cache" (
            del /f /s /q "%%P\Cache\*" >nul 2>&1
            for /d %%G in ("%%P\Cache\*") do rd /s /q "%%G" >nul 2>&1
        )
        if exist "%%P\Code Cache" (
            del /f /s /q "%%P\Code Cache\*" >nul 2>&1
            for /d %%G in ("%%P\Code Cache\*") do rd /s /q "%%G" >nul 2>&1
        )
    )
)

:: ==========================================================
:: PULIZIA CACHE HARDWARE E RUNTIME
:: ==========================================================

:: Cache Shader NVIDIA
if exist "%USERPROFILE%\AppData\Local\NVIDIA\GLCache" (
    del /f /s /q "%USERPROFILE%\AppData\Local\NVIDIA\GLCache\*" >nul 2>&1
    for /d %%G in ("%USERPROFILE%\AppData\Local\NVIDIA\GLCache\*") do rd /s /q "%%G" >nul 2>&1
)
if exist "%USERPROFILE%\AppData\Local\NVIDIA\DXCache" (
    del /f /s /q "%USERPROFILE%\AppData\Local\NVIDIA\DXCache\*" >nul 2>&1
    for /d %%G in ("%USERPROFILE%\AppData\Local\NVIDIA\DXCache\*") do rd /s /q "%%G" >nul 2>&1
)
if exist "%USERPROFILE%\AppData\Roaming\NVIDIA\ComputeCache" (
    del /f /s /q "%USERPROFILE%\AppData\Roaming\NVIDIA\ComputeCache\*" >nul 2>&1
    for /d %%G in ("%USERPROFILE%\AppData\Roaming\NVIDIA\ComputeCache\*") do rd /s /q "%%G" >nul 2>&1
)

:: Cache Installer NVIDIA (Cartella radice rimovibile interamente)
if exist "C:\NVIDIA" rd /s /q "C:\NVIDIA" >nul 2>&1

:: Cache Shader AMD Radeon
if exist "%USERPROFILE%\AppData\Local\AMD\DxCache" (
    del /f /s /q "%USERPROFILE%\AppData\Local\AMD\DxCache\*" >nul 2>&1
    for /d %%G in ("%USERPROFILE%\AppData\Local\AMD\DxCache\*") do rd /s /q "%%G" >nul 2>&1
)

:: Cache Runtime Java
if exist "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\cache" (
    del /f /s /q "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\cache\*" >nul 2>&1
    for /d %%G in ("%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\cache\*") do rd /s /q "%%G" >nul 2>&1
)

:: Cache Launcher e Shader Steam (Rilevamento dinamico dal Registro di sistema)
set "STEAM_PATH="
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v "SteamPath" 2^>nul') do set "STEAM_PATH=%%B"
if defined STEAM_PATH (
    set "STEAM_PATH=!STEAM_PATH:/=\!"
    if exist "!STEAM_PATH!\appcache" (
        del /f /s /q "!STEAM_PATH!\appcache\*" >nul 2>&1
        for /d %%G in ("!STEAM_PATH!\appcache\*") do rd /s /q "%%G" >nul 2>&1
    )
    if exist "!STEAM_PATH!\htmlcache" (
        del /f /s /q "!STEAM_PATH!\htmlcache\*" >nul 2>&1
        for /d %%G in ("!STEAM_PATH!\htmlcache\*") do rd /s /q "%%G" >nul 2>&1
    )
    if exist "!STEAM_PATH!\steamapps\shadercache" (
        del /f /s /q "!STEAM_PATH!\steamapps\shadercache\*" >nul 2>&1
        for /d %%G in ("!STEAM_PATH!\steamapps\shadercache\*") do rd /s /q "%%G" >nul 2>&1
    )
)

:: Cache Diagnostica Sicura di WSL / Ubuntu (Esclude ext4.vhdx)
for /d %%D in ("%USERPROFILE%\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu*") do (
    if exist "%%D\LocalState\diagnostics" (
        del /f /s /q "%%D\LocalState\diagnostics\*" >nul 2>&1
        for /d %%G in ("%%D\LocalState\diagnostics\*") do rd /s /q "%%G" >nul 2>&1
    )
    if exist "%%D\LocalState\logs" (
        del /f /s /q "%%D\LocalState\logs\*" >nul 2>&1
        for /d %%G in ("%%D\LocalState\logs\*") do rd /s /q "%%G" >nul 2>&1
    )
)

:: ==========================================================

:: Cestino
powershell -NoProfile -ExecutionPolicy Bypass "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1

:: Component Store
echo.
echo Ottimizzazione Component Store (Rimozione vecchi update)...
DISM /Online /Cleanup-Image /StartComponentCleanup

:: Storage Sense (Invocazione e attesa sincrona con controllo di stato sanificato)
echo Esecuzione Pulizia Disco tramite Storage Sense...
schtasks /run /tn "\Microsoft\Windows\StorageSense\StorageSenseTask" >nul 2>&1

:AttesaStorageSense
timeout /t 3 /nobreak >nul
:: Il metodo .Trim() rimuove spazi vuoti e ritorni a capo (\r\n) evitando bug di confronto stringa
set "taskState="
for /f "delims=" %%I in ('powershell -NoProfile -Command "[string](Get-ScheduledTask -TaskName 'StorageSenseTask').State.ToString().Trim()"') do set "taskState=%%I"
if /i "!taskState!"=="Running" goto AttesaStorageSense

:: Riavvio servizi
echo Ripristino servizi...
for %%S in (bits wuauserv dosvc) do net start %%S >nul 2>&1

:: Explorer
start "" explorer.exe

cls
echo.
echo ==========================================
echo          PULIZIA COMPLETATA
echo ==========================================
echo.
echo [OK] Temp Utente
echo [OK] Temp Windows
echo [OK] Windows Update
echo [OK] Delivery Optimization
echo [OK] DirectX Cache
echo [OK] ThumbCache
echo [OK] IconCache
echo [OK] Compute Index
echo [OK] Windows Error Reporting
echo [OK] CBS Logs
echo [OK] Windows Defender Cache
echo [OK] Crash Dump
echo [OK] Recenti
echo [OK] DNS Cache
echo [OK] Microsoft Store Cache
echo [OK] Cache Multi-Profilo Chrome (Sanificata)
echo [OK] Cache Multi-Profilo Edge (Sanificata)
echo [OK] Cache GPU NVIDIA / AMD (Sanificata)
echo [OK] Installer Obsoleti NVIDIA (Rimossi)
echo [OK] Cache Java Deployment (Sanificata)
echo [OK] Cache e Shader Steam (Sanificata)
echo [OK] Diagnostica e Log WSL/Ubuntu (Protetti)
echo [OK] Svuotamento Cestino
echo [OK] Component Store DISM
echo [OK] Storage Sense (Output Trimmed e Sincronizzato)
echo.

pause
exit
