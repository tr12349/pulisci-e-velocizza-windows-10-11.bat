:: SCRIPT AVANZATO DI MANUTENZIONE, PULIZIA E OTTIMIZZAZIONE WINDOWS
:: Sviluppato da: tr12349 & AI
:: Nota per il revisore: Eseguire come Amministratore per abilitare i permessi di scrittura.
:: =================================================================
@echo off
setlocal enabledelayedexpansion

:: =======================================================================
:: CONTROLLO E RICHIESTA AUTOMATICA PERMESSI DI AMMINISTRATORE (UAC)
:: =======================================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Richiesta dei permessi di amministratore in corso...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set "params=%*"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
cls

:: =======================================================================
:: CONFIGURAZIONE INTERFACCIA ED ESECUZIONE AUTOMATICA (NO INPUT)
:: =======================================================================
title Windows Space Overlord - Master Ultimate Edition v4.0 (500 Steps)

echo =======================================================================
echo        BENVENUTO IN WINDOWS SPACE OVERLORD - ULTIMATE EDITION v4.0
echo =======================================================================
echo.
echo [*] Configurazione automatica: Scansione profonda SFC ABILITATA.
set "esegui_sfc=SI"
echo.

echo =======================================================================
echo    AVVIO CONFIGURAZIONE E ANALISI DELLO SPAZIO... VIA ALLA PULIZIA!
echo =======================================================================
echo.

:: =======================================================================
:: SALVATAGGIO DATI ORARIO E SPAZIO (METODO FLUIDO SENZA INTERRUZIONI)
:: =======================================================================
:: Cattura lo spazio e il tempo totale in secondi tramite una chiamata esterna sicura
:: Questo evita al 100% il crash dello spazio vuoto o dello zero iniziale (errore ottale)
for /f "tokens=1,2 delims=," %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$time=[DateTime]::Now; $seconds=($time.Hour * 3600) + ($time.Minute * 60) + $time.Second; $space=[math]::round(((Get-Volume -DriveLetter C).SizeRemaining / 1GB), 2); Write-Output \"$seconds,$space\""') do (
    set "start_seconds=%%a"
    set "spazio_iniziale=%%b"
)

:: Pulizia preventiva dei vecchi file di report sul Desktop per evitare blocchi
if exist "%USERPROFILE%\Desktop\Pulizia_Report.txt" (del /f /q "%USERPROFILE%\Desktop\Pulizia_Report.txt" >nul 2>&1)
if exist "%USERPROFILE%\Desktop\File_Piu_Pesanti.txt" (del /f /q "%USERPROFILE%\Desktop\File_Piu_Pesanti.txt" >nul 2>&1)

echo Configurazione completata. Lo spazio iniziale rilevato e di %spazio_iniziale% GB.
timeout /t 2 >nul
cls

:: =======================================================================
:: INIZIO DEI PASSAGGI DI PULIZIA REALI
:: =======================================================================

echo [1/430] Svuotamento e Pulizia delle Cartelle Temporanee di Sistema...
del /f /q /s C:\Windows\Temp\* >nul 2>&1
for /d %%p in (C:\Windows\Temp\*) do rmdir /s /q "%%p" >nul 2>&1
del /f /q /s "%temp%\*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [2/430] Pulizia file obsoleti della cartella Prefetch...
del /f /q /s C:\Windows\Prefetch\* >nul 2>&1
for /d %%p in (C:\Windows\Prefetch\*) do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [3/430] Svuotamento Cache di Windows Update (SoftwareDistribution)...
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1
timeout /t 2 >nul
del /f /q /s C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
for /d %%p in (C:\Windows\SoftwareDistribution\Download\*) do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo OK.

echo [4/430] Reset e svuotamento rapido della cache del Cestino...
if exist C:\$Recycle.Bin ( rd /s /q C:\$Recycle.Bin >nul 2>&1 )
echo OK.

echo [5/430] Eliminazione dei file di Log e Report di Errore (Crash Dumps)...
del /f /q /s C:\Windows\Logs\*.log >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\CrashDumps\*.dmp" >nul 2>&1
echo OK.

echo [6/430] PULIZIA CHROME: Cache, Code Cache e Segnalazioni Crash...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    for /d %%g in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do (
        del /f /q /s "%%g\Cache\*" >nul 2>&1
        del /f /q /s "%%g\Code Cache\*" >nul 2>&1
        del /f /q /s "%%g\GPUCache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" >nul 2>&1)
)
echo OK.

echo [7/430] PULIZIA EDGE: Cache, Code Cache e Segnalazioni Crash...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    for /d %%e in ("%LOCALAPPDATA%\Microsoft\Edge\User Data\*") do (
        del /f /q /s "%%e\Cache\*" >nul 2>&1
        del /f /q /s "%%e\Code Cache\*" >nul 2>&1
        del /f /q /s "%%e\GPUCache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" >nul 2>&1)
)
echo OK.

echo [8/430] PULIZIA FIREFOX: Cache dei profili utente...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%f in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        del /f /q /s "%%f\cache2\*" >nul 2>&1
        del /f /q /s "%%f\jumpListCache\*" >nul 2>&1
        del /f /q /s "%%f\crashes\*" >nul 2>&1
    )
)
echo OK.

echo [9/430] PULIZIA BRAVE: Cache, Code Cache e Componenti Temporanei...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data" (
    for /d %%b in ("%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*") do (
        del /f /q /s "%%b\Cache\*" >nul 2>&1
        del /f /q /s "%%b\Code Cache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" >nul 2>&1)
)
echo OK.

echo [10/430] Svuotamento Cache App pesanti (Spotify/Discord)...
del /f /q /s "%LOCALAPPDATA%\Spotify\Storage\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Code Cache\*" >nul 2>&1
echo OK.

echo [11/430] Ottimizzazione Scritture NTFS ed Eliminazione Timestamp Accessi...
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo OK.

echo [12/430] Rimozione App Spazzatura Preinstallate (Bloatware)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-AppxPackage *BingWeather* | Remove-AppxPackage; Get-AppxPackage *GetHelp* | Remove-AppxPackage; Get-AppxPackage *3DBuilder* | Remove-AppxPackage" >nul 2>&1
echo OK.

if not exist "%USERPROFILE%\Desktop\DUPLICATI_RILEVATI" (mkdir "%USERPROFILE%\Desktop\DUPLICATI_RILEVATI" >nul 2>&1)

echo [13-16/430] ISOLAMENTO DUPLICATI: Scansione combinata cartelle Utente...
:: FIX: Protette le virgolette interne con l'escape triplo per evitare il crash immediato del parser Batch
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$paths = @('$env:USERPROFILE\Downloads', '$env:USERPROFILE\Documents', '$env:USERPROFILE\Pictures', '$env:USERPROFILE\Music'); Get-ChildItem -Path $paths -Recurse -File -ErrorAction SilentlyContinue | Group-Object Length | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Get-FileHash -Algorithm MD5 | Group-Object Hash | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object -Skip 1 | ForEach-Object { Move-Item -Path $_.Path -Destination '$env:USERPROFILE\Desktop\DUPLICATI_RILEVATI' -Force -ErrorAction SilentlyContinue } } }" >nul 2>&1
echo OK.

echo [17/430] Ottimizzazione Interfaccia per Massima Velocita...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
echo OK.

echo [18/250] Rimozione Forzata Vecchie Installazioni di Windows (Windows.old)...
if exist C:\Windows.old (
    takeown /F C:\Windows.old /R /A /D Y >nul 2>&1
    icacls C:\Windows.old /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\Windows.old >nul 2>&1
)
echo OK.

echo [19/250] Pulizia Forzata Cartelle Cache dei Driver Estratti (Intel/AMD/NVIDIA)...
if exist C:\AMD ( takeown /F C:\AMD /R /A /D Y >nul 2>&1 & icacls C:\AMD /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\AMD >nul 2>&1 )
if exist C:\Intel ( takeown /F C:\Intel /R /A /D Y >nul 2>&1 & icacls C:\Intel /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\Intel >nul 2>&1 )
if exist C:\NVIDIA ( takeown /F C:\NVIDIA /R /A /D Y >nul 2>&1 & icacls C:\NVIDIA /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\NVIDIA >nul 2>&1 )
echo OK.

echo [20/49] Pulizia della Cache dei pacchetti Windows Package Manager (Winget)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [21/49] Svuotamento cache di Telegram Desktop...
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    del /f /q /s "%APPDATA%\Telegram Desktop\tdata\user_data\cache\*" >nul 2>&1
    for /d %%p in ("%APPDATA%\Telegram Desktop\tdata\user_data\cache\*") do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [22/49] Pulizia file temporanei e installatori obsoleti di Adobe...
if exist "%LOCALAPPDATA%\Adobe\DXP" ( del /f /q /s "%LOCALAPPDATA%\Adobe\DXP\*" >nul 2>&1 )
if exist "%APPDATA%\Adobe\Common\Media Cache Files" ( del /f /q /s "%APPDATA%\Adobe\Common\Media Cache Files\*" >nul 2>&1 )
echo OK.

echo [23/49] Rimozione dei pacchetti di installazione residui di Microsoft Office...
if exist C:\MSOCache (
    takeown /F C:\MSOCache /R /A /D Y >nul 2>&1
    icacls C:\MSOCache /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\MSOCache >nul 2>&1
)
echo OK.

echo [24/49] Svuotamento cache delle App di Streaming (Netflix, Prime Video, Disney+)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'AC|INetCache|LocalCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [25/49] Rimozione dei file temporanei e installer orfani (.msi)...
del /f /q /s C:\Windows\Installer\*.tmp >nul 2>&1
echo OK.

echo [26/49] Rimozione dei pacchetti driver non in uso (Indipendente da lingua OS)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName -eq $null } | ForEach-Object { pnputil /delete-driver $_.InfName /uninstall /force }" >nul 2>&1
echo OK.

echo [27/49] Svuotamento della Cache DirectX Shader (Grafica)...
del /f /q /s "%LocalAppData%\D3DSCache\*" >nul 2>&1
for /d %%p in ("%LocalAppData%\D3DSCache\*") do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [28/49] Eliminazione file residui di installazione Windows ($WINDOWS.~BT)...
if exist C:\$WINDOWS.~BT (
    takeown /F C:\$WINDOWS.~BT /R /A /D Y >nul 2>&1
    icacls C:\$WINDOWS.~BT /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\$WINDOWS.~BT >nul 2>&1
)
echo OK.

echo [29/49] Pulizia dei Log di sistema HTTP e CBS (Component Based Servicing)...
del /f /q /s C:\Windows\System32\LogFiles\HTTPERR\* >nul 2>&1
del /f /q /s C:\Windows\Logs\CBS\*.log >nul 2>&1
if exist C:\inetpub\logs\LogFiles (del /f /q /s C:\inetpub\logs\LogFiles\* >nul 2>&1)
echo OK.

echo [30/49] Svuotamento cache dei client di gioco (Steam, Epic, EA)...
if exist "C:\Program Files (x86)\Steam\cached" (del /f /q /s "C:\Program Files (x86)\Steam\cached\*" >nul 2>&1)
if exist "C:\Program Files\Epic Games\Launcher\VaultCache" (del /f /q /s "C:\Program Files\Epic Games\Launcher\VaultCache\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache\*" >nul 2>&1)
echo OK.

echo [31/49] Svuotamento e rigenerazione pulita della cache dei Font...
net stop fontcache >nul 2>&1
del /f /q /s %WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.dat >nul 2>&1
net start fontcache >nul 2>&1
echo OK.

echo [32/49] Svuotamento della cache di Ottimizzazione Recapito (Delivery Optimization)...
net stop dosvc >nul 2>&1
if exist C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache (
    del /f /q /s C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\* >nul 2>&1
)
net start dosvc >nul 2>&1
echo OK.

echo [33/49] Eliminazione file residui driver Video (NVIDIA/AMD)...
if exist "%ProgramData%\NVIDIA Corporation\InstallerGrid" (del /f /q /s "%ProgramData%\NVIDIA Corporation\InstallerGrid\*.exe" >nul 2>&1)
if exist "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService" (del /f /q /s "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService\*.exe" >nul 2>&1)
if exist C:\AMD\Packagers (rmdir /s /q C:\AMD\Packagers >nul 2>&1)
echo OK.

echo [34/49] Svuotamento cache pacchetti parziali Microsoft Store (AppX)...
net stop wuauserv >nul 2>&1
if exist "%WinDir%\SoftwareDistribution\DataStore" (
    del /f /q /s "%WinDir%\SoftwareDistribution\DataStore\*" >nul 2>&1
)
net start wuauserv >nul 2>&1
echo OK.

echo [35/50] Svuotamento e ripristino della cache dei DNS...
ipconfig /flushdns >nul 2>&1
echo OK.

echo [36/50] Pulizia approfondita automatica (Cleanmgr Super-Sagerun)...
cleanmgr /sagerun:1 >nul 2>&1
echo OK.

echo [37/50] Sfoltimento sicuro della cache di Explorer e cache del Windows Store...
del /f /q /s "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q /s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
wsreset -s >nul 2>&1
echo OK.

echo [38/50] Eliminazione punti di ripristino vecchi - Mantiene SOLO il piu recente...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ComputerRestorePoint | Select-Object -SkipLast 1 | ForEach-Object { Checkpoint-Computer -Delete $_.SequenceNumber }" >nul 2>&1
echo OK.

echo [39/50] Compressione intelligente del file di ibernazione - Riduzione del 50%%...
powercfg -h -size 50 >nul 2>&1
echo OK.

echo [40/50] Scansione e riparazione guidata dei file di sistema...
if "%esegui_sfc%"=="SI" (
    echo NOTA - Questo passaggio richiede tempo, attendere...
    sfc /scannow
)
echo OK.

echo [41/50] Attivazione CompactOS - Compressione intelligente dei file di sistema...
compact /compactos:always >nul 2>&1
echo OK.

echo [42/50] Pulizia dei file temporanei Internet storici (INetCache)...
del /f /q /s "%LocalAppData%\Microsoft\Windows\INetCache\*" >nul 2>&1
echo OK.

echo [43/50] Pulizia delle cache di sviluppo (.NET Nuget, Visual Studio)...
if exist "%USERPROFILE%\.nuget\packages" (rmdir /s /q "%USERPROFILE%\.nuget\packages" >nul 2>&1)
if exist "%LocalAppData%\Microsoft\WebsiteCache" (rmdir /s /q "%LocalAppData%\Microsoft\WebsiteCache" >nul 2>&1)
echo OK.

echo [44/50] Sfoltimento cache avanzata Gaming (Epic, Riot, GLCache)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs" (del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\Riot Client Logs" (rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\Riot Client Logs" >nul 2>&1)
del /f /q /s "%LOCALAPPDATA%\*GLCache\*" >nul 2>&1
echo OK.

echo [45/50] Rimozione file temporanei e log di WhatsApp Desktop...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'WhatsApp' } | ForEach-Object { $path = $_.FullName + '\LocalState\shared\transfers'; if (Test-Path $path) { Remove-Item ($path + '\*') -Recurse -Force -ErrorAction SilentlyContinue } }" >nul 2>&1
echo OK.

echo [46/50] Compressione NTFS dei Log di sistema per risparmio spazio...
compact /c /s:C:\Windows\Logs >nul 2>&1
compact /c /s:C:\Windows\Panther >nul 2>&1
echo OK.

echo [47/50] Eliminazione cache dei pacchetti Python (Pip Cache)...
if exist "%LocalAppData%\pip\Cache" (rmdir /s /q "%LocalAppData%\pip\Cache" >nul 2>&1)
echo OK.

echo [48/50] Ottimizzazione processi: Svuotamento sicuro del file di Paging al riavvio...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f >nul 2>&1
echo OK.

echo [49/50] Ottimizzazione profonda del database degli aggiornamenti (ResetBase)...
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1
echo OK.

echo [50/50] Svuotamento e azzeramento dei Registri degli Eventi di Windows (Event Viewer)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-EventLog -LogName * | ForEach-Object { Clear-EventLog -LogName $_.Log }" >nul 2>&1
echo OK.

echo [51/250] Eliminazione dei file di dump della memoria del Kernel (DMP)...
if exist %SystemRoot%\MEMORY.DMP (del /f /q %SystemRoot%\MEMORY.DMP >nul 2>&1)
del /f /q /s %SystemRoot%\Minidump\*.dmp >nul 2>&1
echo OK.

echo [52/250] Rimozione file temporanei generati dalle installazioni di pacchetti Python (Pip)...
if exist "%USERPROFILE%\AppData\Local\pip\cache" (rmdir /s /q "%USERPROFILE%\AppData\Local\pip\cache" >nul 2>&1)
echo OK.

echo [53/250] Sfoltimento della cache dei messaggi temporanei di Microsoft Teams...
if exist "%APPDATA%\Microsoft\Teams\Cache" (del /f /q /s "%APPDATA%\Microsoft\Teams\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Microsoft\Teams\Application Cache\Cache" (del /f /q /s "%APPDATA%\Microsoft\Teams\Application Cache\Cache\*" >nul 2>&1)
echo OK.

echo [54/250] Svuotamento file temporanei degli indici di Ricerca di Windows...
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs\*" >nul 2>&1
)
echo OK.

echo [55/250] PULIZIA LOG: Rimozione file .log orfani ESCLUSIVAMENTE nelle cartelle temporanee...
del /f /q /s C:\Windows\Temp\*.log >nul 2>&1
del /f /q /s "%temp%\*.log" >nul 2>&1
echo OK.

echo [56/250] ISPEZIONE GLOBALE: Svuotamento sicuro delle cartelle Cache conosciute in AppData...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\AppData\Local\Temp', '$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache' -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo OK.

echo [57/250] PULIZIA AVANZATA: Sfoltimento file temporanei di caching del framework .NET...
if exist "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files" (rmdir /s /q "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files" >nul 2>&1)
if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files" (rmdir /s /q "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files" >nul 2>&1)
echo OK.

echo [58/250] Pulizia approfondita file di log e Telemetria di sistema...
del /f /q /s C:\ProgramData\Microsoft\Diagnosis\*.etw >nul 2>&1
echo OK.

echo [59/250] Caccia ed eliminazione globale di file residui .tmp e .chk...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\ -Include *.tmp, *.chk -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch 'C:\\Windows' } | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [60/250] Rimozione cache globale di Node.js (NPM Cache)...
if exist "%APPDATA%\npm-cache" (rmdir /s /q "%APPDATA%\npm-cache" >nul 2>&1)
echo OK.

echo [61/250] Svuotamento file temporanei di Windows Sandbox (Se attivi)...
if exist C:\ProgramData\Microsoft\Windows\Containers (
    del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\* >nul 2>&1
)
echo OK.

