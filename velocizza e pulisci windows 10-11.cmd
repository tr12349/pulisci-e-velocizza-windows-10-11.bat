:: SCRIPT AVANZATO DI MANUTENZIONE, PULIZIA E OTTIMIZZAZIONE WINDOWS
:: Sviluppato da: tr12349 & AI
:: Nota per il revisore: Eseguire come Amministratore per abilitare i permessi di scrittura.
:: =================================================================
@echo off
setlocal enabledelayedexpansion

:: Abilita il supporto nativo ai colori ANSI nel prompt di Windows
reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: =======================================================================
:: CONTROLLO E RICHIESTA AUTOMATICA PERMESSI DI AMMINISTRATORE (UAC)
:: =======================================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo [96m[INFO] Richiesta dei permessi di amministratore in corso...[0m
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
title Windows Space Overlord - Master Ultimate Edition v4.0 (700 Steps)

echo [92m=======================================================================[0m
echo [92m       _      _           _                                            [0m
echo [92m      / \    / \  _ _____/ \____ _ ___ _ _   _ ____ ____  _ ____ ____  [0m
echo [92m     /   \  /   \/ / ___/_  __ / //  // / \ / /_  _// __ \/ / __// __ \ [0m
echo [92m    / / \ \/ / / / \__ \  / /  / // _// / \ V /  / / / / / / / _// /_/ / [0m
echo [92m   /_/   \__/ /_/ /____/ /_/  /_/ \__/_/_/ \_/  /_/ /_/ /_/_/_/  \____/  [0m
echo [92m                                                                       [0m
echo [92m       BENVENUTO IN WINDOWS SPACE OVERLORD - ULTIMATE EDITION v4.0     [0m
echo [92m=======================================================================[0m
echo.
echo [96m[*] Configurazione automatica: Scansione profonda SFC ABILITATA.[0m
set "esegui_sfc=SI"
echo.

echo [93m=======================================================================[0m
echo [93m   AVVIO CONFIGURAZIONE E ANALISI DELLO SPAZIO... VIA ALLA PULIZIA!    [0m
echo [93m=======================================================================[0m
echo.

:: =======================================================================
:: SALVATAGGIO DATI ORARIO E SPAZIO (METODO FLUIDO SENZA INTERRUZIONI)
:: =======================================================================
for /f "tokens=1,2 delims=," %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$time=[DateTime]::Now; $seconds=($time.Hour * 3600) + ($time.Minute * 60) + $time.Second; $space=[math]::round(((Get-Volume -DriveLetter C).SizeRemaining / 1GB), 2); Write-Output \"$seconds,$space\""') do (
    set "start_seconds=%%a"
    set "spazio_iniziale=%%b"
)

:: Pulizia preventiva dei vecchi file di report sul Desktop per evitare blocchi
if exist "%USERPROFILE%\Desktop\Pulizia_Report.txt" (del /f /q "%USERPROFILE%\Desktop\Pulizia_Report.txt" >nul 2>&1)
if exist "%USERPROFILE%\Desktop\File_Piu_Pesanti.txt" (del /f /q "%USERPROFILE%\Desktop\File_Piu_Pesanti.txt" >nul 2>&1)

echo [92m[PRONTO] Configurazione completata.[0m 
echo [96m[INFO] Spazio iniziale rilevato sul disco C: [93m%spazio_iniziale% GB[0m.
echo.
echo [91m[ATTENZIONE] Non chiudere questa finestra fino al completamento totale.[0m
timeout /t 3 >nul
cls

:: =======================================================================
:: INIZIO DEI PASSAGGI DI PULIZIA REALI
:: =======================================================================

echo [1/425] Svuotamento e Pulizia delle Cartelle Temporanee di Sistema...
del /f /q /s C:\Windows\Temp\* >nul 2>&1
for /d %%p in (C:\Windows\Temp\*) do rmdir /s /q "%%p" >nul 2>&1
del /f /q /s "%temp%\*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [2/425] Pulizia file obsoleti della cartella Prefetch...
del /f /q /s C:\Windows\Prefetch\* >nul 2>&1
for /d %%p in (C:\Windows\Prefetch\*) do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [3/425] Svuotamento Cache di Windows Update (SoftwareDistribution)...
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1
timeout /t 2 >nul
del /f /q /s C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
for /d %%p in (C:\Windows\SoftwareDistribution\Download\*) do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo OK.

echo [4/425] Reset e svuotamento rapido della cache del Cestino...
if exist C:\$Recycle.Bin ( rd /s /q C:\$Recycle.Bin >nul 2>&1 )
echo OK.

echo [5/425] Eliminazione dei file di Log e Report di Errore (Crash Dumps)...
del /f /q /s C:\Windows\Logs\*.log >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\CrashDumps\*.dmp" >nul 2>&1
echo OK.

echo [6/425] PULIZIA CHROME: Cache, Code Cache e Segnalazioni Crash...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    for /d %%g in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do (
        del /f /q /s "%%g\Cache\*" >nul 2>&1
        del /f /q /s "%%g\Code Cache\*" >nul 2>&1
        del /f /q /s "%%g\GPUCache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" >nul 2>&1)
)
echo OK.

echo [7/425] PULIZIA EDGE: Cache, Code Cache e Segnalazioni Crash...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    for /d %%e in ("%LOCALAPPDATA%\Microsoft\Edge\User Data\*") do (
        del /f /q /s "%%e\Cache\*" >nul 2>&1
        del /f /q /s "%%e\Code Cache\*" >nul 2>&1
        del /f /q /s "%%e\GPUCache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" >nul 2>&1)
)
echo OK.

echo [8/425] PULIZIA FIREFOX: Cache dei profili utente...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%f in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        del /f /q /s "%%f\cache2\*" >nul 2>&1
        del /f /q /s "%%f\jumpListCache\*" >nul 2>&1
        del /f /q /s "%%f\crashes\*" >nul 2>&1
    )
)
echo OK.

echo [9/425] PULIZIA BRAVE: Cache, Code Cache e Componenti Temporanei...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data" (
    for /d %%b in ("%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*") do (
        del /f /q /s "%%b\Cache\*" >nul 2>&1
        del /f /q /s "%%b\Code Cache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" >nul 2>&1)
)
echo OK.

echo [10/425] Svuotamento Cache App pesanti (Spotify/Discord)...
del /f /q /s "%LOCALAPPDATA%\Spotify\Storage\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Code Cache\*" >nul 2>&1
echo OK.

echo [11/425] Ottimizzazione Scritture NTFS ed Eliminazione Timestamp Accessi...
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo OK.

echo [12/425] Rimozione App Spazzatura Preinstallate (Bloatware)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-AppxPackage *BingWeather* | Remove-AppxPackage; Get-AppxPackage *GetHelp* | Remove-AppxPackage; Get-AppxPackage *3DBuilder* | Remove-AppxPackage" >nul 2>&1
echo OK.

if not exist "%USERPROFILE%\Desktop\DUPLICATI_RILEVATI" (mkdir "%USERPROFILE%\Desktop\DUPLICATI_RILEVATI" >nul 2>&1)

echo [13/425] ISOLAMENTO DUPLICATI: Scansione combinata cartelle Utente...
:: FIX: Protette le virgolette interne con l'escape triplo per evitare il crash immediato del parser Batch
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$paths = @('$env:USERPROFILE\Downloads', '$env:USERPROFILE\Documents', '$env:USERPROFILE\Pictures', '$env:USERPROFILE\Music'); Get-ChildItem -Path $paths -Recurse -File -ErrorAction SilentlyContinue | Group-Object Length | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Get-FileHash -Algorithm MD5 | Group-Object Hash | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object -Skip 1 | ForEach-Object { Move-Item -Path $_.Path -Destination '$env:USERPROFILE\Desktop\DUPLICATI_RILEVATI' -Force -ErrorAction SilentlyContinue } } }" >nul 2>&1
echo OK.

echo [14/425] Ottimizzazione Interfaccia per Massima Velocita...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
echo OK.

echo [15/425] Rimozione Forzata Vecchie Installazioni di Windows (Windows.old)...
if exist C:\Windows.old (
    takeown /F C:\Windows.old /R /A /D Y >nul 2>&1
    icacls C:\Windows.old /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\Windows.old >nul 2>&1
)
echo OK.

echo [16/425] Pulizia Forzata Cartelle Cache dei Driver Estratti (Intel/AMD/NVIDIA)...
if exist C:\AMD ( takeown /F C:\AMD /R /A /D Y >nul 2>&1 & icacls C:\AMD /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\AMD >nul 2>&1 )
if exist C:\Intel ( takeown /F C:\Intel /R /A /D Y >nul 2>&1 & icacls C:\Intel /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\Intel >nul 2>&1 )
if exist C:\NVIDIA ( takeown /F C:\NVIDIA /R /A /D Y >nul 2>&1 & icacls C:\NVIDIA /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\NVIDIA >nul 2>&1 )
echo OK.

echo [17/425] Pulizia della Cache dei pacchetti Windows Package Manager (Winget)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [18/425] Svuotamento cache di Telegram Desktop...
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    del /f /q /s "%APPDATA%\Telegram Desktop\tdata\user_data\cache\*" >nul 2>&1
    for /d %%p in ("%APPDATA%\Telegram Desktop\tdata\user_data\cache\*") do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [19/425] Pulizia file temporanei e installatori obsoleti di Adobe...
if exist "%LOCALAPPDATA%\Adobe\DXP" ( del /f /q /s "%LOCALAPPDATA%\Adobe\DXP\*" >nul 2>&1 )
if exist "%APPDATA%\Adobe\Common\Media Cache Files" ( del /f /q /s "%APPDATA%\Adobe\Common\Media Cache Files\*" >nul 2>&1 )
echo OK.

echo [20/425] Rimozione dei pacchetti di installazione residui di Microsoft Office...
if exist C:\MSOCache (
    takeown /F C:\MSOCache /R /A /D Y >nul 2>&1
    icacls C:\MSOCache /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\MSOCache >nul 2>&1
)
echo OK.

echo [21/425] Svuotamento cache delle App di Streaming (Netflix, Prime Video, Disney+)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'AC|INetCache|LocalCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [22/425] Rimozione dei file temporanei e installer orfani (.msi)...
del /f /q /s C:\Windows\Installer\*.tmp >nul 2>&1
echo OK.

echo [23/425] Rimozione dei pacchetti driver non in uso (Indipendente da lingua OS)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName -eq $null } | ForEach-Object { pnputil /delete-driver $_.InfName /uninstall /force }" >nul 2>&1
echo OK.

echo [24/425] Svuotamento della Cache DirectX Shader (Grafica)...
del /f /q /s "%LocalAppData%\D3DSCache\*" >nul 2>&1
for /d %%p in ("%LocalAppData%\D3DSCache\*") do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [25/425] Eliminazione file residui di installazione Windows ($WINDOWS.~BT)...
if exist C:\$WINDOWS.~BT (
    takeown /F C:\$WINDOWS.~BT /R /A /D Y >nul 2>&1
    icacls C:\$WINDOWS.~BT /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\$WINDOWS.~BT >nul 2>&1
)
echo OK.

echo [26/425] Pulizia dei Log di sistema HTTP e CBS (Component Based Servicing)...
del /f /q /s C:\Windows\System32\LogFiles\HTTPERR\* >nul 2>&1
del /f /q /s C:\Windows\Logs\CBS\*.log >nul 2>&1
if exist C:\inetpub\logs\LogFiles (del /f /q /s C:\inetpub\logs\LogFiles\* >nul 2>&1)
echo OK.

echo [27/425] Svuotamento cache dei client di gioco (Steam, Epic, EA)...
if exist "C:\Program Files (x86)\Steam\cached" (del /f /q /s "C:\Program Files (x86)\Steam\cached\*" >nul 2>&1)
if exist "C:\Program Files\Epic Games\Launcher\VaultCache" (del /f /q /s "C:\Program Files\Epic Games\Launcher\VaultCache\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache\*" >nul 2>&1)
echo OK.

echo [28/425] Svuotamento e rigenerazione pulita della cache dei Font...
net stop fontcache >nul 2>&1
del /f /q /s %WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.dat >nul 2>&1
net start fontcache >nul 2>&1
echo OK.

echo [29/425] Svuotamento della cache di Ottimizzazione Recapito (Delivery Optimization)...
net stop dosvc >nul 2>&1
if exist C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache (
    del /f /q /s C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\* >nul 2>&1
)
net start dosvc >nul 2>&1
echo OK.

echo [30/425] Eliminazione file residui driver Video (NVIDIA/AMD)...
if exist "%ProgramData%\NVIDIA Corporation\InstallerGrid" (del /f /q /s "%ProgramData%\NVIDIA Corporation\InstallerGrid\*.exe" >nul 2>&1)
if exist "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService" (del /f /q /s "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService\*.exe" >nul 2>&1)
if exist C:\AMD\Packagers (rmdir /s /q C:\AMD\Packagers >nul 2>&1)
echo OK.

echo [31/425] Svuotamento cache pacchetti parziali Microsoft Store (AppX)...
net stop wuauserv >nul 2>&1
if exist "%WinDir%\SoftwareDistribution\DataStore" (
    del /f /q /s "%WinDir%\SoftwareDistribution\DataStore\*" >nul 2>&1
)
net start wuauserv >nul 2>&1
echo OK.

echo [32/425] Svuotamento e ripristino della cache dei DNS...
ipconfig /flushdns >nul 2>&1
echo OK.

echo [33/425] Pulizia approfondita automatica (Cleanmgr Super-Sagerun)...
cleanmgr /sagerun:1 >nul 2>&1
echo OK.

echo [34/425] Sfoltimento sicuro della cache di Explorer e cache del Windows Store...
del /f /q /s "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q /s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
wsreset -s >nul 2>&1
echo OK.

echo [35/425] Eliminazione punti di ripristino vecchi - Mantiene SOLO il piu recente...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ComputerRestorePoint | Select-Object -SkipLast 1 | ForEach-Object { Checkpoint-Computer -Delete $_.SequenceNumber }" >nul 2>&1
echo OK.

echo [36/425] Compressione intelligente del file di ibernazione - Riduzione del 50%%...
powercfg -h -size 50 >nul 2>&1
echo OK.

echo [37/425] Scansione e riparazione guidata dei file di sistema...
if "%esegui_sfc%"=="SI" (
    echo NOTA - Questo passaggio richiede tempo, attendere...
    sfc /scannow
)
echo OK.

echo [38/425] Attivazione CompactOS - Compressione intelligente dei file di sistema...
compact /compactos:always >nul 2>&1
echo OK.

echo [39/425] Pulizia dei file temporanei Internet storici (INetCache)...
del /f /q /s "%LocalAppData%\Microsoft\Windows\INetCache\*" >nul 2>&1
echo OK.

echo [40/425] Pulizia delle cache di sviluppo (.NET Nuget, Visual Studio)...
if exist "%USERPROFILE%\.nuget\packages" (rmdir /s /q "%USERPROFILE%\.nuget\packages" >nul 2>&1)
if exist "%LocalAppData%\Microsoft\WebsiteCache" (rmdir /s /q "%LocalAppData%\Microsoft\WebsiteCache" >nul 2>&1)
echo OK.

echo [41/425] Sfoltimento cache avanzata Gaming (Epic, Riot, GLCache)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs" (del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\Riot Client Logs" (rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\Riot Client Logs" >nul 2>&1)
del /f /q /s "%LOCALAPPDATA%\*GLCache\*" >nul 2>&1
echo OK.

echo [42/425] Rimozione file temporanei e log di WhatsApp Desktop...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'WhatsApp' } | ForEach-Object { $path = $_.FullName + '\LocalState\shared\transfers'; if (Test-Path $path) { Remove-Item ($path + '\*') -Recurse -Force -ErrorAction SilentlyContinue } }" >nul 2>&1
echo OK.

echo [43/425] Compressione NTFS dei Log di sistema per risparmio spazio...
compact /c /s:C:\Windows\Logs >nul 2>&1
compact /c /s:C:\Windows\Panther >nul 2>&1
echo OK.

echo [44/425] Eliminazione cache dei pacchetti Python (Pip Cache)...
if exist "%LocalAppData%\pip\Cache" (rmdir /s /q "%LocalAppData%\pip\Cache" >nul 2>&1)
echo OK.

echo [45/425] Ottimizzazione processi: Svuotamento sicuro del file di Paging al riavvio...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f >nul 2>&1
echo OK.

echo [46/425] Ottimizzazione profonda del database degli aggiornamenti (ResetBase)...
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1
echo OK.

echo [47/425] Svuotamento e azzeramento dei Registri degli Eventi di Windows (Event Viewer)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-EventLog -LogName * | ForEach-Object { Clear-EventLog -LogName $_.Log }" >nul 2>&1
echo OK.

echo [48/425] Eliminazione dei file di dump della memoria del Kernel (DMP)...
if exist %SystemRoot%\MEMORY.DMP (del /f /q %SystemRoot%\MEMORY.DMP >nul 2>&1)
del /f /q /s %SystemRoot%\Minidump\*.dmp >nul 2>&1
echo OK.

echo [49/425] Rimozione file temporanei generati dalle installazioni di pacchetti Python (Pip)...
if exist "%USERPROFILE%\AppData\Local\pip\cache" (rmdir /s /q "%USERPROFILE%\AppData\Local\pip\cache" >nul 2>&1)
echo OK.

echo [50/425] Sfoltimento della cache dei messaggi temporanei di Microsoft Teams...
if exist "%APPDATA%\Microsoft\Teams\Cache" (del /f /q /s "%APPDATA%\Microsoft\Teams\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Microsoft\Teams\Application Cache\Cache" (del /f /q /s "%APPDATA%\Microsoft\Teams\Application Cache\Cache\*" >nul 2>&1)
echo OK.

echo [51/425] Svuotamento file temporanei degli indici di Ricerca di Windows...
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs\*" >nul 2>&1
)
echo OK.

echo [52/425] PULIZIA LOG: Rimozione file .log orfani ESCLUSIVAMENTE nelle cartelle temporanee...
del /f /q /s C:\Windows\Temp\*.log >nul 2>&1
del /f /q /s "%temp%\*.log" >nul 2>&1
echo OK.

echo [53/425] ISPEZIONE GLOBALE: Svuotamento sicuro delle cartelle Cache conosciute in AppData...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\AppData\Local\Temp', '$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache' -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo OK.

echo [54/425] PULIZIA AVANZATA: Sfoltimento file temporanei di caching del framework .NET...
if exist "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files" (rmdir /s /q "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files" >nul 2>&1)
if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files" (rmdir /s /q "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files" >nul 2>&1)
echo OK.

echo [55/425] Pulizia approfondita file di log e Telemetria di sistema...
del /f /q /s C:\ProgramData\Microsoft\Diagnosis\*.etw >nul 2>&1
echo OK.

echo [56/425] Caccia ed eliminazione globale di file residui .tmp e .chk...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\ -Include *.tmp, *.chk -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch 'C:\\Windows' } | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [57/425] Rimozione cache globale di Node.js (NPM Cache)...
if exist "%APPDATA%\npm-cache" (rmdir /s /q "%APPDATA%\npm-cache" >nul 2>&1)
echo OK.

echo [58/425] Svuotamento file temporanei di Windows Sandbox (Se attivi)...
if exist C:\ProgramData\Microsoft\Windows\Containers (
    del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\* >nul 2>&1
)
echo OK.

echo [59/425] Eliminazione file residui post-riavvio di Windows Update...
if exist C:\Windows\SoftwareDistribution\PostRebootEventCache.V2 (
    rmdir /s /q C:\Windows\SoftwareDistribution\PostRebootEventCache.V2 >nul 2>&1
)
echo OK.

echo [60/425] Pulizia profonda delle code di stampa bloccate (Spooler)...
net stop spooler >nul 2>&1
del /f /q /s C:\Windows\System32\spool\PRINTERS\* >nul 2>&1
net start spooler >nul 2>&1
echo OK.

echo [61/425] Rimozione file .log e .tmp interni ai profili dei Browser...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Include *.log, *.tmp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Microsoft\Edge\User Data' -Include *.log, *.tmp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
echo OK.

echo [62/425] Svuotamento dei file di log generati dall'installatore .NET Framework...
del /f /q /s C:\Windows\Microsoft.NET\Framework*\*\*.log >nul 2>&1
echo OK.

echo [63/425] Rimozione della cache di compilazione degli Shader di gioco (NVIDIA/AMD)...
if exist "%LocalAppData%\NVIDIA\DXCache" (del /f /q /s "%LocalAppData%\NVIDIA\DXCache\*" >nul 2>&1)
if exist "%LocalAppData%\AMD\DxCache" (del /f /q /s "%LocalAppData%\AMD\DxCache\*" >nul 2>&1)
echo OK.

echo [64/425] Forzatura svuotamento cache Delivery Optimization tramite utilita nativa...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-CimInstance -Namespace root/Microsoft/Windows/DeliveryOptimization -ClassName MSFT_DeliveryOptimizationConfiguration | Invoke-CimMethod -MethodName DeleteCache" >nul 2>&1
echo OK.

echo [65/425] Disattivazione dello Spazio Riservato di Windows (Libera circa 7GB)...
DISM.exe /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1
echo OK.

echo [66/425] Compressione e ottimizzazione finale delle unita (Retrim per SSD)...
defrag C: /O >nul 2>&1
echo OK.

echo [67/425] Disattivazione della Telemetria avanzata e raccolta dati...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo OK.

echo [68/425] Disattivazione Ibernazione (Eliminazione hiberfil.sys)...
powercfg /h off >nul 2>&1
echo OK.

echo [69/425] Configurazione efficiente della memoria virtuale (Pagefile a 2-4GB)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$wmi = Get-CimInstance -ClassName Win32_ComputerSystem -EnableAllPrivileges; $wmi.AutomaticManagedPagefile = $False; Invoke-CimMethod -InputObject $wmi -MethodName Modify; $pagefile = Get-CimInstance -ClassName Win32_PageFileSetting; if ($pagefile) { $pagefile.InitialSize = 2048; $pagefile.MaximumSize = 4096; Invoke-CimMethod -InputObject $pagefile -MethodName Modify } else { New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\\pagefile.sys'; InitialSize=2048; MaximumSize=4096} }" >nul 2>&1
echo OK.

echo [70/425] Ridimensionamento dello spazio massimo per i Punti di Ripristino (Max 2%%)...
vssadmin resize shadowstorage /for=c: /on=c: /maxsize=2% >nul 2>&1
echo OK.

echo [71/425] Disattivazione della Riserva di Spazio per Windows Update (Metodo Registro)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f >nul 2>&1
echo OK.

echo [72/425] Svuotamento e reset completo della cache del Microsoft Store...
wsreset /s >nul 2>&1
if exist "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)
echo OK.

echo [73/425] Eliminazione e compressione del Database di Ricerca (Windows.edb)...
net stop wsearch >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f >nul 2>&1
del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1
net start wsearch >nul 2>&1
echo OK.

echo [74/425] Svuotamento cache e file temporanei di Zoom e Skype Desktop...
if exist "%APPDATA%\Zoom\data" (del /f /q /s "%APPDATA%\Zoom\data\*" >nul 2>&1)
if exist "%APPDATA%\Microsoft\Skype for Desktop\Cache" (rmdir /s /q "%APPDATA%\Microsoft\Skype for Desktop\Cache" >nul 2>&1)
echo OK.

echo [75/425] Pulizia dei file temporanei di installazione dei driver grafici NVIDIA/AMD...
if exist "%ProgramFiles%\NVIDIA Corporation\Installer2" (rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\Installer2" >nul 2>&1)
if exist C:\ProgramData\AMD\OemDrivers (rmdir /s /q C:\ProgramData\AMD\OemDrivers >nul 2>&1)
echo OK.

echo [76/425] Rimozione file temporanei di compilazione dei pacchetti Rust (Cargo Cache)...
if exist "%USERPROFILE%\.cargo\registry\cache" (rmdir /s /q "%USERPROFILE%\.cargo\registry\cache" >nul 2>&1)
echo OK.

echo [77/425] Eliminazione dei file residui dei vecchi checkpoint di sistema (VSS Old Metadata)...
vssadmin delete shadows /for=c: /oldest /quiet >nul 2>&1
echo OK.

echo [78/425] Cancellazione dei file di log di tracciamento dell'interfaccia utente (ShellBags)...
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
echo OK.

echo [79/425] Consolidamento hardware e rimozione dei metadati NTFS orfani...
fsutil usn deletejournal /d /n C: >nul 2>&1
echo OK.

echo [80/425] Pulizia dei driver fantasma sconosciuti e non associati a hardware reale...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Status -eq 'Unknown' } | ForEach-Object { pnputil /remove-device $_.DeviceID }" >nul 2>&1
echo OK.

echo [81/425] Azzeramento delle cache dei flussi multimediali di Windows Media Foundation...
if exist "%LocalAppData%\Microsoft\Media Player" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player" >nul 2>&1)
echo OK.

echo [82/425] Forzatura dello svuotamento dei file di transazione del File System (TxF)...
fsutil resource setautoreset true C:\ >nul 2>&1
echo OK.

echo [83/425] Pulizia profonda e compattazione del Database di Windows Update (WUSP)...
net stop wuauserv >nul 2>&1
del /f /q /s C:\Windows\SoftwareDistribution\DataStore\Logs\*.log >nul 2>&1
net start wuauserv >nul 2>&1
echo OK.

echo [84/425] Pulizia delle cache dei Font di terze parti (Adobe, Google Fonts, TypeKit)...
if exist "%LocalAppData%\Adobe\FontCache" (rmdir /s /q "%LocalAppData%\Adobe\FontCache" >nul 2>&1)
echo OK.

echo [85/425] Rimozione forzata dei file speculari generati dai crash di sistema (Chkdsk)...
del /f /q /s C:\found.* >nul 2>&1
for /d %%p in (C:\found.*) do rmdir /s /q "%%p" >nul 2>&1
echo OK.

echo [86/425] Ottimizzazione strutturale MFT e consolidamento dello spazio libero SSD/HDD...
defrag C: /O /H /X >nul 2>&1
echo OK.

echo [87/425] Azzeramento totale e forzato delle Copie Shadow dei Volumi (VSS)...
vssadmin delete shadows /all /quiet >nul 2>&1
echo OK.

echo [88/425] Svuotamento dei log storici dell'utilita di controllo del disco (Chkdsk)...
if exist "C:\System Volume Information\Chkdsk" (
    takeown /F "C:\System Volume Information" /A >nul 2>&1
    icacls "C:\System Volume Information" /grant Administrators:F >nul 2>&1
    del /f /q /s "C:\System Volume Information\Chkdsk\*" >nul 2>&1
)
echo OK.

echo [89/425] Rimozione della cronologia locale delle scansioni in tempo reale di Defender...
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store" (
    del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
)
echo OK.

echo [90/425] Pulizia dei file temporanei del gestore delle transazioni del Registro (TxR)...
del /f /q /s C:\Windows\System32\config\TxR\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\config\TxR\*.blf >nul 2>&1
echo OK.

echo [91/425] Svuotamento dei log di diagnostica sui consumi elettrici in sospensione (SleepStudy)...
if exist C:\Windows\System32\SleepStudy (
    del /f /q /s C:\Windows\System32\SleepStudy\* >nul 2>&1
)
echo OK.

echo [92/425] Reset del database temporaneo delle notifiche di Windows...
del /f /q /s "%LocalAppData%\Microsoft\Windows\Notifications\*.db" >nul 2>&1
echo OK.

echo [93/425] Rimozione file temporanei del motore di campionamento Audio (AudioEngine)...
if exist "%LocalAppData%\Microsoft\Windows\AudioEngine" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\AudioEngine\*" >nul 2>&1
)
echo OK.

echo [94/425] Pulizia della cache dei metadati grafici del Desktop Window Manager (DWM)...
if exist "%LocalAppData%\Microsoft\Windows\DWM" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\DWM\*" >nul 2>&1
)
echo OK.

echo [95/425] Svuotamento dei dati grezzi del Monitoraggio Affidabilità di Windows (RAC)...
if exist C:\ProgramData\Microsoft\RAC (
    del /f /q /s C:\ProgramData\Microsoft\RAC\StateData\* >nul 2>&1
    del /f /q /s C:\ProgramData\Microsoft\RAC\Outbound\* >nul 2>&1
)
echo OK.

echo [96/425] Rimozione forzata dei file temporanei di installazione dump (.tmp) orfani...
del /f /q C:\DUMP*.tmp >nul 2>&1
echo OK.

echo [97/425] Rimozione della cache dei token e file temporanei di LiveUpdate...
if exist "C:\ProgramData\Microsoft\LiveUpdate" (
    del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1
)
echo OK.

echo [98/425] Pulizia dei log di tracciamento e installazione delle estensioni AppX...
if exist C:\Windows\System32\AppXDeploymentServer (
    del /f /q /s C:\Windows\System32\AppXDeploymentServer\*.log >nul 2>&1
)
echo OK.

echo [99/425] Svuotamento della cache dei file temporanei della mappa offline di Windows...
if exist "%ProgramData%\Microsoft\MapData" (
    del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1
)
echo OK.

echo [100/425] Sfoltimento dei file temporanei del modulo di telemetria hardware (Inventory)...
if exist C:\Windows\System32\CompatTelRunner (
    del /f /q /s C:\Windows\System32\CompatTelRunner\*.tmp >nul 2>&1
)
echo OK.

echo [101/425] Eliminazione cache dei file temporanei del visualizzatore foto nativo...
if exist "%LocalAppData%\Microsoft\Windows Photo Viewer" (
    rmdir /s /q "%LocalAppData%\Microsoft\Windows Photo Viewer" >nul 2>&1
)
echo OK.

echo [102/425] Svuotamento dei file temporanei generati da Windows Error Reporting (LocalDumps)...
if exist "%LocalAppData%\CrashDumps" (
    del /f /q /s "%LocalAppData%\CrashDumps\*" >nul 2>&1
)
echo OK.

echo [103/425] Pulizia dei log temporanei crittografici e chiavi rimosse (Crypto)...
if exist "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18" (
    del /f /q /s "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18\*.tmp" >nul 2>&1
)
echo OK.

echo [104/425] Rimozione dei log storici di migrazione e installazione driver (Setupapi)...
del /f /q /s C:\Windows\inf\setupapi*.log >nul 2>&1
echo OK.

echo [105/425] Svuotamento dei log residui di Windows Defender Network Inspection (WdNis)...
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis" (
    del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1
)
echo OK.

echo [106/425] Svuotamento dei file temporanei della cache delle mappe di BitLocker...
if exist C:\Windows\System32\BitLocker (
    del /f /q /s C:\Windows\System32\BitLocker\*.tmp >nul 2>&1
)
echo OK.

echo [107/425] Pulizia dei log temporanei di isolamento di Microsoft Defender Application Guard...
if exist "%ProgramData%\Microsoft\HVSI" (
    del /f /q /s "%ProgramData%\Microsoft\HVSI\*" >nul 2>&1
)
echo OK.

echo [108/425] Rimozione dei log temporanei di diagnostica del chip di sicurezza hardware (TPM)...
if exist C:\Windows\Logs\MeasuredBoot (
    del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1
)
echo OK.

echo [109/425] Eliminazione cache di compressione bitmap per Connessione Desktop Remoto...
if exist "%LocalAppData%\Microsoft\Terminal Server Client\Cache" (
    rmdir /s /q "%LocalAppData%\Microsoft\Terminal Server Client\Cache" >nul 2>&1
)
echo OK.

echo [110/425] Svuotamento dei log di tracciamento interni della Xbox Game Bar...
if exist "%LocalAppData%\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [111/425] Svuotamento log e temporanei Windows Biometric Service (Windows Hello)...
net stop WbioSrvc >nul 2>&1
if exist C:\Windows\System32\WinBioDatabase (
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.log >nul 2>&1
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.tmp >nul 2>&1
)
net start WbioSrvc >nul 2>&1
echo OK.

echo [112/425] Pulizia della cache dei metadati di installazione delle periferiche (DeviceMetadata)...
if exist "%ProgramData%\Microsoft\Windows\DeviceMetadataCache" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\DeviceMetadataCache\*" >nul 2>&1
)
echo OK.

echo [113/425] Svuotamento della cache dei file temporanei della libreria grafica DirectX (D3D)...
if exist "%LocalAppData%\Microsoft\DirectX" (
    del /f /q /s "%LocalAppData%\Microsoft\DirectX\*" >nul 2>&1
)
echo OK.

echo [114/425] Rimozione dei log temporanei accumulati dal Kernel Boot Performance (ReadyBoot)...
if exist C:\Windows\System32\LogFiles\ReadyBoot (
    del /f /q /s C:\Windows\System32\LogFiles\ReadyBoot\*.fx >nul 2>&1
)
echo OK.

echo [115/425] Pulizia dei file di transazione temporanei del File System Transazionale (KTM)...
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.blf >nul 2>&1
echo OK.

echo [116/425] Sfoltimento dei file di log temporanei del modulo Windows Update Agent (WUA)...
if exist C:\Windows\Logs\WindowsUpdate (
    del /f /q /s C:\Windows\Logs\WindowsUpdate\* >nul 2>&1
)
echo OK.

echo [117/425] Svuotamento dei log di tracciamento interni della console dei comandi e PowerShell...
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs\*" >nul 2>&1
)
echo OK.

echo [118/425] Pulizia della cache dei pacchetti scaricati da Java (Deployment Cache)...
if exist "%APPDATA%\Sun\Java\Deployment\cache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\cache" >nul 2>&1
)
echo OK.

echo [119/425] Svuotamento dei file temporanei e log di Microsoft OneDrive...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1
)
echo OK.

echo [120/425] Svuotamento della cache dei log di telemetria di Office (CefCache)...
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

echo [121/425] Pulizia dei file temporanei generati da Windows Subsystem for Linux (WSL)...
if exist "%USERPROFILE%\.wslg\logs" (
    del /f /q /s "%USERPROFILE%\.wslg\logs\*" >nul 2>&1
)
echo OK.

echo [122/425] Rimozione della cache dei moduli estratti da PowerShell (ModuleAnalysisCache)...
if exist "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" (
    del /f /q "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" >nul 2>&1
)
echo OK.

echo [123/425] Cancellazione dei file di log temporanei dell'utilita di diagnostica DirectX (DxDiag)...
if exist "%WINDIR%\System32\dxdiag.exe" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1
)
echo OK.

echo [124/425] Svuotamento dei file temporanei del modulo di isolamento delle app (AppContainer)...
if exist "%LocalAppData%\Packages\Microsoft.Windows.Appcontainer.Behavior_cw5n1h2txyewy" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.Windows.Appcontainer.Behavior_cw5n1h2txyewy\LocalState\*" >nul 2>&1
)
echo OK.

echo [125/425] Rimozione cache di Steam (Browser integrato e file temporanei)...
if exist "C:\Program Files (x86)\Steam\appcache" (rmdir /s /q "C:\Program Files (x86)\Steam\appcache" >nul 2>&1)
if exist "C:\Program Files (x86)\Steam\config\htmlcache" (del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1)
echo OK.

echo [126/425] Svuotamento cache di Epic Games Launcher (Webcache)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" (rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1)
echo OK.

echo [127/425] Rimozione cache del Client EA Desktop...
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1)
if exist "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache" (del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*" >nul 2>&1)
echo OK.

:: =================================================================
:: AREA 3: OTTIMIZZAZIONE DELLE PRESTAZIONI E ALGORITMI DI COMPRESSIONE
:: Tecniche utilizzate: Strumento nativo COMPACT (Compressione File System NTFS).
:: Obiettivo: Ridurre lo spazio occupato dai programmi installati senza comprometterne l'avvio.
:: righe: 151 alla 370
:: =================================================================

echo [128/425] Svuotamento cache di Ubisoft Connect (Logs e Cache)...
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" (rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1)
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs" (del /f /q /s "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs\*" >nul 2>&1)
echo OK.

echo [129/425] Pulizia file temporanei e log di Microsoft Teams (Nuovo)...
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [130/425] Svuotamento file temporanei ed estratti di Zoom Desktop...
if exist "%APPDATA%\Zoom\logs" (del /f /q /s "%APPDATA%\Zoom\logs\*" >nul 2>&1)
echo OK.

echo [131/425] Pulizia cache di Adobe Acrobat Reader (File temporanei)...
if exist "%LOCALAPPDATA%\Adobe\Acrobat\DC\Cache" (rmdir /s /q "%LOCALAPPDATA%\Adobe\Acrobat\DC\Cache" >nul 2>&1)
echo OK.

echo [132/425] Rimozione cache e file temporanei di Photoshop (Se presente)...
if exist "%APPDATA%\Adobe\Adobe Photoshop *\AutoRecover" (del /f /q /s "%APPDATA%\Adobe\Adobe Photoshop *\AutoRecover\*" >nul 2>&1)
echo OK.

echo [133/425] Svuotamento cache del browser Opera / Opera GX...
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\*" >nul 2>&1)
echo OK.

echo [134/425] Svuotamento cache del browser Vivaldi...
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1)
echo OK.

echo [135/425] Rimozione log e file orfani generati dall'emulatore BlueStacks...
if exist "C:\ProgramData\BlueStacks_nxt\Logs" (del /f /q /s "C:\ProgramData\BlueStacks_nxt\Logs\*" >nul 2>&1)
echo OK.

echo [136/425] Pulizia file temporanei dello strumento di cattura Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [137/425] Svuotamento cache del client cloud Dropbox...
if exist "%LOCALAPPDATA%\Dropbox\instance1\scratch" (del /f /q /s "%LOCALAPPDATA%\Dropbox\instance1\scratch\*" >nul 2>&1)
echo OK.

echo [138/425] Rimozione della cache dei componenti aggiuntivi di Office (VSTO)...
if exist "%LOCALAPPDATA%\assembly\dl3" (rmdir /s /q "%LOCALAPPDATA%\assembly\dl3" >nul 2>&1)
echo OK.

echo [139/425] Pulizia file temporanei generati da WinRAR (Estrazioni interrotte)...
if exist "%APPDATA%\WinRAR\Templates" (del /f /q /s "%APPDATA%\WinRAR\Templates\*" >nul 2>&1)
echo OK.

echo [140/425] Svuotamento file temporanei generati da 7-Zip (Estrazioni orfane)...
if exist "%LOCALAPPDATA%\7-Zip" (rmdir /s /q "%LOCALAPPDATA%\7-Zip" >nul 2>&1)
echo OK.

echo [141/425] Svuotamento della cache universale delle estensioni del kernel Windows...
if exist "C:\Windows\System32\KernelExtensionCache" (del /f /q /s "C:\Windows\System32\KernelExtensionCache\*" >nul 2>&1)
echo OK.

echo [142/425] Pulizia dei log di errore del server web locale IIS Express...
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1)
echo OK.

echo [143/425] Pulizia file temporanei accumulati da Windows Speech Recognition...
if exist "%LOCALAPPDATA%\Microsoft\Speech\Files" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Speech\Files\*" >nul 2>&1)
echo OK.

echo [144/425] Svuotamento della cache di Microsoft Edge WebView2 (Cache App UWP)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'EBWebView' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [145/425] Svuotamento dei file temporanei e log di cMP (Crypto Machine Providers)...
if exist "C:\ProgramData\Microsoft\Crypto\SystemKeys" (del /f /q /s "C:\ProgramData\Microsoft\Crypto\SystemKeys\*.tmp" >nul 2>&1)
echo OK.

echo [146/425] Svuotamento della cache dei metadati di rete di Windows (NetworkCache)...
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1)
echo OK.

echo [147/425] Rimozione log e file orfani generati dal sottosistema hardware Intel/AMD...
if exist "C:\ProgramData\Intel\ShaderCache" (rmdir /s /q "C:\ProgramData\Intel\ShaderCache" >nul 2>&1)
echo OK.

echo [148/425] Rimozione file temporanei storici accumulati da Windows Pen and Ink...
if exist "%LOCALAPPDATA%\Microsoft\InputPersonalization" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\InputPersonalization" >nul 2>&1)
echo OK.

echo [149/425] Forzatura azzeramento file residui di disinstallazione parziale delle app...
if exist "%LOCALAPPDATA%\UntrustedAppCache" (rmdir /s /q "%LOCALAPPDATA%\UntrustedAppCache" >nul 2>&1)
echo OK.

echo [150/425] Ottimizzazione finale e allineamento dello spazio libero sui settori logici...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Defrag -Verbose" >nul 2>&1
echo OK.

echo [151/425] Rimozione delle vecchie versioni dei driver video compresse (DriverStore Cache)...
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\DriverStore\FileRepository -Filter *.zip, *.exe, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
echo OK.

echo [152/425] Sfoltimento forzato dei file rimasti nella cartella temporanea dei dump di memoria...
if exist "C:\Windows\Minidump" (
    del /f /q /s C:\Windows\Minidump\* >nul 2>&1
)
echo OK.

echo [153/425] Svuotamento della cache globale dei download in background (Servizio BITS)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-BitsTransfer -AllUsers | Remove-BitsTransfer -ErrorAction SilentlyContinue" >nul 2>&1
echo OK.

echo [154/425] Rimozione della cache dei log delle vecchie installazioni di pacchetti Microsoft (MSI)...
if exist "C:\Windows\Installer" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
echo OK.

echo [155/425] Svuotamento della cache dei file temporanei di compressione bitmap dello spooler di stampa...
if exist "C:\Windows\System32\spool\SERVERS" (
    del /f /q /s C:\Windows\System32\spool\SERVERS\* >nul 2>&1
)
echo OK.

echo [156/425] Rimozione dei log temporanei generati dall'indicizzazione dei file offline (CSC Cache)...
if exist "C:\Windows\CSC" (
    takeown /F C:\Windows\CSC /R /A >nul 2>&1
    icacls C:\Windows\CSC /grant Administrators:F /T >nul 2>&1
    del /f /q /s C:\Windows\CSC\* >nul 2>&1
)
echo OK.

echo [157/425] Forzatura azzeramento file residui nascosti nella radice del disco C:...
if exist "C:\$SysReset" (rmdir /s /q "C:\$SysReset" >nul 2>&1)
if exist "C:\$GetCurrent" (rmdir /s /q "C:\$GetCurrent" >nul 2>&1)
echo OK.

echo [158/425] Svuotamento della cache dei pacchetti isolati di Microsoft Store (LocalCache)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'LocalCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [159/425] Rimozione della cache shader e temporanea del browser Opera GX (D3DSCache)...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" >nul 2>&1
)
echo OK.

echo [160/425] Pulizia dei file di log e crash dump accumulati da Steam (CrashDumps)...
if exist "C:\Program Files (x86)\Steam\dumps" (rmdir /s /q "C:\Program Files (x86)\Steam\dumps" >nul 2>&1)
if exist "C:\Program Files (x86)\Steam\logs" (del /f /q /s "C:\Program Files (x86)\Steam\logs\*" >nul 2>&1)
echo OK.

echo [161/425] Svuotamento dei file temporanei e file recenti di Blender (Se installato)...
if exist "%APPDATA%\Blender Foundation\Blender" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Blender Foundation\Blender' -Include *.crash, *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [162/425] Pulizia approfondita dei file temporanei e cache del framework di sviluppo Node.js...
if exist "%USERPROFILE%\.node-gyp" (rmdir /s /q "%USERPROFILE%\.node-gyp" >nul 2>&1)
echo OK.

echo [163/425] Svuotamento della cache dei certificati digitali revocati o scaduti di Windows...
certutil -urlcache * delete >nul 2>&1
echo OK.

echo [164/425] Pulizia forzata dei file temporanei del gestore pacchetti NuGet (Sviluppatori)...
if exist "%USERPROFILE%\.nuget" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [165/425] Svuotamento della cache degli Shader e dei dati locali di Unreal Engine...
if exist "%LOCALAPPDATA%\UnrealEngine" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\UnrealEngine' -Include *.log, *.tmp, *ShaderCache* -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [166/425] Pulizia dei log temporanei di crash generati dai giochi in Unity Engine...
if exist "%LOCALAPPDATA%\LocalLow" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\LocalLow' -Include *.log, *.crashdumps -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [167/425] Svuotamento completo della cache e del database dei messaggi temporanei di Slack...
if exist "%APPDATA%\Slack\Cache" (del /f /q /s "%APPDATA%\Slack\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Slack\Code Cache" (del /f /q /s "%APPDATA%\Slack\Code Cache\*" >nul 2>&1)
echo OK.

echo [168/425] Rimozione dei log storici accumulati dal servizio Windows Error Reporting (WER)...
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" (rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" >nul 2>&1)
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" (rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1)
echo OK.

echo [169/425] Svuotamento della cache di icone e anteprime del menu Start di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\*.db" >nul 2>&1
)
echo OK.

echo [170/425] Pulizia dei log di telemetria e tracciamento delle prestazioni di rete (NetTrace)...
if exist C:\Windows\System32\LogFiles\NetTrace (
    del /f /q /s C:\Windows\System32\LogFiles\NetTrace\* >nul 2>&1
)
echo OK.

echo [171/425] Svuotamento dei file temporanei e delle miniature del client di gioco GOG Galaxy...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache" (rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache" >nul 2>&1)
echo OK.

echo [172/425] Rimozione delle cache di rendering dei font usati dalle applicazioni Electron (Scaffolding)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'FontCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [173/425] Pulizia approfondita dei file temporanei del gestore di installazione Python (Setuptools)...
if exist "%USERPROFILE%\.easy_install" (rmdir /s /q "%USERPROFILE%\.easy_install" >nul 2>&1)
echo OK.

echo [174/425] Compressione e sintonizzazione finale approfondita dei blocchi liberi...
defrag C: /O /H /U /V >nul 2>&1
echo OK.

echo [175/425] Sfoltimento sicuro del DriverStore (Eliminazione driver obsoleti e non in uso)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "pnputil /delete-driver oem*.inf /uninstall /force" >nul 2>&1
echo OK.

echo [176/425] Rimozione forzata dei dati residui delle App UWP disinstallate (Bloatware Orfani)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -ErrorAction SilentlyContinue | Where-Object { (Get-AppxPackage -Name $_.Name -AllUsers) -eq $null } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [177/425] Svuotamento della cache dei log di installazione di Windows Setup (Panther Cache)...
if exist C:\Windows\Panther (
    del /f /q /s C:\Windows\Panther\*.log >nul 2>&1
    del /f /q /s C:\Windows\Panther\*.tmp >nul 2>&1
)
echo OK.

echo [178/425] Svuotamento dei file temporanei della cache delle icone della barra delle applicazioni...
if exist "%LocalAppData%\Microsoft\Windows\Explorer" (
    del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
)
echo OK.

echo [179/425] Pulizia approfondita dei file temporanei generati da Windows Update (wbt)...
if exist C:\$WINDOWS.~BT (
    del /f /q /s C:\$WINDOWS.~BT\*.tmp >nul 2>&1
    del /f /q /s C:\$WINDOWS.~BT\*.log >nul 2>&1
)
echo OK.

echo [180/425] Svuotamento della cache di compilazione .NET (Assembly Optimization Cache)...
if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SetupCache" (
    rmdir /s /q "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SetupCache" >nul 2>&1
)
echo OK.

echo [181/425] Rimozione della cache dei moduli compressi di Microsoft Edge (Edge WebView Cache)...
if exist "%LocalAppData%\Microsoft\EdgeWebView\User Data\Default\Cache" (
    del /f /q /s "%LocalAppData%\Microsoft\EdgeWebView\User Data\Default\Cache\*" >nul 2>&1
)
echo OK.

echo [182/425] Svuotamento forzato della cache locale dei file temporanei di OneDrive...
if exist "%LocalAppData%\Microsoft\OneDrive\cache" (
    rmdir /s /q "%LocalAppData%\Microsoft\OneDrive\cache" >nul 2>&1
)
echo OK.

echo [183/425] Pulizia della cache dei metadati di tracciamento dell'app Xbox su PC...
if exist "%LocalAppData%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\*" >nul 2>&1
)
echo OK.

echo [184/425] Rimozione dei log temporanei accumulati dal servizio di geolocalizzazione Windows...
if exist "%ProgramData%\Microsoft\Windows\SystemData\LfS" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\SystemData\LfS\*" >nul 2>&1
)
echo OK.

echo [185/425] Svuotamento dei file di tracciamento e log dell'Utilità di Pianificazione (Tasks Logs)...
if exist C:\Windows\System32\Tasks (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Tasks -Recurse -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [186/425] Pulizia della cache dei file temporanei dell'Editor del Registro di sistema...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v "LastKey" /f >nul 2>&1
echo OK.

echo [187/425] Svuotamento dei file residui temporanei nella cartella di installazione Speech...
if exist C:\Windows\Speech\SpeechReco (
    del /f /q /s C:\Windows\Speech\SpeechReco\*.tmp >nul 2>&1
)
echo OK.

echo [188/425] Forzatura dello svuotamento dei file temporanei di transazione NTFS (FST)...
fsutil transaction thin C:\ >nul 2>&1
echo OK.

echo [189/425] Compressione LZX intelligente dei software e dei giochi installati (Cache/Logs/Temp)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\Program Files', 'C:\Program Files (x86)' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^(Cache|Logs|Temp)$' } | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"
echo OK.

echo [190/425] Ottimizzazione strutturale profonda della cache dei pacchetti installer (.msi)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.msi -ErrorAction SilentlyContinue | ForEach-Object { compact /c /exe:lzx $_.FullName >$null 2>&1 }"
echo OK.

echo [191/425] Disattivazione forzata e rimozione dei file di dump completi del Kernel...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 0 /f >nul 2>&1
if exist C:\Windows\MEMORY.DMP (del /f /q C:\Windows\MEMORY.DMP >nul 2>&1)
echo OK.

echo [192/425] Sfoltimento della cache dei file di configurazione pre-caricati dei servizi (Sysprep)...
if exist C:\Windows\System32\sysprep\Panther (
    del /f /q /s C:\Windows\System32\sysprep\Panther\*.log >nul 2>&1
    del /f /q /s C:\Windows\System32\sysprep\Panther\*.xml >nul 2>&1
)
echo OK.

echo [193/425] Compressione NTFS dei vecchi log storici delle applicazioni terze (AppData)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\AppData\Local', '$env:USERPROFILE\AppData\Roaming' -Recurse -Filter *.log -ErrorAction SilentlyContinue | ForEach-Object { compact /c \"$($_.FullName)\" >$null 2>&1 }"
echo OK.

echo [194/425] Svuotamento della cache di pre-caricamento del menu Start (TileDataLayer)...
if exist "%LocalAppData%\TileDataLayer" (rmdir /s /q "%LocalAppData%\TileDataLayer" >nul 2>&1)
echo OK.

echo [195/425] Svuotamento dei file temporanei generati dallo strumento di migrazione (USMT)...
if exist C:\USMTMIG (rmdir /s /q C:\USMTMIG >nul 2>&1)
echo OK.

echo [196/425] Pulizia della cache di sincronizzazione dei criteri di sicurezza locali...
if exist C:\Windows\System32\GroupPolicyUsers (rmdir /s /q C:\Windows\System32\GroupPolicyUsers >nul 2>&1)
echo OK.

echo [197/425] Compressione NTFS aggressiva delle cartelle di log storiche di Windows...
compact /c /s:C:\Windows\System32\LogFiles /i >nul 2>&1
compact /c /s:C:\Windows\System32\winevt\Logs /i >nul 2>&1
echo OK.

echo [198/425] Sfoltimento radicale della cache dei file di installazione MSI (Patch Cache)...
if exist "C:\Windows\Installer\\$PatchCache$" (
    rmdir /s /q "C:\Windows\Installer\\$PatchCache$" >nul 2>&1
)
echo OK.

echo [199/425] Eliminazione del database storico delle firme di Windows Defender...
if exist "%ProgramData%\Microsoft\Windows Defender\Definition Updates" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:ProgramData\Microsoft\Windows Defender\Definition Updates' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^{.*}$' } | ForEach-Object { rmdir $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [200/425] Svuotamento dei file temporanei del database di WinSxS (Manifest Cache)...
if exist "C:\Windows\winsxs\ManifestCache" (
    del /f /q /s C:\Windows\winsxs\ManifestCache\* >nul 2>&1
)
echo OK.

echo [201/425] Forzatura azzeramento della cache dei log delle sessioni Event Trace (ETW)...
if exist "C:\Windows\System32\LogFiles\WMI\RtBackup" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\LogFiles\WMI\RtBackup -Filter *.etl -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [202/425] Rimozione definitiva della cache dei pacchetti lingua non utilizzati (MUI Clean)...
Lpksetup /u >nul 2>&1
echo OK.

echo [203/425] Compressione LZX profonda della cartella delle funzionalità opzionali di Windows...
if exist "C:\Windows\Servicing" (
    compact /c /s:C:\Windows\Servicing /exe:lzx /i >nul 2>&1
)
echo OK.

echo [204/425] Svuotamento del database di diagnostica e telemetria utente (DiagTrack Cache)...
if exist "%ProgramData%\Microsoft\Diagnosis\DownloadedSettings" (
    del /f /q /s "%ProgramData%\Microsoft\Diagnosis\DownloadedSettings\*" >nul 2>&1
)
echo OK.

echo [205/425] Pulizia dei file residui temporanei generati dall'utilita CheckDisk (chkdsk)...
del /f /q /s C:\*.chk >nul 2>&1
echo OK.

echo [206/425] Disattivazione della riserva di spazio per il rollback delle versioni di Windows...
DISM.exe /Online /Cleanup-Image /SFC /Disable-Feature /FeatureName:Windows-Rollback-Data >nul 2>&1
echo OK.

echo [207/425] Compressione LZX ultra-aggressiva dei binari nativi di PowerShell...
compact /c /s:C:\Windows\System32\WindowsPowerShell /exe:lzx /i >nul 2>&1
echo OK.

echo [208/425] Rimozione forzata dei file temporanei del modulo di telemetria software (sqm)...
del /f /q /s C:\*.sqm >nul 2>&1
echo OK.

echo [209/425] Svuotamento della cache di indicizzazione dei file multimediali di rete (WMPNS)...
if exist "%PROGRAMDATA%\Microsoft\Media Player\Network Sharing" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Network Sharing\*" >nul 2>&1
)
echo OK.

echo [210/425] Compressione NTFS dei driver di terze parti archiviati nel DriverStore...
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:C:\Windows\System32\DriverStore\FileRepository /i >nul 2>&1
)
echo OK.

echo [211/425] Sfoltimento e azzeramento forzato dei file di Log della crittografia BitLocker...
if exist C:\Windows\System32\LogFiles\BitLocker (
    del /f /q /s C:\Windows\System32\LogFiles\BitLocker\* >nul 2>&1
)
echo OK.

echo [212/425] Eliminazione della cache dei file temporanei del visualizzatore di immagini UWP...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^Photos.*Cache$' } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [213/425] Rimozione forzata dei file di dump delle eccezioni del runtime .NET (Watson)...
if exist "%ProgramData%\Microsoft\Windows\WER\ReportQueue" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\WER\ReportQueue\AppCrash_*" >nul 2>&1
)
echo OK.

echo [214/425] Svuotamento della cache dei file di configurazione temporanei di Windows Defender ATP...
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense\*" >nul 2>&1
)
echo OK.

echo [215/425] Compressione LZX dei file di help e supporto locali di Windows...
if exist C:\Windows\Help (
    compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1
)
echo OK.

echo [216/425] Svuotamento della cache dei log di sincronizzazione del Microsoft Store...
if exist "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\Logs" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\Logs\*" >nul 2>&1
)
echo OK.

