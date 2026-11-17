@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: =================================================================
:: CONTROLLO PERMESSI DI AMMINISTRATORE
:: =================================================================
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Richiesta dei permessi di amministratore in corso...
    powershell -NoProfile -Command "Start-Process cmd.exe -ArgumentList '/c \"\"%~dpnx0\"\"' -Verb RunAs"
    exit /b
)

:: =================================================================
:: IMPOSTAZIONI INIZIALI E CALCOLO SPAZIO LIBERATO
:: =================================================================
color 0B
title PULIZIA ESTREMA + COMPRESSIONE LZX - WINDOWS
set "ora_inizio=%TIME:~0,8%"
set "total_steps=30"
set "current_step=0"

for /f "tokens=*" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-PSDrive C).Free / 1GB, 2)"') do set "spazio_prima=%%a"

cls
echo =================================================================
echo    PULIZIA ESTREMA + COMPRESSIONE LZX DEL SISTEMA
echo =================================================================
echo.
echo  ATTENZIONE:
echo  1. Chiudi tutti i browser, giochi e programmi aperti.
echo  2. Questa procedura include la compressione LZX e DISM ResetBase:
echo     puo' richiedere da 5 a 20 minuti. NON spegnere il PC.
echo  3. I tuoi file personali, cookie e password sono al sicuro.
echo.
echo  Spazio libero attuale su C: %spazio_prima% GB
echo =================================================================
pause

:: =================================================================
:: FASE 1: PULIZIA PROFONDA DI WINDOWS E INSTALLAZIONI
:: =================================================================

set "desc=Pulizia cartelle Temp di Windows e Utente"
call :Avanzamento
del /f /q /s "C:\Windows\Temp\*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p" >nul 2>&1
del /f /q /s "%TEMP%\*" >nul 2>&1
for /d %%p in ("%TEMP%\*") do rmdir /s /q "%%p" >nul 2>&1

set "desc=Pulizia file temporanei Windows Installer, Patch e root C:"
call :Avanzamento
del /f /q /s "C:\Windows\Installer\*.tmp" >nul 2>&1
del /f /q /s "C:\Windows\Installer\*.log" >nul 2>&1
if exist "C:\Windows\Installer\$PatchCache$" rmdir /s /q "C:\Windows\Installer\$PatchCache$" >nul 2>&1
del /f /q /s "C:\*.tmp" >nul 2>&1
del /f /q /s "C:\*.chk" >nul 2>&1
del /f /q /s "C:\*.sqm" >nul 2>&1
del /f /q /s "C:\found.*" >nul 2>&1
for /d %%p in ("C:\found.*") do rmdir /s /q "%%p" >nul 2>&1

set "desc=Pulizia cache Windows Update e Delivery Optimization"
call :Avanzamento
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop dosvc >nul 2>&1
del /f /q /s "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%p in ("C:\Windows\SoftwareDistribution\Download\*") do rmdir /s /q "%%p" >nul 2>&1
if exist "C:\Windows\SoftwareDistribution\PostRebootEventCache.V2" rmdir /s /q "C:\Windows\SoftwareDistribution\PostRebootEventCache.V2" >nul 2>&1
if exist "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" (
    del /f /q /s "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" >nul 2>&1
)
powershell -NoProfile -Command "Get-CimInstance -Namespace root/Microsoft/Windows/DeliveryOptimization -ClassName MSFT_DeliveryOptimizationConfiguration | Invoke-CimMethod -MethodName DeleteCache" >nul 2>&1
net start dosvc >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1