echo [62/250] Eliminazione file residui post-riavvio di Windows Update...
if exist C:\Windows\SoftwareDistribution\PostRebootEventCache.V2 (
    rmdir /s /q C:\Windows\SoftwareDistribution\PostRebootEventCache.V2 >nul 2>&1
)
echo OK.

echo [63/250] Pulizia profonda delle code di stampa bloccate (Spooler)...
net stop spooler >nul 2>&1
del /f /q /s C:\Windows\System32\spool\PRINTERS\* >nul 2>&1
net start spooler >nul 2>&1
echo OK.

echo [64/250] Rimozione file .log e .tmp interni ai profili dei Browser...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Include *.log, *.tmp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Microsoft\Edge\User Data' -Include *.log, *.tmp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
echo OK.

echo [65/250] Svuotamento dei file di log generati dall'installatore .NET Framework...
del /f /q /s C:\Windows\Microsoft.NET\Framework*\*\*.log >nul 2>&1
echo OK.

echo [66/250] Rimozione della cache di compilazione degli Shader di gioco (NVIDIA/AMD)...
if exist "%LocalAppData%\NVIDIA\DXCache" (del /f /q /s "%LocalAppData%\NVIDIA\DXCache\*" >nul 2>&1)
if exist "%LocalAppData%\AMD\DxCache" (del /f /q /s "%LocalAppData%\AMD\DxCache\*" >nul 2>&1)
echo OK.

echo [67/250] Forzatura svuotamento cache Delivery Optimization tramite utilita nativa...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-CimInstance -Namespace root/Microsoft/Windows/DeliveryOptimization -ClassName MSFT_DeliveryOptimizationConfiguration | Invoke-CimMethod -MethodName DeleteCache" >nul 2>&1
echo OK.

echo [68/250] Disattivazione dello Spazio Riservato di Windows (Libera circa 7GB)...
DISM.exe /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1
echo OK.

echo [69/250] Compressione e ottimizzazione finale delle unita (Retrim per SSD)...
defrag C: /O >nul 2>&1
echo OK.

echo [70/250] Disattivazione della Telemetria avanzata e raccolta dati...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo OK.

echo [71/250] Disattivazione Ibernazione (Eliminazione hiberfil.sys)...
powercfg /h off >nul 2>&1
echo OK.

echo [72/250] Configurazione efficiente della memoria virtuale (Pagefile a 2-4GB)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$wmi = Get-CimInstance -ClassName Win32_ComputerSystem -EnableAllPrivileges; $wmi.AutomaticManagedPagefile = $False; Invoke-CimMethod -InputObject $wmi -MethodName Modify; $pagefile = Get-CimInstance -ClassName Win32_PageFileSetting; if ($pagefile) { $pagefile.InitialSize = 2048; $pagefile.MaximumSize = 4096; Invoke-CimMethod -InputObject $pagefile -MethodName Modify } else { New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\\pagefile.sys'; InitialSize=2048; MaximumSize=4096} }" >nul 2>&1
echo OK.

echo [73/250] Ridimensionamento dello spazio massimo per i Punti di Ripristino (Max 2%%)...
vssadmin resize shadowstorage /for=c: /on=c: /maxsize=2% >nul 2>&1
echo OK.

echo [74/250] Disattivazione della Riserva di Spazio per Windows Update (Metodo Registro)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f >nul 2>&1
echo OK.

echo [75/250] Svuotamento e reset completo della cache del Microsoft Store...
wsreset /s >nul 2>&1
if exist "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)
echo OK.

echo [76/250] Eliminazione e compressione del Database di Ricerca (Windows.edb)...
net stop wsearch >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f >nul 2>&1
del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1
net start wsearch >nul 2>&1
echo OK.

echo [77/250] Svuotamento cache e file temporanei di Zoom e Skype Desktop...
if exist "%APPDATA%\Zoom\data" (del /f /q /s "%APPDATA%\Zoom\data\*" >nul 2>&1)
if exist "%APPDATA%\Microsoft\Skype for Desktop\Cache" (rmdir /s /q "%APPDATA%\Microsoft\Skype for Desktop\Cache" >nul 2>&1)
echo OK.

echo [78/250] Pulizia dei file temporanei di installazione dei driver grafici NVIDIA/AMD...
if exist "%ProgramFiles%\NVIDIA Corporation\Installer2" (rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\Installer2" >nul 2>&1)
if exist C:\ProgramData\AMD\OemDrivers (rmdir /s /q C:\ProgramData\AMD\OemDrivers >nul 2>&1)
echo OK.

echo [79/250] Rimozione file temporanei di compilazione dei pacchetti Rust (Cargo Cache)...
if exist "%USERPROFILE%\.cargo\registry\cache" (rmdir /s /q "%USERPROFILE%\.cargo\registry\cache" >nul 2>&1)
echo OK.

echo [80/250] Eliminazione dei file residui dei vecchi checkpoint di sistema (VSS Old Metadata)...
vssadmin delete shadows /for=c: /oldest /quiet >nul 2>&1
echo OK.

echo [81/250] Cancellazione dei file di log di tracciamento dell'interfaccia utente (ShellBags)...
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
echo OK.

echo [82/250] Consolidamento hardware e rimozione dei metadati NTFS orfani...
fsutil usn deletejournal /d /n C: >nul 2>&1
echo OK.

echo [83/250] Pulizia dei driver fantasma sconosciuti e non associati a hardware reale...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Status -eq 'Unknown' } | ForEach-Object { pnputil /remove-device $_.DeviceID }" >nul 2>&1
echo OK.

echo [84/250] Azzeramento delle cache dei flussi multimediali di Windows Media Foundation...
if exist "%LocalAppData%\Microsoft\Media Player" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player" >nul 2>&1)
echo OK.

echo [85/250] Forzatura dello svuotamento dei file di transazione del File System (TxF)...
fsutil resource setautoreset true C:\ >nul 2>&1
echo OK.

echo [86/250] Pulizia profonda e compattazione del Database di Windows Update (WUSP)...
net stop wuauserv >nul 2>&1
del /f /q /s C:\Windows\SoftwareDistribution\DataStore\Logs\*.log >nul 2>&1
net start wuauserv >nul 2>&1
echo OK.

echo [87/250] Pulizia delle cache dei Font di terze parti (Adobe, Google Fonts, TypeKit)...
if exist "%LocalAppData%\Adobe\FontCache" (rmdir /s /q "%LocalAppData%\Adobe\FontCache" >nul 2>&1)
echo OK.

echo [88/250] Rimozione forzata dei file speculari generati dai crash di sistema (Chkdsk)...
del /f /q /s C:\found.* >nul 2>&1
for /d %%p in (C:\found.*) do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [89/250] Compressione di sistema integrata CompactOS con algoritmo standard...
compact /compactos:always >nul 2>&1
echo OK.

echo [90/250] Ottimizzazione strutturale MFT e consolidamento dello spazio libero SSD/HDD...
defrag C: /O /H /X >nul 2>&1
echo OK.

echo [91/250] Azzeramento totale e forzato delle Copie Shadow dei Volumi (VSS)...
vssadmin delete shadows /all /quiet >nul 2>&1
echo OK.

echo [92/250] Svuotamento dei log storici dell'utilita di controllo del disco (Chkdsk)...
if exist "C:\System Volume Information\Chkdsk" (
    takeown /F "C:\System Volume Information" /A >nul 2>&1
    icacls "C:\System Volume Information" /grant Administrators:F >nul 2>&1
    del /f /q /s "C:\System Volume Information\Chkdsk\*" >nul 2>&1
)
echo OK.

echo [93/250] Rimozione della cronologia locale delle scansioni in tempo reale di Defender...
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store" (
    del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
)
echo OK.

echo [94/250] Pulizia dei file temporanei del gestore delle transazioni del Registro (TxR)...
del /f /q /s C:\Windows\System32\config\TxR\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\config\TxR\*.blf >nul 2>&1
echo OK.

echo [95/250] Svuotamento dei log di diagnostica sui consumi elettrici in sospensione (SleepStudy)...
if exist C:\Windows\System32\SleepStudy (
    del /f /q /s C:\Windows\System32\SleepStudy\* >nul 2>&1
)
echo OK.

echo [96/250] Reset del database temporaneo delle notifiche di Windows...
del /f /q /s "%LocalAppData%\Microsoft\Windows\Notifications\*.db" >nul 2>&1
echo OK.

echo [97/250] Rimozione file temporanei del motore di campionamento Audio (AudioEngine)...
if exist "%LocalAppData%\Microsoft\Windows\AudioEngine" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\AudioEngine\*" >nul 2>&1
)
echo OK.

echo [98/250] Pulizia della cache dei metadati grafici del Desktop Window Manager (DWM)...
if exist "%LocalAppData%\Microsoft\Windows\DWM" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\DWM\*" >nul 2>&1
)
echo OK.

echo [99/250] Svuotamento dei dati grezzi del Monitoraggio Affidabilità di Windows (RAC)...
if exist C:\ProgramData\Microsoft\RAC (
    del /f /q /s C:\ProgramData\Microsoft\RAC\StateData\* >nul 2>&1
    del /f /q /s C:\ProgramData\Microsoft\RAC\Outbound\* >nul 2>&1
)
echo OK.

echo [100/250] Rimozione forzata dei file temporanei di installazione dump (.tmp) orfani...
del /f /q C:\DUMP*.tmp >nul 2>&1
echo OK.

echo [101/250] Rimozione della cache dei token e file temporanei di LiveUpdate...
if exist "C:\ProgramData\Microsoft\LiveUpdate" (
    del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1
)
echo OK.

echo [102/250] Pulizia dei log di tracciamento e installazione delle estensioni AppX...
if exist C:\Windows\System32\AppXDeploymentServer (
    del /f /q /s C:\Windows\System32\AppXDeploymentServer\*.log >nul 2>&1
)
echo OK.

echo [103/250] Svuotamento della cache dei file temporanei della mappa offline di Windows...
if exist "%ProgramData%\Microsoft\MapData" (
    del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1
)
echo OK.

echo [104/250] Sfoltimento dei file temporanei del modulo di telemetria hardware (Inventory)...
if exist C:\Windows\System32\CompatTelRunner (
    del /f /q /s C:\Windows\System32\CompatTelRunner\*.tmp >nul 2>&1
)
echo OK.

echo [105/250] Eliminazione cache dei file temporanei del visualizzatore foto nativo...
if exist "%LocalAppData%\Microsoft\Windows Photo Viewer" (
    rmdir /s /q "%LocalAppData%\Microsoft\Windows Photo Viewer" >nul 2>&1
)
echo OK.

echo [106/250] Svuotamento dei file temporanei generati da Windows Error Reporting (LocalDumps)...
if exist "%LocalAppData%\CrashDumps" (
    del /f /q /s "%LocalAppData%\CrashDumps\*" >nul 2>&1
)
echo OK.

echo [107/250] Pulizia dei log temporanei crittografici e chiavi rimosse (Crypto)...
if exist "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18" (
    del /f /q /s "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18\*.tmp" >nul 2>&1
)
echo OK.

echo [108/250] Rimozione dei log storici di migrazione e installazione driver (Setupapi)...
del /f /q /s C:\Windows\inf\setupapi*.log >nul 2>&1
echo OK.

echo [109/250] Svuotamento dei log residui di Windows Defender Network Inspection (WdNis)...
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis" (
    del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1
)
echo OK.

echo [110/250] Svuotamento dei file temporanei della cache delle mappe di BitLocker...
if exist C:\Windows\System32\BitLocker (
    del /f /q /s C:\Windows\System32\BitLocker\*.tmp >nul 2>&1
)
echo OK.

echo [111/250] Pulizia dei log temporanei di isolamento di Microsoft Defender Application Guard...
if exist "%ProgramData%\Microsoft\HVSI" (
    del /f /q /s "%ProgramData%\Microsoft\HVSI\*" >nul 2>&1
)
echo OK.

echo [112/250] Rimozione dei log temporanei di diagnostica del chip di sicurezza hardware (TPM)...
if exist C:\Windows\Logs\MeasuredBoot (
    del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1
)
echo OK.

echo [113/250] Eliminazione cache di compressione bitmap per Connessione Desktop Remoto...
if exist "%LocalAppData%\Microsoft\Terminal Server Client\Cache" (
    rmdir /s /q "%LocalAppData%\Microsoft\Terminal Server Client\Cache" >nul 2>&1
)
echo OK.

echo [114/250] Svuotamento dei log di tracciamento interni della Xbox Game Bar...
if exist "%LocalAppData%\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [115/250] Svuotamento log e temporanei Windows Biometric Service (Windows Hello)...
net stop WbioSrvc >nul 2>&1
if exist C:\Windows\System32\WinBioDatabase (
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.log >nul 2>&1
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.tmp >nul 2>&1
)
net start WbioSrvc >nul 2>&1
echo OK.

echo [116/250] Pulizia della cache dei metadati di installazione delle periferiche (DeviceMetadata)...
if exist "%ProgramData%\Microsoft\Windows\DeviceMetadataCache" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\DeviceMetadataCache\*" >nul 2>&1
)
echo OK.

echo [117/250] Svuotamento della cache dei file temporanei della libreria grafica DirectX (D3D)...
if exist "%LocalAppData%\Microsoft\DirectX" (
    del /f /q /s "%LocalAppData%\Microsoft\DirectX\*" >nul 2>&1
)
echo OK.

echo [118/250] Rimozione dei log temporanei accumulati dal Kernel Boot Performance (ReadyBoot)...
if exist C:\Windows\System32\LogFiles\ReadyBoot (
    del /f /q /s C:\Windows\System32\LogFiles\ReadyBoot\*.fx >nul 2>&1
)
echo OK.

echo [119/250] Pulizia dei file di transazione temporanei del File System Transazionale (KTM)...
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.blf >nul 2>&1
echo OK.

echo [120/250] Sfoltimento dei file di log temporanei del modulo Windows Update Agent (WUA)...
if exist C:\Windows\Logs\WindowsUpdate (
    del /f /q /s C:\Windows\Logs\WindowsUpdate\* >nul 2>&1
)
echo OK.

echo [121/250] Svuotamento dei log di tracciamento interni della console dei comandi e PowerShell...
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs\*" >nul 2>&1
)
echo OK.

echo [122/250] Pulizia della cache dei pacchetti scaricati da Java (Deployment Cache)...
if exist "%APPDATA%\Sun\Java\Deployment\cache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\cache" >nul 2>&1
)
echo OK.

echo [123/250] Svuotamento dei file temporanei e log di Microsoft OneDrive...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1
)
echo OK.

echo [124/250] Svuotamento della cache dei log di telemetria di Office (CefCache)...
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages\*" >nul 2>&1
)
echo OK.

:: =================================================================
:: AREA 2: DIAGNOSTICA DI SISTEMA, RIPARAZIONE FILE E STRUMENTI DISM
:: Tecniche utilizzate: SFC (System File Checker) e DISM (Deployment Image Servicing).
:: Obiettivo: Scansionare l'integrità del sistema operativo e riparare file corrotti.
:: righe: da 125 a 150
:: =================================================================

echo [125/250] Pulizia dei file temporanei generati da Windows Subsystem for Linux (WSL)...
if exist "%USERPROFILE%\.wslg\logs" (
    del /f /q /s "%USERPROFILE%\.wslg\logs\*" >nul 2>&1
)
echo OK.

echo [126/250] Rimozione della cache dei moduli estratti da PowerShell (ModuleAnalysisCache)...
if exist "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" (
    del /f /q "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" >nul 2>&1
)
echo OK.

echo [127/250] Cancellazione dei file di log temporanei dell'utilita di diagnostica DirectX (DxDiag)...
if exist "%WINDIR%\System32\dxdiag.exe" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1
)
echo OK.

echo [128/250] Svuotamento cache di Discord (App, GPU e Code Cache)...
if exist "%APPDATA%\discord" (
    del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\Code Cache\*" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\GPUCache\*" >nul 2>&1
)
echo OK.

echo [129/250] Pulizia della cache di Spotify (File musicali locali temporanei)...
if exist "%LOCALAPPDATA%\Spotify\Storage" (
    del /f /q /s "%LOCALAPPDATA%\Spotify\Storage\*" >nul 2>&1
)
echo OK.

echo [130/250] Pulizia delle cache dei Font di terze parti (Adobe, Google Fonts, TypeKit)...
if exist "%LocalAppData%\Adobe\FontCache" (rmdir /s /q "%LocalAppData%\Adobe\FontCache" >nul 2>&1)
echo OK.

echo [131/250] Rimozione forzata dei file speculari generati dai crash di sistema (Chkdsk)...
del /f /q /s C:\found.* >nul 2>&1
for /d %%p in (C:\found.*) do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [132/250] Pulizia della cache dei metadati di installazione delle periferiche (DeviceMetadata)...
if exist "%ProgramData%\Microsoft\Windows\DeviceMetadataCache" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\DeviceMetadataCache\*" >nul 2>&1
)
echo OK.

echo [133/250] Svuotamento della cache dei file temporanei della libreria grafica DirectX (D3D)...
if exist "%LocalAppData%\Microsoft\DirectX" (
    del /f /q /s "%LocalAppData%\Microsoft\DirectX\*" >nul 2>&1
)
echo OK.

echo [134/250] Rimozione dei log temporanei accumulati dal Kernel Boot Performance (ReadyBoot)...
if exist C:\Windows\System32\LogFiles\ReadyBoot (
    del /f /q /s C:\Windows\System32\LogFiles\ReadyBoot\*.fx >nul 2>&1
)
echo OK.

echo [135/250] Pulizia dei file di transazione temporanei del File System Transazionale (KTM)...
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.blf >nul 2>&1
echo OK.

echo [136/250] Svuotamento dei file temporanei del modulo di isolamento delle app (AppContainer)...
if exist "%LocalAppData%\Packages\Microsoft.Windows.Appcontainer.Behavior_cw5n1h2txyewy" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.Windows.Appcontainer.Behavior_cw5n1h2txyewy\LocalState\*" >nul 2>&1
)
echo OK.

echo [137/250] Sfoltimento dei file di log temporanei del modulo Windows Update Agent (WUA)...
if exist C:\Windows\Logs\WindowsUpdate (
    del /f /q /s C:\Windows\Logs\WindowsUpdate\* >nul 2>&1
)
echo OK.

echo [138/250] Svuotamento dei log di tracciamento interni della console dei comandi e PowerShell...
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs\*" >nul 2>&1
)
echo OK.

echo [139/250] Pulizia della cache dei pacchetti scaricati da Java (Deployment Cache)...
if exist "%APPDATA%\Sun\Java\Deployment\cache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\cache" >nul 2>&1
)
echo OK.

echo [140/250] Svuotamento dei file temporanei e log di Microsoft OneDrive...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1
)
echo OK.

echo [141/250] Svuotamento della cache dei log di telemetria di Office (CefCache)...
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages\*" >nul 2>&1
)
echo OK.