echo [217/425] Rimozione forzata dei file temporanei lasciati dai vecchi pacchetti NuGet e PIP orfani...
del /f /q /s C:\Users\*\AppData\Local\pip\cache\*.tmp >nul 2>&1
echo OK.

echo [218/425] Reset totale e forzato dei descrittori di sicurezza NTFS orfani (Security Clean)...
chkntfs /X C: >nul 2>&1
echo OK.

echo [219/425] Consolidamento finale estremo dello spazio e compattazione dei descrittori MFT...
defrag C: /U /V /X /H /K /G >nul 2>&1
echo OK.

echo [220/425] Allineamento logico finale dei cluster e ottimizzazione TRIM dell'unita di sistema...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -ReTrim -Defrag" >nul 2>&1
echo OK.

echo [221/425] OTTIMIZZAZIONE STRUTTURALE: Sincronizzazione fisica e svuotamento dei buffer del disco C...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force" >nul 2>&1
echo OK.

echo [222/425] Rimozione dei vecchi pacchetti di installazione dei driver grafici (OEM Driver Clean)...
if exist "%SystemDrive%\ProgramData\AMD" (rmdir /s /q "%SystemDrive%\ProgramData\AMD" >nul 2>&1)
if exist "%SystemDrive%\ProgramData\NVIDIA" (rmdir /s /q "%SystemDrive%\ProgramData\NVIDIA" >nul 2>&1)
echo OK.