set "desc=Rimozione residui vecchie installazioni Windows (Windows.old / BT)"
call :Avanzamento
if exist "C:\Windows.old" (
    takeown /F "C:\Windows.old" /R /A /D Y >nul 2>&1
    icacls "C:\Windows.old" /grant Administrators:F /T >nul 2>&1
    rmdir /s /q "C:\Windows.old" >nul 2>&1
)
if exist "C:\$WINDOWS.~BT" (
    takeown /F "C:\$WINDOWS.~BT" /R /A /D Y >nul 2>&1
    icacls "C:\$WINDOWS.~BT" /grant Administrators:F /T >nul 2>&1
    rmdir /s /q "C:\$WINDOWS.~BT" >nul 2>&1
)
if exist "C:\$SysReset" rmdir /s /q "C:\$SysReset" >nul 2>&1
if exist "C:\$GetCurrent" rmdir /s /q "C:\$GetCurrent" >nul 2>&1
if exist "C:\USMTMIG" rmdir /s /q "C:\USMTMIG" >nul 2>&1
if exist "C:\MSOCache" (
    takeown /F "C:\MSOCache" /R /A /D Y >nul 2>&1
    icacls "C:\MSOCache" /grant Administrators:F /T >nul 2>&1
    rmdir /s /q "C:\MSOCache" >nul 2>&1
)

set "desc=Rimozione pacchetti di installazione driver estratti (NVIDIA/AMD/Intel)"
call :Avanzamento
if exist "C:\AMD" rmdir /s /q "C:\AMD" >nul 2>&1
if exist "C:\Intel" rmdir /s /q "C:\Intel" >nul 2>&1
if exist "C:\NVIDIA" rmdir /s /q "C:\NVIDIA" >nul 2>&1
if exist "%ProgramData%\NVIDIA Corporation\InstallerGrid" del /f /q /s "%ProgramData%\NVIDIA Corporation\InstallerGrid\*.exe" >nul 2>&1
if exist "%ProgramFiles%\NVIDIA Corporation\Installer2" rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\Installer2" >nul 2>&1
if exist "C:\ProgramData\AMD\OemDrivers" rmdir /s /q "C:\ProgramData\AMD\OemDrivers" >nul 2>&1
if exist "C:\ProgramData\Intel\Downloads" rmdir /s /q "C:\ProgramData\Intel\Downloads" >nul 2>&1

set "desc=Svuotamento Cestino e file di backup sistema"
call :Avanzamento
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
del /f /q "C:\Windows\Boot\EFI\*.bak" >nul 2>&1
del /f /q /s "C:\Windows\Fonts\*.bak" >nul 2>&1
del /f /q /s "C:\Windows\Fonts\*.tmp" >nul 2>&1

:: =================================================================
:: FASE 2: LOG, TELEMETRIA E CRASH DUMP
:: =================================================================

set "desc=Eliminazione file dump errori e schermate blu (CrashDumps)"
call :Avanzamento
if exist "%SystemRoot%\MEMORY.DMP" del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
del /f /q /s "%SystemRoot%\Minidump\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\CrashDumps\*" >nul 2>&1
if exist "C:\Windows\LiveKernelReports" (
    del /f /q /s "C:\Windows\LiveKernelReports\*.dmp" >nul 2>&1
    for /d %%p in ("C:\Windows\LiveKernelReports\*") do rmdir /s /q "%%p" >nul 2>&1
)

set "desc=Eliminazione segnalazioni errori Windows (WER)"
call :Avanzamento
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" >nul 2>&1
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1

set "desc=Pulizia approfondita file di log di Windows"
call :Avanzamento
del /f /q /s "C:\Windows\Logs\*.log" >nul 2>&1
del /f /q /s "C:\Windows\Logs\CBS\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\DISM\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\WindowsUpdate\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\MeasuredBoot\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\WaasMedic\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\Defrag\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\NetworkDiagnostics\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\MOS\*" >nul 2>&1
del /f /q /s "C:\Windows\Logs\VDS\*" >nul 2>&1
del /f /q /s "C:\Windows\Panther\*.log" >nul 2>&1
del /f /q /s "C:\Windows\Panther\*.tmp" >nul 2>&1
del /f /q /s "C:\Windows\inf\setupapi*.log" >nul 2>&1
del /f /q /s "C:\PerfLogs\*" >nul 2>&1