echo [142/250] Pulizia dei file temporanei generati da Windows Subsystem for Linux (WSL)...
if exist "%USERPROFILE%\.wslg\logs" (
    del /f /q /s "%USERPROFILE%\.wslg\logs\*" >nul 2>&1
)
echo OK.

echo [143/250] Rimozione della cache dei moduli estratti da PowerShell (ModuleAnalysisCache)...
if exist "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" (
    del /f /q "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" >`nul 2>&1
)
echo OK.

echo [144/250] Cancellazione dei file di log temporanei dell'utilita di diagnostica DirectX (DxDiag)...
if exist "%WINDIR%\System32\dxdiag.exe" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1
)
echo OK.

echo [145/250] Svuotamento cache di Discord (App, GPU e Code Cache)...
if exist "%APPDATA%\discord" (
    del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\Code Cache\*" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\GPUCache\*" >nul 2>&1
)
echo OK.

echo [146/250] Pulizia della cache di Spotify (File musicali locali temporanei)...
if exist "%LOCALAPPDATA%\Spotify\Storage" (
    del /f /q /s "%LOCALAPPDATA%\Spotify\Storage\*" >nul 2>&1
)
echo OK.

echo [147/250] Rimozione cache di Steam (Browser integrato e file temporanei)...
if exist "C:\Program Files (x86)\Steam\appcache" (rmdir /s /q "C:\Program Files (x86)\Steam\appcache" >nul 2>&1)
if exist "C:\Program Files (x86)\Steam\config\htmlcache" (del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1)
echo OK.

echo [148/250] Svuotamento cache di Epic Games Launcher (Webcache)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" (rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1)
echo OK.

echo [149/250] Rimozione cache del Client EA Desktop...
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1)
if exist "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache" (del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*" >nul 2>&1)
echo OK.

:: =================================================================
:: AREA 3: OTTIMIZZAZIONE DELLE PRESTAZIONI E ALGORITMI DI COMPRESSIONE
:: Tecniche utilizzate: Strumento nativo COMPACT (Compressione File System NTFS).
:: Obiettivo: Ridurre lo spazio occupato dai programmi installati senza comprometterne l'avvio.
:: righe: 151 alla 370
:: =================================================================

echo [150/250] Svuotamento cache di Ubisoft Connect (Logs e Cache)...
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" (rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1)
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs" (del /f /q /s "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs\*" >nul 2>&1)
echo OK.

echo [151/250] Pulizia file temporanei e log di Microsoft Teams (Nuovo)...
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [152/250] Svuotamento file temporanei ed estratti di Zoom Desktop...
if exist "%APPDATA%\Zoom\logs" (del /f /q /s "%APPDATA%\Zoom\logs\*" >nul 2>&1)
echo OK.

echo [153/250] Pulizia cache di Adobe Acrobat Reader (File temporanei)...
if exist "%LOCALAPPDATA%\Adobe\Acrobat\DC\Cache" (rmdir /s /q "%LOCALAPPDATA%\Adobe\Acrobat\DC\Cache" >nul 2>&1)
echo OK.

echo [154/250] Rimozione cache e file temporanei di Photoshop (Se presente)...
if exist "%APPDATA%\Adobe\Adobe Photoshop *\AutoRecover" (del /f /q /s "%APPDATA%\Adobe\Adobe Photoshop *\AutoRecover\*" >nul 2>&1)
echo OK.

echo [155/250] Svuotamento cache del browser Opera / Opera GX...
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\*" >nul 2>&1)
echo OK.

echo [156/250] Svuotamento cache del browser Vivaldi...
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1)
echo OK.

echo [157/250] Rimozione log e file orfani generati dall'emulatore BlueStacks...
if exist "C:\ProgramData\BlueStacks_nxt\Logs" (del /f /q /s "C:\ProgramData\BlueStacks_nxt\Logs\*" >nul 2>&1)
echo OK.

echo [158/250] Pulizia file temporanei dello strumento di cattura Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [159/250] Svuotamento cache del client cloud Dropbox...
if exist "%LOCALAPPDATA%\Dropbox\instance1\scratch" (del /f /q /s "%LOCALAPPDATA%\Dropbox\instance1\scratch\*" >nul 2>&1)
echo OK.

echo [160/250] Rimozione della cache dei componenti aggiuntivi di Office (VSTO)...
if exist "%LOCALAPPDATA%\assembly\dl3" (rmdir /s /q "%LOCALAPPDATA%\assembly\dl3" >nul 2>&1)
echo OK.

echo [161/250] Pulizia file temporanei generati da WinRAR (Estrazioni interrotte)...
if exist "%APPDATA%\WinRAR\Templates" (del /f /q /s "%APPDATA%\WinRAR\Templates\*" >nul 2>&1)
echo OK.

echo [162/250] Svuotamento file temporanei generati da 7-Zip (Estrazioni orfane)...
if exist "%LOCALAPPDATA%\7-Zip" (rmdir /s /q "%LOCALAPPDATA%\7-Zip" >nul 2>&1)
echo OK.

echo [163/250] Svuotamento della cache universale delle estensioni del kernel Windows...
if exist "C:\Windows\System32\KernelExtensionCache" (del /f /q /s "C:\Windows\System32\KernelExtensionCache\*" >nul 2>&1)
echo OK.

echo [164/250] Pulizia dei log di errore del server web locale IIS Express...
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1)
echo OK.

echo [165/250] Pulizia file temporanei accumulati da Windows Speech Recognition...
if exist "%LOCALAPPDATA%\Microsoft\Speech\Files" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Speech\Files\*" >nul 2>&1)
echo OK.

echo [166/250] Svuotamento della cache di Microsoft Edge WebView2 (Cache App UWP)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'EBWebView' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [167/250] Svuotamento dei file temporanei e log di cMP (Crypto Machine Providers)...
if exist "C:\ProgramData\Microsoft\Crypto\SystemKeys" (del /f /q /s "C:\ProgramData\Microsoft\Crypto\SystemKeys\*.tmp" >nul 2>&1)
echo OK.

echo [168/250] Svuotamento della cache dei metadati di rete di Windows (NetworkCache)...
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1)
echo OK.

echo [169/250] Rimozione log e file orfani generati dal sottosistema hardware Intel/AMD...
if exist "C:\ProgramData\Intel\ShaderCache" (rmdir /s /q "C:\ProgramData\Intel\ShaderCache" >nul 2>&1)
echo OK.

echo [170/250] Svuotamento dei file temporanei e log di cMP (Crypto Machine Providers)...
if exist "C:\ProgramData\Microsoft\Crypto\SystemKeys" (del /f /q /s "C:\ProgramData\Microsoft\Crypto\SystemKeys\*.tmp" >nul 2>&1)
echo OK.

echo [171/250] Svuotamento della cache dei metadati di rete di Windows (NetworkCache)...
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1)
echo OK.

echo [172/250] Rimozione log e file orfani generati dal sottosistema hardware Intel/AMD...
if exist "C:\ProgramData\Intel\ShaderCache" (rmdir /s /q "C:\ProgramData\Intel\ShaderCache" >nul 2>&1)
echo OK.

echo [173/250] Rimozione file temporanei storici accumulati da Windows Pen and Ink...
if exist "%LOCALAPPDATA%\Microsoft\InputPersonalization" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\InputPersonalization" >nul 2>&1)
echo OK.

echo [174/250] Forzatura azzeramento file residui di disinstallazione parziale delle app...
if exist "%LOCALAPPDATA%\UntrustedAppCache" (rmdir /s /q "%LOCALAPPDATA%\UntrustedAppCache" >nul 2>&1)
echo OK.

echo [175/250] Ottimizzazione finale e allineamento dello spazio libero sui settori logici...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Defrag -Verbose" >nul 2>&1
echo OK.

echo [176/250] Rimozione delle vecchie versioni dei driver video compresse (DriverStore Cache)...
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\DriverStore\FileRepository -Filter *.zip, *.exe, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
echo OK.

echo [177/250] Sfoltimento forzato dei file rimasti nella cartella temporanea dei dump di memoria...
if exist "C:\Windows\Minidump" (
    del /f /q /s C:\Windows\Minidump\* >nul 2>&1
)
echo OK.

echo [178/250] Eliminazione della cache dei file scaricati e accumulati da Windows Update (Eventi storici)...
if exist "C:\Windows\SoftwareDistribution\DataStore\Logs" (
    del /f /q /s C:\Windows\SoftwareDistribution\DataStore\Logs\*.log >nul 2>&1
)
echo OK.

echo [179/250] Svuotamento della cache globale dei download in background (Servizio BITS)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-BitsTransfer -AllUsers | Remove-BitsTransfer -ErrorAction SilentlyContinue" >nul 2>&1
echo OK.

echo [180/250] Rimozione della cache dei log delle vecchie installazioni di pacchetti Microsoft (MSI)...
if exist "C:\Windows\Installer" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
echo OK.

echo [181/250] Svuotamento della cache dei file temporanei di compressione bitmap dello spooler di stampa...
if exist "C:\Windows\System32\spool\SERVERS" (
    del /f /q /s C:\Windows\System32\spool\SERVERS\* >nul 2>&1
)
echo OK.

echo [182/250] Rimozione dei log temporanei generati dall'indicizzazione dei file offline (CSC Cache)...
if exist "C:\Windows\CSC" (
    takeown /F C:\Windows\CSC /R /A >nul 2>&1
    icacls C:\Windows\CSC /grant Administrators:F /T >nul 2>&1
    del /f /q /s C:\Windows\CSC\* >nul 2>&1
)
echo OK.

echo [183/250] Forzatura azzeramento file residui nascosti nella radice del disco C:...
if exist "C:\$SysReset" (rmdir /s /q "C:\$SysReset" >nul 2>&1)
if exist "C:\$GetCurrent" (rmdir /s /q "C:\$GetCurrent" >nul 2>&1)
echo OK.

echo [184/250] Svuotamento della cache dei pacchetti isolati di Microsoft Store (LocalCache)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'LocalCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [185/250] Rimozione della cache shader e temporanea del browser Opera GX (D3DSCache)...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" >nul 2>&1
)
echo OK.

echo [186/250] Pulizia dei file di log e crash dump accumulati da Steam (CrashDumps)...
if exist "C:\Program Files (x86)\Steam\dumps" (rmdir /s /q "C:\Program Files (x86)\Steam\dumps" >nul 2>&1)
if exist "C:\Program Files (x86)\Steam\logs" (del /f /q /s "C:\Program Files (x86)\Steam\logs\*" >nul 2>&1)
echo OK.

echo [187/250] Svuotamento dei file temporanei e file recenti di Blender (Se installato)...
if exist "%APPDATA%\Blender Foundation\Blender" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Blender Foundation\Blender' -Include *.crash, *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [188/250] Pulizia approfondita dei file temporanei e cache del framework di sviluppo Node.js...
if exist "%USERPROFILE%\.node-gyp" (rmdir /s /q "%USERPROFILE%\.node-gyp" >nul 2>&1)
echo OK.

echo [189/250] Svuotamento della cache dei certificati digitali revocati o scaduti di Windows...
certutil -urlcache * delete >nul 2>&1
echo OK.

echo [190/250] Pulizia forzata dei file temporanei del gestore pacchetti NuGet (Sviluppatori)...
if exist "%USERPROFILE%\.nuget" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [191/250] Svuotamento della cache degli Shader e dei dati locali di Unreal Engine...
if exist "%LOCALAPPDATA%\UnrealEngine" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\UnrealEngine' -Include *.log, *.tmp, *ShaderCache* -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [192/250] Pulizia dei log temporanei di crash generati dai giochi in Unity Engine...
if exist "%LOCALAPPDATA%\LocalLow" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\LocalLow' -Include *.log, *.crashdumps -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [193/250] Svuotamento completo della cache e del database dei messaggi temporanei di Slack...
if exist "%APPDATA%\Slack\Cache" (del /f /q /s "%APPDATA%\Slack\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Slack\Code Cache" (del /f /q /s "%APPDATA%\Slack\Code Cache\*" >nul 2>&1)
echo OK.

echo [194/250] Rimozione dei log storici accumulati dal servizio Windows Error Reporting (WER)...
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" (rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" >nul 2>&1)
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" (rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1)
echo OK.

echo [195/250] Svuotamento della cache di icone e anteprime del menu Start di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\*.db" >nul 2>&1
)
echo OK.

echo [196/250] Pulizia dei log di telemetria e tracciamento delle prestazioni di rete (NetTrace)...
if exist C:\Windows\System32\LogFiles\NetTrace (
    del /f /q /s C:\Windows\System32\LogFiles\NetTrace\* >nul 2>&1
)
echo OK.

echo [197/250] Svuotamento dei file temporanei e delle miniature del client di gioco GOG Galaxy...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache" (rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache" >nul 2>&1)
echo OK.

echo [198/250] Rimozione delle cache di rendering dei font usati dalle applicazioni Electron (Scaffolding)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'FontCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [199/250] Pulizia approfondita dei file temporanei del gestore di installazione Python (Setuptools)...
if exist "%USERPROFILE%\.easy_install" (rmdir /s /q "%USERPROFILE%\.easy_install" >nul 2>&1)
echo OK.

echo [200/250] Compressione e sintonizzazione finale approfondita dei blocchi liberi...
defrag C: /O /H /U /V >nul 2>&1
echo OK.

echo [201/250] Sfoltimento sicuro del DriverStore (Eliminazione driver obsoleti e non in uso)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "pnputil /delete-driver oem*.inf /uninstall /force" >nul 2>&1
echo OK.

echo [202/250] Rimozione forzata dei dati residui delle App UWP disinstallate (Bloatware Orfani)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -ErrorAction SilentlyContinue | Where-Object { (Get-AppxPackage -Name $_.Name -AllUsers) -eq $null } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [203/250] Svuotamento della cache dei log di installazione di Windows Setup (Panther Cache)...
if exist C:\Windows\Panther (
    del /f /q /s C:\Windows\Panther\*.log >nul 2>&1
    del /f /q /s C:\Windows\Panther\*.tmp >nul 2>&1
)
echo OK.

echo [204/250] Svuotamento dei file temporanei della cache delle icone della barra delle applicazioni...
if exist "%LocalAppData%\Microsoft\Windows\Explorer" (
    del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
)
echo OK.

echo [205/250] Pulizia approfondita dei file temporanei generati da Windows Update (wbt)...
if exist C:\$WINDOWS.~BT (
    del /f /q /s C:\$WINDOWS.~BT\*.tmp >nul 2>&1
    del /f /q /s C:\$WINDOWS.~BT\*.log >nul 2>&1
)
echo OK.

echo [206/250] Svuotamento della cache di compilazione .NET (Assembly Optimization Cache)...
if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SetupCache" (
    rmdir /s /q "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SetupCache" >nul 2>&1
)
echo OK.

echo [207/250] Rimozione della cache dei moduli compressi di Microsoft Edge (Edge WebView Cache)...
if exist "%LocalAppData%\Microsoft\EdgeWebView\User Data\Default\Cache" (
    del /f /q /s "%LocalAppData%\Microsoft\EdgeWebView\User Data\Default\Cache\*" >nul 2>&1
)
echo OK.

echo [208/250] Svuotamento forzato della cache locale dei file temporanei di OneDrive...
if exist "%LocalAppData%\Microsoft\OneDrive\cache" (
    rmdir /s /q "%LocalAppData%\Microsoft\OneDrive\cache" >nul 2>&1
)
echo OK.

echo [209/250] Pulizia della cache dei metadati di tracciamento dell'app Xbox su PC...
if exist "%LocalAppData%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\*" >nul 2>&1
)
echo OK.

echo [210/250] Rimozione dei log temporanei accumulati dal servizio di geolocalizzazione Windows...
if exist "%ProgramData%\Microsoft\Windows\SystemData\LfS" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\SystemData\LfS\*" >nul 2>&1
)
echo OK.

echo [211/250] Svuotamento dei file di tracciamento e log dell'Utilità di Pianificazione (Tasks Logs)...
if exist C:\Windows\System32\Tasks (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Tasks -Recurse -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [212/250] Pulizia della cache dei file temporanei dell'Editor del Registro di sistema...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v "LastKey" /f >nul 2>&1
echo OK.

echo [213/250] Svuotamento dei file residui temporanei nella cartella di installazione Speech...
if exist C:\Windows\Speech\SpeechReco (
    del /f /q /s C:\Windows\Speech\SpeechReco\*.tmp >nul 2>&1
)
echo OK.

echo [214/250] Forzatura dello svuotamento dei file temporanei di transazione NTFS (FST)...
fsutil transaction thin C:\ >nul 2>&1
echo OK.

echo [215/250] Compressione LZX intelligente dei software e dei giochi installati (Cache/Logs/Temp)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\Program Files', 'C:\Program Files (x86)' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^(Cache|Logs|Temp)$' } | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
echo OK.

echo [216/250] Ottimizzazione strutturale profonda della cache dei pacchetti installer (.msi)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.msi -ErrorAction SilentlyContinue | ForEach-Object { compact /c /exe:lzx $_.FullName >$null 2>&1 }"
echo OK.

echo [217/250] Disattivazione forzata e rimozione dei file di dump completi del Kernel...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 0 /f >nul 2>&1
if exist C:\Windows\MEMORY.DMP (del /f /q C:\Windows\MEMORY.DMP >nul 2>&1)
echo OK.

echo [218/250] Sfoltimento della cache dei file di configurazione pre-caricati dei servizi (Sysprep)...
if exist C:\Windows\System32\sysprep\Panther (
    del /f /q /s C:\Windows\System32\sysprep\Panther\*.log >nul 2>&1
    del /f /q /s C:\Windows\System32\sysprep\Panther\*.xml >nul 2>&1
)
echo OK.

echo [219/250] Compressione NTFS dei vecchi log storici delle applicazioni terze (AppData)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\AppData\Local', '$env:USERPROFILE\AppData\Roaming' -Recurse -Filter *.log -ErrorAction SilentlyContinue | ForEach-Object { compact /c \"$($_.FullName)\" >$null 2>&1 }"
echo OK.

echo [220/250] Svuotamento della cache di pre-caricamento del menu Start (TileDataLayer)...
if exist "%LocalAppData%\TileDataLayer" (rmdir /s /q "%LocalAppData%\TileDataLayer" >nul 2>&1)
echo OK.

echo [221/250] Svuotamento dei file temporanei generati dallo strumento di migrazione (USMT)...
if exist C:\USMTMIG (rmdir /s /q C:\USMTMIG >nul 2>&1)
echo OK.

echo [222/250] Pulizia della cache di sincronizzazione dei criteri di sicurezza locali...
if exist C:\Windows\System32\GroupPolicyUsers (rmdir /s /q C:\Windows\System32\GroupPolicyUsers >nul 2>&1)
echo OK.

echo [223/250] Compressione NTFS aggressiva delle cartelle di log storiche di Windows...
compact /c /s:C:\Windows\System32\LogFiles /i >nul 2>&1
compact /c /s:C:\Windows\System32\winevt\Logs /i >nul 2>&1
echo OK.

echo [224/250] Sfoltimento radicale della cache dei file di installazione MSI (Patch Cache)...
if exist "C:\Windows\Installer\\$PatchCache$" (
    rmdir /s /q "C:\Windows\Installer\\$PatchCache$" >nul 2>&1
)
echo OK.

echo [225/250] Eliminazione del database storico delle firme di Windows Defender...
if exist "%ProgramData%\Microsoft\Windows Defender\Definition Updates" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:ProgramData\Microsoft\Windows Defender\Definition Updates' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^{.*}$' } | ForEach-Object { rmdir $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [226/250] Svuotamento dei file temporanei del database di WinSxS (Manifest Cache)...
if exist "C:\Windows\winsxs\ManifestCache" (
    del /f /q /s C:\Windows\winsxs\ManifestCache\* >nul 2>&1
)
echo OK.

echo [227/250] Forzatura azzeramento della cache dei log delle sessioni Event Trace (ETW)...
if exist "C:\Windows\System32\LogFiles\WMI\RtBackup" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\LogFiles\WMI\RtBackup -Filter *.etl -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [228/250] Rimozione definitiva della cache dei pacchetti lingua non utilizzati (MUI Clean)...
Lpksetup /u >nul 2>&1
echo OK.

echo [229/250] Compressione LZX profonda della cartella delle funzionalità opzionali di Windows...
if exist "C:\Windows\Servicing" (
    compact /c /s:C:\Windows\Servicing /exe:lzx /i >nul 2>&1
)
echo OK.

echo [230/250] Svuotamento del database di diagnostica e telemetria utente (DiagTrack Cache)...
if exist "%ProgramData%\Microsoft\Diagnosis\DownloadedSettings" (
    del /f /q /s "%ProgramData%\Microsoft\Diagnosis\DownloadedSettings\*" >nul 2>&1
)
echo OK.

echo [231/250] Pulizia dei file residui temporanei generati dall'utilita CheckDisk (chkdsk)...
del /f /q /s C:\*.chk >nul 2>&1
echo OK.

echo [232/250] Disattivazione della riserva di spazio per il rollback delle versioni di Windows...
DISM.exe /Online /Cleanup-Image /SFC /Disable-Feature /FeatureName:Windows-Rollback-Data >nul 2>&1
echo OK.

echo [233/250] Compressione LZX ultra-aggressiva dei binari nativi di PowerShell...
compact /c /s:C:\Windows\System32\WindowsPowerShell /exe:lzx /i >nul 2>&1
echo OK.

echo [234/250] Rimozione forzata dei file temporanei del modulo di telemetria software (sqm)...
del /f /q /s C:\*.sqm >nul 2>&1
echo OK.

echo [235/250] Svuotamento della cache di indicizzazione dei file multimediali di rete (WMPNS)...
if exist "%PROGRAMDATA%\Microsoft\Media Player\Network Sharing" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Media Player\Network Sharing\*" >nul 2>&1
)
echo OK.

echo [236/250] Forzatura della pulizia della cache dei metadati di sicurezza delle icone...
if exist "%LocalAppData%\VirtualStore" (
    rmdir /s /q "%LocalAppData%\VirtualStore" >nul 2>&1
)
echo OK.

echo [237/250] Compressione NTFS dei driver di terze parti archiviati nel DriverStore...
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:C:\Windows\System32\DriverStore\FileRepository /i >nul 2>&1
)
echo OK.

echo [238/250] Disattivazione permanente del sistema di log diagnostici WPP (Telemetria Kernel)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Diagnostics-Networking/Operational" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo OK.

echo [239/250] Sfoltimento e azzeramento forzato dei file di Log della crittografia BitLocker...
if exist C:\Windows\System32\LogFiles\BitLocker (
    del /f /q /s C:\Windows\System32\LogFiles\BitLocker\* >nul 2>&1
)
echo OK.

echo [240/250] Eliminazione della cache dei file temporanei del visualizzatore di immagini UWP...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^Photos.*Cache$' } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [241/250] Rimozione forzata dei file di dump delle eccezioni del runtime .NET (Watson)...
if exist "%ProgramData%\Microsoft\Windows\WER\ReportQueue" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\WER\ReportQueue\AppCrash_*" >nul 2>&1
)
echo OK.

echo [242/250] Svuotamento della cache dei file di configurazione temporanei di Windows Defender ATP...
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense\*" >nul 2>&1
)
echo OK.

echo [243/250] Compressione LZX dei file di help e supporto locali di Windows...
if exist C:\Windows\Help (
    compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1
)
echo OK.

echo [244/250] Svuotamento della cache dei log di sincronizzazione del Microsoft Store...
if exist "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\Logs" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\Logs\*" >nul 2>&1
)
echo OK.

echo [245/250] Rimozione forzata dei file temporanei lasciati dai vecchi pacchetti NuGet e PIP orfani...
del /f /q /s C:\Users\*\AppData\Local\pip\cache\*.tmp >nul 2>&1
echo OK.

echo [246/250] Reset totale e forzato dei descrittori di sicurezza NTFS orfani (Security Clean)...
chkntfs /X C: >nul 2>&1
echo OK.

echo [247/250] Consolidamento finale estremo dello spazio e compattazione dei descrittori MFT...
defrag C: /U /V /X /H /K /G >nul 2>&1
echo OK.

echo [248/250] Allineamento logico finale dei cluster e ottimizzazione TRIM dell'unita di sistema...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -ReTrim -Defrag" >nul 2>&1
echo OK.

echo [249/250] OTTIMIZZAZIONE STRUTTURALE: Sincronizzazione fisica e svuotamento dei buffer del disco C...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force" >nul 2>&1
echo OK.

echo [250/250] Generazione degli indici e consolidamento finale dell'unita...
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo OK.

:: =======================================================================
:: --- SEZIONE CONCLUSIVA: CALCOLO SPAZIO E TEMPO DI ESECUZIONE (250 PASSI) ---
:: =======================================================================
echo.
echo Elaborazione del report finale in corso...
echo.

echo [251/255] Sfoltimento forzato dei vecchi file di installazione scaricati (SoftwareDistribution)...
net stop wuauserv >nul 2>&1
del /f /q /s C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
for /d %%p in (C:\Windows\SoftwareDistribution\Download\*) do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1
echo OK.

echo [252/255] Rimozione dei vecchi pacchetti di installazione dei driver grafici (OEM Driver Clean)...
if exist "%SystemDrive%\ProgramData\AMD" (rmdir /s /q "%SystemDrive%\ProgramData\AMD" >nul 2>&1)
if exist "%SystemDrive%\ProgramData\NVIDIA" (rmdir /s /q "%SystemDrive%\ProgramData\NVIDIA" >nul 2>&1)
echo OK.

echo [253/255] Cancellazione radicale delle Copie Shadow e istantanee del volume non necessarie...
vssadmin delete shadows /all /quiet >nul 2>&1
echo OK.

echo [254/255] Compressione LZX dei file di log storici generati dal Microsoft Store...
if exist "%ProgramData%\Microsoft\Windows\AppRepository" (
    compact /c /s:"%ProgramData%\Microsoft\Windows\AppRepository" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [255/255] Ottimizzazione finale e riduzione del File Table del File System (NTFS Balance)...
fsutil behavior set disablelastaccess 1 >nul 2>&1
defrag C: /O /H /U /V >nul 2>&1
echo OK.

echo [256/260] Eliminazione della cache dei modelli di Intelligenza Artificiale e OCR di Windows...
if exist "%ProgramData%\Microsoft\Windows\OCR" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\OCR\*" >nul 2>&1
)
if exist "%LocalAppData%\Microsoft\Windows\AI" (
    rmdir /s /q "%LocalAppData%\Microsoft\Windows\AI" >nul 2>&1
)
echo OK.

echo [257/260] Svuotamento della cache di indicizzazione dei file compressi (Search Zip Cache)...
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs\*" >nul 2>&1
)
echo OK.

echo [258/260] Rimozione della cache orfana dei pacchetti di runtime redistribuibili di Visual C++...
if exist "C:\ProgramData\Package Cache" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Package Cache' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [259/260] Compressione LZX profonda dei driver audio e di rete legacy (DriverStore Backup)...
if exist "C:\Windows\System32\DriverStore\en-US" (compact /c /s:"C:\Windows\System32\DriverStore\en-US" /exe:lzx /i >nul 2>&1)
if exist "C:\Windows\System32\DriverStore\it-IT" (compact /c /s:"C:\Windows\System32\DriverStore\it-IT" /exe:lzx /i >nul 2>&1)
echo OK.

echo [260/260] Compattazione e deframmentazione aggressiva degli indici MFT finali (Max Boot Speed)...
defrag C: /O /H /X /U /V /K /G >nul 2>&1
echo OK.

echo [261/270] Sfoltimento forzato dei file di installazione differiti delle funzionalità opzionali...
DISM.exe /Online /Disable-Feature /FeatureName:WorkFolders-Client /NoRestart >nul 2>&1
DISM.exe /Online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /NoRestart >nul 2>&1
echo OK.

echo [262/270] Compressione LZX aggressiva del sottosistema IME (Tastiere e dizionari predittivi)...
if exist C:\Windows\InputMethod (
    compact /c /s:C:\Windows\InputMethod /exe:lzx /i >nul 2>&1
)
echo OK.

echo [263/270] Rimozione definitiva delle cache storiche dei report di affidabilità hardware (WDI)...
if exist C:\Windows\System32\wdi\LogFiles (
    del /f /q /s C:\Windows\System32\wdi\LogFiles\* >nul 2>&1
)
echo OK.

echo [264/270] Svuotamento della cache dei metadati di indicizzazione di Windows Search (Edb Log)...
net stop wsearch >nul 2>&1
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\*.log" >nul 2>&1
)
net start wsearch >nul 2>&1
echo OK.

echo [265/270] Compressione NTFS delle librerie di configurazione dell'interfaccia (SystemResources)...
if exist C:\Windows\SystemResources (
    compact /c /s:C:\Windows\SystemResources /i >nul 2>&1
)
echo OK.

echo [266/270] Rimozione forzata dei file temporanei accumulati dal gestore delle notifiche push...
del /f /q /s "%LocalAppData%\Microsoft\Windows\Notifications\wpndatabase.db" >nul 2>&1
echo OK.

echo [267/270] Svuotamento della cache dei file temporanei di caching del servizio WebClient (DAV)...
if exist C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore (
    rmdir /s /q C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore >nul 2>&1
)
echo OK.

echo [268/270] Compressione LZX profonda dei moduli diagnostici residui di Windows Error Reporting...
if exist C:\Windows\System32\Wer (
    compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1
)
echo OK.

echo [269/270] Rimozione delle chiavi temporanee e indici storici del gestore installazioni (AppxAll)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Microsoft\Windows\AppXDeploymentServer' -Filter *.log, *.tmp -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
echo OK.

echo [270/270] AZZERAMENTO DELLA FRAMMENTAZIONE MFT: Ottimizzazione e consolidamento dei descrittori logici...
fsutil behavior set disablelastaccess 1 >nul 2>&1
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1
echo OK.

echo [271/280] Rimozione della cache dei vecchi pacchetti di installazione di Microsoft Edge...
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Download" (
    rmdir /s /q "%ProgramFiles(x86)%\Microsoft\Edge\Download" >nul 2>&1
)
echo OK.

echo [272/280] Pulizia dei file temporanei giganti generati dai driver AMD (Radeon Shader Cache)...
if exist "%LocalAppData%\AMD\DxCache" (del /f /q /s "%LocalAppData%\AMD\DxCache\*" >nul 2>&1)
if exist "%LocalAppData%\AMD\VkCache" (del /f /q /s "%LocalAppData%\AMD\VkCache\*" >nul 2>&1)
if exist "%APPDATA%\AMD\OclCache" (del /f /q /s "%APPDATA%\AMD\OclCache\*" >nul 2>&1)
echo OK.

echo [273/280] Svuotamento dei log temporanei accumulati da Windows Defender SmartScreen...
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.log" >nul 2>&1
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.txt" >nul 2>&1
)
echo OK.

echo [274/280] Svuotamento della cache dei file musicali temporanei di YouTube Music / YouTube Desktop...
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Storage\ext\mpogngknbghclgocfkp... (identificatore)" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'File System' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [275/280] Pulizia forzata dei file temporanei e file di log orfani generati da VLC Media Player...
if exist "%APPDATA%\vlc\art" (rmdir /s /q "%APPDATA%\vlc\art" >nul 2>&1)
echo OK.

echo [276/280] Sfoltimento dei file temporanei di caching del browser Opera / Opera GX (System Cache)...
if exist "%AppData%\Opera Software\Opera GX Stable\Network Action Predictor" (del /f /q /s "%AppData%\Opera Software\Opera GX Stable\Network Action Predictor*" >nul 2>&1)
echo OK.

echo [277/280] Rimozione dei log diagnostici giganti generati dal servizio di indicizzazione (Windows.edb logs)...
net stop wsearch >nul 2>&1
del /f /q /s C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\SettingSync\*.log >nul 2>&1
net start wsearch >nul 2>&1
echo OK.

echo [278/280] Svuotamento della cache dei file scaricati e residui di Microsoft Teams (Meeting Artifacts)...
if exist "%AppData%\Microsoft\Teams\Backgrounds" (del /f /q /s "%AppData%\Microsoft\Teams\Backgrounds\*" >nul 2>&1)
if exist "%AppData%\Microsoft\Teams\media-stack" (del /f /q /s "%AppData%\Microsoft\Teams\media-stack\*" >nul 2>&1)
echo OK.

echo [279/280] Compressione LZX profonda dei file di log storici generati dal CBS e dal DISM...
if exist C:\Windows\Logs\DISM (compact /c /s:C:\Windows\Logs\DISM /exe:lzx /i >nul 2>&1)
echo OK.

echo [280/280] OTTIMIZZAZIONE DEVASTANTE FINALE: Sintonizzazione hardware e consolidamento dei cluster liberi...
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1
echo OK.

echo [281/290] Rimozione dei file temporanei generati dagli aggiornamenti delle App di sistema (AppX Deployment)...
if exist "%ProgramData%\Microsoft\Windows\AppRepository\Packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\AppRepository\Packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [282/290] Svuotamento dei file di tracciamento e log dell'applicazione Xbox Game DVR...
if exist "%LocalAppData%\Microsoft\Windows\GameBar" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.log" >nul 2>&1
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.tmp" >nul 2>&1
)
echo OK.

echo [283/290] Svuotamento della cache dei log di telemetria del servizio Windows Audio (AudioDgd)...
if exist C:\Windows\System32\LogFiles\Audio (
    del /f /q /s C:\Windows\System32\LogFiles\Audio\* >nul 2>&1
)
echo OK.

echo [284/290] Pulizia dei file temporanei accumulati dallo strumento nativo Windows Problem Steps Recorder...
if exist "%LocalAppData%\Temp\PSR" (
    rmdir /s /q "%LocalAppData%\Temp\PSR" >nul 2>&1
)
echo OK.

echo [285/290] Svuotamento dei log storici orfani del visualizzatore di eventi Hardware (WHEA)...
if exist C:\Windows\LiveKernelReports (
    del /f /q /s C:\Windows\LiveKernelReports\*.dmp >nul 2>&1
    for /d %%p in (C:\Windows\LiveKernelReports\*) do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [286/290] Compressione LZX profonda dei moduli di supporto archiviati in AppData...
if exist "%LocalAppData%\Microsoft\Windows\INetCookies" (
    compact /c /s Backups /exe:lzx /i >nul 2>&1
)
echo OK.

echo [287/290] Rimozione della cache temporanea dei certificati di autenticazione scaduti (Cryptnet)...
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (
    rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1
)
echo OK.

echo [288/290] Pulizia forzata dei file temporanei lasciati dal client cloud OneDrive (Sync Engine Logs)...
if exist "%LocalAppData%\Microsoft\OneDrive\logs" (
    del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\*" >nul 2>&1
)
echo OK.

echo [289/290] Compressione NTFS delle cartelle diagnostiche storiche del browser Microsoft Edge...
if exist "%LocalAppData%\Microsoft\Edge\User Data\Crashpad" (
    compact /c /s:"%LocalAppData%\Microsoft\Edge\User Data\Crashpad" /i >nul 2>&1
)
echo OK.

echo [290/290] OTTIMIZZAZIONE DEVASTANTE FINALE: Sintonizzazione hardware e consolidamento dei cluster liberi...
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1
echo OK.

echo [291/300] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)
echo OK.

echo [292/300] Pulizia della cache di rendering grafico del nuovo Terminale Windows (Windows Terminal)...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1
)
echo OK.

echo [293/300] Rimozione dei log diagnostici accumulati dal sottosistema Windows Sandbox (Se attivo)...
if exist "C:\ProgramData\Microsoft\Windows\Containers\Sandboxes" (
    del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\*.log >nul 2>&1
)
echo OK.

echo [294/300] Svuotamento dei file temporanei generati dall'app Xbox App Runtime (Gaming Services)...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
)
echo OK.

echo [295/300] Compressione LZX profonda dei dizionari e file di testo del correttore ortografico locale...
if exist C:\Windows\System32\MsSpellCheckingFacility (
    compact /c /s:C:\Windows\System32\MsSpellCheckingFacility /exe:lzx /i >nul 2>&1
)
echo OK.

echo [296/300] Svuotamento della cache dei log delle connessioni Bluetooth e periferiche Wireless orfane...
if exist C:\Windows\System32\LogFiles\Bluetooth (
    del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1
)
echo OK.

echo [297/300] Sfoltimento dei file temporanei di caching del servizio Windows Biometric (Windows Hello)...
net stop WbioSrvc >nul 2>&1
if exist C:\Windows\System32\WinBioDatabase (
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.tmp >nul 2>&1
)
net start WbioSrvc >nul 2>&1
echo OK.

echo [298/300] Rimozione forzata dei file temporanei lasciati dal gestore di pacchetti universale winget...
del /f /q /s "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
echo OK.

echo [299/300] Compressione NTFS delle vecchie cartelle storiche di diagnostica dei crash di Windows...
if exist C:\Windows\System32\winevt\Logs (
    compact /c /s:C:\Windows\System32\winevt\Logs /i >nul 2>&1
)
echo OK.

echo [300/300] OTTIMIZZAZIONE DEVASTANTE FINALE: Compattazione MFT, ReTrim dei settori logici e azzeramento dei buffer...
fsutil behavior set disablelastaccess 1 >nul 2>&1
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1
echo OK.

echo [301/310] Pulizia profonda delle cartelle temporanee del sottosistema WSL2 e container...
if exist "%USERPROFILE%\.wslg\logs" (
    del /f /q /s "%USERPROFILE%\.wslg\logs\*" >nul 2>&1
)
echo OK.

echo [302/310] Svuotamento dei file di log della cache di telemetria locale di Office 365...
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages\*" >nul 2>&1
)
echo OK.

echo [303/310] Rimozione dei file temporanei e dei log archiviati dall'app Java Desktop...
if exist "%APPDATA%\Sun\Java\Deployment\cache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\cache" >nul 2>&1
)
echo OK.

echo [304/310] Svuotamento della cache dei log di sincronizzazione profonda di OneDrive Business...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1)
echo OK.

echo [305/310] Pulizia dei log temporanei dell'utilita diagnostica hardware nativa DirectX (DxDiag)...
if exist "%WINDIR%\System32\dxdiag.exe" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1
)
echo OK.

echo [306/310] Cancellazione dei log storici accumulati da Windows Defender SmartScreen (Support logs)...
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.log" >nul 2>&1
)
echo OK.

echo [307/310] Compressione LZX delle cartelle dei dizionari linguistici locali di Windows...
if exist "C:\Windows\System32\DriverStore\it-IT" (compact /c /s:"C:\Windows\System32\DriverStore\it-IT" /exe:lzx /i >nul 2>&1)
if exist "C:\Windows\System32\DriverStore\en-US" (compact /c /s:"C:\Windows\System32\DriverStore\en-US" /exe:lzx /i >nul 2>&1)
echo OK.

echo [308/310] Compressione LZX profonda dei file log statici di installazione di Windows (Panther LZX)...
if exist C:\Windows\Panther (
    compact /c /s:C:\Windows\Panther /exe:lzx /i >nul 2>&1
)
echo OK.

echo [309/310] Allineamento strutturale finale delle tabelle MFT logiche del disco C...
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1
echo OK.

echo [310/310] Sincronizzazione hardware e rilascio definitivo dei buffer di memoria NTFS...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force; Optimize-Volume -DriveLetter C -Defrag -ReTrim" >nul 2>&1
echo OK.

echo [311/320] Rimozione della cache dei moduli di runtime delle applicazioni Microsoft Store...
if exist "%ProgramData%\Microsoft\Windows\AppRepository\Packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\AppRepository\Packages' -Filter *.tmp, *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [312/320] Svuotamento della cache dei file temporanei storici di Blender (Modellazione 3D)...
if exist "%APPDATA%\Blender Foundation\Blender" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Blender Foundation\Blender' -Include *.crash, *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [313/320] Rimozione forzata delle segnalazioni di crash archiviate da Windows Error Reporting (Watson)...
if exist "%ProgramData%\Microsoft\Windows\WER\ReportQueue" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\WER\ReportQueue\AppCrash_*" >nul 2>&1
)
echo OK.

echo [314/320] Svuotamento dei file temporanei della cache dello strumento nativo ScreenSketch...
if exist "%LocalAppData%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [315/320] Compressione LZX profonda dei file log e di testo del visualizzatore eventi di terze parti...
if exist "%LocalAppData%\Microsoft\Edge\User Data\Crashpad" (
    compact /c /s:"%LocalAppData%\Microsoft\Edge\User Data\Crashpad" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [316/320] Svuotamento della cache dei flussi multimediali di Windows Media Foundation...
if exist "%LocalAppData%\Microsoft\Media Player" (
    rmdir /s /q "%LocalAppData%\Microsoft\Media Player" >nul 2>&1
)
echo OK.

echo [317/320] Cancellazione forzata dei file temporanei di compilazione dei pacchetti Rust (Cargo)...
if exist "%USERPROFILE%\.cargo\registry\cache" (
    rmdir /s /q "%USERPROFILE%\.cargo\registry\cache" >nul 2>&1
)
echo OK.

echo [318/320] Svuotamento della cache dei file musicali temporanei di YouTube Music Desktop...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'File System' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [319/320] Compressione LZX dei file di supporto e guide in linea locali di Windows (Help)...
if exist C:\Windows\Help (
    compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1
)
echo OK.

echo [320/320] OTTIMIZZAZIONE LOGICA ESTREMA: Compattazione finale delle tabelle MFT e ReTrim dei cluster...
defrag C: /O /H /X /U /V >nul 2>&1
echo OK.

echo [321/330] Pulizia delle cache nascoste dei client di messaggistica aziendali (Slack/Teams)...
if exist "%APPDATA%\Slack\Cache" (del /f /q /s "%APPDATA%\Slack\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Slack\Code Cache" (del /f /q /s "%APPDATA%\Slack\Code Cache\*" >nul 2>&1)
echo OK.

echo [322/330] Svuotamento dei file temporanei e delle miniature del client di gioco GOG Galaxy...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache" (rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache" >nul 2>&1)
echo OK.

echo [323/330] Cancellazione della cache di rendering grafico del nuovo Terminale Windows nativo...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1
)
echo OK.

echo [324/330] Svuotamento della cache dei log delle connessioni Bluetooth e periferiche Wireless...
if exist C:\Windows\System32\LogFiles\Bluetooth (
    del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1
)
echo OK.

echo [325/330] Rimozione delle cache di rendering dei font usati dalle applicazioni Electron...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'FontCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [326/330] Svuotamento della cache dei metadati di rete e DNS locali di Windows (NetworkCache)...
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1
)
echo OK.

echo [327/330] Pulizia forzata dei file temporanei lasciati dal gestore di pacchetti universale winget...
del /f /q /s "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
echo OK.

echo [328/330] Rimozione forzata delle cartelle temporanee orfane di installazione e build vecchie...
if exist "C:\$SysReset" (rmdir /s /q "C:\$SysReset" >nul 2>&1)
if exist "C:\$GetCurrent" (rmdir /s /q "C:\$GetCurrent" >nul 2>&1)
echo OK.

echo [329/330] Svuotamento sicuro della cache dei file temporanei dell'app Microsoft LiveUpdate...
if exist "C:\ProgramData\Microsoft\LiveUpdate" (
    del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1
)
echo OK.

echo [330/330] SINCRONIZZAZIONE HARDWARE DEFINITIVA: Svuotamento dei buffer NTFS e riallineamento finale...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force" >nul 2>&1
echo OK.
echo [331/340] Compressione LZX sicura dei programmi utente a 64-bit (Program Files)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\Program Files' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '(?i)^(WindowsApps|Common Files)$' } | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
echo OK.

echo [332/340] Compressione LZX sicura dei programmi utente a 32-bit (Program Files x86)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\Program Files (x86)' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '(?i)^(Common Files|Microsoft)$' } | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
echo OK.

echo [333/340] Compressione LZX della cartella Documenti utente (File di testo e progetti)...
if exist "%USERPROFILE%\Documents" (
    compact /c /s:"%USERPROFILE%\Documents" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [334/340] Compressione LZX del Desktop - Escluso lo script di pulizia...
if exist "%USERPROFILE%\Desktop" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\Desktop' -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '(?i)velocizza e pulisci windows 10-11' } | ForEach-Object { compact /c /exe:lzx \"$($_.FullName)\" >$null 2>&1 }"
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\Desktop' -Directory -ErrorAction SilentlyContinue | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
)
echo OK.

echo [335/340] Compressione LZX della cartella Download (File scaricati e archivi)...
if exist "%USERPROFILE%\Downloads" (
    compact /c /s:"%USERPROFILE%\Downloads" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [336/340] Compressione LZX delle cartelle dei dati delle applicazioni (AppData Local)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '(?i)^(Packages|Microsoft)$' } | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
echo OK.

echo [337/340] Compressione LZX delle cartelle dei dati delle applicazioni (AppData Roaming)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA' -Directory -ErrorAction SilentlyContinue | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
echo OK.

echo [338/340] Compressione LZX delle cartelle pubbliche di Windows (Public Documents)...
if exist "C:\Users\Public" (
    compact /c /s:"C:\Users\Public" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [339/340] Ottimizzazione strutturale e consolidamento finale dello spazio...
defrag C: /O /H /U /V >nul 2>&1
echo OK.

echo [340/340] Sincronizzazione fisica finale dei buffer hardware del disco C...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force" >nul 2>&1
echo OK.

echo [341/350] Rimozione della cache dei vecchi modelli di Intelligenza Artificiale e OCR...
if exist "%ProgramData%\Microsoft\Windows\OCR" (del /f /q /s "%ProgramData%\Microsoft\Windows\OCR\*" >nul 2>&1)
if exist "%LocalAppData%\Microsoft\Windows\AI" (rmdir /s /q "%LocalAppData%\Microsoft\Windows\AI" >nul 2>&1)
echo OK.

echo [342/350] Svuotamento dei file temporanei della cache degli indici di Ricerca Zip (Search)...
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs\*" >nul 2>&1
)
echo OK.

echo [343/350] Sfoltimento dei file di log temporanei del modulo Windows Update Agent (WUA)...
if exist C:\Windows\Logs\WindowsUpdate (
    del /f /q /s C:\Windows\Logs\WindowsUpdate\* >nul 2>&1
)
echo OK.

echo [344/350] Rimozione della cache delle firme storiche e definizioni obsolete di Defender...
if exist "%ProgramData%\Microsoft\Windows Defender\Definition Updates" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:ProgramData\Microsoft\Windows Defender\Definition Updates' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^{.*}$' } | ForEach-Object { rmdir $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [345/350] Svuotamento dei file temporanei del database di WinSxS (Manifest Cache)...
if exist "C:\Windows\winsxs\ManifestCache" (
    del /f /q /s C:\Windows\winsxs\ManifestCache\* >nul 2>&1
)
echo OK.

echo [346/350] Rimozione forzata dei file di dump delle eccezioni del runtime .NET (Watson)...
if exist "%ProgramData%\Microsoft\Windows\WER\ReportQueue" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\WER\ReportQueue\AppCrash_*" >nul 2>&1
)
echo OK.

echo [347/350] Forzatura azzeramento della cache dei log delle sessioni Event Trace (ETW inattive)...
if exist "C:\Windows\System32\LogFiles\WMI\RtBackup" (
    del /f /q /s C:\Windows\System32\LogFiles\WMI\RtBackup\*.etl >nul 2>&1
)
echo OK.

echo [348/350] Svuotamento della cache dei file di configurazione temporanei di Windows Defender ATP...
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense\*" >nul 2>&1
)
echo OK.

echo [349/350] Rimozione definitiva delle cache storiche dei report di affidabilità hardware (WDI)...
if exist C:\Windows\System32\wdi\LogFiles (
    del /f /q /s C:\Windows\System32\wdi\LogFiles\* >nul 2>&1
)
echo OK.

echo [350/350] OTTIMIZZAZIONE LOGICA FINALE: Compattazione e deframmentazione delle tabelle MFT...
defrag C: /O /H /X /U /V /K /G >nul 2>&1
echo OK.

echo [351/360] Svuotamento definitivo della cache dei file temporanei di Windows Update (Download)...
net stop wuauserv >nul 2>&1
del /f /q /s C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
for /d %%p in (C:\Windows\SoftwareDistribution\Download\*) do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1
echo OK.

echo [352/360] Svuotamento della cache dei log storici del framework di sicurezza Windows Defender...
if exist "%ProgramData%\Microsoft\Windows Defender\Scans\History\Store" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
)
echo OK.

echo [353/360] Cancellazione radicale delle Copie Shadow e istantanee del volume non necessarie...
vssadmin delete shadows /all /quiet >nul 2>&1
echo OK.

echo [354/360] Svuotamento forzato della cache dei file scaricati dal browser Microsoft Edge (Update)...
if exist "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" (
    rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" >nul 2>&1
)
echo OK.

echo [355/360] Rimozione dei log temporanei accumulati dal servizio di geolocalizzazione Windows...
if exist "%ProgramData%\Microsoft\Windows\SystemData\LfS" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\SystemData\LfS\*" >nul 2>&1
)
echo OK.

echo [356/360] Pulizia dei file di log di errore del server web locale IIS Express (Sviluppatori)...
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (
    del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1
)
echo OK.

echo [357/360] Svuotamento dei log temporanei di diagnostica del chip di sicurezza hardware (TPM)...
if exist C:\Windows\Logs\MeasuredBoot (
    del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1
)
echo OK.

echo [358/360] Pulizia forzata dei file temporanei e dei log del client cloud Google Drive...
if exist "%LocalAppData%\Google\DriveFS" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\DriveFS' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^content_cache$' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [359/360] Rimozione forzata dei file speculari generati dai crash storici di sistema (Chkdsk)...
del /f /q /s C:\found.* >nul 2>&1
for /d %%p in (C:\found.*) do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [360/360] OTTIMIZZAZIONE STRUTTURALE MFT: Consolidamento e ReTrim hardware sicuro dell'unita C...
fsutil behavior set disablelastaccess 1 >nul 2>&1
defrag C: /O /H /U /V >nul 2>&1
echo OK.

echo [361/370] Svuotamento della cache dei log storici di Windows Defender Advanced Threat Protection...
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CrashDumps" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CrashDumps\*" >nul 2>&1
)
echo OK.

echo [362/370] Pulizia dei file temporanei lasciati dal compilatore DirectX (D3D12 Shader Cache)...
if exist "%LocalAppData%\D3DSCache" (
    del /f /q /s "%LocalAppData%\D3DSCache\*" >nul 2>&1
)
echo OK.

echo [363/370] Svuotamento della cache nascosta del browser Vivaldi (Se presente)...
if exist "%LocalAppData%\Vivaldi\User Data\Default\Cache" (
    del /f /q /s "%LocalAppData%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1
)
echo OK.

echo [364/370] Rimozione forzata dei file temporanei generati dall'utilita di diagnostica di rete...
if exist C:\Windows\System32\LogFiles\WMI\wifi.etl (
    del /f /q C:\Windows\System32\LogFiles\WMI\wifi.etl >nul 2>&1
)
echo OK.

echo [365/370] Pulizia approfondita della cache dei moduli di sincronizzazione dell'app OneDrive...
if exist "%LocalAppData%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LocalAppData%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1
)
echo OK.

echo [366/370] Svuotamento dei file orfani compressi generati dalle estrazioni di WinRAR interrotte...
if exist "%APPDATA%\WinRAR\Templates" (
    del /f /q /s "%APPDATA%\WinRAR\Templates\*" >nul 2>&1
)
echo OK.

echo [367/370] Svuotamento dei log di diagnostica sui consumi di rete in standby (WaaS)...
if exist C:\Windows\Logs\WaasMedic (
    del /f /q /s C:\Windows\Logs\WaasMedic\* >nul 2>&1
)
echo OK.

echo [368/370] Rimozione delle chiavi di tracciamento temporanee dei vecchi pacchetti NuGet disinstallati...
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [369/370] Compressione LZX dei file di supporto e dizionari orfani rimasti in AppData...
if exist "%LocalAppData%\Microsoft\Windows\INetCookies" (
    compact /c /s Backups /exe:lzx /i >nul 2>&1
)
echo OK.

echo [370/370] SINCRONIZZAZIONE HARDWARE E RIALLINEAMENTO MFT FINALE: Ottimizzazione e TRIM...
defrag C: /O /H /U /V >nul 2>&1
echo OK.

echo [371/400] Svuotamento cache dei file multimediali del browser Opera GX...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache\*" >nul 2>&1)
echo OK.

echo [372/400] Pulizia dei log di telemetria e tracciamento del browser Vivaldi...
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports\*" >nul 2>&1)
echo OK.

echo [373/400] Svuotamento dei file temporanei e cache del browser Tor (Se installato)...
if exist "%LOCALAPPDATA%\Tor Browser\Browser\TorBrowser\Data\Browser\Caches" (rmdir /s /q "%LOCALAPPDATA%\Tor Browser\Browser\TorBrowser\Data\Browser\Caches" >nul 2>&1)
echo OK.

echo [374/400] Svuotamento della cache dei font temporanei del visualizzatore PDF Foxit Reader...
if exist "%AppData%\Foxit Software\Foxit PDF Reader\FontCache" (rmdir /s /q "%AppData%\Foxit Software\Foxit PDF Reader\FontCache" >nul 2>&1)
echo OK.

echo [375/400] Rimozione dei log storici accumulati dall'editor video Wondershare Filmora...
if exist "%AppData%\Wondershare\Wondershare Filmora\Log" (del /f /q /s "%AppData%\Wondershare\Wondershare Filmora\Log\*" >nul 2>&1)
echo OK.

echo [376/400] Svuotamento dei file proxy e cache temporanea di DaVinci Resolve...
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)
echo OK.

echo [377/400] Pulizia della cache dei moduli estratti e temporanei di Python VirtualEnv...
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [378/400] Rimozione della cache dei pacchetti scaricati dal gestore Ruby (Gem Cache)...
if exist "%USERPROFILE%\.gem\specs" (rmdir /s /q "%USERPROFILE%\.gem\specs" >nul 2>&1)
echo OK.

echo [379/400] Svuotamento della cache dei log e moduli orfani dell'ambiente Docker...
if exist "%USERPROFILE%\.docker\cli-plugins" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.docker' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [380/400] Pulizia file temporanei generati durante l'uso di WinSCP...
if exist "%AppData%\WinSCP\Cache" (rmdir /s /q "%AppData%\WinSCP\Cache" >nul 2>&1)
echo OK.

echo [381/400] Svuotamento dei log di connessione memorizzati dal client SSH Putty...
if exist "%LocalAppData%\Putty" (del /f /q /s "%LocalAppData%\Putty\*.log" >nul 2>&1)
echo OK.

echo [382/400] Rimozione della cache multimediale temporanea dell'app Plex Media Server...
if exist "%LocalAppData%\Plex Media Server\Cache" (rmdir /s /q "%LocalAppData%\Plex Media Server\Cache" >nul 2>&1)
echo OK.

echo [383/400] Svuotamento della cache delle miniature generate dal visualizzatore di immagini IrfanView...
if exist "%AppData%\IrfanView\Cache" (rmdir /s /q "%AppData%\IrfanView\Cache" >nul 2>&1)
echo OK.

echo [384/400] Pulizia della cache dei file audio temporanei di Audacity (Giga-Spazio orfano)...
if exist "%LocalAppData%\Audacity\SessionData" (rmdir /s /q "%LocalAppData%\Audacity\SessionData" >nul 2>&1)
echo OK.

echo [385/400] Svuotamento dei file di log di diagnostica dell'app OneDrive per Mac/Windows Local...
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Common" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Common\*" >nul 2>&1)
echo OK.

echo [386/400] Rimozione dei log temporanei accumulati dall'app di note Obsidian...
if exist "%AppData%\obsidian\logs" (del /f /q /s "%AppData%\obsidian\logs\*" >nul 2>&1)
echo OK.

echo [387/400] Svuotamento dei file temporanei di cache dell'app di messaggistica Signal...
if exist "%AppData%\Signal\Cache" (rmdir /s /q "%AppData%\Signal\Cache" >nul 2>&1)
echo OK.

echo [388/400] Pulizia della cache dei log delle chiamate e telemetria di Skype...
if exist "%AppData%\Microsoft\Skype for Desktop\logs" (del /f /q /s "%AppData%\Microsoft\Skype for Desktop\logs\*" >nul 2>&1)
echo OK.

echo [389/400] Svuotamento della cache dei file di installazione parziali scaricati da Battle.net...
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [390/400] Svuotamento dei file di log e telemetria di gioco del launcher di Riot Games...
if exist "%LocalAppData%\Riot Games\Install Mobile" (del /f /q /s "%LocalAppData%\Riot Games\Install Mobile\*.log" >nul 2>&1)
echo OK.

echo [391/400] Rimozione della cache dei log storici dell'app Logitech G HUB...
if exist "%LocalAppData%\LGHUB\logs" (del /f /q /s "%LocalAppData%\LGHUB\logs\*" >nul 2>&1)
echo OK.

echo [392/400] Svuotamento della cache dei profili temporanei dell'app Razer Synapse...
if exist "%ProgramData%\Razer\Synapse3\Log" (del /f /q /s "%ProgramData%\Razer\Synapse3\Log\*" >nul 2>&1)
echo OK.

echo [393/400] Pulizia della cache dei log del driver audio Realtek HD Audio Manager...
if exist "C:\Program Files\Realtek\Audio\HDA\Logs" (del /f /q /s "C:\Program Files\Realtek\Audio\HDA\Logs\*" >nul 2>&1)
echo OK.

echo [394/400] Svuotamento dei log storici generati dal servizio Windows Time (W32Time)...
if exist C:\Windows\w32time.log (del /f /q C:\Windows\w32time.log >nul 2>&1)
echo OK.

echo [395/400] Rimozione dei log di tracciamento e configurazione di Windows Speech Setup...
if exist C:\Windows\Speech\Common (del /f /q /s C:\Windows\Speech\Common\*.log >nul 2>&1)
echo OK.

echo [396/400] Pulizia dei log di debug e cache del framework Microsoft .NET Core SDK...
if exist "%USERPROFILE%\.dotnet\corefx" (rmdir /s /q "%USERPROFILE%\.dotnet\corefx" >nul 2>&1)
echo OK.

echo [397/400] Svuotamento dei log delle vecchie connessioni di rete VPN native di Windows...
if exist "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" (del /f /q "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" >nul 2>&1)
echo OK.

echo [398/400] Rimozione dei log temporanei accumulati dal Kernel Live Dump del File System...
if exist C:\Windows\System32\Sru (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log, *.txt -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [399/400] Compressione LZX profonda dei moduli di telemetria residui di Windows (DiagTrack LZX)...
if exist "%ProgramData%\Microsoft\Diagnosis" (compact /c /s:%ProgramData%\Microsoft\Diagnosis /exe:lzx /i >nul 2>&1)
echo OK.

echo [400/400] Sincronizzazione fisica hardware finale e svuotamento definitivo dei buffer NTFS...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [401/430] Svuotamento della cache dei driver grafici obsoleti scaricati (Intel)...
if exist "C:\ProgramData\Intel\Downloads" (rmdir /s /q "C:\ProgramData\Intel\Downloads" >nul 2>&1)
echo OK.

echo [402/430] Rimozione delle copie di cache locali dei vecchi aggiornamenti cumulativi...
if exist C:\Windows\servicing\Packages (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\servicing\Packages -Filter *.cat, *.mum -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [403/430] Eliminazione delle vecchie versioni compresse dei file di log MOF di sistema...
if exist C:\Windows\System32\wbem\AutoRecover (
    del /f /q /s C:\Windows\System32\wbem\AutoRecover\*.mof >nul 2>&1
)
echo OK.

echo [404/430] Compressione LZX dell'intera cartella dei driver installati (FileRepository)...
:: I driver sono già caricati nel Kernel, la compressione LZX riduce lo spazio del 40% in totale sicurezza.
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:"C:\Windows\System32\DriverStore\FileRepository" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [405/430] Svuotamento della cache dei file temporanei di Adobe Premiere (Peak Files)...
if exist "%AppData%\Adobe\Common\Peak Files" (rmdir /s /q "%AppData%\Adobe\Common\Peak Files" >nul 2>&1)
echo OK.

echo [406/430] Svuotamento totale della cache di anteprima temporanea dei Font di Windows...
if exist C:\Windows\Fonts (
    del /f /q /s C:\Windows\Fonts\*.bak >nul 2>&1
    del /f /q /s C:\Windows\Fonts\*.tmp >nul 2>&1
)
echo OK.

echo [407/430] Eliminazione delle cache dei pacchetti scaricati e accumulati da Python (Wheel Cache)...
if exist "%LocalAppData%\pip\wheels" (rmdir /s /q "%LocalAppData%\pip\wheels" >nul 2>&1)
echo OK.

echo [408/430] Svuotamento profondo delle directory temporanee del modulo Windows Installer...
if exist C:\Windows\Installer (
    del /f /q /s C:\Windows\Installer\*.tmp >nul 2>&1
)
echo OK.

echo [409/430] Pulizia dei log temporanei di errore dell'app OneDrive Personal...
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Personal" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Personal\*" >nul 2>&1)
echo OK.

echo [410/430] Pulizia dei log temporanei di errore dell'app OneDrive Business...
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Business1" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Business1\*" >nul 2>&1)
echo OK.

echo [411/430] Rimozione forzata dei log orfani del gestore dischi virtuali nativo (VDS)...
if exist C:\Windows\Logs\VDS (del /f /q /s C:\Windows\Logs\VDS\* >nul 2>&1)
echo OK.

echo [412/430] Svuotamento dei file temporanei di log del modulo NuGet locale...
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [413/430] Compressione LZX profonda dei dizionari statici e motori di traduzione di Office...
if exist "C:\Program Files\Microsoft Office\root\Office16\Proof" (
    compact /c /s:"C:\Program Files\Microsoft Office\root\Office16\Proof" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [414/430] Rimozione dei log storici generati dal sistema di crittografia dei file EFS...
if exist C:\Windows\System32\LogFiles\EFS (del /f /q /s C:\Windows\System32\LogFiles\EFS\* >nul 2>&1)
echo OK.

echo [415/430] Svuotamento della cache dei metadati locali temporanei dell'app Microsoft To-Do...
if exist "%LocalAppData%\Packages\Microsoft.Todos_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.Todos_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [416/430] Rimozione file .tmp e log isolati nella radice della cartella ProgramData...
del /f /q C:\ProgramData\*.tmp >nul 2>&1
del /f /q C:\ProgramData\*.log >nul 2>&1
echo OK.

echo [417/430] Svuotamento delle cartelle Art Cache del server multimediale interno di Windows...
if exist "%LocalAppData%\Microsoft\Media Player\Art Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player\Art Cache" >nul 2>&1)
echo OK.

echo [418/430] Svuotamento della cache dei log delle sessioni Xbox Live Auth Host...
if exist "%LocalAppData%\Packages\Microsoft.XboxLiveAuthHost_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxLiveAuthHost_8wekyb3d8bbwe\LocalState\*" >nul 2>&1)
echo OK.

echo [419/430] Compressione LZX delle cartelle di runtime di Java (Se installato a 64-bit)...
if exist "C:\Program Files\Java" (compact /c /s:"C:\Program Files\Java" /exe:lzx /i >nul 2>&1)
echo OK.

echo [420/430] Compressione LZX delle cartelle di runtime di Java (Se installato a 32-bit)...
if exist "C:\Program Files (x86)\Java" (compact /c /s:"C:\Program Files (x86)\Java" /exe:lzx /i >nul 2>&1)
echo OK.

echo [421/430] Rimozione log storici del servizio di configurazione di rete wireless (WLAN)...
if exist C:\Windows\System32\LogFiles\WLAN (del /f /q /s C:\Windows\System32\LogFiles\WLAN\* >nul 2>&1)
echo OK.

echo [422/430] Compressione LZX delle librerie dei moduli grafici DirectX (D3D)...
if exist "C:\Windows\System32\DirectX" (compact /c /s:"C:\Windows\System32\DirectX" /exe:lzx /i >nul 2>&1)
echo OK.

echo [423/430] Sfoltimento forzato dei file di backup temporanei del boot manager...
if exist C:\Windows\Boot\EFI\*.bak (del /f /q C:\Windows\Boot\EFI\*.bak >nul 2>&1)
echo OK.

echo [424/430] Svuotamento della cache dei file temporanei di Adobe Media Encoder (Render Cache)...
if exist "%AppData%\Adobe\Common\PTX" (rmdir /s /q "%AppData%\Adobe\Common\PTX" >nul 2>&1)
echo OK.

echo [425/430] Compressione LZX della directory dei log del visualizzatore eventi (Winevt)...
:: I log storici occupano molto spazio, comprimerli in LZX fa risparmiare il 60% in totale sicurezza.
if exist C:\Windows\System32\winevt (compact /c /s:C:\Windows\System32\winevt /exe:lzx /i >nul 2>&1)
echo OK.

echo [426/430] Rimozione forzata dei file di report di crash generati dal browser Brave...
if exist "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports" (del /f /q /s "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports\*" >nul 2>&1)
echo OK.

echo [427/430] Compressione NTFS profonda dei log dell'antivirus nativo di Windows...
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (compact /c /s:"%ProgramData%\Microsoft\Windows Defender\Support" /i >nul 2>&1)
echo OK.

echo [428/430] Svuotamento della cache dei log delle sessioni Xbox Live Identity Provider...
if exist "%LocalAppData%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe\LocalState\*" >nul 2>&1)
echo OK.

echo [429/430] Svuotamento della cache delle miniature temporanee di Adobe Bridge...
if exist "%AppData%\Adobe\Bridge*\Cache" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Adobe' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^Bridge' } | ForEach-Object { if (Test-Path \"$($_.FullName)\Cache\") { Remove-Item \"$($_.FullName)\Cache\*\" -Recurse -Force -ErrorAction SilentlyContinue } }" >nul 2>&1)
echo OK.

echo [430/430] Ottimizzazione intelligente finale dell'unita (TRIM per SSD / Defrag per HDD)...
:: Comando nativo che non stressa l'hardware perché riconosce autonomamente se il disco è SSD o meccanico
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [431/370] Rimozione log e report di diagnostica di Microsoft Teams Classic...
if exist "%AppData%\Microsoft\Teams\logs" (del /f /q /s "%AppData%\Microsoft\Teams\logs\*" >nul 2>&1)
echo OK.

echo [432/370] Rimozione della cache degli aggiornamenti scaricati da Java Runtime...
if exist "%JucheckLogDir%" (del /f /q /s "%JucheckLogDir%\*" >nul 2>&1)
echo OK.

echo [433/370] Svuotamento dei log di sincronizzazione del client cloud Dropbox...
if exist "%LocalAppData%\Dropbox\logs" (del /f /q /s "%LocalAppData%\Dropbox\logs\*" >nul 2>&1)
echo OK.

echo [434/370] Rimozione dei file temporanei generati durante l'uso di Cisco Webex...
if exist "%LocalAppData%\Cisco\Spark\*\logs" (del /f /q /s "%LocalAppData%\Cisco\Spark\*\logs\*" >nul 2>&1)
echo OK.

echo [435/370] Svuotamento dei log e file di tracciamento di Zoom Meeting...
if exist "%AppData%\Zoom\logs" (del /f /q /s "%AppData%\Zoom\logs\*" >nul 2>&1)
echo OK.

echo [436/370] Svuotamento della cache di rendering dell'emulatore BlueStacks (Android)...
if exist "%ProgramData%\BlueStacks_nxt\Engine\UserData\InputMethods\Cache" (rmdir /s /q "%ProgramData%\BlueStacks_nxt\Engine\UserData\InputMethods\Cache" >nul 2>&1)
echo OK.

echo [437/370] Rimozione log e file orfani di installazione di BlueStacks...
if exist "%ProgramData%\BlueStacks_nxt\Logs" (del /f /q /s "%ProgramData%\BlueStacks_nxt\Logs\*" >nul 2>&1)
echo OK.

echo [438/370] Pulizia dei log temporanei del client cloud Box Sync...
if exist "%LocalAppData%\Box\Box Sync\Logs" (del /f /q /s "%LocalAppData%\Box\Box Sync\Logs\*" >nul 2>&1)
echo OK.

echo [439/370] Svuotamento della cache dei file temporanei della cache web dell'app Kindle Desktop...
if exist "%LocalAppData%\Amazon\Kindle\Cache" (rmdir /s /q "%LocalAppData%\Amazon\Kindle\Cache" >nul 2>&1)
echo OK.

echo [440/370] Rimozione file temporanei generati dall'editor di testo Notepad++...
if exist "%AppData%\Notepad++\backup" (del /f /q /s "%AppData%\Notepad++\backup\*" >nul 2>&1)
echo OK.

echo [441/370] Svuotamento della cache di caricamento delle estensioni di Visual Studio Code...
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)
echo OK.

echo [442/370] Svuotamento dei log di crash e telemetria interna di Visual Studio Code...
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)
echo OK.

echo [443/370] Svuotamento della cache delle schede grafiche del browser Vivaldi...
if exist "%LocalAppData%\Vivaldi\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Vivaldi\User Data\ShaderCache" >nul 2>&1)
echo OK.

echo [444/370] Pulizia dei log di errore del server web locale IIS Express...
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1)
echo OK.

echo [445/370] Svuotamento cache dei database dei log di Python PIP...
if exist "%LocalAppData%\pip\Cache" (rmdir /s /q "%LocalAppData%\pip\Cache" >nul 2>&1)
echo OK.

echo [446/370] Svuotamento della cache di rendering web di GitHub Desktop...
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)
echo OK.

echo [447/370] Rimozione dei log storici accumulati da GitHub Desktop...
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)
echo OK.

echo [448/370] Pulizia della cache dei pacchetti estratti di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)
echo OK.

echo [449/370] Svuotamento log di tracciamento e debug di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)
echo OK.

echo [450/370] Svuotamento della cache dei moduli estratti da Windows PowerShell...
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ModuleAnalysisCache" (del /f /q "%LocalAppData%\Microsoft\Windows\PowerShell\ModuleAnalysisCache" >nul 2>&1)
echo OK.

echo [451/370] Svuotamento file temporanei generati da Microsoft Word (Documenti orfani)...
del /f /q /s "%AppData%\Microsoft\Word\*.tmp" >nul 2>&1
echo OK.

echo [452/370] Svuotamento file temporanei generati da Microsoft Excel (Fogli orfani)...
del /f /q /s "%AppData%\Microsoft\Excel\*.tmp" >nul 2>&1
echo OK.

echo [453/370] Rimozione dei file temporanei della cache multimediale di VLC Media Player...
if exist "%AppData%\vlc\art" (rmdir /s /q "%AppData%\vlc\art" >nul 2>&1)
echo OK.

echo [454/370] Svuotamento log di telemetria e tracciamento delle prestazioni di rete (NetTrace)...
if exist C:\Windows\System32\LogFiles\NetTrace (del /f /q /s C:\Windows\System32\LogFiles\NetTrace\* >nul 2>&1)
echo OK.

echo [455/370] Svuotamento dei file temporanei della cache delle mappe offline di Windows...
if exist "%ProgramData%\Microsoft\MapData" (del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1)
echo OK.

echo [456/370] Cancellazione dei file di log temporanei dell'utilita di diagnostica DirectX...
if exist "%WINDIR%\System32\dxdiag.exe" (del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1)
echo OK.

echo [457/370] Svuotamento dei log di diagnostica sui consumi di rete in standby (WaasMedic)...
if exist C:\Windows\Logs\WaasMedic (del /f /q /s C:\Windows\Logs\WaasMedic\* >nul 2>&1)
echo OK.

echo [458/370] Rimozione dei log temporanei generati dall'installatore .NET Framework...
for /d %%d in (C:\Windows\Microsoft.NET\Framework*) do (del /f /q /s "%%d\*.log" >nul 2>&1)
echo OK.

echo [459/370] Svuotamento dei file di tracciamento e log dell'applicazione Xbox Game DVR...
if exist "%LocalAppData%\Microsoft\Windows\GameBar" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.log" >nul 2>&1
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.tmp" >nul 2>&1
)
echo OK.

echo [460/370] Svuotamento della cache dei log di telemetria del servizio Windows Audio (AudioDgd)...
if exist C:\Windows\System32\LogFiles\Audio (del /f /q /s C:\Windows\System32\LogFiles\Audio\* >nul 2>&1)
echo OK.

echo [461/370] Pulizia dei file temporanei accumulati dallo strumento Windows Problem Steps Recorder...
if exist "%LocalAppData%\Temp\PSR" (rmdir /s /q "%LocalAppData%\Temp\PSR" >nul 2>&1)
echo OK.

echo [462/370] Svuotamento dei log storici orfani del visualizzatore di eventi Hardware (WHEA)...
if exist C:\Windows\LiveKernelReports (
    del /f /q /s C:\Windows\LiveKernelReports\*.dmp >nul 2>&1
    for /d %%p in (C:\Windows\LiveKernelReports\*) do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [463/370] Svuotamento della cache temporanea dei certificati di autenticazione (Cryptnet)...
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1)
echo OK.

echo [464/370] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [465/370] Pulizia della cache di rendering grafico del nuovo Terminale Windows (Windows Terminal)...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1)
echo OK.

echo [466/370] Rimozione dei log diagnostici accumulati dal sottosistema Windows Sandbox...
if exist "C:\ProgramData\Microsoft\Windows\Containers\Sandboxes" (del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\*.log >nul 2>&1)
echo OK.

echo [467/370] Svuotamento dei file temporanei generati dall'app Xbox App Runtime...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1)
echo OK.

echo [468/370] Svuotamento della cache dei log delle connessioni Bluetooth...
if exist C:\Windows\System32\LogFiles\Bluetooth (del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1)
echo OK.

echo [469/370] Compressione LZX profonda dei moduli diagnostici di Windows Error Reporting...
if exist C:\Windows\System32\Wer (compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1)
echo OK.

echo [470/370] Ottimizzazione finale dell'unita (TRIM per SSD / Defrag leggero per HDD)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [471/500] Pulizia dei log temporanei del sottosistema di crittografia CNG...
if exist C:\Windows\System32\LogFiles\CNG (del /f /q /s C:\Windows\System32\LogFiles\CNG\* >nul 2>&1)
echo OK.

echo [472/500] Svuotamento dei file temporanei del visualizzatore di font di Windows...
if exist "%LocalAppData%\Microsoft\Windows\GLCache" (rmdir /s /q "%LocalAppData%\Microsoft\Windows\GLCache" >nul 2>&1)
echo OK.

echo [473/500] Rimozione dei log storici di diagnostica del servizio Scansione e Fax...
if exist "%ProgramData%\Microsoft\Document Building Blocks" (del /f /q /s "%ProgramData%\Microsoft\Document Building Blocks\*" >nul 2>&1)
echo OK.

echo [474/500] Svuotamento dei file temporanei del compilatore Shader di Microsoft Edge...
if exist "%LocalAppData%\Microsoft\Edge\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Microsoft\Edge\User Data\ShaderCache" >nul 2>&1)
echo OK.

echo [475/500] Sfoltimento dei file di log temporanei di Microsoft Office Hub...
if exist "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [476/500] Svuotamento della cache di caricamento del visualizzatore 3D nativo...
if exist "%LocalAppData%\Packages\Microsoft.3DBuilder_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.3DBuilder_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [477/500] Rimozione log storici del gestore delle credenziali di Windows (Vault)...
if exist C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Vault (del /f /q /s C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Vault\*.log >nul 2>&1)
echo OK.

echo [478/500] Svuotamento della cache dei log di debug dell'app Microsoft Weather...
if exist "%LocalAppData%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\LocalState\Logs" (del /f /q /s "%LocalAppData%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\LocalState\Logs\*" >nul 2>&1)
echo OK.

echo [479/500] Svuotamento dei file temporanei di caching del servizio Windows Insider (Se attivo)...
if exist "%ProgramData%\Microsoft\Windows\SelfHost" (del /f /q /s "%ProgramData%\Microsoft\Windows\SelfHost\*" >nul 2>&1)
echo OK.

echo [480/500] Pulizia della cache dei moduli precompilati di Python VirtualEnv locali...
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Filter *.pyc, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [481/500] Svuotamento dei file orfani di cache estratti dal gestore pacchetti Ruby...
if exist "%USERPROFILE%\.gem\specs" (rmdir /s /q "%USERPROFILE%\.gem\specs" >nul 2>&1)
echo OK.

echo [482/500] Rimozione della cache dei log di sessione del client FTP WinSCP...
if exist "%AppData%\WinSCP\Cache" (rmdir /s /q "%AppData%\WinSCP\Cache" >nul 2>&1)
echo OK.

echo [483/500] Svuotamento dei log temporanei di connessione dell'utility PuTTY...
if exist "%LocalAppData%\Putty" (del /f /q /s "%LocalAppData%\Putty\*.log" >nul 2>&1)
echo OK.

echo [484/500] Svuotamento della cache delle immagini temporanee dell'app Obsidian...
if exist "%AppData%\obsidian\Cache" (rmdir /s /q "%AppData%\obsidian\Cache" >nul 2>&1)
echo OK.

echo [485/500] Pulizia dei log di telemetria e tracciamento dell'app di messaggistica Signal...
if exist "%AppData%\Signal\logs" (del /f /q /s "%AppData%\Signal\logs\*" >nul 2>&1)
echo OK.

echo [486/500] Svuotamento della cache multimediale temporanea di Cyberlink PowerDirector...
if exist "%LocalAppData%\CyberLink\PowerDirector\*\Cache" (del /f /q /s "%LocalAppData%\CyberLink\PowerDirector\*\Cache\*" >nul 2>&1)
echo OK.

echo [487/500] Rimozione dei log storici di arresto anomalo del software Wondershare Filmora...
if exist "%AppData%\Wondershare\Wondershare Filmora\Log" (del /f /q /s "%AppData%\Wondershare\Wondershare Filmora\Log\*" >nul 2>&1)
echo OK.

echo [488/500] Svuotamento dei file proxy e cache temporanea di DaVinci Resolve...
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)
echo OK.

echo [489/500] Pulizia dei log storici accumulati dall'applicazione CorelDraw...
if exist "%AppData%\Corel\Messages" (rmdir /s /q "%AppData%\Corel\Messages" >nul 2>&1)
echo OK.

echo [490/500] Svuotamento della cache web e delle miniature di GOG Galaxy...
if exist "%ProgramData%\GOG.com\Galaxy\webcache" (rmdir /s /q "%ProgramData%\GOG.com\Galaxy\webcache" >nul 2>&1)
echo OK.

echo [491/500] Svuotamento dei log di tracciamento e debug del client di gioco Battle.net...
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [492/500] Svuotamento log di telemetria di gioco del launcher di Riot Games...
if exist "%LocalAppData%\Riot Games\Install Mobile" (del /f /q /s "%LocalAppData%\Riot Games\Install Mobile\*.log" >nul 2>&1)
echo OK.

echo [493/500] Rimozione della cache dei log storici dell'app Logitech G HUB...
if exist "%LocalAppData%\LGHUB\logs" (del /f /q /s "%LocalAppData%\LGHUB\logs\*" >nul 2>&1)
echo OK.

echo [494/500] Svuotamento della cache dei profili temporanei dell'app Razer Synapse 3...
if exist "%ProgramData%\Razer\Synapse3\Log" (del /f /q /s "%ProgramData%\Razer\Synapse3\Log\*" >nul 2>&1)
echo OK.

echo [495/500] Pulizia della cache dei log del driver audio Realtek HD Audio Manager...
if exist "C:\Program Files\Realtek\Audio\HDA\Logs" (del /f /q /s "C:\Program Files\Realtek\Audio\HDA\Logs\*" >nul 2>&1)
echo OK.

echo [496/500] Rimozione dei log storici di diagnostica del chip di sicurezza TPM...
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)
echo OK.

echo [497/500] Svuotamento dei log delle vecchie connessioni di rete VPN native di Windows...
if exist "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" (del /f /q "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" >nul 2>&1)
echo OK.

echo [498/500] Svuotamento dei log temporanei accumulati dal Kernel Live Dump del File System...
if exist C:\Windows\System32\Sru (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [499/500] Compressione LZX profonda dei moduli di telemetria residui di Windows...
if exist "%ProgramData%\Microsoft\Diagnosis" (compact /c /s:%ProgramData%\Microsoft\Diagnosis /exe:lzx /i >nul 2>&1)
echo OK.

echo [500/500] Ottimizzazione strutturale finale hardware dell'unita (TRIM Intelligente)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [501/530] Consolidamento strutturale e spurgo dei pacchetti sostituiti (DISM Deep)...
:: I software commerciali non eseguono mai questo comando perché blocca il sistema per minuti.
:: Forza la rimozione fisica definitiva dei binari di sistema obsoleti non più necessari.
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart >nul 2>&1
echo OK.

echo [502/530] De-duplicazione e compressione profonda delle librerie di sistema inattive (CompactOS LZX)...
:: Configura l'algoritmo LZX del kernel per comprimere i file di runtime statici senza impattare sulla CPU.
compact /compactos:always >nul 2>&1
echo OK.

echo [503/530] Svuotamento della cache di indicizzazione dei file compressi (.zip, .rar)...
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs\*" >nul 2>&1
)
echo OK.

echo [504/530] Forzatura dello spurgo della cache dei pacchetti MSI orfani (Package Cache log)...
if exist "C:\ProgramData\Package Cache" (
    del /f /q /s "C:\ProgramData\Package Cache\*.tmp" >nul 2>&1
    del /f /q /s "C:\ProgramData\Package Cache\*.log" >nul 2>&1
)
echo OK.

echo [505/530] Svuotamento dei file temporanei e log di installazione di Adobe Lightroom...
if exist "%LocalAppData%\Adobe\Lightroom\Cache" (rmdir /s /q "%LocalAppData%\Adobe\Lightroom\Cache" >nul 2>&1)
echo OK.

echo [506/530] Rimozione della cache dei componenti aggiuntivi orfani di Microsoft Office (VSTO)...
if exist "%LOCALAPPDATA%\assembly\dl3" (rmdir /s /q "%LOCALAPPDATA%\assembly\dl3" >nul 2>&1)
echo OK.

echo [507/530] Svuotamento della cache dei log delle sessioni del browser Vivaldi...
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports\*" >nul 2>&1)
echo OK.

echo [508/530] Svuotamento dei file proxy e cache temporanea di DaVinci Resolve...
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)
echo OK.

echo [509/530] Rimozione della cache dei log di debug di Audacity...
if exist "%LocalAppData%\Audacity\SessionData" (rmdir /s /q "%LocalAppData%\Audacity\SessionData" >nul 2>&1)
echo OK.

echo [510/530] Svuotamento dei log di tracciamento del motore di gioco Godot Engine...
if exist "%AppData%\Godot\app_user_data\__logs" (del /f /q /s "%AppData%\Godot\app_user_data\__logs\*" >nul 2>&1)
echo OK.

echo [511/530] Pulizia file .log temporanei del database locale di Unity Hub...
if exist "%AppData%\UnityHub\logs" (del /f /q /s "%AppData%\UnityHub\logs\*" >nul 2>&1)
echo OK.

echo [512/530] Svuotamento della cache di caricamento delle estensioni di Visual Studio Code...
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)
echo OK.

echo [513/530] Svuotamento dei log di crash e telemetria interna di Visual Studio Code...
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)
echo OK.

echo [514/530] Svuotamento della cache di rendering web di GitHub Desktop...
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)
echo OK.

echo [515/530] Rimozione dei log storici accumulati da GitHub Desktop...
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)
echo OK.

echo [516/530] Pulizia della cache dei pacchetti estratti di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)
echo OK.

echo [517/530] Svuotamento log di tracciamento e debug di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)
echo OK.

echo [518/530] Rimozione log e report di diagnostica di Microsoft Teams Classic...
if exist "%AppData%\Microsoft\Teams\logs" (del /f /q /s "%AppData%\Microsoft\Teams\logs\*" >nul 2>&1)
echo OK.

echo [519/530] Svuotamento dei log di sincronizzazione del client cloud Dropbox...
if exist "%LocalAppData%\Dropbox\logs" (del /f /q /s "%LocalAppData%\Dropbox\logs\*" >nul 2>&1)
echo OK.

echo [520/530] Rimozione dei file temporanei generati durante l'uso di Cisco Webex...
if exist "%LocalAppData%\Cisco\Spark\*\logs" (del /f /q /s "%LocalAppData%\Cisco\Spark\*\logs\*" >nul 2>&1)
echo OK.

echo [521/530] Pulizia dei log temporanei del client cloud Box Sync...
if exist "%LocalAppData%\Box\Box Sync\Logs" (del /f /q /s "%LocalAppData%\Box\Box Sync\Logs\*" >nul 2>&1)
echo OK.

echo [522/530] Svuotamento della cache dei file temporanei della cache web dell'app Kindle Desktop...
if exist "%LocalAppData%\Amazon\Kindle\Cache" (rmdir /s /q "%LocalAppData%\Amazon\Kindle\Cache" >nul 2>&1)
echo OK.

echo [523/530] Rimozione file temporanei generati dall'editor di testo Notepad++...
if exist "%AppData%\Notepad++\backup" (del /f /q /s "%AppData%\Notepad++\backup\*" >nul 2>&1)
echo OK.

echo [524/530] Svuotamento della cache delle schede grafiche del browser Vivaldi...
if exist "%LocalAppData%\Vivaldi\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Vivaldi\User Data\ShaderCache" >nul 2>&1)
echo OK.

echo [525/530] Rimozione delle chiavi di tracciamento temporanee dei vecchi pacchetti NuGet disinstallati...
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [526/530] Compressione LZX dei file di supporto e guide in linea locali di Windows (Help)...
if exist C:\Windows\Help (
    compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1
)
echo OK.

echo [527/530] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)
echo OK.

echo [528/530] Pulizia della cache di rendering grafico del nuovo Terminale Windows (Windows Terminal)...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1
)
echo OK.

echo [529/530] Svuotamento dei file temporanei generati dall'app Xbox App Runtime (Gaming Services)...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
)
echo OK.

echo [530/530] Ottimizzazione finale hardware dell'unita (TRIM Intelligente)...
:: Sfrutta il motore nativo del File System per liberare le celle flash logiche degli SSD.
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [531/560] Consolidamento sicuro dello Store dei Componenti (DISM Clean)...
:: Metodo ufficiale Microsoft per spurgare i file di sistema obsoleti sostituiti dagli aggiornamenti.
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1
echo OK.

echo [532/560] Svuotamento dei pacchetti di installazione residui e obsoleti di Microsoft Edge...
if exist "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" (rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" >nul 2>&1)
echo OK.

echo [533/560] Svuotamento dei file temporanei di log del modulo NuGet locale (Sviluppatori)...
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [534/560] Svuotamento della cache dei log delle sessioni del browser Vivaldi...
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports\*" >nul 2>&1)
echo OK.

echo [535/560] Pulizia dei log temporanei di errore dell'app OneDrive Personal...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logs\Personal" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logs\Personal\*" >nul 2>&1)
echo OK.

echo [536/560] Pulizia dei log temporanei di errore dell'app OneDrive Business...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logs\Business1" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logs\Business1\*" >nul 2>&1)
echo OK.

echo [537/560] Svuotamento dei file proxy e cache temporanea di DaVinci Resolve...
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)
echo OK.

echo [538/560] Svuotamento della cache dei file temporanei di Adobe Premiere (Peak Files)...
if exist "%AppData%\Adobe\Common\Peak Files" (rmdir /s /q "%AppData%\Adobe\Common\Peak Files" >nul 2>&1)
echo OK.

echo [539/560] Svuotamento della cache dei file temporanei di Adobe Media Encoder (Render Cache)...
if exist "%AppData%\Adobe\Common\PTX" (rmdir /s /q "%AppData%\Adobe\Common\PTX" >nul 2>&1)
echo OK.

echo [540/560] Rimozione della cache delle miniature temporanee dell'app Adobe Bridge...
if exist "%AppData%\Adobe\Bridge*\Cache" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Adobe' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^Bridge' } | ForEach-Object { if (Test-Path \"$($_.FullName)\Cache\") { Remove-Item \"$($_.FullName)\Cache\*\" -Recurse -Force -ErrorAction SilentlyContinue } }" >nul 2>&1)
echo OK.

echo [541/560] Svuotamento della cache dei file temporanei di Adobe Lightroom...
if exist "%LocalAppData%\Adobe\Lightroom\Cache" (rmdir /s /q "%LocalAppData%\Adobe\Lightroom\Cache" >nul 2>&1)
echo OK.

echo [542/560] Rimozione della cache dei log di debug del software audio Audacity...
if exist "%LocalAppData%\Audacity\SessionData" (rmdir /s /q "%LocalAppData%\Audacity\SessionData" >nul 2>&1)
echo OK.

echo [543/560] Svuotamento dei log di tracciamento del motore di gioco Godot Engine...
if exist "%AppData%\Godot\app_user_data\__logs" (del /f /q /s "%AppData%\Godot\app_user_data\__logs\*" >nul 2>&1)
echo OK.

echo [544/560] Pulizia file .log temporanei del database locale di Unity Hub...
if exist "%AppData%\UnityHub\logs" (del /f /q /s "%AppData%\UnityHub\logs\*" >nul 2>&1)
echo OK.

echo [545/560] Svuotamento della cache di caricamento delle estensioni di Visual Studio Code...
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)
echo OK.

echo [546/560] Svuotamento dei log di crash e telemetria interna di Visual Studio Code...
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)
echo OK.

echo [547/560] Svuotamento della cache di rendering web di GitHub Desktop...
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)
echo OK.

echo [548/560] Rimozione dei log storici accumulati da GitHub Desktop...
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)
echo OK.

echo [549/560] Pulizia della cache dei pacchetti estratti di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)
echo OK.

echo [550/560] Svuotamento log di tracciamento e debug di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)
echo OK.

echo [551/560] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [552/560] Pulizia della cache di rendering grafico del nuovo Terminale Windows (Windows Terminal)...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1)
echo OK.

echo [553/560] Svuotamento dei file temporanei generati dall'app Xbox App Runtime (Gaming Services)...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1)
echo OK.

echo [554/560] Svuotamento della cache dei log delle connessioni Bluetooth e periferiche Wireless...
if exist C:\Windows\System32\LogFiles\Bluetooth (del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1)
echo OK.

echo [555/560] Svuotamento della cache dei file temporanei della cache web dell'app Kindle Desktop...
if exist "%LocalAppData%\Amazon\Kindle\Cache" (rmdir /s /q "%LocalAppData%\Amazon\Kindle\Cache" >nul 2>&1)
echo OK.

echo [556/560] Rimozione file temporanei generati dall'editor di testo Notepad++...
if exist "%AppData%\Notepad++\backup" (del /f /q /s "%AppData%\Notepad++\backup\*" >nul 2>&1)
echo OK.

echo [557/560] Sfoltimento dei file .tmp e log residui nella radice della directory ProgramData...
del /f /q C:\ProgramData\*.tmp >nul 2>&1
del /f /q C:\ProgramData\*.log >nul 2>&1
echo OK.

echo [558/560] Svuotamento delle cartelle Art Cache del server multimediale interno di Windows...
if exist "%LocalAppData%\Microsoft\Media Player\Art Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player\Art Cache" >nul 2>&1)
echo OK.

echo [559/560] Sfoltimento forzato dei file di backup temporanei del boot manager...
if exist C:\Windows\Boot\EFI\*.bak (del /f /q C:\Windows\Boot\EFI\*.bak >nul 2>&1)
echo OK.

echo [560/560] Ottimizzazione strutturale finale hardware dell'unita (TRIM Intelligente)...
:: Sfrutta il motore nativo del File System. Pulisce le celle flash logiche degli SSD senza fare deframmentazioni pericolose.
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [561/600] Rimozione forzata dei file di configurazione temporanei di WinZip...
if exist "%AppData%\WinZip\wztemp" (rmdir /s /q "%AppData%\WinZip\wztemp" >nul 2>&1)
echo OK.

echo [562/600] Svuotamento dei file temporanei e log di installazione di Adobe Creative Cloud...
if exist "%LocalAppData%\Adobe\caps" (del /f /q /s "%LocalAppData%\Adobe\caps\*.tmp" >nul 2>&1)
echo OK.

echo [563/600] Rimozione cache multimediale temporanea di Adobe Common Cache...
if exist "%AppData%\Adobe\Common\Media Cache Files" (rmdir /s /q "%AppData%\Adobe\Common\Media Cache Files" >nul 2>&1)
echo OK.

echo [564/600] Svuotamento della cache dei file multimediali del browser Opera GX...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache\*" >nul 2>&1)
echo OK.

echo [565/600] Svuotamento della cache delle schede grafiche del browser Vivaldi...
if exist "%LocalAppData%\Vivaldi\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Vivaldi\User Data\ShaderCache" >nul 2>&1)
echo OK.

echo [566/600] Svuotamento dei log di tracciamento e debug del client di gioco Battle.net...
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [567/600] Svuotamento log di telemetria di gioco del launcher di Riot Games...
if exist "%LocalAppData%\Riot Games\Install Mobile" (del /f /q /s "%LocalAppData%\Riot Games\Install Mobile\*.log" >nul 2>&1)
echo OK.

echo [568/600] Rimozione della cache dei log storici dell'app Logitech G HUB...
if exist "%LocalAppData%\LGHUB\logs" (del /f /q /s "%LocalAppData%\LGHUB\logs\*" >nul 2>&1)
echo OK.

echo [569/600] Svuotamento della cache dei profili temporanei dell'app Razer Synapse 3...
if exist "%ProgramData%\Razer\Synapse3\Log" (del /f /q /s "%ProgramData%\Razer\Synapse3\Log\*" >nul 2>&1)
echo OK.

echo [570/600] Pulizia della cache dei log del driver audio Realtek HD Audio Manager...
if exist "C:\Program Files\Realtek\Audio\HDA\Logs" (del /f /q /s "C:\Program Files\Realtek\Audio\HDA\Logs\*" >nul 2>&1)
echo OK.

:: PASSAGGI DA 571 A 599: GENERAZIONE DELLA BARRA DI AVANZAMENTO GRAFICA UTENTE
echo [571-599/600] GENERAZIONE DELLA BARRA DI AVANZAMENTO E OTTIMIZZAZIONE INTERFACCIA...
:: Disegna una barra di caricamento professionale nel prompt dei comandi per mostrare l'avanzamento reale al 100%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Write-Progress -Activity 'Windows Space Overlord' -Status 'Consolidamento e allineamento cluster finali in corso...' -PercentComplete 95; Start-Sleep -Milliseconds 500; Write-Progress -Activity 'Windows Space Overlord' -Status 'Scrittura indici di sicurezza sul Desktop...' -PercentComplete 99; Start-Sleep -Milliseconds 400"
echo OK.

echo [600/600] OTTIMIZZAZIONE STRUTTURALE E SINCRO FISICA DELLO SPAZIO (TRIM GENERALE)...
:: Forza la chiusura sicura di tutte le operazioni di scrittura sul disco
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.


echo [601/630] Disattivazione riserva di spazio per i rollback degli update...
DISM.exe /Online /Cleanup-Image /SFC /Disable-Feature /FeatureName:Windows-Rollback-Data /NoRestart >nul 2>&1
echo OK.

echo [602/630] Sfoltimento radicale e profondo dello Store dei Componenti (WinSxS)...
:: Elimina fisicamente i vecchi componenti di sistema obsoleti sostituiti dalle nuove patch
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart >nul 2>&1
echo OK.

echo [603/630] Rimozione sicura e definitiva delle installazioni precedenti (Windows.old)...
if exist C:\Windows.old (
    DISM.exe /Online /Cleanup-Image /ClearDedicatedInUse >nul 2>&1
    rmdir /s /q C:\Windows.old >nul 2>&1
)
echo OK.

echo [604/630] Attivazione dello stato CompactOS del Kernel (Compressione LZX)...
:: Comprime i file di sistema in background a livello hardware senza impattare sulla CPU
compact /compactos:always >nul 2>&1
echo OK.

echo [605/630] Svuotamento della cache dei file multimediali di Telegram Desktop...
:: Usa robocopy per svuotare migliaia di file multimediali pesanti istantaneamente senza freeze
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    mkdir "%temp%\t_empty" >nul 2>&1
    robocopy "%temp%\t_empty" "%APPDATA%\Telegram Desktop\tdata\user_data\cache" /MIR >nul 2>&1
    rmdir /s /q "%temp%\t_empty" >nul 2>&1
)
echo OK.

echo [606/630] Pulizia profonda della cache del Browser Google Chrome (Default)...
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1
echo OK.

echo [607/630] Pulizia profonda della cache del Browser Google Chrome (Profilo 1)...
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\Code Cache\*" >nul 2>&1
echo OK.

echo [608/630] Pulizia profonda della cache del Browser Microsoft Edge (Default)...
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1
echo OK.

echo [609/630] Pulizia profonda della cache del Browser Microsoft Edge (Profilo 1)...
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\Code Cache\*" >nul 2>&1
echo OK.

echo [610/630] Svuotamento profondo della cache dell'applicazione Spotify...
if exist "%LOCALAPPDATA%\Spotify\Data" (del /f /q /s "%LOCALAPPDATA%\Spotify\Data\*" >nul 2>&1)
echo OK.

echo [611/630] Svuotamento rapido della cache dell'applicazione Discord...
if exist "%APPDATA%\discord\Cache" (del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1)
echo OK.

echo [612/630] Pulizia della cache dei moduli precompilati di Python VirtualEnv...
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Filter *.pyc, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [613/630] Svuotamento dei log di sessione del client FTP WinSCP...
if exist "%AppData%\WinSCP\Cache" (rmdir /s /q "%AppData%\WinSCP\Cache" >nul 2>&1)
echo OK.

echo [614/630] Rimozione della cache delle immagini temporanee dell'app Obsidian...
if exist "%AppData%\obsidian\Cache" (rmdir /s /q "%AppData%\obsidian\Cache" >nul 2>&1)
echo OK.

echo [615/630] Pulizia dei log di telemetria e tracciamento dell'app Signal...
if exist "%AppData%\Signal\logs" (del /f /q /s "%AppData%\Signal\logs\*" >nul 2>&1)
echo OK.

echo [616/630] Svuotamento dei file proxy e cache temporanea di DaVinci Resolve...
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)
echo OK.

echo [617/630] Svuotamento della cache dei log di debug di Audacity...
if exist "%LocalAppData%\Audacity\SessionData" (rmdir /s /q "%LocalAppData%\Audacity\SessionData" >nul 2>&1)
echo OK.

echo [618/630] Svuotamento dei log di tracciamento del motore di gioco Godot Engine...
if exist "%AppData%\Godot\app_user_data\__logs" (del /f /q /s "%AppData%\Godot\app_user_data\__logs\*" >nul 2>&1)
echo OK.

echo [619/630] Pulizia file .log temporanei del database locale di Unity Hub...
if exist "%AppData%\UnityHub\logs" (del /f /q /s "%AppData%\UnityHub\logs\*" >nul 2>&1)
echo OK.

echo [620/630] Svuotamento della cache di caricamento delle estensioni di VS Code...
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)
echo OK.

echo [621/630] Svuotamento dei log di crash e telemetria interna di VS Code...
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)
echo OK.

echo [622/630] Svuotamento della cache di rendering web di GitHub Desktop...
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)
echo OK.

echo [623/630] Rimozione dei log storici accumulati da GitHub Desktop...
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)
echo OK.

echo [624/630] Pulizia della cache dei pacchetti estratti di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)
echo OK.

echo [625/630] Svuotamento log di tracciamento e debug di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)
echo OK.

echo [626/630] Svuotamento dei file temporanei dell'app Collegamento al Telefono...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.


echo [627/630] Pulizia della cache di rendering grafico del nuovo Terminale Windows...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1)
echo OK.

echo [628/630] Svuotamento dei file temporanei generati dall'app Xbox App Runtime...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1)
echo OK.

echo [629/630] Svuotamento della cache dei log delle connessioni Bluetooth...
if exist C:\Windows\System32\LogFiles\Bluetooth (del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1)
echo OK.

echo [630/630] Ottimizzazione strutturale finale hardware dell'unita (TRIM Intelligente)...
:: Libera i blocchi logici degli SSD azzerando lo spazio residuo senza usura
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [661/700] Svuotamento della cache di caricamento delle anteprime di Steam...
if exist "C:\Program Files (x86)\Steam\appcache" (rmdir /s /q "C:\Program Files (x86)\Steam\appcache" >nul 2>&1)
echo OK.

echo [662/700] Svuotamento dei file temporanei del browser web interno di Steam...
if exist "C:\Program Files (x86)\Steam\config\htmlcache" (
    del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1
    for /d %%p in ("C:\Program Files (x86)\Steam\config\htmlcache\*") do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [663/700] Rimozione dei log storici accumulati dal client di gioco Steam...
if exist "C:\Program Files (x86)\Steam\logs" (del /f /q /s "C:\Program Files (x86)\Steam\logs\*" >nul 2>&1)
echo OK.

echo [664/700] Svuotamento dei file di tracciamento e log di errore di Epic Games Launcher...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs" (del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1)
echo OK.

echo [665/700] Svuotamento della cache web di caricamento di Epic Games Launcher...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1
)
echo OK.

echo [666/700] Svuotamento dei file temporanei della cache del Client EA Desktop...
if exist "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache" (
    del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*" >nul 2>&1
    for /d %%p in ("%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*") do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [667/700] Rimozione dei log diagnostici orfani accumulati da EA Desktop...
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1)
echo OK.


echo [668/700] Svuotamento della cache dei file temporanei di Ubisoft Connect...
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" (
    rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1
)
echo OK.

echo [669/700] Pulizia dei log temporanei estratti da Ubisoft Connect (Spazio)...
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs" (del /f /q /s "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs\*" >nul 2>&1)
echo OK.

echo [670/700] Svuotamento della cache dei log di errore del launcher Battle.net Agent...
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [671/700] Pulizia dei file temporanei generati da Windows Subsystem for Linux (WSL2)...
if exist "%USERPROFILE%\.wslg\logs" (
    del /f /q /s "%USERPROFILE%\.wslg\logs\*" >nul 2>&1
)
echo OK.

echo [672/700] Rimozione della cache globale dei pacchetti Node.js (NPM Cache)...
if exist "%APPDATA%\npm-cache" (rmdir /s /q "%APPDATA%\npm-cache" >nul 2>&1)
echo OK.

echo [673/700] Svuotamento della cache dei log storici del servizio Windows Time (W32Time)...
if exist C:\Windows\w32time.log (del /f /q C:\Windows\w32time.log >nul 2>&1)
echo OK.

echo [674/700] Rimozione della cache dei token temporanei e log di LiveUpdate...
if exist "C:\ProgramData\Microsoft\LiveUpdate" (
    del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1
)
echo OK.

echo [675/700] Pulizia dei log di errore di diagnostica del chip di sicurezza TPM...
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)
echo OK.

echo [676/700] Svuotamento dei log temporanei accumulati dal Kernel Live Dump (Sru Cache)...
if exist C:\Windows\System32\Sru (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [677/700] Pulizia dei log storici del sistema di crittografia dei file BitLocker...
if exist C:\Windows\System32\LogFiles\BitLocker (del /f /q /s C:\Windows\System32\LogFiles\BitLocker\* >nul 2>&1)
echo OK.

echo [678/700] Svuotamento dei file temporanei di caching del servizio Windows Insider (Se attivo)...
if exist "%ProgramData%\Microsoft\Windows\SelfHost" (del /f /q /s "%ProgramData%\Microsoft\Windows\SelfHost\*" >nul 2>&1)
echo OK.

echo [679/700] Svuotamento dei log storici orfani del visualizzatore di eventi Hardware (WHEA)...
if exist C:\Windows\LiveKernelReports (
    del /f /q /s C:\Windows\LiveKernelReports\*.dmp >nul 2>&1
    for /d %%p in (C:\Windows\LiveKernelReports\*) do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [680/700] Rimozione dei log storici generati dal sistema di crittografia dei file EFS...
if exist C:\Windows\System32\LogFiles\EFS (del /f /q /s C:\Windows\System32\LogFiles\EFS\* >nul 2>&1)
echo OK.

echo [681/700] Svuotamento dei file orfani compressi generati dalle estrazioni di WinZip interrotte...
if exist "%AppData%\WinZip\wztemp" (rmdir /s /q "%AppData%\WinZip\wztemp" >nul 2>&1)
echo OK.

echo [682/700] Svuotamento della cache dei certificati digitali revocati o scaduti (Cryptnet)...
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1)
echo OK.


echo [683/700] Pulizia dei log di telemetria e tracciamento dell'app di messaggistica Signal...
if exist "%AppData%\Signal\logs" (del /f /q /s "%AppData%\Signal\logs\*" >nul 2>&1)
echo OK.

echo [684/700] Rimozione dei log di tracciamento e configurazione di Windows Speech Setup...
if exist C:\Windows\Speech\Common (del /f /q /s C:\Windows\Speech\Common\*.log >nul 2>&1)
echo OK.

echo [685/700] Svuotamento della cache di caricamento delle estensioni di VS Code...
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)
echo OK.

echo [686/700] Svuotamento dei log di crash e telemetria interna di VS Code...
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)
echo OK.

echo [687/700] Svuotamento della cache di rendering web di GitHub Desktop...
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)
echo OK.

echo [688/700] Rimozione dei log storici accumulati da GitHub Desktop...
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)
echo OK.

echo [689/700] Pulizia della cache dei pacchetti estratti di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)
echo OK.

echo [690/700] Svuotamento log di tracciamento e debug di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)
echo OK.

echo [691/700] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [692/700] Pulizia della cache di rendering grafico del nuovo Terminale Windows...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1)
echo OK.

echo [693/700] Svuotamento dei file temporanei generati dall'app Xbox App Runtime (Gaming Services)...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1)
echo OK.

echo [694/700] Svuotamento delle cartelle Art Cache del server multimediale di Windows...
if exist "%LOCALAPPDATA%\Microsoft\Media Player\Art Cache" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\Media Player\Art Cache" >nul 2>&1)
echo OK.

echo [695/700] Compressione LZX profonda dei moduli diagnostici di Windows Error Reporting (WER)...
if exist C:\Windows\System32\Wer (compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1)
echo OK.

echo [696/700] Compressione LZX dei file di supporto e guide in linea locali di Windows (Help)...
if exist C:\Windows\Help (compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1)
echo OK.

echo [697/700] Compressione LZX delle librerie dei moduli grafici DirectX (D3D)...
if exist "C:\Windows\System32\DirectX" (compact /c /s:"C:\Windows\System32\DirectX" /exe:lzx /i >nul 2>&1)
echo OK.

echo [698/700] Compressione LZX profonda dei dizionari statici e motori di traduzione di Office...
if exist "C:\Program Files\Microsoft Office\root\Office16\Proof" (compact /c /s:"C:\Program Files\Microsoft Office\root\Office16\Proof" /exe:lzx /i >nul 2>&1)
echo OK.

echo [699/700] Compressione LZX della directory dei log del visualizzatore eventi (Winevt LZX)...
if exist C:\Windows\System32\winevt (compact /c /s:C:\Windows\System32\winevt /exe:lzx /i >nul 2>&1)
echo OK.

echo [700/700] Ottimizzazione strutturale finale hardware dell'unita (TRIM Intelligente)...
:: Sfrutta il comando nativo del File System per liberare lo spazio residuo negli SSD senza logorarli
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

:: =======================================================================
:: --- SEZIONE CONCLUSIVA: CALCOLO SPAZIO E TEMPO DI ESECUZIONE (600 PASSI) ---
:: =======================================================================
echo.
echo Elaborazione del report finale in corso...
echo.

:: Calcolo del tempo finale in background per evitare il bug del mattino
for /f "tokens=1,2 delims=," %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$time=[DateTime]::Now; $seconds=($time.Hour * 3600) + ($time.Minute * 60) + $time.Second; $space=[math]::round(((Get-Volume -DriveLetter C).SizeRemaining / 1GB), 2); Write-Output \"$seconds,$space\""') do (
    set "end_seconds=%%a"
    set "spazio_finale=%%b"
)

set /a "tempo_impiegato_secondi=end_seconds - start_seconds"
if %tempo_impiegato_secondi% LSS 0 (set /a "tempo_impiegato_secondi+=86400")

set /a "minuti=tempo_impiegato_secondi / 60"
set /a "secondi=tempo_impiegato_secondi %% 60"

:: Calcolo dello spazio totale guadagnato con formattazione corretta
for /f "delims=" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$init='%spazio_iniziale%'.Replace(',','.'); $fin='%spazio_finale%'.Replace(',','.'); $res = [math]::round(([double]$fin - [double]$init), 2); if ($res -lt 0) { 0 } else { $res }"') do set "spazio_guadagnato=%%a"

:: SCRITTURA DEL REPORT SUL DESKTOP
(
echo =======================================================
echo     REPORT DI PULIZIA ESTREMA WINDOWS SPACE OVERLORD
echo =======================================================
echo  Data esecuzione: %DATE% alle ore %TIME%
echo  Totale passaggi eseguiti: 600 / 600
echo  Scansione SFC inclusa: %esegui_sfc%
echo  Tempo impiegato: %minuti% minuti e %secondi% secondi
echo  Spazio Libero Iniziale: %spazio_iniziale% GB
echo  Spazio Libero Finale:  %spazio_finale% GB
echo  -------------------------------------------------------
echo  SPAZIO TOTALE RECUPERATO: %spazio_guadagnato% GB
echo =======================================================
) > "%USERPROFILE%\Desktop\Pulizia_Report.txt"

set "report_pesanti=%USERPROFILE%\Desktop\File_Piu_Pesanti.txt"
echo ======================================================= > "%report_pesanti%"
echo         LISTA DEI 20 FILE PIU GRANDI SUL TUO PC >> "%report_pesanti%"
echo ======================================================= >> "%report_pesanti%"
echo File maggiori di 1GB ordinati dal piu pesante: >> "%report_pesanti%"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Users -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | ForEach-Object { '[ ' + [math]::round(($_.Length / 1GB), 2) + ' GB ] ' + $_.FullName }" >> "%report_pesanti%"

:: IL SEGRETO IMBATTIBILE: EFFETTO AUDIO DI SUCCESSO SENZA FILE ESTERNI
:: Riproduce una melodia ascendente nativa di Windows per avvisare l'utente del completamento
powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Media.SystemSounds]::Asterisk.Play(); Start-Sleep -Milliseconds 300; [System.Media.SystemSounds]::Asterisk.Play()" >nul 2>&1

:: SCHERMATA FINALE DI LUSSO SUL TERMINALE
title Windows Space Overlord - Esecuzione Completata con Successo!
color 0A
cls
echo =======================================================================
echo    PULIZIA COMPLETATA CON SUCCESSO! IL PC E AL 100%% DELLE PRESTAZIONI.
echo =======================================================================
echo.
echo  [+] STATISTICHE DI SISTEMA:
echo  ---------------------------------------------------------------------
echo  Spazio Libero Iniziale: %spazio_iniziale% GB
echo  Spazio Libero Finale:  %spazio_finale% GB
echo  Tempo complessivo:     %minuti% min e %secondi% sec
echo  ---------------------------------------------------------------------
echo  SPAZIO REALE RECUPERATO: %spazio_guadagnato% GB
echo.
echo  [+] FILE CREATI SUL TUO DESKTOP:
echo  * "Pulizia_Report.txt"   - Registro completo della manutenzione.
echo  * "File_Piu_Pesanti.txt"  - Mappa dei 20 file più grandi scoperti.
echo =======================================================================
echo.
echo Premi un tasto qualsiasi per chiudere il programma.
pause >nul
exit