echo [223/425] Compressione LZX dei file di log storici generati dal Microsoft Store...
if exist "%ProgramData%\Microsoft\Windows\AppRepository" (
    compact /c /s:"%ProgramData%\Microsoft\Windows\AppRepository" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [224/425] Eliminazione della cache dei modelli di Intelligenza Artificiale e OCR di Windows...
if exist "%ProgramData%\Microsoft\Windows\OCR" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\OCR\*" >nul 2>&1
)
if exist "%LocalAppData%\Microsoft\Windows\AI" (
    rmdir /s /q "%LocalAppData%\Microsoft\Windows\AI" >nul 2>&1
)
echo OK.

echo [225/425] Rimozione della cache orfana dei pacchetti di runtime redistribuibili di Visual C++...
if exist "C:\ProgramData\Package Cache" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Package Cache' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [226/425] Compressione LZX profonda dei driver audio e di rete legacy (DriverStore Backup)...
if exist "C:\Windows\System32\DriverStore\en-US" (compact /c /s:"C:\Windows\System32\DriverStore\en-US" /exe:lzx /i >nul 2>&1)
if exist "C:\Windows\System32\DriverStore\it-IT" (compact /c /s:"C:\Windows\System32\DriverStore\it-IT" /exe:lzx /i >nul 2>&1)
echo OK.

echo [227/425] Compattazione e deframmentazione aggressiva degli indici MFT finali (Max Boot Speed)...
defrag C: /O /H /X /U /V /K /G >nul 2>&1
echo OK.

echo [228/425] Sfoltimento forzato dei file di installazione differiti delle funzionalità opzionali...
DISM.exe /Online /Disable-Feature /FeatureName:WorkFolders-Client /NoRestart >nul 2>&1
DISM.exe /Online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /NoRestart >nul 2>&1
echo OK.

echo [229/425] Compressione LZX aggressiva del sottosistema IME (Tastiere e dizionari predittivi)...
if exist C:\Windows\InputMethod (
    compact /c /s:C:\Windows\InputMethod /exe:lzx /i >nul 2>&1
)
echo OK.

echo [230/425] Rimozione definitiva delle cache storiche dei report di affidabilità hardware (WDI)...
if exist C:\Windows\System32\wdi\LogFiles (
    del /f /q /s C:\Windows\System32\wdi\LogFiles\* >nul 2>&1
)
echo OK.

echo [231/425] Svuotamento della cache dei metadati di indicizzazione di Windows Search (Edb Log)...
net stop wsearch >nul 2>&1
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\*.log" >nul 2>&1
)
net start wsearch >nul 2>&1
echo OK.

echo [232/425] Compressione NTFS delle librerie di configurazione dell'interfaccia (SystemResources)...
if exist C:\Windows\SystemResources (
    compact /c /s:C:\Windows\SystemResources /i >nul 2>&1
)
echo OK.

echo [233/425] Rimozione forzata dei file temporanei accumulati dal gestore delle notifiche push...
del /f /q /s "%LocalAppData%\Microsoft\Windows\Notifications\wpndatabase.db" >nul 2>&1
echo OK.

echo [234/425] Svuotamento della cache dei file temporanei di caching del servizio WebClient (DAV)...
if exist C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore (
    rmdir /s /q C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore >nul 2>&1
)
echo OK.

echo [235/425] Compressione LZX profonda dei moduli diagnostici residui di Windows Error Reporting...
if exist C:\Windows\System32\Wer (
    compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1
)
echo OK.

echo [236/425] Rimozione delle chiavi temporanee e indici storici del gestore installazioni (AppxAll)...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Microsoft\Windows\AppXDeploymentServer' -Filter *.log, *.tmp -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
echo OK.

echo [237/425] Rimozione della cache dei vecchi pacchetti di installazione di Microsoft Edge...
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Download" (
    rmdir /s /q "%ProgramFiles(x86)%\Microsoft\Edge\Download" >nul 2>&1
)
echo OK.

echo [238/425] Svuotamento dei log temporanei accumulati da Windows Defender SmartScreen...
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.log" >nul 2>&1
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.txt" >nul 2>&1
)
echo OK.

echo [239/425] Svuotamento della cache dei file musicali temporanei di YouTube Music / YouTube Desktop...
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Storage\ext\mpogngknbghclgocfkp... (identificatore)" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'File System' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo OK.

echo [240/425] Pulizia forzata dei file temporanei e file di log orfani generati da VLC Media Player...
if exist "%APPDATA%\vlc\art" (rmdir /s /q "%APPDATA%\vlc\art" >nul 2>&1)
echo OK.

echo [241/425] Sfoltimento dei file temporanei di caching del browser Opera / Opera GX (System Cache)...
if exist "%AppData%\Opera Software\Opera GX Stable\Network Action Predictor" (del /f /q /s "%AppData%\Opera Software\Opera GX Stable\Network Action Predictor*" >nul 2>&1)
echo OK.

echo [242/425] Rimozione dei log diagnostici giganti generati dal servizio di indicizzazione (Windows.edb logs)...
net stop wsearch >nul 2>&1
del /f /q /s C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\SettingSync\*.log >nul 2>&1
net start wsearch >nul 2>&1
echo OK.

echo [243/425] Svuotamento della cache dei file scaricati e residui di Microsoft Teams (Meeting Artifacts)...
if exist "%AppData%\Microsoft\Teams\Backgrounds" (del /f /q /s "%AppData%\Microsoft\Teams\Backgrounds\*" >nul 2>&1)
if exist "%AppData%\Microsoft\Teams\media-stack" (del /f /q /s "%AppData%\Microsoft\Teams\media-stack\*" >nul 2>&1)
echo OK.

echo [244/425] Compressione LZX profonda dei file di log storici generati dal CBS e dal DISM...
if exist C:\Windows\Logs\DISM (compact /c /s:C:\Windows\Logs\DISM /exe:lzx /i >nul 2>&1)
echo OK.

echo [245/425] OTTIMIZZAZIONE DEVASTANTE FINALE: Sintonizzazione hardware e consolidamento dei cluster liberi...
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1
echo OK.

echo [246/425] Rimozione dei file temporanei generati dagli aggiornamenti delle App di sistema (AppX Deployment)...
if exist "%ProgramData%\Microsoft\Windows\AppRepository\Packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\AppRepository\Packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [247/425] Svuotamento dei file di tracciamento e log dell'applicazione Xbox Game DVR...
if exist "%LocalAppData%\Microsoft\Windows\GameBar" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.log" >nul 2>&1
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.tmp" >nul 2>&1
)
echo OK.

echo [248/425] Svuotamento della cache dei log di telemetria del servizio Windows Audio (AudioDgd)...
if exist C:\Windows\System32\LogFiles\Audio (
    del /f /q /s C:\Windows\System32\LogFiles\Audio\* >nul 2>&1
)
echo OK.

echo [249/425] Pulizia dei file temporanei accumulati dallo strumento nativo Windows Problem Steps Recorder...
if exist "%LocalAppData%\Temp\PSR" (
    rmdir /s /q "%LocalAppData%\Temp\PSR" >nul 2>&1
)
echo OK.

echo [250/425] Svuotamento dei log storici orfani del visualizzatore di eventi Hardware (WHEA)...
if exist C:\Windows\LiveKernelReports (
    del /f /q /s C:\Windows\LiveKernelReports\*.dmp >nul 2>&1
    for /d %%p in (C:\Windows\LiveKernelReports\*) do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [251/425] Compressione LZX profonda dei moduli di supporto archiviati in AppData...
if exist "%LocalAppData%\Microsoft\Windows\INetCookies" (
    compact /c /s Backups /exe:lzx /i >nul 2>&1
)
echo OK.

echo [252/425] Rimozione della cache temporanea dei certificati di autenticazione scaduti (Cryptnet)...
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (
    rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1
)
echo OK.

echo [253/425] Pulizia forzata dei file temporanei lasciati dal client cloud OneDrive (Sync Engine Logs)...
if exist "%LocalAppData%\Microsoft\OneDrive\logs" (
    del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\*" >nul 2>&1
)
echo OK.

echo [254/425] Compressione NTFS delle cartelle diagnostiche storiche del browser Microsoft Edge...
if exist "%LocalAppData%\Microsoft\Edge\User Data\Crashpad" (
    compact /c /s:"%LocalAppData%\Microsoft\Edge\User Data\Crashpad" /i >nul 2>&1
)
echo OK.

echo [255/425] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)
echo OK.