set "desc=Pulizia log telemetria, WMI, Rete, Bluetooth e Audio"
call :Avanzamento
del /f /q /s "C:\Windows\System32\LogFiles\HTTPERR\*" >nul 2>&1
del /f /q /s "C:\Windows\System32\LogFiles\NetTrace\*" >nul 2>&1
del /f /q /s "C:\Windows\System32\LogFiles\Audio\*" >nul 2>&1
del /f /q /s "C:\Windows\System32\LogFiles\Bluetooth\*" >nul 2>&1
del /f /q /s "C:\Windows\System32\LogFiles\WLAN\*" >nul 2>&1
del /f /q /s "C:\Windows\System32\LogFiles\WMI\*.etl" >nul 2>&1
del /f /q /s "C:\Windows\System32\LogFiles\WMI\RtBackup\*.etl" >nul 2>&1
del /f /q /s "C:\Windows\System32\SleepStudy\*" >nul 2>&1
del /f /q /s "C:\Windows\Microsoft.NET\Framework*\*\*.log" >nul 2>&1
del /f /q /s "C:\ProgramData\Microsoft\Diagnosis\*.etw" >nul 2>&1
del /f /q /s "C:\ProgramData\Microsoft\RAC\StateData\*" >nul 2>&1
del /f /q /s "C:\ProgramData\Microsoft\RAC\Outbound\*" >nul 2>&1

set "desc=Pulizia cronologia scansioni e definizioni vecchie Windows Defender"
call :Avanzamento
del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1
del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Support\*" >nul 2>&1
if exist "%ProgramData%\Microsoft\Windows Defender\Definition Updates" (
    powershell -NoProfile -Command "Get-ChildItem -Path '$env:ProgramData\Microsoft\Windows Defender\Definition Updates' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^{.*}$' } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)

:: =================================================================
:: FASE 3: CACHE GRAFICHE, SISTEMA E STORE
:: =================================================================

set "desc=Pulizia Shader Cache (DirectX, NVIDIA, AMD, Intel, OpenGL)"
call :Avanzamento
del /f /q /s "%LOCALAPPDATA%\D3DSCache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\NVIDIA\DXCache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\NVIDIA\GLCache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\AMD\DxCache\*" >nul 2>&1
if exist "C:\ProgramData\Intel\ShaderCache" rmdir /s /q "C:\ProgramData\Intel\ShaderCache" >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\Windows\GLCache" rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\GLCache" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\*GLCache\*" >nul 2>&1

set "desc=Pulizia cache Font, Icone, Miniature e Rete"
call :Avanzamento
net stop fontcache >nul 2>&1
del /f /q /s "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.dat" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\FontCache\*" >nul 2>&1
net start fontcache >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\CryptnetUrlCache" rmdir /s /q "%LOCALAPPDATA%\Microsoft\CryptnetUrlCache" >nul 2>&1
certutil -urlcache * delete >nul 2>&1

set "desc=Pulizia cache Microsoft Store, App UWP e Pacchetti Orfani"
call :Avanzamento
wsreset -s >nul 2>&1
powershell -NoProfile -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Directory -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item ($_.FullName + '\TempState\*') -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item ($_.FullName + '\LocalCache\*') -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item ($_.FullName + '\AC\INetCache\*') -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -NoProfile -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -ErrorAction SilentlyContinue | Where-Object { (Get-AppxPackage -Name $_.Name -AllUsers) -eq $null } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1

set "desc=Pulizia coda di stampa e cache file offline (CSC)"
call :Avanzamento
net stop spooler >nul 2>&1
del /f /q /s "C:\Windows\System32\spool\PRINTERS\*" >nul 2>&1
net start spooler >nul 2>&1
if exist "C:\Windows\CSC" (
    takeown /F "C:\Windows\CSC" /R /A >nul 2>&1
    icacls "C:\Windows\CSC" /grant Administrators:F /T >nul 2>&1
    del /f /q /s "C:\Windows\CSC\*" >nul 2>&1
)

:: =================================================================
:: FASE 4: BROWSER (CACHE E CRASH - COOKIE E PASSWORD INTATTI)
:: =================================================================

set "desc=Pulizia cache Google Chrome (tutti i profili)"
call :Avanzamento
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    for /d %%g in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do (
        del /f /q /s "%%g\Cache\*" >nul 2>&1
        del /f /q /s "%%g\Code Cache\*" >nul 2>&1
        del /f /q /s "%%g\GPUCache\*" >nul 2>&1
        del /f /q /s "%%g\Media Cache\*" >nul 2>&1
        if exist "%%g\ShaderCache" rmdir /s /q "%%g\ShaderCache" >nul 2>&1
        if exist "%%g\Application Cache" rmdir /s /q "%%g\Application Cache" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" >nul 2>&1
)

set "desc=Pulizia cache Microsoft Edge e EdgeWebView"
call :Avanzamento
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    for /d %%e in ("%LOCALAPPDATA%\Microsoft\Edge\User Data\*") do (
        del /f /q /s "%%e\Cache\*" >nul 2>&1
        del /f /q /s "%%e\Code Cache\*" >nul 2>&1
        del /f /q /s "%%e\GPUCache\*" >nul 2>&1
        if exist "%%e\ShaderCache" rmdir /s /q "%%e\ShaderCache" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\EdgeWebView\User Data\Default\Cache" del /f /q /s "%LOCALAPPDATA%\Microsoft\EdgeWebView\User Data\Default\Cache\*" >nul 2>&1

set "desc=Pulizia cache Mozilla Firefox (cookie e preferiti intatti)"
call :Avanzamento
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%f in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        del /f /q /s "%%f\cache2\*" >nul 2>&1
        del /f /q /s "%%f\jumpListCache\*" >nul 2>&1
        if exist "%%f\startupCache" rmdir /s /q "%%f\startupCache" >nul 2>&1
        if exist "%%f\MediaCache" rmdir /s /q "%%f\MediaCache" >nul 2>&1
    )
)
if exist "%APPDATA%\Mozilla\Firefox\Crash Reports" rmdir /s /q "%APPDATA%\Mozilla\Firefox\Crash Reports" >nul 2>&1