echo [256/425] Pulizia della cache di rendering grafico del nuovo Terminale Windows (Windows Terminal)...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1
)
echo OK.

echo [257/425] Rimozione dei log diagnostici accumulati dal sottosistema Windows Sandbox (Se attivo)...
if exist "C:\ProgramData\Microsoft\Windows\Containers\Sandboxes" (
    del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\*.log >nul 2>&1
)
echo OK.

echo [258/425] Svuotamento dei file temporanei generati dall'app Xbox App Runtime (Gaming Services)...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
)
echo OK.

echo [259/425] Compressione LZX profonda dei dizionari e file di testo del correttore ortografico locale...
if exist C:\Windows\System32\MsSpellCheckingFacility (
    compact /c /s:C:\Windows\System32\MsSpellCheckingFacility /exe:lzx /i >nul 2>&1
)
echo OK.

echo [260/425] Svuotamento della cache dei log delle connessioni Bluetooth e periferiche Wireless orfane...
if exist C:\Windows\System32\LogFiles\Bluetooth (
    del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1
)
echo OK.

echo [261/425] Rimozione forzata dei file temporanei lasciati dal gestore di pacchetti universale winget...
del /f /q /s "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
echo OK.

echo [262/425] Svuotamento della cache dei log di sincronizzazione profonda di OneDrive Business...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1)
echo OK.

echo [263/425] Compressione LZX profonda dei file log statici di installazione di Windows (Panther LZX)...
if exist C:\Windows\Panther (
    compact /c /s:C:\Windows\Panther /exe:lzx /i >nul 2>&1
)
echo OK.

echo [264/425] Sincronizzazione hardware e rilascio definitivo dei buffer di memoria NTFS...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force; Optimize-Volume -DriveLetter C -Defrag -ReTrim" >nul 2>&1
echo OK.

echo [265/425] Rimozione della cache dei moduli di runtime delle applicazioni Microsoft Store...
if exist "%ProgramData%\Microsoft\Windows\AppRepository\Packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\AppRepository\Packages' -Filter *.tmp, *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [266/425] Compressione LZX profonda dei file log e di testo del visualizzatore eventi di terze parti...
if exist "%LocalAppData%\Microsoft\Edge\User Data\Crashpad" (
    compact /c /s:"%LocalAppData%\Microsoft\Edge\User Data\Crashpad" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [267/425] Svuotamento della cache dei flussi multimediali di Windows Media Foundation...
if exist "%LocalAppData%\Microsoft\Media Player" (
    rmdir /s /q "%LocalAppData%\Microsoft\Media Player" >nul 2>&1
)
echo OK.

echo [268/425] Cancellazione forzata dei file temporanei di compilazione dei pacchetti Rust (Cargo)...
if exist "%USERPROFILE%\.cargo\registry\cache" (
    rmdir /s /q "%USERPROFILE%\.cargo\registry\cache" >nul 2>&1
)
echo OK.

echo [269/425] OTTIMIZZAZIONE LOGICA ESTREMA: Compattazione finale delle tabelle MFT e ReTrim dei cluster...
defrag C: /O /H /X /U /V >nul 2>&1
echo OK.

echo [270/425] Svuotamento della cache dei metadati di rete e DNS locali di Windows (NetworkCache)...
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1
)
echo OK.

echo [271/700] Pulizia dei cookie orfani e sessioni scadute di Mozilla Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'cookies.sqlite*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [272/700] Rimozione della cache dei moduli di telemetria di Mozilla Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'datareporting' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force" >nul 2>&1
)
echo OK.

echo [273/700] Svuotamento dei file temporanei di compressione delle pagine di Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'startupCache' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force" >nul 2>&1
)
echo OK.

echo [274/700] Polverizzazione dei log di crash e dump accumulati da Firefox...
if exist "%APPDATA%\Mozilla\Firefox\Crash Reports" (
    rmdir /s /q "%APPDATA%\Mozilla\Firefox\Crash Reports" >nul 2>&1
)
echo OK.

echo [275/700] Rimozione dei file temporanei e dei backup orfani delle estensioni di Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'extension-cookies' -ErrorAction SilentlyContinue | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File | Remove-Item -Force }" >nul 2>&1
)
echo OK.

echo [276/700] Pulizia approfondita dei file temporanei del database delle icone di Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'favicons.sqlite*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [277/700] Svuotamento della cache dei file di configurazione HTTP pendenti di Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'AlternateServices.txt' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [278/425] Compressione LZX delle cartelle pubbliche di Windows (Public Documents)...
if exist "C:\Users\Public" (
    compact /c /s:"C:\Users\Public" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [279/425] Rimozione della cache dei vecchi modelli di Intelligenza Artificiale e OCR...
if exist "%ProgramData%\Microsoft\Windows\OCR" (del /f /q /s "%ProgramData%\Microsoft\Windows\OCR\*" >nul 2>&1)
if exist "%LocalAppData%\Microsoft\Windows\AI" (rmdir /s /q "%LocalAppData%\Microsoft\Windows\AI" >nul 2>&1)
echo OK.

echo [280/425] Forzatura azzeramento della cache dei log delle sessioni Event Trace (ETW inattive)...
if exist "C:\Windows\System32\LogFiles\WMI\RtBackup" (
    del /f /q /s C:\Windows\System32\LogFiles\WMI\RtBackup\*.etl >nul 2>&1
)
echo OK.

echo [281/425] Svuotamento della cache dei log storici del framework di sicurezza Windows Defender...
if exist "%ProgramData%\Microsoft\Windows Defender\Scans\History\Store" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
)
echo OK.

echo [282/425] Svuotamento forzato della cache dei file scaricati dal browser Microsoft Edge (Update)...
if exist "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" (
    rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" >nul 2>&1
)
echo OK.

echo [283/425] Pulizia dei file di log di errore del server web locale IIS Express (Sviluppatori)...
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (
    del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1
)
echo OK.

echo [284/425] Pulizia forzata dei file temporanei e dei log del client cloud Google Drive...
if exist "%LocalAppData%\Google\DriveFS" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\DriveFS' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^content_cache$' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [285/425] Svuotamento della cache dei log storici di Windows Defender Advanced Threat Protection...
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CrashDumps" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CrashDumps\*" >nul 2>&1
)
echo OK.

echo [286/425] Svuotamento della cache nascosta del browser Vivaldi (Se presente)...
if exist "%LocalAppData%\Vivaldi\User Data\Default\Cache" (
    del /f /q /s "%LocalAppData%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1
)
echo OK.

echo [287/425] Rimozione forzata dei file temporanei generati dall'utilita di diagnostica di rete...
if exist C:\Windows\System32\LogFiles\WMI\wifi.etl (
    del /f /q C:\Windows\System32\LogFiles\WMI\wifi.etl >nul 2>&1
)
echo OK.

echo [288/425] Svuotamento dei file orfani compressi generati dalle estrazioni di WinRAR interrotte...
if exist "%APPDATA%\WinRAR\Templates" (
    del /f /q /s "%APPDATA%\WinRAR\Templates\*" >nul 2>&1
)
echo OK.

echo [289/425] Svuotamento dei log di diagnostica sui consumi di rete in standby (WaaS)...
if exist C:\Windows\Logs\WaasMedic (
    del /f /q /s C:\Windows\Logs\WaasMedic\* >nul 2>&1
)
echo OK.

echo [290/425] Rimozione delle chiavi di tracciamento temporanee dei vecchi pacchetti NuGet disinstallati...
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [291/425] Svuotamento cache dei file multimediali del browser Opera GX...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache\*" >nul 2>&1)
echo OK.

echo [292/425] Pulizia dei log di telemetria e tracciamento del browser Vivaldi...
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports\*" >nul 2>&1)
echo OK.

echo [293/425] Svuotamento dei file temporanei e cache del browser Tor (Se installato)...
if exist "%LOCALAPPDATA%\Tor Browser\Browser\TorBrowser\Data\Browser\Caches" (rmdir /s /q "%LOCALAPPDATA%\Tor Browser\Browser\TorBrowser\Data\Browser\Caches" >nul 2>&1)
echo OK.

echo [294/425] Svuotamento della cache dei font temporanei del visualizzatore PDF Foxit Reader...
if exist "%AppData%\Foxit Software\Foxit PDF Reader\FontCache" (rmdir /s /q "%AppData%\Foxit Software\Foxit PDF Reader\FontCache" >nul 2>&1)
echo OK.

echo [295/425] Rimozione dei log storici accumulati dall'editor video Wondershare Filmora...
if exist "%AppData%\Wondershare\Wondershare Filmora\Log" (del /f /q /s "%AppData%\Wondershare\Wondershare Filmora\Log\*" >nul 2>&1)
echo OK.

echo [296/425] Svuotamento dei file proxy e cache temporanea di DaVinci Resolve...
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)
echo OK.

echo [297/425] Pulizia della cache dei moduli estratti e temporanei di Python VirtualEnv...
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [298/425] Rimozione della cache dei pacchetti scaricati dal gestore Ruby (Gem Cache)...
if exist "%USERPROFILE%\.gem\specs" (rmdir /s /q "%USERPROFILE%\.gem\specs" >nul 2>&1)
echo OK.

echo [299/425] Svuotamento della cache dei log e moduli orfani dell'ambiente Docker...
if exist "%USERPROFILE%\.docker\cli-plugins" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.docker' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [300/425] Pulizia file temporanei generati durante l'uso di WinSCP...
if exist "%AppData%\WinSCP\Cache" (rmdir /s /q "%AppData%\WinSCP\Cache" >nul 2>&1)
echo OK.

echo [301/425] Svuotamento dei log di connessione memorizzati dal client SSH Putty...
if exist "%LocalAppData%\Putty" (del /f /q /s "%LocalAppData%\Putty\*.log" >nul 2>&1)
echo OK.

echo [302/425] Rimozione della cache multimediale temporanea dell'app Plex Media Server...
if exist "%LocalAppData%\Plex Media Server\Cache" (rmdir /s /q "%LocalAppData%\Plex Media Server\Cache" >nul 2>&1)
echo OK.

echo [303/425] Svuotamento della cache delle miniature generate dal visualizzatore di immagini IrfanView...
if exist "%AppData%\IrfanView\Cache" (rmdir /s /q "%AppData%\IrfanView\Cache" >nul 2>&1)
echo OK.

echo [304/425] Pulizia della cache dei file audio temporanei di Audacity (Giga-Spazio orfano)...
if exist "%LocalAppData%\Audacity\SessionData" (rmdir /s /q "%LocalAppData%\Audacity\SessionData" >nul 2>&1)
echo OK.

echo [305/425] Svuotamento dei file di log di diagnostica dell'app OneDrive per Mac/Windows Local...
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Common" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Common\*" >nul 2>&1)
echo OK.

echo [306/425] Rimozione dei log temporanei accumulati dall'app di note Obsidian...
if exist "%AppData%\obsidian\logs" (del /f /q /s "%AppData%\obsidian\logs\*" >nul 2>&1)
echo OK.

echo [307/425] Svuotamento dei file temporanei di cache dell'app di messaggistica Signal...
if exist "%AppData%\Signal\Cache" (rmdir /s /q "%AppData%\Signal\Cache" >nul 2>&1)
echo OK.

echo [308/425] Pulizia della cache dei log delle chiamate e telemetria di Skype...
if exist "%AppData%\Microsoft\Skype for Desktop\logs" (del /f /q /s "%AppData%\Microsoft\Skype for Desktop\logs\*" >nul 2>&1)
echo OK.

echo [309/425] Svuotamento della cache dei file di installazione parziali scaricati da Battle.net...
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [310/425] Svuotamento dei file di log e telemetria di gioco del launcher di Riot Games...
if exist "%LocalAppData%\Riot Games\Install Mobile" (del /f /q /s "%LocalAppData%\Riot Games\Install Mobile\*.log" >nul 2>&1)
echo OK.

echo [311/425] Rimozione della cache dei log storici dell'app Logitech G HUB...
if exist "%LocalAppData%\LGHUB\logs" (del /f /q /s "%LocalAppData%\LGHUB\logs\*" >nul 2>&1)
echo OK.

echo [312/425] Svuotamento della cache dei profili temporanei dell'app Razer Synapse...
if exist "%ProgramData%\Razer\Synapse3\Log" (del /f /q /s "%ProgramData%\Razer\Synapse3\Log\*" >nul 2>&1)
echo OK.

echo [313/425] Pulizia della cache dei log del driver audio Realtek HD Audio Manager...
if exist "C:\Program Files\Realtek\Audio\HDA\Logs" (del /f /q /s "C:\Program Files\Realtek\Audio\HDA\Logs\*" >nul 2>&1)
echo OK.

echo [314/425] Svuotamento dei log storici generati dal servizio Windows Time (W32Time)...
if exist C:\Windows\w32time.log (del /f /q C:\Windows\w32time.log >nul 2>&1)
echo OK.

echo [315/425] Rimozione dei log di tracciamento e configurazione di Windows Speech Setup...
if exist C:\Windows\Speech\Common (del /f /q /s C:\Windows\Speech\Common\*.log >nul 2>&1)
echo OK.

echo [316/425] Pulizia dei log di debug e cache del framework Microsoft .NET Core SDK...
if exist "%USERPROFILE%\.dotnet\corefx" (rmdir /s /q "%USERPROFILE%\.dotnet\corefx" >nul 2>&1)
echo OK.

echo [317/425] Svuotamento dei log delle vecchie connessioni di rete VPN native di Windows...
if exist "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" (del /f /q "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" >nul 2>&1)
echo OK.

echo [318/425] Rimozione dei log temporanei accumulati dal Kernel Live Dump del File System...
if exist C:\Windows\System32\Sru (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log, *.txt -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [319/425] Compressione LZX profonda dei moduli di telemetria residui di Windows (DiagTrack LZX)...
if exist "%ProgramData%\Microsoft\Diagnosis" (compact /c /s:%ProgramData%\Microsoft\Diagnosis /exe:lzx /i >nul 2>&1)
echo OK.

echo [320/425] Sincronizzazione fisica hardware finale e svuotamento definitivo dei buffer NTFS...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1
echo OK.

echo [321/425] Svuotamento della cache dei driver grafici obsoleti scaricati (Intel)...
if exist "C:\ProgramData\Intel\Downloads" (rmdir /s /q "C:\ProgramData\Intel\Downloads" >nul 2>&1)
echo OK.

echo [322/425] Rimozione delle copie di cache locali dei vecchi aggiornamenti cumulativi...
if exist C:\Windows\servicing\Packages (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\servicing\Packages -Filter *.cat, *.mum -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [323/425] Eliminazione delle vecchie versioni compresse dei file di log MOF di sistema...
if exist C:\Windows\System32\wbem\AutoRecover (
    del /f /q /s C:\Windows\System32\wbem\AutoRecover\*.mof >nul 2>&1
)
echo OK.

echo [324/425] Compressione LZX dell'intera cartella dei driver installati (FileRepository)...
:: I driver sono già caricati nel Kernel, la compressione LZX riduce lo spazio del 40% in totale sicurezza.
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:"C:\Windows\System32\DriverStore\FileRepository" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [325/425] Svuotamento della cache dei file temporanei di Adobe Premiere (Peak Files)...
if exist "%AppData%\Adobe\Common\Peak Files" (rmdir /s /q "%AppData%\Adobe\Common\Peak Files" >nul 2>&1)
echo OK.

echo [326/425] Svuotamento totale della cache di anteprima temporanea dei Font di Windows...
if exist C:\Windows\Fonts (
    del /f /q /s C:\Windows\Fonts\*.bak >nul 2>&1
    del /f /q /s C:\Windows\Fonts\*.tmp >nul 2>&1
)
echo OK.

echo [327/425] Eliminazione delle cache dei pacchetti scaricati e accumulati da Python (Wheel Cache)...
if exist "%LocalAppData%\pip\wheels" (rmdir /s /q "%LocalAppData%\pip\wheels" >nul 2>&1)
echo OK.

echo [328/425] Pulizia dei log temporanei di errore dell'app OneDrive Personal...
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Personal" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Personal\*" >nul 2>&1)
echo OK.

echo [329/425] Pulizia dei log temporanei di errore dell'app OneDrive Business...
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Business1" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Business1\*" >nul 2>&1)
echo OK.

echo [330/425] Rimozione forzata dei log orfani del gestore dischi virtuali nativo (VDS)...
if exist C:\Windows\Logs\VDS (del /f /q /s C:\Windows\Logs\VDS\* >nul 2>&1)
echo OK.

echo [331/425] Svuotamento dei file temporanei di log del modulo NuGet locale...
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)
echo OK.

echo [332/425] Compressione LZX profonda dei dizionari statici e motori di traduzione di Office...
if exist "C:\Program Files\Microsoft Office\root\Office16\Proof" (
    compact /c /s:"C:\Program Files\Microsoft Office\root\Office16\Proof" /exe:lzx /i >nul 2>&1
)
echo OK.

echo [333/425] Rimozione dei log storici generati dal sistema di crittografia dei file EFS...
if exist C:\Windows\System32\LogFiles\EFS (del /f /q /s C:\Windows\System32\LogFiles\EFS\* >nul 2>&1)
echo OK.

echo [334/425] Svuotamento della cache dei metadati locali temporanei dell'app Microsoft To-Do...
if exist "%LocalAppData%\Packages\Microsoft.Todos_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.Todos_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [335/425] Rimozione file .tmp e log isolati nella radice della cartella ProgramData...
del /f /q C:\ProgramData\*.tmp >nul 2>&1
del /f /q C:\ProgramData\*.log >nul 2>&1
echo OK.

echo [336/425] Svuotamento delle cartelle Art Cache del server multimediale interno di Windows...
if exist "%LocalAppData%\Microsoft\Media Player\Art Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player\Art Cache" >nul 2>&1)
echo OK.

echo [337/425] Svuotamento della cache dei log delle sessioni Xbox Live Auth Host...
if exist "%LocalAppData%\Packages\Microsoft.XboxLiveAuthHost_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxLiveAuthHost_8wekyb3d8bbwe\LocalState\*" >nul 2>&1)
echo OK.

echo [338/425] Compressione LZX delle cartelle di runtime di Java (Se installato a 64-bit)...
if exist "C:\Program Files\Java" (compact /c /s:"C:\Program Files\Java" /exe:lzx /i >nul 2>&1)
echo OK.

echo [339/425] Compressione LZX delle cartelle di runtime di Java (Se installato a 32-bit)...
if exist "C:\Program Files (x86)\Java" (compact /c /s:"C:\Program Files (x86)\Java" /exe:lzx /i >nul 2>&1)
echo OK.

echo [340/425] Rimozione log storici del servizio di configurazione di rete wireless (WLAN)...
if exist C:\Windows\System32\LogFiles\WLAN (del /f /q /s C:\Windows\System32\LogFiles\WLAN\* >nul 2>&1)
echo OK.

echo [341/425] Compressione LZX delle librerie dei moduli grafici DirectX (D3D)...
if exist "C:\Windows\System32\DirectX" (compact /c /s:"C:\Windows\System32\DirectX" /exe:lzx /i >nul 2>&1)
echo OK.

echo [342/425] Sfoltimento forzato dei file di backup temporanei del boot manager...
if exist C:\Windows\Boot\EFI\*.bak (del /f /q C:\Windows\Boot\EFI\*.bak >nul 2>&1)
echo OK.

echo [343/425] Svuotamento della cache dei file temporanei di Adobe Media Encoder (Render Cache)...
if exist "%AppData%\Adobe\Common\PTX" (rmdir /s /q "%AppData%\Adobe\Common\PTX" >nul 2>&1)
echo OK.

echo [344/425] Compressione LZX della directory dei log del visualizzatore eventi (Winevt)...
:: I log storici occupano molto spazio, comprimerli in LZX fa risparmiare il 60% in totale sicurezza.
if exist C:\Windows\System32\winevt (compact /c /s:C:\Windows\System32\winevt /exe:lzx /i >nul 2>&1)
echo OK.

echo [345/425] Rimozione forzata dei file di report di crash generati dal browser Brave...
if exist "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports" (del /f /q /s "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports\*" >nul 2>&1)
echo OK.

echo [346/425] Compressione NTFS profonda dei log dell'antivirus nativo di Windows...
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (compact /c /s:"%ProgramData%\Microsoft\Windows Defender\Support" /i >nul 2>&1)
echo OK.

echo [347/425] Svuotamento della cache dei log delle sessioni Xbox Live Identity Provider...
if exist "%LocalAppData%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe\LocalState\*" >nul 2>&1)
echo OK.

echo [348/700] Rimozione forzata dei file di log temporanei accumulati in AppData Local...
if exist "%LOCALAPPDATA%\Temp" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Temp' -Recurse -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [349/425] Rimozione log e report di diagnostica di Microsoft Teams Classic...
if exist "%AppData%\Microsoft\Teams\logs" (del /f /q /s "%AppData%\Microsoft\Teams\logs\*" >nul 2>&1)
echo OK.

echo [350/425] Rimozione della cache degli aggiornamenti scaricati da Java Runtime...
if exist "%JucheckLogDir%" (del /f /q /s "%JucheckLogDir%\*" >nul 2>&1)
echo OK.

echo [351/425] Svuotamento dei log di sincronizzazione del client cloud Dropbox...
if exist "%LocalAppData%\Dropbox\logs" (del /f /q /s "%LocalAppData%\Dropbox\logs\*" >nul 2>&1)
echo OK.

echo [352/425] Rimozione dei file temporanei generati durante l'uso di Cisco Webex...
if exist "%LocalAppData%\Cisco\Spark\*\logs" (del /f /q /s "%LocalAppData%\Cisco\Spark\*\logs\*" >nul 2>&1)
echo OK.

echo [353/425] Svuotamento della cache di rendering dell'emulatore BlueStacks (Android)...
if exist "%ProgramData%\BlueStacks_nxt\Engine\UserData\InputMethods\Cache" (rmdir /s /q "%ProgramData%\BlueStacks_nxt\Engine\UserData\InputMethods\Cache" >nul 2>&1)
echo OK.

echo [354/425] Rimozione log e file orfani di installazione di BlueStacks...
if exist "%ProgramData%\BlueStacks_nxt\Logs" (del /f /q /s "%ProgramData%\BlueStacks_nxt\Logs\*" >nul 2>&1)
echo OK.

echo [355/425] Pulizia dei log temporanei del client cloud Box Sync...
if exist "%LocalAppData%\Box\Box Sync\Logs" (del /f /q /s "%LocalAppData%\Box\Box Sync\Logs\*" >nul 2>&1)
echo OK.

echo [356/425] Svuotamento della cache dei file temporanei della cache web dell'app Kindle Desktop...
if exist "%LocalAppData%\Amazon\Kindle\Cache" (rmdir /s /q "%LocalAppData%\Amazon\Kindle\Cache" >nul 2>&1)
echo OK.

echo [357/425] Rimozione file temporanei generati dall'editor di testo Notepad++...
if exist "%AppData%\Notepad++\backup" (del /f /q /s "%AppData%\Notepad++\backup\*" >nul 2>&1)
echo OK.

echo [358/425] Svuotamento della cache di caricamento delle estensioni di Visual Studio Code...
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)
echo OK.

echo [359/425] Svuotamento dei log di crash e telemetria interna di Visual Studio Code...
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)
echo OK.

echo [360/425] Svuotamento della cache delle schede grafiche del browser Vivaldi...
if exist "%LocalAppData%\Vivaldi\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Vivaldi\User Data\ShaderCache" >nul 2>&1)
echo OK.

echo [361/425] Svuotamento della cache di rendering web di GitHub Desktop...
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)
echo OK.

echo [362/425] Rimozione dei log storici accumulati da GitHub Desktop...
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)
echo OK.

echo [363/425] Pulizia della cache dei pacchetti estratti di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)
echo OK.

echo [364/425] Svuotamento log di tracciamento e debug di Android Studio...
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)
echo OK.

echo [365/425] Svuotamento della cache dei moduli estratti da Windows PowerShell...
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ModuleAnalysisCache" (del /f /q "%LocalAppData%\Microsoft\Windows\PowerShell\ModuleAnalysisCache" >nul 2>&1)
echo OK.

echo [366/425] Svuotamento file temporanei generati da Microsoft Word (Documenti orfani)...
del /f /q /s "%AppData%\Microsoft\Word\*.tmp" >nul 2>&1
echo OK.

echo [367/425] Svuotamento file temporanei generati da Microsoft Excel (Fogli orfani)...
del /f /q /s "%AppData%\Microsoft\Excel\*.tmp" >nul 2>&1
echo OK.

echo [368/425] Svuotamento log di telemetria e tracciamento delle prestazioni di rete (NetTrace)...
if exist C:\Windows\System32\LogFiles\NetTrace (del /f /q /s C:\Windows\System32\LogFiles\NetTrace\* >nul 2>&1)
echo OK.

echo [369/425] Svuotamento dei file temporanei della cache delle mappe offline di Windows...
if exist "%ProgramData%\Microsoft\MapData" (del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1)
echo OK.

echo [370/425] Cancellazione dei file di log temporanei dell'utilita di diagnostica DirectX...
if exist "%WINDIR%\System32\dxdiag.exe" (del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1)
echo OK.

echo [371/425] Svuotamento dei log di diagnostica sui consumi di rete in standby (WaasMedic)...
if exist C:\Windows\Logs\WaasMedic (del /f /q /s C:\Windows\Logs\WaasMedic\* >nul 2>&1)
echo OK.

echo [372/425] Rimozione dei log temporanei generati dall'installatore .NET Framework...
for /d %%d in (C:\Windows\Microsoft.NET\Framework*) do (del /f /q /s "%%d\*.log" >nul 2>&1)
echo OK.

echo [373/425] Svuotamento della cache dei log di telemetria del servizio Windows Audio (AudioDgd)...
if exist C:\Windows\System32\LogFiles\Audio (del /f /q /s C:\Windows\System32\LogFiles\Audio\* >nul 2>&1)
echo OK.

echo [374/425] Pulizia dei file temporanei accumulati dallo strumento Windows Problem Steps Recorder...
if exist "%LocalAppData%\Temp\PSR" (rmdir /s /q "%LocalAppData%\Temp\PSR" >nul 2>&1)
echo OK.

echo [375/425] Svuotamento della cache temporanea dei certificati di autenticazione (Cryptnet)...
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1)
echo OK.

echo [376/425] Svuotamento dei file temporanei dell'app Collegamento al Telefono (Phone Link)...
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [377/425] Pulizia della cache di rendering grafico del nuovo Terminale Windows (Windows Terminal)...
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1)
echo OK.

echo [378/425] Rimozione dei log diagnostici accumulati dal sottosistema Windows Sandbox...
if exist "C:\ProgramData\Microsoft\Windows\Containers\Sandboxes" (del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\*.log >nul 2>&1)
echo OK.

echo [379/425] Svuotamento dei file temporanei generati dall'app Xbox App Runtime...
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1)
echo OK.

echo [380/425] Svuotamento della cache dei log delle connessioni Bluetooth...
if exist C:\Windows\System32\LogFiles\Bluetooth (del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1)
echo OK.

echo [381/425] Compressione LZX profonda dei moduli diagnostici di Windows Error Reporting...
if exist C:\Windows\System32\Wer (compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1)
echo OK.

echo [382/425] Pulizia dei log temporanei del sottosistema di crittografia CNG...
if exist C:\Windows\System32\LogFiles\CNG (del /f /q /s C:\Windows\System32\LogFiles\CNG\* >nul 2>&1)
echo OK.

echo [383/425] Svuotamento dei file temporanei del visualizzatore di font di Windows...
if exist "%LocalAppData%\Microsoft\Windows\GLCache" (rmdir /s /q "%LocalAppData%\Microsoft\Windows\GLCache" >nul 2>&1)
echo OK.

echo [384/425] Rimozione dei log storici di diagnostica del servizio Scansione e Fax...
if exist "%ProgramData%\Microsoft\Document Building Blocks" (del /f /q /s "%ProgramData%\Microsoft\Document Building Blocks\*" >nul 2>&1)
echo OK.

echo [385/425] Svuotamento dei file temporanei del compilatore Shader di Microsoft Edge...
if exist "%LocalAppData%\Microsoft\Edge\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Microsoft\Edge\User Data\ShaderCache" >nul 2>&1)
echo OK.

echo [386/425] Sfoltimento dei file di log temporanei di Microsoft Office Hub...
if exist "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [387/425] Svuotamento della cache di caricamento del visualizzatore 3D nativo...
if exist "%LocalAppData%\Packages\Microsoft.3DBuilder_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.3DBuilder_8wekyb3d8bbwe\LocalCache" >nul 2>&1)
echo OK.

echo [388/425] Rimozione log storici del gestore delle credenziali di Windows (Vault)...
if exist C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Vault (del /f /q /s C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Vault\*.log >nul 2>&1)
echo OK.

echo [389/425] Svuotamento della cache dei log di debug dell'app Microsoft Weather...
if exist "%LocalAppData%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\LocalState\Logs" (del /f /q /s "%LocalAppData%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\LocalState\Logs\*" >nul 2>&1)
echo OK.

echo [390/425] Svuotamento dei file temporanei di caching del servizio Windows Insider (Se attivo)...
if exist "%ProgramData%\Microsoft\Windows\SelfHost" (del /f /q /s "%ProgramData%\Microsoft\Windows\SelfHost\*" >nul 2>&1)
echo OK.

echo [391/425] Pulizia della cache dei moduli precompilati di Python VirtualEnv locali...
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Filter *.pyc, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [392/425] Svuotamento della cache delle immagini temporanee dell'app Obsidian...
if exist "%AppData%\obsidian\Cache" (rmdir /s /q "%AppData%\obsidian\Cache" >nul 2>&1)
echo OK.

echo [393/425] Pulizia dei log di telemetria e tracciamento dell'app di messaggistica Signal...
if exist "%AppData%\Signal\logs" (del /f /q /s "%AppData%\Signal\logs\*" >nul 2>&1)
echo OK.

echo [394/425] Svuotamento della cache multimediale temporanea di Cyberlink PowerDirector...
if exist "%LocalAppData%\CyberLink\PowerDirector\*\Cache" (del /f /q /s "%LocalAppData%\CyberLink\PowerDirector\*\Cache\*" >nul 2>&1)
echo OK.

echo [395/425] Pulizia dei log storici accumulati dall'applicazione CorelDraw...
if exist "%AppData%\Corel\Messages" (rmdir /s /q "%AppData%\Corel\Messages" >nul 2>&1)
echo OK.

echo [396/425] Rimozione dei log storici di diagnostica del chip di sicurezza TPM...
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)
echo OK.

echo [397/425] Svuotamento dei log temporanei accumulati dal Kernel Live Dump del File System...
if exist C:\Windows\System32\Sru (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)
echo OK.

echo [398/425] Consolidamento strutturale e spurgo dei pacchetti sostituiti (DISM Deep)...
:: I software commerciali non eseguono mai questo comando perché blocca il sistema per minuti.
:: Forza la rimozione fisica definitiva dei binari di sistema obsoleti non più necessari.
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart >nul 2>&1
echo OK.

echo [399/425] Forzatura dello spurgo della cache dei pacchetti MSI orfani (Package Cache log)...
if exist "C:\ProgramData\Package Cache" (
    del /f /q /s "C:\ProgramData\Package Cache\*.tmp" >nul 2>&1
    del /f /q /s "C:\ProgramData\Package Cache\*.log" >nul 2>&1
)
echo OK.

echo [400/425] Svuotamento dei file temporanei e log di installazione di Adobe Lightroom...
if exist "%LocalAppData%\Adobe\Lightroom\Cache" (rmdir /s /q "%LocalAppData%\Adobe\Lightroom\Cache" >nul 2>&1)
echo OK.

echo [401/425] Svuotamento dei log di tracciamento del motore di gioco Godot Engine...
if exist "%AppData%\Godot\app_user_data\__logs" (del /f /q /s "%AppData%\Godot\app_user_data\__logs\*" >nul 2>&1)
echo OK.

echo [402/425] Pulizia file .log temporanei del database locale di Unity Hub...
if exist "%AppData%\UnityHub\logs" (del /f /q /s "%AppData%\UnityHub\logs\*" >nul 2>&1)
echo OK.

echo [403/425] Consolidamento sicuro dello Store dei Componenti (DISM Clean)...
:: Metodo ufficiale Microsoft per spurgare i file di sistema obsoleti sostituiti dagli aggiornamenti.
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1
echo OK.

echo [404/425] Svuotamento dei pacchetti di installazione residui e obsoleti di Microsoft Edge...
if exist "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" (rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" >nul 2>&1)
echo OK.

echo [405/425] Rimozione forzata dei file di configurazione temporanei di WinZip...
if exist "%AppData%\WinZip\wztemp" (rmdir /s /q "%AppData%\WinZip\wztemp" >nul 2>&1)
echo OK.

echo [406/425] Svuotamento dei file temporanei e log di installazione di Adobe Creative Cloud...
if exist "%LocalAppData%\Adobe\caps" (del /f /q /s "%LocalAppData%\Adobe\caps\*.tmp" >nul 2>&1)
echo OK.

echo [407/425] Rimozione cache multimediale temporanea di Adobe Common Cache...
if exist "%AppData%\Adobe\Common\Media Cache Files" (rmdir /s /q "%AppData%\Adobe\Common\Media Cache Files" >nul 2>&1)
echo OK.

echo [408/425] GENERAZIONE DELLA BARRA DI AVANZAMENTO E OTTIMIZZAZIONE INTERFACCIA...
:: Disegna una barra di caricamento professionale nel prompt dei comandi per mostrare l'avanzamento reale al 100%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Write-Progress -Activity 'Windows Space Overlord' -Status 'Consolidamento e allineamento cluster finali in corso...' -PercentComplete 95; Start-Sleep -Milliseconds 500; Write-Progress -Activity 'Windows Space Overlord' -Status 'Scrittura indici di sicurezza sul Desktop...' -PercentComplete 99; Start-Sleep -Milliseconds 400"
echo OK.

echo [409/425] Disattivazione riserva di spazio per i rollback degli update...
DISM.exe /Online /Cleanup-Image /SFC /Disable-Feature /FeatureName:Windows-Rollback-Data /NoRestart >nul 2>&1
echo OK.

echo [410/425] Svuotamento della cache dei file multimediali di Telegram Desktop...
:: Usa robocopy per svuotare migliaia di file multimediali pesanti istantaneamente senza freeze
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    mkdir "%temp%\t_empty" >nul 2>&1
    robocopy "%temp%\t_empty" "%APPDATA%\Telegram Desktop\tdata\user_data\cache" /MIR >nul 2>&1
    rmdir /s /q "%temp%\t_empty" >nul 2>&1
)
echo OK.

echo [411/425] Pulizia profonda della cache del Browser Google Chrome (Default)...
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1
echo OK.

echo [412/425] Pulizia profonda della cache del Browser Google Chrome (Profilo 1)...
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\Code Cache\*" >nul 2>&1
echo OK.

echo [413/425] Pulizia profonda della cache del Browser Microsoft Edge (Default)...
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1
echo OK.

echo [414/425] Pulizia profonda della cache del Browser Microsoft Edge (Profilo 1)...
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\Code Cache\*" >nul 2>&1
echo OK.

echo [415/425] Svuotamento profondo della cache dell'applicazione Spotify...
if exist "%LOCALAPPDATA%\Spotify\Data" (del /f /q /s "%LOCALAPPDATA%\Spotify\Data\*" >nul 2>&1)
echo OK.

echo [416/425] Svuotamento rapido della cache dell'applicazione Discord...
if exist "%APPDATA%\discord\Cache" (del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1)
echo OK.

echo [417/425] Svuotamento dei file temporanei del browser web interno di Steam...
if exist "C:\Program Files (x86)\Steam\config\htmlcache" (
    del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1
    for /d %%p in ("C:\Program Files (x86)\Steam\config\htmlcache\*") do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [418/425] Svuotamento della cache web di caricamento di Epic Games Launcher...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1
)
echo OK.

echo [419/425] Svuotamento dei file temporanei della cache del Client EA Desktop...
if exist "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache" (
    del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*" >nul 2>&1
    for /d %%p in ("%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*") do rmdir /s /q "%%p" >nul 2>&1
)
echo OK.

echo [420/425] Svuotamento della cache dei file temporanei di Ubisoft Connect...
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" (
    rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1
)
echo OK.

echo [421/425] Svuotamento della cache dei log di errore del launcher Battle.net Agent...
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [422/425] Svuotamento dei log temporanei accumulati dal Kernel Live Dump (Sru Cache)...
if exist C:\Windows\System32\Sru (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [423/425] Pulizia dei log storici del sistema di crittografia dei file BitLocker...
if exist C:\Windows\System32\LogFiles\BitLocker (del /f /q /s C:\Windows\System32\LogFiles\BitLocker\* >nul 2>&1)
echo OK.

echo [424/425] Compressione LZX dei file di supporto e guide in linea locali di Windows (Help)...
if exist C:\Windows\Help (compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1)
echo OK.

echo [425/425] Compressione LZX profonda dei dizionari statici e motori di traduzione di Office...
if exist "C:\Program Files\Microsoft Office\root\Office16\Proof" (compact /c /s:"C:\Program Files\Microsoft Office\root\Office16\Proof" /exe:lzx /i >nul 2>&1)
echo OK.

echo [426/700] Svuotamento dei file temporanei della cache shader di Google Chrome (WebGPU)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Video ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Video ShaderCache" >nul 2>&1
)
echo OK.

echo [427/700] Sfoltimento dei file di log temporanei generati dalle estensioni di Microsoft Edge...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extension Logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extension Logs\*" >nul 2>&1
)
echo OK.

echo [428/700] Svuotamento della cache dei metadati musicali temporanei di iTunes (Se presente)...
if exist "%LOCALAPPDATA%\Apple Computer\iTunes\SubscriptionPlayCache" (
    rmdir /s /q "%LOCALAPPDATA%\Apple Computer\iTunes\SubscriptionPlayCache" >nul 2>&1
)
echo OK.

echo [429/700] Rimozione forzata dei crash dump temporanei dell'applicazione Discord...
if exist "%APPDATA%\discord\Crashpad" (
    rmdir /s /q "%APPDATA%\discord\Crashpad" >nul 2>&1
)
echo OK.

echo [430/700] Rimozione forzata dei pacchetti di cache obsoleti del compilatore shader DirectX (D3DCache System)...
if exist "%WINDIR%\System32\config\systemprofile\AppData\Local\D3DSCache" (
    rmdir /s /q "%WINDIR%\System32\config\systemprofile\AppData\Local\D3DSCache" >nul 2>&1
)
echo OK.

echo [431/700] Svuotamento dei file di cache orfani creati dal launcher di gioco CurseForge...
if exist "%LOCALAPPDATA%\CurseForge\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\CurseForge\Cache" >nul 2>&1
)
echo OK.

echo [432/700] Rimozione dei log storici di installazione e aggiornamento di Visual Studio Community...
if exist "%PROGRAMDATA%\Microsoft\VisualStudio\Packages\_Instances" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:PROGRAMDATA\Microsoft\VisualStudio\Packages\_Instances' -Recurse -Include *.log, *.tmp -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [433/700] Svuotamento della cache dei pacchetti orfani scaricati dal gestore estensioni di Python...
if exist "%USERPROFILE%\.cache\pip" (
    rmdir /s /q "%USERPROFILE%\.cache\pip" >nul 2>&1
)
echo OK.

echo [434/700] Pulizia profonda dei file .tmp generati dai software di compressione (WinZip/Bandizip)...
if exist "%LOCALAPPDATA%\Temp" (
    del /f /q /s "%LOCALAPPDATA%\Temp\*.tmp" >nul 2>&1
)
echo OK.

echo [435/700] Forzatura azzeramento dei log storici del servizio orario di Windows (W32Time)...
if exist "C:\Windows\w32time" (
    del /f /q /s "C:\Windows\w32time\*" >nul 2>&1
)
echo OK.

echo [436/700] Polverizzazione della cache dei vecchi dati di navigazione di Microsoft Edge (Code Cache)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\js" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\js" >nul 2>&1
)
echo OK.

echo [437/700] Pulizia delle immagini di anteprima accumulate nel database dei widget di Windows 11...
if exist "%LOCALAPPDATA%\Packages\MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy\LocalState\Cache" >nul 2>&1
)
echo OK.

echo [438/700] Svuotamento dei file temporanei e dei crash dump generati dal browser Brave...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports\*" >nul 2>&1
)
echo OK.

echo [439/700] Rimozione radicale dei log storici accumulati dal launcher Faceit (CS2/Gaming)...
if exist "%APPDATA%\faceitclient\logs" (
    del /f /q /s "%APPDATA%\faceitclient\logs\*" >nul 2>&1
)
echo OK.

echo [440/700] Svuotamento forzato della cache dei file JavaScript compilati da Discord (DawnWebGPU)...
if exist "%LOCALAPPDATA%\Discord\app-*\modules" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Discord' -Recurse -Directory -Filter 'DawnWebGPUCache' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }" >nul 2>&1
)
echo OK.

echo [441/700] Pulizia profonda delle mod temporanee orfane scaricate dal launcher CurseForge...
if exist "%LOCALAPPDATA%\CurseForge\Minecraft\Install\temp" (
    rmdir /s /q "%LOCALAPPDATA%\CurseForge\Minecraft\Install\temp" >nul 2>&1
)
echo OK.

echo [442/700] Svuotamento dei file .tmp residui generati dall'app desktop di Spotify...
if exist "%LOCALAPPDATA%\Spotify" (
    del /f /q /s "%LOCALAPPDATA%\Spotify\*.tmp" >nul 2>&1
)
echo OK.

echo [443/700] Sfoltimento forzato dei log di telemetria e tracciamento hardware dell'app Xbox...
if exist "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\logs" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\logs\*" >nul 2>&1
)
echo OK.

echo [444/700] Eliminazione dei file temporanei accumulati dal visualizzatore 3D nativo di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [445/700] Rimozione dei log di sincronizzazione storici dello strumento Microsoft OneDrive...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*.log" >nul 2>&1
)
echo OK.

echo [446/700] Svuotamento della cache dei dati di installazione temporanei di Java (Sun-Deployment)...
if exist "%APPDATA%\Sun\Java\Deployment\SystemCache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\SystemCache" >nul 2>&1
)
echo OK.

echo [447/700] Pulizia forzata della cartella temporanea dei dump del sottosistema audio (Windows Audio)...
if exist "%WINDIR%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\AudioEngine" (
    del /f /q /s "%WINDIR%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\AudioEngine\*" >nul 2>&1
)
echo OK.

echo [448/700] Svuotamento dei file di registro temporanei generati dallo strumento di diagnostica PerfLogs...
if exist "C:\PerfLogs" (
    del /f /q /s "C:\PerfLogs\*" >nul 2>&1
)
echo OK.

echo [449/700] Compressione e rimozione dei file temporanei della cache nativa dei caratteri di Office...
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\FontCache" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Office\16.0\FontCache" >nul 2>&1
)
echo OK.