set "desc=Pulizia cache Brave, Opera, Opera GX e Vivaldi"
call :Avanzamento
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data" (
    for /d %%b in ("%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*") do (
        del /f /q /s "%%b\Cache\*" >nul 2>&1
        del /f /q /s "%%b\Code Cache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" rmdir /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache" del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Media Cache" del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Media Cache\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache" del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache" del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" rmdir /s /q "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" >nul 2>&1
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache" del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1

:: =================================================================
:: FASE 5: SOCIAL, MEDIA, CLOUD E GAMING
:: =================================================================

set "desc=Pulizia cache Discord, Teams, Zoom, Slack e Signal"
call :Avanzamento
del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Code Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\GPUCache\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\logs\*" >nul 2>&1
if exist "%APPDATA%\discord\Crashpad" rmdir /s /q "%APPDATA%\discord\Crashpad" >nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Teams\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Teams\Application Cache\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Teams\logs\*" >nul 2>&1
del /f /q /s "%APPDATA%\Zoom\logs\*" >nul 2>&1
del /f /q /s "%APPDATA%\Slack\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\Slack\Code Cache\*" >nul 2>&1
if exist "%APPDATA%\Signal\Cache" rmdir /s /q "%APPDATA%\Signal\Cache" >nul 2>&1

set "desc=Pulizia cache Telegram, WhatsApp, Spotify, VLC e Cloud"
call :Avanzamento
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    mkdir "%TEMP%\t_empty" >nul 2>&1
    robocopy "%TEMP%\t_empty" "%APPDATA%\Telegram Desktop\tdata\user_data\cache" /MIR >nul 2>&1
    rmdir /s /q "%TEMP%\t_empty" >nul 2>&1
)
del /f /q /s "%APPDATA%\Telegram Desktop\tdata\crashes\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Spotify\Storage\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Spotify\Data\*" >nul 2>&1
if exist "%APPDATA%\vlc\art" rmdir /s /q "%APPDATA%\vlc\art" >nul 2>&1
if exist "%APPDATA%\vlc\cache" rmdir /s /q "%APPDATA%\vlc\cache" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logs\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\cache" rmdir /s /q "%LOCALAPPDATA%\Microsoft\OneDrive\cache" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\DriveFS\Logs\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Google\DriveFS\CloudCache" rmdir /s /q "%LOCALAPPDATA%\Google\DriveFS\CloudCache" >nul 2>&1