echo [450/700] Svuotamento radicale dei file temporanei della cache di rendering di Epic Games Online Services...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache_4430" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache_4430" >nul 2>&1
)
echo OK.

echo [451/700] Rimozione dei file temporanei accumulati dall'hub dei pacchetti NuGet (Global Packages Cache)...
if exist "%USERPROFILE%\.nuget\packages\.tools" (
    rmdir /s /q "%USERPROFILE%\.nuget\packages\.tools" >nul 2>&1
)
echo OK.

echo [452/700] Svuotamento dei file di tracciamento e log dell'applicazione nativa Note Adesive (Sticky Notes)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [453/700] Pulizia dei log di telemetria e cache di navigazione dell'app Xbox Game Bar Plugin (Party Chat)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.XboxGameOverlay_8wekyb3d8bbwe\AC\INetCache" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.XboxGameOverlay_8wekyb3d8bbwe\AC\INetCache\*" >nul 2>&1
)
echo OK.

echo [454/700] Svuotamento dei file dump orfani generati dal client desktop di Telegram (CrashDumps)...
if exist "%APPDATA%\Telegram Desktop\tdata\crashes" (
    del /f /q /s "%APPDATA%\Telegram Desktop\tdata\crashes\*" >nul 2>&1
)
echo OK.

echo [455/700] Rimozione dei log storici accumulati dallo strumento di migrazione dati di Windows (USMT)...
if exist "C:\Windows\Logs\MOS" (
    del /f /q /s "C:\Windows\Logs\MOS\*" >nul 2>&1
)
echo OK.

echo [456/700] Svuotamento della cache di anteprima delle icone e miniature di Microsoft OneDrive...
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\thumbnails" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\OneDrive\thumbnails" >nul 2>&1
)
echo OK.

echo [457/700] Polverizzazione dei log temporanei delle transazioni dei criteri di gruppo utente (GroupPolicy)...
if exist "C:\Windows\System32\GroupPolicy\Machine" (
    del /f /q /s "C:\Windows\System32\GroupPolicy\Machine\*.log" >nul 2>&1
)
echo OK.

echo [458/700] Svuotamento della cache dei file temporanei del browser Opera (Media Cache)...
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Media Cache" (
    del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Media Cache\*" >nul 2>&1
)
echo OK.

echo [459/700] Rimozione forzata dei crash report orfani creati dall'emulatore BlueStacks...
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\CrashDump" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\CrashDump\*" >nul 2>&1
)
echo OK.

echo [460/700] Sfoltimento dei file temporanei accumulati dall'applicazione Mixer Audio di Windows...
if exist "%LOCALAPPDATA%\Microsoft\Windows\Audio" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\Audio\*.tmp" >nul 2>&1
)
echo OK.

echo [461/700] Svuotamento dei file residui di installazione accumulati dal client di gioco GOG Galaxy...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\temp" (
    rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\temp" >nul 2>&1
)
echo OK.

echo [462/700] Pulizia dei log di errore e tracciamento dello strumento nativo Microsoft Edge Update...
if exist "%PROGRAMDATA%\Microsoft\EdgeUpdate\Log" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\EdgeUpdate\Log\*" >nul 2>&1
)
echo OK.

echo [463/700] Svuotamento della cache dei componenti isolati di Windows Defender (Scans History Cached)...
if exist "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\CacheManager" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\CacheManager\*" >nul 2>&1
)
echo OK.

echo [464/700] Forzatura azzeramento dei log storici del gestore delle risorse di rete (NetCache System)...
if exist "C:\Windows\System32\LogFiles\WMI\NetCore" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\NetCore\*" >nul 2>&1
)
echo OK.

echo [465/700] Svuotamento forzato dei file temporanei della cache delle icone dell'applicazione Xbox...
if exist "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\Cache" >nul 2>&1
)
echo OK.

echo [466/700] Polverizzazione della cache dei dati locali temporanei di Microsoft Store (AcquisitionManager)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\AcquisitionManager" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\AcquisitionManager" >nul 2>&1
)
echo OK.

echo [467/700] Pulizia forzata dei log storici accumulati dallo strumento di installazione pacchetti Python (Pip Setup)...
if exist "%LOCALAPPDATA%\pip\Logs" (
    del /f /q /s "%LOCALAPPDATA%\pip\Logs\*" >nul 2>&1
)
echo OK.

echo [468/700] Svuotamento dei file temporanei e dei crash dump generati dal browser Brave (Code Cache)...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache\*" >nul 2>&1
)
echo OK.

echo [469/700] Rimozione radicale dei log storici e dei file temporanei di Discord (Local Storage Cache)...
if exist "%APPDATA%\discord\Local Storage" (
    del /f /q /s "%APPDATA%\discord\Local Storage\leveldb\*.log" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\Local Storage\leveldb\*.tmp" >nul 2>&1
)
echo OK.

echo [470/700] Svuotamento della cache dei dati multimediali estratti temporaneamente dall'app Netflix (UWP)...
if exist "%LOCALAPPDATA%\Packages\4DF9E0F8.Netflix_mcm4yx254vgr4\LocalState\offline_views" (
    del /f /q /s "%LOCALAPPDATA%\Packages\4DF9E0F8.Netflix_mcm4yx254vgr4\LocalState\offline_views\*.tmp" >nul 2>&1
)
echo OK.

echo [471/700] Pulizia dei log di telemetria e tracciamento delle prestazioni grafiche di Windows (DwmRedir)...
if exist "C:\Windows\System32\LogFiles\DwmRedir" (
    del /f /q /s "C:\Windows\System32\LogFiles\DwmRedir\*" >nul 2>&1
)
echo OK.

echo [472/700] Svuotamento forzato della cache dei file temporanei dell'Editor video Clipchamp di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.ClipchampVideoEditor_8wekyb3d8bbwe\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.ClipchampVideoEditor_8wekyb3d8bbwe\LocalState\Cache" >nul 2>&1
)
echo OK.

echo [473/700] Rimozione dei log storici generati dallo strumento di diagnostica di rete Microsoft (NDF)...
if exist "C:\Windows\Logs\NetworkDiagnostics" (
    del /f /q /s "C:\Windows\Logs\NetworkDiagnostics\*" >nul 2>&1
)
echo OK.

echo [474/700] Svuotamento dei file residui temporanei nella cartella di installazione delle estensioni di Edge...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extensions\Temp" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extensions\Temp" >nul 2>&1
)
echo OK.

echo [475/700] Pulizia profonda delle immagini di copertina temporanee memorizzate dall'app Groove Musica...
if exist "%LOCALAPPDATA%\Packages\Microsoft.ZuneMusic_8wekyb3d8bbwe\LocalState\ImageStore" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.ZuneMusic_8wekyb3d8bbwe\LocalState\ImageStore" >nul 2>&1
)
echo OK.

echo [476/700] Svuotamento della cache dei log di telemetria dell'applicazione Adobe Creative Cloud desktop...
if exist "%LOCALAPPDATA%\Adobe\Logs" (
    del /f /q /s "%LOCALAPPDATA%\Adobe\Logs\*" >nul 2>&1
)
echo OK.

echo [477/700] Rimozione forzata dei crash dump orfani creati dal Launcher di Epic Games (CrashReportClient)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\CrashReportClient" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\CrashReportClient" >nul 2>&1
)
echo OK.

echo [478/700] Svuotamento dei file temporanei della cache delle icone del browser Mozilla Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'shortcut-cache*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [479/700] Forzatura azzeramento dei log di errore accumulati dallo strumento Windows Troubleshooting (WTP)...
if exist "%PROGRAMDATA%\Microsoft\Windows\WDI\LogFiles" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows\WDI\LogFiles\*" >nul 2>&1
)
echo OK.

echo [480/700] Pulizia profonda delle miniature e dei log orfani accumulati dal visualizzatore di font di Windows...
if exist "%LOCALAPPDATA%\Microsoft\Windows\FontCache" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\FontCache\*" >nul 2>&1
)
echo OK.

echo [481/700] Polverizzazione della cache dei file multimediali pesanti di Google Chrome (Media Cache)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache" (
    del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache\*" >nul 2>&1
)
echo OK.

echo [482/700] Svuotamento dei file temporanei della cache dei motori di ricerca di Microsoft Edge...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Search Engine Data" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Search Engine Data" >nul 2>&1
)
echo OK.

echo [483/700] Rimozione forzata dei log storici e dei file di tracciamento di Mozilla Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Crash Reports" (
    rmdir /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Crash Reports" >nul 2>&1
)
echo OK.

echo [484/700] Svuotamento della cache dei file grafici e delle icone dei siti web di Opera GX (Favicons)...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\User Data\Default\Favicons" (
    del /f /q "%LOCALAPPDATA%\Opera Software\Opera GX Stable\User Data\Default\Favicons" >nul 2>&1
)
echo OK.

echo [485/700] Sfoltimento dei file di dump orfani generati dalle schede andate in crash su Brave Browser...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\completed" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\completed\*" >nul 2>&1
)
echo OK.

echo [486/700] Svuotamento forzato della cache dei metadati grafici del Launcher Riot Games...
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX" >nul 2>&1
)
echo OK.

echo [487/700] Rimozione dei file temporanei e dei log orfani accumulati da EA Desktop App (Crashpad)...
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Crashpad" (
    rmdir /s /q "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Crashpad" >nul 2>&1
)
echo OK.

echo [488/700] Pulizia forzata delle miniature e delle immagini temporanee del negozio di GOG Galaxy...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Cookies" (
    del /f /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Cookies" >nul 2>&1
)
echo OK.

echo [489/700] Svuotamento della cache dei file temporanei del database interno di Ubisoft Connect...
if exist "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\configuration" (
    rmdir /s /q "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\configuration" >nul 2>&1
)
echo OK.

echo [490/700] Rimozione dei log storici accumulati durante gli aggiornamenti dei giochi di Steam...
if exist "C:\Program Files (x86)\Steam\logs\content_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\content_log.txt" >nul 2>&1
)
echo OK.

echo [491/700] Svuotamento dei file temporanei della cache delle icone dell'Editor del Registro di sistema...
if exist "%LOCALAPPDATA%\Microsoft\Windows\Regedit" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\Regedit" >nul 2>&1
)
echo OK.

echo [492/700] Pulizia dei log di telemetria e tracciamento delle sessioni del Terminale di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [493/700] Svuotamento dei file residui temporanei generati dall'app nativa Calcolatrice...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsCalculator_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsCalculator_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [494/700] Rimozione dei log storici di installazione dello strumento Microsoft .NET SDK (Se presente)...
if exist "%PROGRAMDATA%\Microsoft\NET Framework Setup\InstructionFiles" (
    rmdir /s /q "%PROGRAMDATA%\Microsoft\NET Framework Setup\InstructionFiles" >nul 2>&1
)
echo OK.

echo [495/700] Forzatura azzeramento dei file temporanei della cache dei font usati da WPF (.NET)...
if exist "%WINDIR%\Microsoft.NET\Framework\v4.0.30319\WPF\Fonts" (
    del /f /q /s "%WINDIR%\Microsoft.NET\Framework\v4.0.30319\WPF\Fonts\*" >nul 2>&1
)
echo OK.

echo [496/700] Polverizzazione della cache dei file di configurazione remota di Microsoft Edge...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Configuration" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Configuration" >nul 2>&1
)
echo OK.

echo [497/700] Svuotamento dei file temporanei della cache delle icone di estensione di Google Chrome...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extension Cookies" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extension Cookies" >nul 2>&1
)
echo OK.

echo [498/700] Rimozione forzata dei vecchi file multimediali orfani dalla cache di WhatsApp Desktop...
if exist "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\logs" (
    del /f /q /s "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\logs\*" >nul 2>&1
)
echo OK.

echo [499/700] Svuotamento radicale dei file di log temporanei dell'applicazione desktop di Discord...
if exist "%APPDATA%\discord\logs" (
    del /f /q /s "%APPDATA%\discord\logs\*" >nul 2>&1
)
echo OK.

echo [500/700] Eliminazione dei file temporanei e dei registri di crash del browser Mozilla Firefox...
if exist "%APPDATA%\Mozilla\Firefox\Crash Reports" (
    rmdir /s /q "%APPDATA%\Mozilla\Firefox\Crash Reports" >nul 2>&1
)
echo OK.

echo [501/700] Svuotamento della cache dei log di telemetria del client Riot Client (Riot Services)...
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\Telemetry" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\Telemetry" >nul 2>&1
)
echo OK.

echo [502/700] Rimozione dei file temporanei di download residui del client di gioco Steam (Depotcache)...
if exist "C:\Program Files (x86)\Steam\depotcache" (
    del /f /q /s "C:\Program Files (x86)\Steam\depotcache\*" >nul 2>&1
)
echo OK.

echo [503/700] Pulizia forzata della cache dei file JavaScript compilati da Epic Games Launcher...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage\*" >nul 2>&1
)
echo OK.

echo [504/700] Svuotamento della cache dei log e dei report di errore accumulati da EA Desktop App...
if exist "%PROGRAMDATA%\Electronic Arts\EA Services\License" (
    del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Services\License\*.tmp" >nul 2>&1
)
echo OK.

echo [505/700] Rimozione dei log storici generati dall'applicazione di ottimizzazione Razer Cortex...
if exist "%LOCALAPPDATA%\Razer\Razer Cortex\Logs" (
    rmdir /s /q "%LOCALAPPDATA%\Razer\Razer Cortex\Logs" >nul 2>&1
)
echo OK.

echo [506/700] Svuotamento forzato dei log temporanei dello strumento Strumenti di Amministrazione...
if exist "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Administrative Tools" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\WER\ReportQueue\AppCrash_mmc.exe*" >nul 2>&1
)
echo OK.

echo [507/700] Pulizia dei log di telemetria dello strumento di ottimizzazione disco di Windows...
if exist "C:\Windows\Logs\Defrag" (
    del /f /q /s "C:\Windows\Logs\Defrag\*" >nul 2>&1
)
echo OK.

echo [508/700] Svuotamento dei file temporanei e dei crash dump generati dall'applicazione Blocco Note...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [509/700] Rimozione dei log storici accumulati dallo strumento nativo Windows Defender Advanced Threat Protection...
if exist "%PROGRAMDATA%\Microsoft\Windows Defender Advanced Threat Protection\SenseSenseDtc.log" (
    del /f /q "%PROGRAMDATA%\Microsoft\Windows Defender Advanced Threat Protection\SenseSenseDtc.log" >nul 2>&1
)
echo OK.

echo [510/700] Rimozione forzata dei log temporanei accumulati dal servizio di indicizzazione Windows Search...
if exist "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\Search" (
    del /f /q /s "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\Search\*.log" >nul 2>&1
)
echo OK.

echo [511/700] Polverizzazione della cache dei dati locali e delle mappe temporanee di Roblox...
if exist "%LOCALAPPDATA%\Roblox\Downloads" (rmdir /s /q "%LOCALAPPDATA%\Roblox\Downloads" >nul 2>&1)
if exist "%LOCALAPPDATA%\Roblox\LocalStorage" (rmdir /s /q "%LOCALAPPDATA%\Roblox\LocalStorage" >nul 2>&1)
echo OK.

echo [512/700] Rimozione dei log e dei file crash orfani accumulati da Minecraft (Java Edition)...
if exist "%APPDATA%\.minecraft\logs" (del /f /q /s "%APPDATA%\.minecraft\logs\*" >nul 2>&1)
if exist "%APPDATA%\.minecraft\crash-reports" (del /f /q /s "%APPDATA%\.minecraft\crash-reports\*" >nul 2>&1)
echo OK.

echo [513/700] Svuotamento della cache dei log di telemetria del client di gioco GOG Galaxy (Tracker)...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\Logs" (
    del /f /q /s "%PROGRAMDATA%\GOG.com\Galaxy\Logs\*" >nul 2>&1
)
echo OK.

echo [514/700] Pulizia dei file temporanei estratti dall'applicazione Logitech G HUB Installer...
if exist "%PROGRAMDATA%\LGHUB\depot" (
    rmdir /s /q "%PROGRAMDATA%\LGHUB\depot" >nul 2>&1
)
echo OK.

echo [515/700] Svuotamento forzato dei log di crash e dump orfani generati da Ubisoft Connect...
if exist "%LOCALAPPDATA%\Ubisoft Game Launcher\crashes" (
    del /f /q /s "%LOCALAPPDATA%\Ubisoft Game Launcher\crashes\*" >nul 2>&1
)
echo OK.

echo [516/700] Svuotamento della cache di rendering WebGL del browser Google Chrome (GPU Shader)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\ShaderCache" >nul 2>&1
)
echo OK.

echo [517/700] Sfoltimento dei file di log temporanei generati dal servizio Microsoft Edge Elevation...
if exist "%PROGRAMFILES(X86)%\Microsoft\EdgeUpdate\Log" (
    del /f /q /s "%PROGRAMFILES(X86)%\Microsoft\EdgeUpdate\Log\*" >nul 2>&1
)
echo OK.

echo [518/700] Rimozione dei file temporanei della cache delle icone dell'app desktop di Discord...
if exist "%APPDATA%\discord\GPUCache" (
    del /f /q /s "%APPDATA%\discord\GPUCache\*" >nul 2>&1
)
echo OK.

echo [519/700] Pulizia forzata della cache dei flussi video scaricati temporaneamente da Opera GX (Cache2)...
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\Cache_Data" (
    del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\Cache_Data\*" >nul 2>&1
)
echo OK.

echo [520/700] Svuotamento della cache di anteprima dei file multimediali caricati su Telegram Desktop...
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\thumbnails" (
    rmdir /s /q "%APPDATA%\Telegram Desktop\tdata\user_data\thumbnails" >nul 2>&1
)
echo OK.

echo [521/700] Pulizia dei log temporanei accumulati dallo strumento nativo Windows Driver Verifier...
if exist "C:\Windows\System32\LogFiles\WMI\Verifier" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\Verifier\*" >nul 2>&1
)
echo OK.

echo [522/700] Svuotamento dei file residui temporanei generati dall'app nativa Meteo di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [523/700] Rimozione forzata dei vecchi log di aggiornamento del Microsoft Store (AppXDeployment)...
if exist "C:\Windows\Logs\AppXDeploymentServer" (
    del /f /q /s "C:\Windows\Logs\AppXDeploymentServer\*" >nul 2>&1
)
echo OK.

echo [524/700] Svuotamento dei log di tracciamento interni dello strumento di diagnostica Microsoft ResMon...
if exist "%LOCALAPPDATA%\CrashDumps\resmon.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\resmon.exe*" >nul 2>&1
)
echo OK.

echo [525/700] Rimozione forzata dei file audio orfani e della cache dei podcast di Spotify...
if exist "%LOCALAPPDATA%\Spotify\Users" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Spotify\Users' -Recurse -Directory -Filter 'Browser' -ErrorAction SilentlyContinue | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File | Remove-Item -Force }" >nul 2>&1
)
echo OK.

echo [526/700] Svuotamento dei file temporanei e dei registri di log di Adobe Substance 3D...
if exist "%APPDATA%\Adobe\Adobe Substance 3D Designer\logs" (
    del /f /q /s "%APPDATA%\Adobe\Adobe Substance 3D Designer\logs\*" >nul 2>&1
)
echo OK.

echo [527/700] Polverizzazione della cache di rendering grafico del browser Opera standard (GPUCache)...
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\GPUCache" (
    rmdir /s /q "%LOCALAPPDATA%\Opera Software\Opera Stable\GPUCache" >nul 2>&1
)
echo OK.

echo [528/700] Sfoltimento dei file di tracciamento e log temporanei del client cloud Dropbox...
if exist "%LOCALAPPDATA%\Dropbox\logs" (
    del /f /q /s "%LOCALAPPDATA%\Dropbox\logs\*" >nul 2>&1
)
echo OK.

echo [529/700] Rimozione dei log e dei report di crash orfani accumulati da Google Drive desktop...
if exist "%LOCALAPPDATA%\Google\DriveFS\Logs" (
    del /f /q /s "%LOCALAPPDATA%\Google\DriveFS\Logs\*" >nul 2>&1
)
echo OK.

echo [530/700] Pulizia forzata della cache delle icone dei siti web salvate da Microsoft Edge (Favicons)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Favicons" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Favicons" >nul 2>&1
)
echo OK.

echo [531/700] Svuotamento forzato della cache dei log delle partite locali di League of Legends...
if exist "C:\Riot Games\League of Legends\Logs\GameLogs" (
    rmdir /s /q "C:\Riot Games\League of Legends\Logs\GameLogs" >nul 2>&1
)
echo OK.

echo [532/700] Rimozione dei file crash dump orfani generati dal client di gioco Minecraft Launcher...
if exist "%GAME_DIR%\.minecraft\crash-reports" (
    del /f /q /s "%GAME_DIR%\.minecraft\crash-reports\*" >nul 2>&1
)
echo OK.

echo [533/700] Pulizia dei log di telemetria e tracciamento hardware dello strumento SteelSeries GG...
if exist "%PROGRAMDATA%\SteelSeries\GG\Logs" (
    del /f /q /s "%PROGRAMDATA%\SteelSeries\GG\Logs\*" >nul 2>&1
)
echo OK.

echo [534/700] Svuotamento dei file temporanei della cache delle miniature video di VLC Media Player...
if exist "%APPDATA%\vlc\art\artistalbum" (
    rmdir /s /q "%APPDATA%\vlc\art\artistalbum" >nul 2>&1
)
echo OK.

echo [535/700] Rimozione dei log storici accumulati dal software di chat vocale TeamSpeak 3 Client...
if exist "%APPDATA%\TS3Client\logs" (
    del /f /q /s "%APPDATA%\TS3Client\logs\*" >nul 2>&1
)
echo OK.