set "desc=Pulizia cache Steam, Epic Games, Riot, EA, Ubisoft e Battle.net"
call :Avanzamento
del /f /q /s "C:\Program Files (x86)\Steam\cached\*" >nul 2>&1
del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1
del /f /q /s "C:\Program Files (x86)\Steam\logs\*" >nul 2>&1
if exist "C:\Program Files (x86)\Steam\dumps" rmdir /s /q "C:\Program Files (x86)\Steam\dumps" >nul 2>&1
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Logs" rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Logs" >nul 2>&1
del /f /q /s "%PROGRAMFILES%\Riot Vanguard\Logs\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Roblox\logs\*" >nul 2>&1
del /f /q /s "%APPDATA%\.minecraft\logs\*" >nul 2>&1
del /f /q /s "%APPDATA%\.minecraft\crash-reports\*" >nul 2>&1

set "desc=Pulizia cache Adobe, Office, OBS e Sviluppo (pip/npm/VSCode)"
call :Avanzamento
del /f /q /s "%LOCALAPPDATA%\Adobe\DXP\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Adobe\Logs\*" >nul 2>&1
del /f /q /s "%APPDATA%\Adobe\Common\Media Cache Files\*" >nul 2>&1
if exist "%APPDATA%\Adobe\Common\Media Cache" rmdir /s /q "%APPDATA%\Adobe\Common\Media Cache" >nul 2>&1
if exist "%APPDATA%\Adobe\Common\Peak Files" rmdir /s /q "%APPDATA%\Adobe\Common\Peak Files" >nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Word\*.tmp" >nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Excel\*.tmp" >nul 2>&1
del /f /q /s "%APPDATA%\obs-studio\crashes\*" >nul 2>&1
if exist "%LOCALAPPDATA%\pip\Cache" rmdir /s /q "%LOCALAPPDATA%\pip\Cache" >nul 2>&1
if exist "%APPDATA%\npm-cache" rmdir /s /q "%APPDATA%\npm-cache" >nul 2>&1
if exist "%APPDATA%\Code\logs" del /f /q /s "%APPDATA%\Code\logs\*" >nul 2>&1
if exist "%APPDATA%\Code\CachedExtensionVSIX" rmdir /s /q "%APPDATA%\Code\CachedExtensionVSIX" >nul 2>&1

:: =================================================================
:: FASE 6: RIDUZIONE SPAZIO SISTEMA (HIBERFIL, RESERVED STORAGE, DISM)
:: =================================================================

set "desc=Riduzione file ibernazione al 50%% (mantiene Avvio Rapido attivo)"
call :Avanzamento
powercfg -h -size 50 >nul 2>&1

set "desc=Disattivazione Archiviazione Riservata di Windows (recupera ~7 GB)"
call :Avanzamento
DISM.exe /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

set "desc=Pulizia profonda componenti WinSxS con ResetBase (attendere...)"
call :Avanzamento
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1
:: =================================================================
:: FASE 7: COMPRESSIONE AVANZATA LZX E COMPACTOS
:: =================================================================

set "desc=Compressione binari del Sistema Operativo (CompactOS LZX - attendere...)"
call :Avanzamento
compact /compactos:always >nul 2>&1

set "desc=Compressione LZX archivio Driver (C:\Windows\System32\DriverStore)"
call :Avanzamento
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:"C:\Windows\System32\DriverStore\FileRepository" /exe:lzx /i >nul 2>&1
)

set "desc=Compressione LZX cartelle Servicing, PowerShell e SystemResources"
call :Avanzamento
if exist "C:\Windows\Servicing" compact /c /s:"C:\Windows\Servicing" /exe:lzx /i >nul 2>&1
if exist "C:\Windows\System32\WindowsPowerShell" compact /c /s:"C:\Windows\System32\WindowsPowerShell" /exe:lzx /i >nul 2>&1
if exist "C:\Windows\SystemResources" compact /c /s:"C:\Windows\SystemResources" /exe:lzx /i >nul 2>&1
if exist "C:\Windows\Help" compact /c /s:"C:\Windows\Help" /exe:lzx /i >nul 2>&1
if exist "C:\Windows\InputMethod" compact /c /s:"C:\Windows\InputMethod" /exe:lzx /i >nul 2>&1

set "desc=Compressione LZX pacchetti Windows Installer (.msi)"
call :Avanzamento
powershell -NoProfile -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.msi -ErrorAction SilentlyContinue | ForEach-Object { compact /c /exe:lzx $_.FullName >$null 2>&1 }"

set "desc=Compressione LZX cartelle Programmi (C:\Program Files)"
call :Avanzamento
compact /c /s:"C:\Program Files" /exe:lzx /i >nul 2>&1

set "desc=Compressione LZX cartelle Programmi x86 (C:\Program Files (x86))"
call :Avanzamento
if exist "C:\Program Files (x86)" compact /c /s:"C:\Program Files (x86)" /exe:lzx /i >nul 2>&1

set "desc=Compressione LZX AppRepository, AppData (Local/Roaming) e Utenti Pubblici"
call :Avanzamento
if exist "C:\ProgramData\Microsoft\Windows\AppRepository" compact /c /s:"C:\ProgramData\Microsoft\Windows\AppRepository" /exe:lzx /i >nul 2>&1
if exist "C:\Users\Public" compact /c /s:"C:\Users\Public" /exe:lzx /i >nul 2>&1
compact /c /s:"%LOCALAPPDATA%" /exe:lzx /i >nul 2>&1
compact /c /s:"%APPDATA%" /exe:lzx /i >nul 2>&1

:: =================================================================
:: FASE 8: PULIZIA FINALE E OTTIMIZZAZIONE DISCO
:: =================================================================

set "desc=Pulizia Prefetch e Svuotamento Cache DNS"
call :Avanzamento
del /f /q /s "C:\Windows\Prefetch\*" >nul 2>&1
ipconfig /flushdns >nul 2>&1

set "desc=Ottimizzazione finale unita C: (TRIM per SSD / Defrag per HDD)"
call :Avanzamento
defrag C: /O >nul 2>&1

:: =================================================================
:: SCHERMATA FINALE CON CALCOLO SPAZIO RECUPERATO
:: =================================================================
for /f "tokens=*" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-PSDrive C).Free / 1GB, 2)"') do set "spazio_dopo=%%a"
for /f "tokens=*" %%a in ('powershell -NoProfile -Command "[math]::Round(%spazio_dopo% - %spazio_prima%, 2)"') do set "spazio_recuperato=%%a"

cls
echo =================================================================
echo    PULIZIA ESTREMA E COMPRESSIONE COMPLETATE!
echo =================================================================
echo.
echo  Operazioni eseguite : %current_step% su %total_steps%
echo  Ora inizio          : %ora_inizio%
echo  Ora fine            : %TIME:~0,8%
echo.
echo  Spazio libero prima : %spazio_prima% GB
echo  Spazio libero ora   : %spazio_dopo% GB
echo  Spazio recuperato   : %spazio_recuperato% GB
echo.
echo  Si consiglia di RIAVVIARE IL COMPUTER per applicare tutte le
echo  ottimizzazioni di sistema.
echo =================================================================
pause
exit /b

:: =================================================================
:: FUNZIONE BARRA DI AVANZAMENTO REALE
:: =================================================================
:Avanzamento
set /a current_step+=1
set /a percent=(current_step * 100) / total_steps
set /a filled=(percent * 25) / 100
set "bar="
for /L %%i in (1,1,25) do (
    if %%i leq !filled! (
        set "bar=!bar!#"
    ) else (
        set "bar=!bar!-"
    )
)
cls
echo =================================================================
echo    PULIZIA ESTREMA + COMPRESSIONE IN CORSO...
echo =================================================================
echo.
echo  Avanzamento: [!bar!] !percent!%%  [%current_step%/%total_steps%]
echo.
echo  Operazione attuale:
echo  ^> !desc!
echo.
echo =================================================================
exit /b