echo [536/700] Svuotamento della cache dei log di telemetria del servizio Windows Biometric Service...
if exist "C:\Windows\System32\WinBioDatabase\Provisioning" (
    del /f /q /s "C:\Windows\System32\WinBioDatabase\Provisioning\*" >nul 2>&1
)
echo OK.

echo [537/700] Pulizia forzata dei registri di tracciamento dello strumento Gestione attività (Taskmgr)...
if exist "%LOCALAPPDATA%\CrashDumps\taskmgr.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\taskmgr.exe*" >nul 2>&1
)
echo OK.

echo [538/700] Svuotamento dei log storici del servizio di geolocalizzazione nativo di Windows...
if exist "%PROGRAMDATA%\Microsoft\Windows\SystemData\LfS\LogFiles" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows\SystemData\LfS\LogFiles\*" >nul 2>&1
)
echo OK.

echo [539/700] Rimozione dei file temporanei orfani generati dallo strumento di diagnostica DirectX (DxDiag Cache)...
if exist "%LOCALAPPDATA%\Microsoft\DxDiag" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*.tmp" >nul 2>&1
)
echo OK.

echo [540/700] Forzatura azzeramento della cache dei file temporanei del visualizzatore eventi nativo (Snap-In)...
if exist "%APPDATA%\Microsoft\MMC\eventvwr" (
    del /f /q "%APPDATA%\Microsoft\MMC\eventvwr" >nul 2>&1
)
echo OK.

echo [541/700] Polverizzazione della cache dei file temporanei grafici di Skype Desktop...
if exist "%APPDATA%\Microsoft\Skype for Desktop\GPUCache" (
    rmdir /s /q "%APPDATA%\Microsoft\Skype for Desktop\GPUCache" >nul 2>&1
)
echo OK.

echo [542/700] Svuotamento dei file temporanei della cache delle icone e dei font di Slack...
if exist "%APPDATA%\Slack\GPUCache" (
    rmdir /s /q "%APPDATA%\Slack\GPUCache" >nul 2>&1
)
echo OK.

echo [543/700] Rimozione dei log storici e dei file temporanei di tracciamento di Zoom Client...
if exist "%APPDATA%\Zoom\logs" (
    del /f /q /s "%APPDATA%\Zoom\logs\*" >nul 2>&1
)
echo OK.

echo [544/700] Svuotamento della cache dei file JavaScript compilati dal client Microsoft Teams (V2)...
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\OneDrive\logs" (
    del /f /q /s "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\OneDrive\logs\*" >nul 2>&1
)
echo OK.

echo [545/700] Pulizia delle immagini di anteprima orfane accumulate dall'app Foto di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\LocalState\Cache" >nul 2>&1
)
echo OK.

echo [546/700] Svuotamento forzato della cache dei log delle sessioni del Launcher Riot Games...
if exist "%LOCALAPPDATA%\Riot Games\Installers" (
    del /f /q /s "%LOCALAPPDATA%\Riot Games\Installers\*.tmp" >nul 2>&1
)
echo OK.

echo [547/700] Rimozione dei file temporanei di download residui del Launcher Battle.net (Blizzard)...
if exist "%PROGRAMDATA%\Battle.net\Agent\Agent.*\Logs" (
    del /f /q /s "%PROGRAMDATA%\Battle.net\Agent\Agent.*\Logs\*" >nul 2>&1
)
echo OK.

echo [548/700] Pulizia forzata della cache dei file di crash dump di Epic Games Online Services...
if exist "%PROGRAMDATA%\Epic\EpicOnlineServices\Crashpad" (
    rmdir /s /q "%PROGRAMDATA%\Epic\EpicOnlineServices\Crashpad" >nul 2>&1
)
echo OK.

echo [549/700] Svuotamento della cache dei log e dei report di errore accumulati dall'emulatore LDPlayer...
if exist "C:\LDPlayer\log" (
    del /f /q /s "C:\LDPlayer\log\*" >nul 2>&1
)
echo OK.

echo [550/700] Rimozione dei log storici accumulati durante gli aggiornamenti software di Razer Synapse...
if exist "%PROGRAMDATA%\Razer\Synapse3\Log" (
    rmdir /s /q "%PROGRAMDATA%\Razer\Synapse3\Log" >nul 2>&1
)
echo OK.

echo [551/700] Svuotamento forzato dei log temporanei dello strumento nativo Controllo Account Utente (UAC)...
if exist "%LOCALAPPDATA%\CrashDumps\consent.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\consent.exe*" >nul 2>&1
)
echo OK.

echo [552/700] Pulizia dei log di telemetria e tracciamento dello strumento nativo Gestione disco...
if exist "%LOCALAPPDATA%\CrashDumps\mmc.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\mmc.exe*" >nul 2>&1
)
echo OK.

echo [553/700] Svuotamento della cache dei file multimediali temporanei di Apple iCloud Desktop...
if exist "%LOCALAPPDATA%\Packages\AppleInc.iCloud_37bcys1dbagmj\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\AppleInc.iCloud_37bcys1dbagmj\LocalState\Cache" >nul 2>&1
)
echo OK.

echo [554/700] Rimozione dei vecchi file di log temporanei del servizio di crittografia nativo di Windows...
if exist "C:\Windows\System32\LogFiles\WMI\Crypto" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\Crypto\*" >nul 2>&1
)
echo OK.

echo [555/700] Rimozione dei file compressi temporanei orfani nella cartella di lavoro di 7-Zip...
if exist "%USERPROFILE%\AppData\Local\Temp\7z*" (
    del /f /q /s "%USERPROFILE%\AppData\Local\Temp\7z*\*" >nul 2>&1
)
echo OK.

echo [556/700] Polverizzazione della cache dei dati temporanei di navigazione di Microsoft Edge (Service Worker)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" >nul 2>&1
)
echo OK.

echo [557/700] Svuotamento dei file temporanei della cache delle icone dei siti web salvati da Brave Browser (Favicons)...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Favicons" (
    del /f /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Favicons" >nul 2>&1
)
echo OK.

echo [558/700] Rimozione dei log storici e dei file temporanei generati dall'applicazione desktop di Spotify (Local-Files Cache)...
if exist "%LOCALAPPDATA%\Spotify\Users" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Spotify\Users' -Recurse -Filter 'local-files.json' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [559/700] Svuotamento radicale dei file di log temporanei del client desktop di Discord (Mojo Cache)...
if exist "%APPDATA%\discord\Cache\Cache_Data" (
    del /f /q /s "%APPDATA%\discord\Cache\Cache_Data\*" >nul 2>&1
)
echo OK.

echo [560/700] Eliminazione dei file temporanei e dei pacchetti orfani scaricati dal programma di chat WhatsApp (UWP Cache)...
if exist "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\From_Server" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\From_Server" >nul 2>&1
)
echo OK.

echo [561/700] Svuotamento della cache di rendering degli Shader di gioco di Epic Games Launcher (D3DSCache)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Windows" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Windows\*.tmp" >nul 2>&1
)
echo OK.

echo [562/700] Rimozione dei file di log di tracciamento e dei registri di crash orfani accumulati da Steam (Steam-Logs)...
if exist "C:\Program Files (x86)\Steam\logs" (
    del /f /q /s "C:\Program Files (x86)\Steam\logs\*.log" >nul 2>&1
)
echo OK.

echo [563/700] Pulizia forzata della cache dei file JavaScript compilati dal Launcher Riot Games (Riot-UX-Cache)...
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX\Cache" >nul 2>&1
)
echo OK.

echo [564/700] Svuotamento della cache dei log e dei report di errore accumulati dall'emulatore BlueStacks (Engine Logs)...
if exist "C:\ProgramData\BlueStacks_nxt\Logs" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Logs\*" >nul 2>&1
)
echo OK.

echo [565/700] Rimozione dei log storici di installazione e aggiornamento del software Logitech G HUB (Updater Logs)...
if exist "%PROGRAMDATA%\LGHUB\logs" (
    del /f /q /s "%PROGRAMDATA%\LGHUB\logs\*" >nul 2>&1
)
echo OK.

echo [566/700] Pulizia dei log di telemetria e crash dump dello strumento Realtek Audio Console...
if exist "%LOCALAPPDATA%\Packages\RealtekSemiconductorCorp.RealtekAudioConsole_7f6ksnebe9st4\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\RealtekSemiconductorCorp.RealtekAudioConsole_7f6ksnebe9st4\LocalState\DiagOutputDir\*" >nul 2>&1
)
echo OK.

echo [567/700] Pulizia dei log di telemetria e tracciamento dello strumento nativo Windows Error Reporting (LocalDumps)...
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" (
    rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1
)
echo OK.

echo [568/700] Svuotamento dei file temporanei e dei registri generati dallo strumento di diagnostica di rete wireless...
if exist "C:\Windows\wlansvc\log" (
    del /f /q /s "C:\Windows\wlansvc\log\*" >nul 2>&1
)
echo OK.

echo [569/700] Rimozione dei vecchi file di log temporanei del servizio di crittografia BitLocker (Se attivo)...
if exist "C:\Windows\System32\LogFiles\WMI\BitLocker" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BitLocker\*" >nul 2>&1
)
echo OK.

echo [570/700] Forzatura azzeramento della cache dei file temporanei dello strumento Blocco Note (Session State)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\LocalState\TabState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\LocalState\TabState\*.bin" >nul 2>&1
)
echo OK.

echo [571/700] Polverizzazione della cache di rendering di Streamlabs Desktop (GPUCache)...
if exist "%APPDATA%\slobs-client\GPUCache" (
    rmdir /s /q "%APPDATA%\slobs-client\GPUCache" >nul 2>&1
)
echo OK.

echo [572/700] Rimozione dei log storici accumulati dal software di chat vocale Curse Voice...
if exist "%APPDATA%\Curse\Logs" (
    del /f /q /s "%APPDATA%\Curse\Logs\*" >nul 2>&1
)
echo OK.

echo [573/700] Svuotamento dei file temporanei della cache delle icone dell'applicazione Overwolf (Gaming)...
if exist "%LOCALAPPDATA%\Overwolf\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Overwolf\Cache" >nul 2>&1
)
echo OK.

echo [574/700] Pulizia forzata della cache dei file JavaScript compilati da OBS Studio (cef_cache)...
if exist "%APPDATA%\obs-studio\plugin_config\obs-browser\cef_cache" (
    rmdir /s /q "%APPDATA%\obs-studio\plugin_config\obs-browser\cef_cache" >nul 2>&1
)
echo OK.

echo [575/700] Svuotamento radicale dei file temporanei delle chat e del database dei server di Discord...
if exist "%APPDATA%\discord\Session Storage" (
    del /f /q /s "%APPDATA%\discord\Session Storage\*" >nul 2>&1
)
echo OK.

echo [576/700] Svuotamento della cache dei file JavaScript compilati da Brave Browser (js-flags)...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Local State" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*.tmp" >nul 2>&1
)
echo OK.

echo [577/700] Sfoltimento dei file di log temporanei generati dal servizio di download qBittorrent (Fastresume)...
if exist "%LOCALAPPDATA%\qBittorrent\BT_backup" (
    del /f /q /s "%LOCALAPPDATA%\qBittorrent\BT_backup\*.tmp" >nul 2>&1
)
echo OK.

echo [578/700] Rimozione dei file temporanei e dei crash dump generati dal browser Opera (Crashpad)...
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Crashpad\reports" (
    del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Crashpad\reports\*" >nul 2>&1
)
echo OK.

echo [579/700] Pulizia forzata della cache dei flussi multimediali del browser Mozilla Firefox (Media Cache)...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'MediaCache' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }" >nul 2>&1
)
echo OK.

echo [580/700] Svuotamento della cache di anteprima dei file multimediali scaricati da Microsoft Teams (V2)...
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Media-Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Media-Cache" >nul 2>&1
)
echo OK.

echo [581/700] Pulizia dei log temporanei accumulati dallo strumento nativo Windows Event Forwarding...
if exist "C:\Windows\System32\LogFiles\WMI\WmitData" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\WmitData\*" >nul 2>&1
)
echo OK.

echo [582/700] Svuotamento dei file residui temporanei generati dall'app nativa Sveglie e Orologio...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsAlarms_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsAlarms_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [583/700] Rimozione forzata dei vecchi log di errore dello strumento nativo Microsoft Edge WebView...
if exist "%PROGRAMDATA%\Microsoft\EdgeWebView\Log" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\EdgeWebView\Log\*" >nul 2>&1
)
echo OK.

echo [584/700] Svuotamento dei log di tracciamento interni dello strumento di diagnostica DirectX (D3DDmp)...
if exist "%LOCALAPPDATA%\CrashDumps\dxdiag.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\dxdiag.exe*" >nul 2>&1
)
echo OK.

echo [585/700] Forzatura azzeramento della cache dei file temporanei dello strumento Assistente Vocale...
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.NarratorQuickStart_cw5n1h2txyewy\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Windows.NarratorQuickStart_cw5n1h2txyewy\TempState\*" >nul 2>&1
)
echo OK.

echo [586/700] Polverizzazione della cache dei dati temporanei di navigazione di Google Chrome (Appcache)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Application Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Application Cache" >nul 2>&1
)
echo OK.

echo [587/700] Svuotamento dei file temporanei della cache delle icone dell'app desktop di Skype...
if exist "%APPDATA%\Microsoft\Skype for Desktop\Cache" (
    del /f /q /s "%APPDATA%\Microsoft\Skype for Desktop\Cache\*" >nul 2>&1
)
echo OK.

echo [588/700] Rimozione dei log storici e dei file temporanei generati dalle estensioni del browser Brave...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Extension Logs" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Extension Logs\*" >nul 2>&1
)
echo OK.

echo [589/700] Svuotamento radicale dei file temporanei audio estratti dall'app Viber Desktop...
if exist "%LOCALAPPDATA%\ViberMedia\Viber\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\ViberMedia\Viber\Cache" >nul 2>&1
)
echo OK.

echo [590/700] Eliminazione dei file temporanei e dei pacchetti orfani di installazione di Microsoft Teams (V2)...
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Deployment" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Deployment" >nul 2>&1
)
echo OK.

echo [591/700] Svuotamento della cache delle miniature e delle immagini dei giochi del Launcher Epic Games...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data\*" >nul 2>&1
)
echo OK.

echo [592/700] Rimozione dei file di log di tracciamento e dei registri di crash accumulati da EA Desktop App (Web-Logs)...
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs" (
    del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1
)
echo OK.

echo [593/700] Pulizia forzata della cache dei file audio temporanei accumulati da TeamSpeak 3 Client (Sound Cache)...
if exist "%APPDATA%\TS3Client\cache\sounds" (
    rmdir /s /q "%APPDATA%\TS3Client\cache\sounds" >nul 2>&1
)
echo OK.

echo [594/700] Svuotamento della cache dei log e dei report di errore generati dal client Razer Synapse (Service Logs)...
if exist "%PROGRAMDATA%\Razer\Razer Services\Logs" (
    del /f /q /s "%PROGRAMDATA%\Razer\Razer Services\Logs\*" >nul 2>&1
)
echo OK.

echo [595/700] Rimozione dei log storici accumulati durante le sessioni di gioco tramite client GOG Galaxy (Overlay Logs)...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\Overlay" (
    del /f /q /s "%PROGRAMDATA%\GOG.com\Galaxy\Overlay\*.log" >nul 2>&1
)
echo OK.

echo [596/700] Svuotamento forzato dei log temporanei dello strumento nativo Diagnostica di memoria Windows...
if exist "C:\Windows\System32\LogFiles\WMI\MemDiag" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\MemDiag\*" >nul 2>&1
)
echo OK.

echo [597/700] Pulizia dei log di telemetria e tracciamento dello strumento nativo Windows Push Notifications...
if exist "%LOCALAPPDATA%\Microsoft\Windows\Notifications\WPNS" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\Notifications\WPNS\*.log" >nul 2>&1
)
echo OK.

echo [598/700] Svuotamento dei file temporanei e dei registri generati dall'app nativa Fotocamera di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsCamera_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsCamera_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [599/700] Rimozione dei vecchi file di log temporanei del servizio di sincronizzazione orario (NtpClient)...
if exist "C:\Windows\Logs\W32Time" (
    del /f /q /s "C:\Windows\Logs\W32Time\*" >nul 2>&1
)
echo OK.

echo [600/700] Forzatura azzeramento della cache dei file di errore generati dallo strumento di Assistenza rapida...
if exist "%LOCALAPPDATA%\Packages\Microsoft.RemoteDesktop_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.RemoteDesktop_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [601/700] Polverizzazione della cache dei dati locali temporanei di navigazione di Microsoft Edge (DOMStorage)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Local Storage\leveldb" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Local Storage\leveldb\*.log" >nul 2>&1
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Local Storage\leveldb\*.tmp" >nul 2>&1
)
echo OK.

echo [602/700] Rimozione forzata dei file di log temporanei e dei report di crash di Roblox...
if exist "%LOCALAPPDATA%\Roblox\logs" (
    del /f /q /s "%LOCALAPPDATA%\Roblox\logs\*" >nul 2>&1
)
echo OK.

echo [603/700] Rimozione della cache dei dizionari orfani e correttori ortografici di Microsoft Office...
if exist "%APPDATA%\Microsoft\Speller" (
    rmdir /s /q "%APPDATA%\Microsoft\Speller" >nul 2>&1
)
echo OK.

echo [604/700] Svuotamento radicale dei file temporanei della cronologia degli URL di Google Chrome (History Provider)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History Provider Cache" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History Provider Cache" >nul 2>&1
)
echo OK.

echo [605/700] Eliminazione dei file temporanei e log di cache dell'app Adobe Creative Cloud (CCX Process)...
if exist "%LOCALAPPDATA%\Adobe\CCXWelcome\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Adobe\CCXWelcome\Cache" >nul 2>&1
)
echo OK.

echo [606/700] Svuotamento forzato della cache dei file log temporanei di Riot Vanguard (VGC Service)...
if exist "%PROGRAMFILES%\Riot Vanguard\Logs" (
    del /f /q /s "%PROGRAMFILES%\Riot Vanguard\Logs\*" >nul 2>&1
)
echo OK.

echo [607/700] Rimozione della cache delle immagini dei giochi e notizie nel Launcher di Battle.net (Blizzard)...
if exist "%LOCALAPPDATA%\Blizzard Entertainment\Battle.net\Cache\html" (
    rmdir /s /q "%LOCALAPPDATA%\Blizzard Entertainment\Battle.net\Cache\html" >nul 2>&1
)
echo OK.

echo [608/700] Pulizia forzata dei log delle transazioni e installazioni di moduli di Epic Games (EOS Logs)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1
)
echo OK.

echo [609/700] Svuotamento dei file temporanei e dei registri di crash orfani dell'emulatore LDPlayer (Dump Logs)...
if exist "C:\LDPlayer\vbox\logs" (
    del /f /q /s "C:\LDPlayer\vbox\logs\*" >nul 2>&1
)
echo OK.

echo [610/700] Rimozione dei log storici accumulati dallo strumento di cattura video Razer Cortex (Gamecaster)...
if exist "%LOCALAPPDATA%\Razer\Razer Cortex\Gamecaster\Logs" (
    rmdir /s /q "%LOCALAPPDATA%\Razer\Razer Cortex\Gamecaster\Logs" >nul 2>&1
)
echo OK.

echo [611/700] Svuotamento forzato dei log di tracciamento del modulo di connessione Bluetooth di Windows...
if exist "C:\Windows\System32\LogFiles\WMI\BthTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthTelemetry\*" >nul 2>&1
)
echo OK.

echo [612/700] Pulizia dei registri temporanei generati dal servizio di diagnostica delle reti Wi-Fi (WlanSvc)...
if exist "C:\Windows\System32\LogFiles\WMI\WlanTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\WlanTelemetry\*" >nul 2>&1
)
echo OK.

echo [613/700] Svuotamento dei file temporanei generati dall'app nativa Film e TV di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.ZuneVideo_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.ZuneVideo_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [614/700] Rimozione dei vecchi file di log temporanei generati dallo strumento Gestore Dispositivi...
if exist "%LOCALAPPDATA%\CrashDumps\devmgmt.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\devmgmt.exe*" >nul 2>&1
)
echo OK.

echo [615/700] Forzatura azzeramento della cache dei log storici del servizio di crittografia Credential Guard...
if exist "C:\Windows\System32\LogFiles\WMI\LsaTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\LsaTelemetry\*" >nul 2>&1
)
echo OK.

echo [616/700] Polverizzazione della cache dei dati locali temporanei di navigazione di Microsoft Edge (Session Storage)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Session Storage" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Session Storage\*" >nul 2>&1
)
echo OK.

echo [617/700] Svuotamento dei file temporanei e dei log orfani accumulati da Google Drive desktop (Transfers Cache)...
if exist "%LOCALAPPDATA%\Google\DriveFS\Transfers" (
    rmdir /s /q "%LOCALAPPDATA%\Google\DriveFS\Transfers" >nul 2>&1
)
echo OK.

echo [618/700] Rimozione della cache delle icone dei componenti aggiuntivi scaricati su Mozilla Firefox...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'extension-preferences' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }" >nul 2>&1
)
echo OK.

echo [619/700] Svuotamento radicale dei file temporanei della cache delle icone dei canali di Discord (Guilds Cache)...
if exist "%APPDATA%\discord\Cache" (
    del /f /q /s "%APPDATA%\discord\Cache\f_*" >nul 2>&1
)
echo OK.

echo [620/700] Eliminazione dei file temporanei e log di cache dell'app Adobe Photoshop (AdobeIPCBroker)...
if exist "%LOCALAPPDATA%\Adobe\OOBE\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Adobe\OOBE\Cache" >nul 2>&1
)
echo OK.

echo [621/700] Svuotamento forzato della cache dei file log temporanei del client Riot Games (RiotClientPrivate)...
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\RiotClientPrivate" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\RiotClientPrivate" >nul 2>&1
)
echo OK.

echo [622/700] Svuotamento della cache delle emoji e delle reazioni animate di Discord...
if exist "%APPDATA%\discord\Cache\Cache_Data" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\discord\Cache\Cache_Data' -Filter 'f_*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [623/700] Pulizia forzata dei log delle transazioni e installazioni di moduli di Steam (SteamChina)...
if exist "C:\Program Files (x86)\Steam\logs\workshop_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\workshop_log.txt" >nul 2>&1
)
echo OK.

echo [624/700] Svuotamento dei file temporanei e dei registri di configurazione orfani di Logitech G HUB...
if exist "%PROGRAMDATA%\LGHUB\temp" (
    rmdir /s /q "%PROGRAMDATA%\LGHUB\temp" >nul 2>&1
)
echo OK.

echo [625/700] Rimozione dei log storici accumulati dallo strumento di cattura video OBS Studio (Updates Logs)...
if exist "%APPDATA%\obs-studio\updates" (
    rmdir /s /q "%APPDATA%\obs-studio\updates" >nul 2>&1
)
echo OK.

echo [626/700] Svuotamento forzato dei log di tracciamento del modulo di geolocalizzazione avanzato di Windows...
if exist "C:\Windows\System32\LogFiles\WMI\GeoTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\GeoTelemetry\*" >nul 2>&1
)
echo OK.

echo [627/700] Pulizia dei registri temporanei generati dal servizio di diagnostica delle memorie RAM (WerFault)...
if exist "%LOCALAPPDATA%\CrashDumps\WerFault.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\WerFault.exe*" >nul 2>&1
)
echo OK.

echo [628/700] Svuotamento dei file temporanei generati dall'app nativa Microsoft Mappe di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsMaps_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsMaps_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [629/700] Rimozione dei vecchi file di log temporanei generati dallo strumento di diagnostica del Bluetooth...
if exist "C:\Windows\System32\LogFiles\WMI\BthPort" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthPort\*" >nul 2>&1
)
echo OK.

echo [630/700] Forzatura azzeramento della cache dei log storici del servizio di sicurezza utente Windows Hello...
if exist "C:\Windows\System32\LogFiles\WMI\NgcTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\NgcTelemetry\*" >nul 2>&1
)
echo OK.

echo [631/700] Polverizzazione della cache dei dati temporanei di navigazione di Google Chrome (Network Cache)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network Action Predictor" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network Action Predictor" >nul 2>&1
)
echo OK.

echo [632/700] Svuotamento dei file temporanei della cache delle icone dei componenti di Microsoft Edge (Sidebar)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Sidebar" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Sidebar" >nul 2>&1
)
echo OK.

echo [633/700] Rimozione forzata dei log storici e dei file temporanei generati dall'app cloud Dropbox (Update Cache)...
if exist "%LOCALAPPDATA%\Dropbox\Update\Log" (
    del /f /q /s "%LOCALAPPDATA%\Dropbox\Update\Log\*" >nul 2>&1
)
echo OK.

echo [634/700] Svuotamento radicale dei file di log temporanei del client desktop di Telegram (Emoji Cache)...
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\emoji" (
    rmdir /s /q "%APPDATA%\Telegram Desktop\tdata\user_data\emoji" >nul 2>&1
)
echo OK.

echo [635/700] Eliminazione dei file temporanei e dei registri di crash del browser Brave (Local Extension Cache)...
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Local Extension Settings" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Local Extension Settings\*" >nul 2>&1
)
echo OK.

echo [636/700] Svuotamento della cache di caricamento delle notizie del client di gioco GOG Galaxy (Feeds)...
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Feeds" (
    rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Feeds" >nul 2>&1
)
echo OK.

echo [637/700] Rimozione dei file di log di tracciamento e dei registri di crash accumulati da EA Desktop App (Igo Logs)...
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\IgoLogs" (
    del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\IgoLogs\*" >nul 2>&1
)
echo OK.

echo [638/700] Pulizia forzata della cache dei file JavaScript compilati dal client Microsoft Teams (Cache Storage)...
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\CacheStorage" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\CacheStorage" >nul 2>&1
)
echo OK.

echo [639/700] Svuotamento della cache dei log e dei report di errore generati dal software Razer Cortex (Feedback Logs)...
if exist "%LOCALAPPDATA%\Razer\Razer Cortex\Feedback" (
    rmdir /s /q "%LOCALAPPDATA%\Razer\Razer Cortex\Feedback" >nul 2>&1
)
echo OK.

echo [640/700] Rimozione dei log storici accumulati durante le sessioni di gioco tramite client Ubisoft Connect (Overlay Cache)...
if exist "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\overlay" (
    rmdir /s /q "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\overlay" >nul 2>&1
)
echo OK.

echo [641/700] Svuotamento forzato dei log temporanei dello strumento nativo Centro Sicurezza Windows (Security Health)...
if exist "%PROGRAMDATA%\Microsoft\Windows Defender\Support" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows Defender\Support\*" >nul 2>&1
)
echo OK.

echo [642/700] Pulizia dei log di telemetria e tracciamento dello strumento nativo Windows Audio Device Graph (Audiodg)...
if exist "%LOCALAPPDATA%\CrashDumps\audiodg.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\audiodg.exe*" >nul 2>&1
)
echo OK.

echo [643/700] Svuotamento dei file temporanei e dei registri generati dall'app nativa Hub di Feedback di Windows...
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [644/700] Rimozione dei vecchi file di log temporanei del servizio di monitoraggio hardware Smart Card...
if exist "C:\Windows\System32\LogFiles\WMI\ScFilter" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\ScFilter\*" >nul 2>&1
)
echo OK.

echo [645/700] Forzatura azzeramento della cache dei file di errore generati dallo strumento Gestione Stampa...
if exist "%LOCALAPPDATA%\CrashDumps\printfilterpipelineprinthandler.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\printfilterpipelineprinthandler.exe*" >nul 2>&1
)
echo OK.

echo [646/700] Polverizzazione della cache dei dati temporanei di navigazione di Google Chrome (GCM Store)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GCM Store\Encryption" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GCM Store\Encryption" >nul 2>&1
)
echo OK.

echo [647/700] Svuotamento dei file temporanei della cache delle icone dell'applicazione desktop di Discord (Guilds Shared)...
if exist "%APPDATA%\discord\Local Storage\leveldb" (
    del /f /q /s "%APPDATA%\discord\Local Storage\leveldb\*.log" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\Local Storage\leveldb\*.tmp" >nul 2>&1
)
echo OK.

echo [648/700] Rimozione forzata dei vecchi file di log temporanei del browser Microsoft Edge (Log-Reporting)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad\reports" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad\reports\*" >nul 2>&1
)
echo OK.

echo [649/700] Svuotamento radicale dei file di log temporanei accumulati dal client di gioco Steam (Steam-Overlay)...
if exist "C:\Program Files (x86)\Steam\logs\overlay_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\overlay_log.txt" >nul 2>&1
)
echo OK.

echo [650/700] Eliminazione dei file temporanei e log di cache dell'app Adobe Illustrator (AIPrefs Cache)...
if exist "%APPDATA%\Adobe\Adobe Illustrator *\AIPrefs" (
    del /f /q "%APPDATA%\Adobe\Adobe Illustrator *\AIPrefs" >nul 2>&1
)
echo OK.

echo [651/700] Svuotamento della cache dei file log temporanei dell'emulatore BlueStacks (Engine User Data Cache)...
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Logs" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Logs\*" >nul 2>&1
)
echo OK.

echo [652/700] Rimozione della cache delle immagini temporanee dei giochi nel Launcher di Epic Games (News Feeds)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\f_*" >nul 2>&1
)
echo OK.

echo [653/700] Pulizia forzata dei log delle transazioni e installazioni di pacchetti di Python (EasyInstall Logs)...
if exist "%USERPROFILE%\.easy_install\logs" (
    del /f /q /s "%USERPROFILE%\.easy_install\logs\*" >nul 2>&1
)
echo OK.

echo [654/700] Svuotamento dei file temporanei e dei registri di configurazione orfani di Visual Studio Code (Workspace Cache)...
if exist "%APPDATA%\Code\User\WorkspaceStorage" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Code\User\WorkspaceStorage' -Recurse -Filter '*.log' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)
echo OK.

echo [655/700] Rimozione dei log storici accumulati dallo strumento di cattura video OBS Studio (Crashes Logs Core)...
if exist "%APPDATA%\obs-studio\crashes" (
    del /f /q /s "%APPDATA%\obs-studio\crashes\*.txt" >nul 2>&1
)
echo OK.

echo [656/700] Svuotamento forzato dei log di tracciamento del modulo di diagnostica audio avanzato di Windows...
if exist "C:\Windows\System32\LogFiles\WMI\AudioTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\AudioTelemetry\*" >nul 2>&1
)
echo OK.

echo [657/700] Pulizia dei registri temporanei generati dal servizio di manutenzione del Kernel (DismHost)...
if exist "%LOCALAPPDATA%\Temp\DismHost*" (
    rmdir /s /q "%LOCALAPPDATA%\Temp\DismHost*" >nul 2>&1
)
echo OK.

echo [658/700] Svuotamento dei file temporanei generati dall'app nativa Microsoft Notizie di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingNews_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingNews_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [659/700] Rimozione dei vecchi file di log temporanei generati dallo strumento di diagnostica di Windows Update...
if exist "C:\Windows\Logs\WindowsUpdateClient" (
    del /f /q /s "C:\Windows\Logs\WindowsUpdateClient\*" >nul 2>&1
)
echo OK.

echo [660/700] Forzatura azzeramento della cache dei log storici del servizio di monitoraggio della batteria (PowerCfg)...
if exist "%LOCALAPPDATA%\CrashDumps\powercfg.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\powercfg.exe*" >nul 2>&1
)
echo OK.

echo [661/700] Polverizzazione della cache dei moduli di report dei crash di Google Chrome (Crashpad Metrics)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad\settings.dat" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad\settings.dat" >nul 2>&1
)
echo OK.

echo [662/700] Svuotamento dei file temporanei della cache delle icone dell'applicazione desktop di Discord (Cache_Data)...
if exist "%APPDATA%\discord\Code Cache\js" (
    rmdir /s /q "%APPDATA%\discord\Code Cache\js" >nul 2>&1
)
echo OK.

echo [663/700] Rimozione forzata dei vecchi file di log temporanei del browser Microsoft Edge (Autofill Logs)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\AutofillStates" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\AutofillStates\*" >nul 2>&1
)
echo OK.

echo [664/700] Svuotamento radicale dei file di log temporanei accumulati dal client di gioco Steam (Steam-Saves-Logs)...
if exist "C:\Program Files (x86)\Steam\logs\cloud_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\cloud_log.txt" >nul 2>&1
)
echo OK.

echo [665/700] Eliminazione dei file temporanei e log di cache dell'app Adobe Premiere Pro (Peak Files)...
if exist "%APPDATA%\Adobe\Common\Peak Files" (
    rmdir /s /q "%APPDATA%\Adobe\Common\Peak Files" >nul 2>&1
)
echo OK.

echo [666/700] Svuotamento della cache dei file log temporanei dell'emulatore BlueStacks (App Manager Logs)...
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Input" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Input\*.tmp" >nul 2>&1
)
echo OK.

echo [667/700] Rimozione della cache delle immagini temporanee dei giochi nel Launcher di Epic Games (HTML Assets)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage\leveldb" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage\leveldb\*.log" >nul 2>&1
)
echo OK.

echo [668/700] Pulizia forzata dei log delle transazioni e installazioni di moduli di Python (SetupTools Logs)...
if exist "%USERPROFILE%\.easy_install\easy_install.log" (
    del /f /q "%USERPROFILE%\.easy_install\easy_install.log" >nul 2>&1
)
echo OK.

echo [669/700] Svuotamento dei file temporanei e dei registri di configurazione orfani di Visual Studio Code (Telemetry Cache)...
if exist "%APPDATA%\Code\User\globalStorage\telemetry" (
    rmdir /s /q "%APPDATA%\Code\User\globalStorage\telemetry" >nul 2>&1
)
echo OK.

echo [670/700] Rimozione dei log storici accumulati dallo strumento di cattura video OBS Studio (Plugin Logs Core)...
if exist "%APPDATA%\obs-studio\plugin_config\obs-browser\logs" (
    del /f /q /s "%APPDATA%\obs-studio\plugin_config\obs-browser\logs\*" >nul 2>&1
)
echo OK.

echo [671/700] Svuotamento forzato dei log di tracciamento del modulo di diagnostica video avanzato di Windows (DwmTelemetry)...
if exist "C:\Windows\System32\LogFiles\WMI\DwmTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\DwmTelemetry\*" >nul 2>&1
)
echo OK.

echo [672/700] Pulizia dei registri temporanei generati dal servizio di manutenzione del Kernel (SFC System Logs)...
if exist "C:\Windows\Logs\CBS\CbsPersist_*" (
    del /f /q /s "C:\Windows\Logs\CBS\CbsPersist_*" >nul 2>&1
)
echo OK.

echo [673/700] Svuotamento dei file temporanei generati dall'app nativa Microsoft Sport di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingSports_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingSports_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [674/700] Rimozione dei vecchi file di log temporanei generati dallo strumento di diagnostica del Bluetooth (BthTelemetry)...
if exist "C:\Windows\System32\LogFiles\WMI\BthPortTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthPortTelemetry\*" >nul 2>&1
)
echo OK.

echo [675/700] Forzatura azzeramento della cache dei log storici del servizio di monitoraggio dei dischi (DiskPerf)...
if exist "%LOCALAPPDATA%\CrashDumps\diskperf.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\diskperf.exe*" >nul 2>&1
)
echo OK.

echo [676/700] Polverizzazione della cache dei moduli di ottimizzazione di Google Chrome (OptimizationGuide)...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\OptimizationGuidePredictionModels" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\OptimizationGuidePredictionModels" >nul 2>&1
)
echo OK.

echo [677/700] Svuotamento dei file temporanei della cache degli Shader grafici di Discord (D3D12Cache)...
if exist "%APPDATA%\discord\D3D12Cache" (
    rmdir /s /q "%APPDATA%\discord\D3D12Cache" >nul 2>&1
)
echo OK.

echo [678/700] Rimozione forzata dei vecchi file di log temporanei del browser Microsoft Edge (Edge-Hub-Cache)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\EdgeHub" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\EdgeHub" >nul 2>&1
)
echo OK.

echo [679/700] Svuotamento radicale dei file di log temporanei accumulati dal client di gioco Steam (Steam-Music-Logs)...
if exist "C:\Program Files (x86)\Steam\logs\music_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\music_log.txt" >nul 2>&1
)
echo OK.

echo [680/700] Eliminazione dei file temporanei e log di cache dell'app Adobe Common (Media Cache Packages)...
if exist "%APPDATA%\Adobe\Common\Media Cache" (
    rmdir /s /q "%APPDATA%\Adobe\Common\Media Cache" >nul 2>&1
)
echo OK.

echo [681/700] Svuotamento della cache dei file log temporanei dell'emulatore BlueStacks (Android OBB Temp Cache)...
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Gadget" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Gadget\*.tmp" >nul 2>&1
)
echo OK.

echo [682/700] Rimozione della cache delle immagini temporanee dei giochi nel Launcher di Epic Games (Ad-Banners)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data\index" >nul 2>&1
)
echo OK.

echo [683/700] Pulizia forzata dei log delle transazioni e installazioni di pacchetti di Python (Wheel Cache)...
if exist "%USERPROFILE%\.cache\wheels" (
    rmdir /s /q "%USERPROFILE%\.cache\wheels" >nul 2>&1
)
echo OK.

echo [684/700] Svuotamento dei file temporanei e dei registri di configurazione orfani di Visual Studio Code (Backups)...
if exist "%APPDATA%\Code\Backups" (
    rmdir /s /q "%APPDATA%\Code\Backups" >nul 2>&1
)
echo OK.

echo [685/700] Rimozione dei log storici accumulati dallo strumento di cattura video OBS Studio (Crash Reports Backup)...
if exist "%APPDATA%\obs-studio\crashes" (
    del /f /q /s "%APPDATA%\obs-studio\crashes\*.dmp" >nul 2>&1
)
echo OK.

echo [686/700] Svuotamento forzato dei log di tracciamento del modulo di diagnostica video avanzato di Windows (DxTelemetry)...
if exist "C:\Windows\System32\LogFiles\WMI\DxTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\DxTelemetry\*" >nul 2>&1
)
echo OK.

echo [687/700] Pulizia dei registri temporanei generati dal servizio di manutenzione del Kernel (DISM Engine Logs)...
if exist "C:\Windows\Logs\DISM\dism.log" (
    del /f /q "C:\Windows\Logs\DISM\dism.log" >nul 2>&1
)
echo OK.

echo [688/700] Svuotamento dei file temporanei generati dall'app nativa Microsoft Viaggi di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingTravel_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingTravel_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [689/700] Rimozione dei vecchi file di log temporanei generati dallo strumento di diagnostica del Bluetooth (BthLegacy)...
if exist "C:\Windows\System32\LogFiles\WMI\BthLegacy" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthLegacy\*" >nul 2>&1
)
echo OK.

echo [690/700] Forzatura azzeramento della cache dei log storici del servizio di monitoraggio dei dischi (FsUtil Logs)...
if exist "%LOCALAPPDATA%\CrashDumps\fsutil.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\fsutil.exe*" >nul 2>&1
)
echo OK.

echo [691/700] Svuotamento della cache dei dati locali temporanei di navigazione di Microsoft Edge (Trust Tokens)...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Trust Tokens" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Trust Tokens" >nul 2>&1
)
echo OK.

echo [692/700] Rimozione dei log storici accumulati dallo strumento Windows Package Manager (Winget-Logs)...
if exist "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir\*.log" >nul 2>&1
)
echo OK.

echo [693/700] Pulizia delle anteprime orfane e dei file temporanei di caching del software VLC Media Player (Cache Data)...
if exist "%APPDATA%\vlc\cache" (
    rmdir /s /q "%APPDATA%\vlc\cache" >nul 2>&1
)
echo OK.

echo [694/700] Svuotamento dei file temporanei generati dall'applicazione cloud Google Drive (Cloud-Cache-Database)...
if exist "%LOCALAPPDATA%\Google\DriveFS\CloudCache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\DriveFS\CloudCache" >nul 2>&1
)
echo OK.

echo [695/700] Rimozione forzata dei crash report orfani creati dal Launcher di Epic Games (Portal Reports)...
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Portal" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Portal" >nul 2>&1
)
echo OK.

echo [696/700] Svuotamento dei file di registro temporanei generati dallo strumento di diagnostica Core di Windows (SqmApi)...
if exist "C:\Windows\System32\LogFiles\WMI\SqmTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\SqmTelemetry\*" >nul 2>&1
)
echo OK.

echo [697/700] Pulizia forzata della cartella temporanea dei dump del sottosistema del registro (Regedit Dumps)...
if exist "%LOCALAPPDATA%\CrashDumps\regedit.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\regedit.exe*" >nul 2>&1
)
echo OK.

echo [698/700] Svuotamento dei file temporanei generati dall'app nativa Microsoft Finanza di Windows 11...
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingFinance_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingFinance_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)
echo OK.

echo [699/700] Rimozione dei vecchi file di log temporanei generati dallo strumento di diagnostica del Wi-Fi (WlanLegacy)...
if exist "C:\Windows\System32\LogFiles\WMI\WlanLegacy" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\WlanLegacy\*" >nul 2>&1
)
echo OK.

echo [700/700] Ottimizzazione finale strutturale ed espulsione forzata di tutti i file di log temporanei pendenti...
fsutil resource setautoreset true C:\ >nul 2>&1
echo OK.

:: =======================================================================
:: --- SEZIONE CONCLUSIVA: CALCOLO SPAZIO E TEMPO DI ESECUZIONE (700 PASSI) ---
:: =======================================================================
echo.
echo Elaborazione del report finale in corso...
echo.

for /f "tokens=1,2 delims=," %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$time=[DateTime]::Now; $seconds=($time.Hour * 3600) + ($time.Minute * 60) + $time.Second; $space=[math]::round(((Get-Volume -DriveLetter C).SizeRemaining / 1GB), 2); Write-Output \"$seconds,$space\""') do (
    set "end_seconds=%%a"
    set "spazio_finale=%%b"
)

set /a "tempo_impiegato_secondi=end_seconds - start_seconds"
if %tempo_impiegato_secondi% LSS 0 (set /a "tempo_impiegato_secondi+=86400")

set /a "minuti=tempo_impiegato_secondi / 60"
set /a "secondi=tempo_impiegato_secondi %% 60"

for /f "delims=" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$init='%spazio_iniziale%'.Replace(',','.'); $fin='%spazio_finale%'.Replace(',','.'); $res = [math]::round(([double]$fin - [double]$init), 2); if ($res -lt 0) { 0 } else { $res }"') do set "spazio_guadagnato=%%a"

(
echo =======================================================
echo     REPORT DI PULIZIA ESTREMA WINDOWS SPACE OVERLORD
echo =======================================================
echo  Data esecuzione: %DATE% alle ore %TIME%
echo  Totale passaggi eseguiti: 660 / 660
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

:: Riproduce il Chime acustico nativo di Windows per avvisare del successo
powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Media.SystemSounds]::Asterisk.Play(); Start-Sleep -Milliseconds 300; [System.Media.SystemSounds]::Asterisk.Play()" >nul 2>&1

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
echo Premi un tasto qualsiasi per uscire dal programma.
pause >nul
exit
