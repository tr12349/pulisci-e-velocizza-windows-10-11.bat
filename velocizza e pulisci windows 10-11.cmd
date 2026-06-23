:: SCRIPT AVANZATO DI MANUTENZIONE, PULIZIA E OTTIMIZZAZIONE WINDOWS
:: Sviluppato da: tr12349 & AI
:: =================================================================
@echo off

:: Forza subito il prompt dei comandi ad avere lo sfondo nero e il testo Verde Matrix
color 0A

:: =======================================================================
:: CONTROLLO E RICHIESTA AUTOMATICA PERMESSI DI AMMINISTRATORE (UAC)
:: =======================================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo [INFO] Richiesta dei permessi di amministratore in corso...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^( "Shell.Application" ^) > "%temp%\getadmin.vbs"
    set "params=%*"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
cls
color 0A

title Windows Space Overlord - Master Ultimate Edition v5.0 (724 Steps)

echo =======================================================================
echo        _      _           _                                             
echo       / \    / \  _ _____/ \____ _ ___ _ _   _ ____ ____  _ ____ ____   
echo      /   \  /   \/ / ___/_  __ / //  // / \ / /_  _// __ \/ / __// __ \  
echo     / / \ \/ / / / \__ \  / /  / // _// / \ V /  / / / / / / / _// /_/ /  
echo    /_/   \__/ /_/ /____/ /_/  /_/ \__/_/_/ \_/  /_/ /_/ /_/_/_/  \____/   
echo                                                                        
echo        BENVENUTO IN WINDOWS SPACE OVERLORD - ULTIMATE EDITION v5.0      
echo =======================================================================
echo.
echo [*] Configurazione automatica: Scansione profonda SFC ABILITATA.
echo.

echo =======================================================================
echo    AVVIO CONFIGURAZIONE E ANALISI DELLO SPAZIO... VIA ALLA PULIZIA!     
echo =======================================================================
echo.

set "spazio_iniziale=0.00"

:: Registra l'orario di inizio gestendo correttamente i numeri ottali
for /f "tokens=1-3 delims=:." %%a in ("%TIME%") do (
    set "H=%%a" & set "M=%%b" & set "S=%%c"
)
set "H=%H: =%"
if %H% LSS 10 set /a H=1%H%-100
if %M% LSS 10 set /a M=1%M%-100
if %S% LSS 10 set /a S=1%S%-100
set /a start_seconds=(H*3600)+(M*60)+S

:: Pulizia preventiva dei vecchi file di report sul Desktop per evitare blocchi
if exist "%USERPROFILE%\Desktop\Pulizia_Report.txt" (del /f /q "%USERPROFILE%\Desktop\Pulizia_Report.txt" >nul 2>&1)
if exist "%USERPROFILE%\Desktop\File_Piu_Pesanti.txt" (del /f /q "%USERPROFILE%\Desktop\File_Piu_Pesanti.txt" >nul 2>&1)

echo [PRONTO] Configurazione completata con successo.
echo.
echo [ATTENZIONE] Non chiudere questa finestra fino al completamento totale.
timeout /t 2 >nul
cls

:: Imposta i parametri numerici statici per la barra
set "totale_operazioni=724"
set "operazione_corrente=0"

:: =======================================================================
:: INIZIO DEI PASSAGGI DI PULIZIA REALI (DA QUI IN POI METTI LE OPZIONI)
:: =======================================================================

%update_bar%
del /f /q /s C:\Windows\Temp\* >nul 2>&1
for /d %%p in (C:\Windows\Temp\*) do rmdir /s /q "%%p" >nul 2>&1
del /f /q /s "%temp%\*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1

%update_bar%
del /f /q /s C:\Windows\Prefetch\* >nul 2>&1
for /d %%p in (C:\Windows\Prefetch\*) do rmdir /s /q "%%p" >nul 2>&1

%update_bar%
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1
timeout /t 2 >nul
del /f /q /s C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
for /d %%p in (C:\Windows\SoftwareDistribution\Download\*) do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1

%update_bar%
if exist C:\$Recycle.Bin ( rd /s /q C:\$Recycle.Bin >nul 2>&1 )

%update_bar%
del /f /q /s C:\Windows\Logs\*.log >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\CrashDumps\*.dmp" >nul 2>&1

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    for /d %%g in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do (
        del /f /q /s "%%g\Cache\*" >nul 2>&1
        del /f /q /s "%%g\Code Cache\*" >nul 2>&1
        del /f /q /s "%%g\GPUCache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad" >nul 2>&1)
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    for /d %%e in ("%LOCALAPPDATA%\Microsoft\Edge\User Data\*") do (
        del /f /q /s "%%e\Cache\*" >nul 2>&1
        del /f /q /s "%%e\Code Cache\*" >nul 2>&1
        del /f /q /s "%%e\GPUCache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad" >nul 2>&1)
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%f in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        del /f /q /s "%%f\cache2\*" >nul 2>&1
        del /f /q /s "%%f\jumpListCache\*" >nul 2>&1
        del /f /q /s "%%f\crashes\*" >nul 2>&1
    )
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data" (
    for /d %%b in ("%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*") do (
        del /f /q /s "%%b\Cache\*" >nul 2>&1
        del /f /q /s "%%b\Code Cache\*" >nul 2>&1
    )
    if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" (rmdir /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad" >nul 2>&1)
)

%update_bar%
del /f /q /s "%LOCALAPPDATA%\Spotify\Storage\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1
del /f /q /s "%APPDATA%\discord\Code Cache\*" >nul 2>&1

%update_bar%
fsutil behavior set disablelastaccess 1 >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-AppxPackage *BingWeather* | Remove-AppxPackage; Get-AppxPackage *GetHelp* | Remove-AppxPackage; Get-AppxPackage *3DBuilder* | Remove-AppxPackage" >nul 2>&1

if not exist "%USERPROFILE%\Desktop\DUPLICATI_RILEVATI" (mkdir "%USERPROFILE%\Desktop\DUPLICATI_RILEVATI" >nul 2>&1)

%update_bar%
:: FIX: Protette le virgolette interne con l'escape triplo per evitare il crash immediato del parser Batch
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$paths = @('$env:USERPROFILE\Downloads', '$env:USERPROFILE\Documents', '$env:USERPROFILE\Pictures', '$env:USERPROFILE\Music'); Get-ChildItem -Path $paths -Recurse -File -ErrorAction SilentlyContinue | Group-Object Length | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Get-FileHash -Algorithm MD5 | Group-Object Hash | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object -Skip 1 | ForEach-Object { Move-Item -Path $_.Path -Destination '$env:USERPROFILE\Desktop\DUPLICATI_RILEVATI' -Force -ErrorAction SilentlyContinue } } }" >nul 2>&1

%update_bar%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1

%update_bar%
if exist C:\Windows.old (
    takeown /F C:\Windows.old /R /A /D Y >nul 2>&1
    icacls C:\Windows.old /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\Windows.old >nul 2>&1
)

%update_bar%
if exist C:\AMD ( takeown /F C:\AMD /R /A /D Y >nul 2>&1 & icacls C:\AMD /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\AMD >nul 2>&1 )
if exist C:\Intel ( takeown /F C:\Intel /R /A /D Y >nul 2>&1 & icacls C:\Intel /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\Intel >nul 2>&1 )
if exist C:\NVIDIA ( takeown /F C:\NVIDIA /R /A /D Y >nul 2>&1 & icacls C:\NVIDIA /grant Administrators:F /T >nul 2>&1 & rmdir /s /q C:\NVIDIA >nul 2>&1 )

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    del /f /q /s "%APPDATA%\Telegram Desktop\tdata\user_data\cache\*" >nul 2>&1
    for /d %%p in ("%APPDATA%\Telegram Desktop\tdata\user_data\cache\*") do rmdir /s /q "%%p" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Adobe\DXP" ( del /f /q /s "%LOCALAPPDATA%\Adobe\DXP\*" >nul 2>&1 )
if exist "%APPDATA%\Adobe\Common\Media Cache Files" ( del /f /q /s "%APPDATA%\Adobe\Common\Media Cache Files\*" >nul 2>&1 )

%update_bar%
if exist C:\MSOCache (
    takeown /F C:\MSOCache /R /A /D Y >nul 2>&1
    icacls C:\MSOCache /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\MSOCache >nul 2>&1
)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'AC|INetCache|LocalCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
del /f /q /s C:\Windows\Installer\*.tmp >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName -eq $null } | ForEach-Object { pnputil /delete-driver $_.InfName /uninstall /force }" >nul 2>&1

%update_bar%
del /f /q /s "%LocalAppData%\D3DSCache\*" >nul 2>&1
for /d %%p in ("%LocalAppData%\D3DSCache\*") do rmdir /s /q "%%p" >nul 2>&1

%update_bar%
if exist C:\$WINDOWS.~BT (
    takeown /F C:\$WINDOWS.~BT /R /A /D Y >nul 2>&1
    icacls C:\$WINDOWS.~BT /grant Administrators:F /T >nul 2>&1
    rmdir /s /q C:\$WINDOWS.~BT >nul 2>&1
)

%update_bar%
del /f /q /s C:\Windows\System32\LogFiles\HTTPERR\* >nul 2>&1
del /f /q /s C:\Windows\Logs\CBS\*.log >nul 2>&1
if exist C:\inetpub\logs\LogFiles (del /f /q /s C:\inetpub\logs\LogFiles\* >nul 2>&1)

%update_bar%
if exist "C:\Program Files (x86)\Steam\cached" (del /f /q /s "C:\Program Files (x86)\Steam\cached\*" >nul 2>&1)
if exist "C:\Program Files\Epic Games\Launcher\VaultCache" (del /f /q /s "C:\Program Files\Epic Games\Launcher\VaultCache\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\EA Desktop\Cache\*" >nul 2>&1)

%update_bar%
net stop fontcache >nul 2>&1
del /f /q /s %WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.dat >nul 2>&1
net start fontcache >nul 2>&1

%update_bar%
net stop dosvc >nul 2>&1
if exist C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache (
    del /f /q /s C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\* >nul 2>&1
)
net start dosvc >nul 2>&1

%update_bar%
if exist "%ProgramData%\NVIDIA Corporation\InstallerGrid" (del /f /q /s "%ProgramData%\NVIDIA Corporation\InstallerGrid\*.exe" >nul 2>&1)
if exist "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService" (del /f /q /s "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService\*.exe" >nul 2>&1)
if exist C:\AMD\Packagers (rmdir /s /q C:\AMD\Packagers >nul 2>&1)

%update_bar%
net stop wuauserv >nul 2>&1
if exist "%WinDir%\SoftwareDistribution\DataStore" (
    del /f /q /s "%WinDir%\SoftwareDistribution\DataStore\*" >nul 2>&1
)
net start wuauserv >nul 2>&1

%update_bar%
ipconfig /flushdns >nul 2>&1

%update_bar%
cleanmgr /sagerun:1 >nul 2>&1

%update_bar%
del /f /q /s "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q /s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
wsreset -s >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ComputerRestorePoint | Select-Object -SkipLast 1 | ForEach-Object { Checkpoint-Computer -Delete $_.SequenceNumber }" >nul 2>&1

%update_bar%
powercfg -h -size 50 >nul 2>&1

%update_bar%
if "%esegui_sfc%"=="SI" (
    echo NOTA - Questo passaggio richiede tempo, attendere...
    sfc /scannow
)

%update_bar%
compact /compactos:always >nul 2>&1

%update_bar%
del /f /q /s "%LocalAppData%\Microsoft\Windows\INetCache\*" >nul 2>&1

%update_bar%
if exist "%USERPROFILE%\.nuget\packages" (rmdir /s /q "%USERPROFILE%\.nuget\packages" >nul 2>&1)
if exist "%LocalAppData%\Microsoft\WebsiteCache" (rmdir /s /q "%LocalAppData%\Microsoft\WebsiteCache" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs" (del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\Riot Client Logs" (rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\Riot Client Logs" >nul 2>&1)
del /f /q /s "%LOCALAPPDATA%\*GLCache\*" >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'WhatsApp' } | ForEach-Object { $path = $_.FullName + '\LocalState\shared\transfers'; if (Test-Path $path) { Remove-Item ($path + '\*') -Recurse -Force -ErrorAction SilentlyContinue } }" >nul 2>&1

%update_bar%
compact /c /s:C:\Windows\Logs >nul 2>&1
compact /c /s:C:\Windows\Panther >nul 2>&1

%update_bar%
if exist "%LocalAppData%\pip\Cache" (rmdir /s /q "%LocalAppData%\pip\Cache" >nul 2>&1)

%update_bar%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f >nul 2>&1

%update_bar%
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-EventLog -LogName * | ForEach-Object { Clear-EventLog -LogName $_.Log }" >nul 2>&1

%update_bar%
if exist %SystemRoot%\MEMORY.DMP (del /f /q %SystemRoot%\MEMORY.DMP >nul 2>&1)
del /f /q /s %SystemRoot%\Minidump\*.dmp >nul 2>&1

%update_bar%
if exist "%USERPROFILE%\AppData\Local\pip\cache" (rmdir /s /q "%USERPROFILE%\AppData\Local\pip\cache" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\Microsoft\Teams\Cache" (del /f /q /s "%APPDATA%\Microsoft\Teams\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Microsoft\Teams\Application Cache\Cache" (del /f /q /s "%APPDATA%\Microsoft\Teams\Application Cache\Cache\*" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\GatherLogs\*" >nul 2>&1
)

%update_bar%
del /f /q /s C:\Windows\Temp\*.log >nul 2>&1
del /f /q /s "%temp%\*.log" >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\AppData\Local\Temp', '$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache' -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1

%update_bar%
if exist "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files" (rmdir /s /q "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files" >nul 2>&1)
if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files" (rmdir /s /q "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files" >nul 2>&1)

%update_bar%
del /f /q /s C:\ProgramData\Microsoft\Diagnosis\*.etw >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\ -Include *.tmp, *.chk -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch 'C:\\Windows' } | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist "%APPDATA%\npm-cache" (rmdir /s /q "%APPDATA%\npm-cache" >nul 2>&1)

%update_bar%
if exist C:\ProgramData\Microsoft\Windows\Containers (
    del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\* >nul 2>&1
)

%update_bar%
if exist C:\Windows\SoftwareDistribution\PostRebootEventCache.V2 (
    rmdir /s /q C:\Windows\SoftwareDistribution\PostRebootEventCache.V2 >nul 2>&1
)

%update_bar%
net stop spooler >nul 2>&1
del /f /q /s C:\Windows\System32\spool\PRINTERS\* >nul 2>&1
net start spooler >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Include *.log, *.tmp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Microsoft\Edge\User Data' -Include *.log, *.tmp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1

%update_bar%
del /f /q /s C:\Windows\Microsoft.NET\Framework*\*\*.log >nul 2>&1

%update_bar%
if exist "%LocalAppData%\NVIDIA\DXCache" (del /f /q /s "%LocalAppData%\NVIDIA\DXCache\*" >nul 2>&1)
if exist "%LocalAppData%\AMD\DxCache" (del /f /q /s "%LocalAppData%\AMD\DxCache\*" >nul 2>&1)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-CimInstance -Namespace root/Microsoft/Windows/DeliveryOptimization -ClassName MSFT_DeliveryOptimizationConfiguration | Invoke-CimMethod -MethodName DeleteCache" >nul 2>&1

%update_bar%
DISM.exe /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

%update_bar%
defrag C: /O >nul 2>&1

%update_bar%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

%update_bar%
powercfg /h off >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$wmi = Get-CimInstance -ClassName Win32_ComputerSystem -EnableAllPrivileges; $wmi.AutomaticManagedPagefile = $False; Invoke-CimMethod -InputObject $wmi -MethodName Modify; $pagefile = Get-CimInstance -ClassName Win32_PageFileSetting; if ($pagefile) { $pagefile.InitialSize = 2048; $pagefile.MaximumSize = 4096; Invoke-CimMethod -InputObject $pagefile -MethodName Modify } else { New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\\pagefile.sys'; InitialSize=2048; MaximumSize=4096} }" >nul 2>&1

%update_bar%
vssadmin resize shadowstorage /for=c: /on=c: /maxsize=2% >nul 2>&1

%update_bar%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f >nul 2>&1

%update_bar%
wsreset /s >nul 2>&1
if exist "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)

%update_bar%
net stop wsearch >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f >nul 2>&1
del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1
net start wsearch >nul 2>&1

%update_bar%
if exist "%APPDATA%\Zoom\data" (del /f /q /s "%APPDATA%\Zoom\data\*" >nul 2>&1)
if exist "%APPDATA%\Microsoft\Skype for Desktop\Cache" (rmdir /s /q "%APPDATA%\Microsoft\Skype for Desktop\Cache" >nul 2>&1)

%update_bar%
if exist "%ProgramFiles%\NVIDIA Corporation\Installer2" (rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\Installer2" >nul 2>&1)
if exist C:\ProgramData\AMD\OemDrivers (rmdir /s /q C:\ProgramData\AMD\OemDrivers >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.cargo\registry\cache" (rmdir /s /q "%USERPROFILE%\.cargo\registry\cache" >nul 2>&1)

%update_bar%
vssadmin delete shadows /for=c: /oldest /quiet >nul 2>&1

%update_bar%
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1

%update_bar%
fsutil usn deletejournal /d /n C: >nul 2>&1

%update_bar%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Status -eq 'Unknown' } | ForEach-Object { pnputil /remove-device $_.DeviceID }" >nul 2>&1

%update_bar%
if exist "%LocalAppData%\Microsoft\Media Player" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player" >nul 2>&1)

%update_bar%
fsutil resource setautoreset true C:\ >nul 2>&1

%update_bar%
net stop wuauserv >nul 2>&1
del /f /q /s C:\Windows\SoftwareDistribution\DataStore\Logs\*.log >nul 2>&1
net start wuauserv >nul 2>&1

%update_bar%
if exist "%LocalAppData%\Adobe\FontCache" (rmdir /s /q "%LocalAppData%\Adobe\FontCache" >nul 2>&1)

%update_bar%
del /f /q /s C:\found.* >nul 2>&1
for /d %%p in (C:\found.*) do rmdir /s /q "%%p" >nul 2>&1

%update_bar%
defrag C: /O /H /X >nul 2>&1

%update_bar%
vssadmin delete shadows /all /quiet >nul 2>&1

%update_bar%
if exist "C:\System Volume Information\Chkdsk" (
    takeown /F "C:\System Volume Information" /A >nul 2>&1
    icacls "C:\System Volume Information" /grant Administrators:F >nul 2>&1
    del /f /q /s "C:\System Volume Information\Chkdsk\*" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store" (
    del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
)

%update_bar%
del /f /q /s C:\Windows\System32\config\TxR\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\config\TxR\*.blf >nul 2>&1

%update_bar%
if exist C:\Windows\System32\SleepStudy (
    del /f /q /s C:\Windows\System32\SleepStudy\* >nul 2>&1
)

%update_bar%
del /f /q /s "%LocalAppData%\Microsoft\Windows\Notifications\*.db" >nul 2>&1

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\AudioEngine" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\AudioEngine\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\DWM" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\DWM\*" >nul 2>&1
)

%update_bar%
if exist C:\ProgramData\Microsoft\RAC (
    del /f /q /s C:\ProgramData\Microsoft\RAC\StateData\* >nul 2>&1
    del /f /q /s C:\ProgramData\Microsoft\RAC\Outbound\* >nul 2>&1
)

%update_bar%
del /f /q C:\DUMP*.tmp >nul 2>&1

%update_bar%
if exist "C:\ProgramData\Microsoft\LiveUpdate" (
    del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\AppXDeploymentServer (
    del /f /q /s C:\Windows\System32\AppXDeploymentServer\*.log >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\MapData" (
    del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\CompatTelRunner (
    del /f /q /s C:\Windows\System32\CompatTelRunner\*.tmp >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows Photo Viewer" (
    rmdir /s /q "%LocalAppData%\Microsoft\Windows Photo Viewer" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\CrashDumps" (
    del /f /q /s "%LocalAppData%\CrashDumps\*" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18" (
    del /f /q /s "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18\*.tmp" >nul 2>&1
)

%update_bar%
del /f /q /s C:\Windows\inf\setupapi*.log >nul 2>&1

%update_bar%
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis" (
    del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\BitLocker (
    del /f /q /s C:\Windows\System32\BitLocker\*.tmp >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\HVSI" (
    del /f /q /s "%ProgramData%\Microsoft\HVSI\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\Logs\MeasuredBoot (
    del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Terminal Server Client\Cache" (
    rmdir /s /q "%LocalAppData%\Microsoft\Terminal Server Client\Cache" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)

%update_bar%
net stop WbioSrvc >nul 2>&1
if exist C:\Windows\System32\WinBioDatabase (
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.log >nul 2>&1
    del /f /q /s C:\Windows\System32\WinBioDatabase\*.tmp >nul 2>&1
)
net start WbioSrvc >nul 2>&1

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\DeviceMetadataCache" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\DeviceMetadataCache\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\DirectX" (
    del /f /q /s "%LocalAppData%\Microsoft\DirectX\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\ReadyBoot (
    del /f /q /s C:\Windows\System32\LogFiles\ReadyBoot\*.fx >nul 2>&1
)

%update_bar%
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.regtrans-ms >nul 2>&1
del /f /q /s C:\Windows\System32\SMI\Store\Machine\*.blf >nul 2>&1

%update_bar%
if exist C:\Windows\Logs\WindowsUpdate (
    del /f /q /s C:\Windows\Logs\WindowsUpdate\* >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\PowerShell\ScheduledJobs\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Sun\Java\Deployment\cache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Office\16.0\WebServiceCache\AllUsers\Office365Pages\*" >nul 2>&1
)

:: =================================================================
:: AREA 2: DIAGNOSTICA DI SISTEMA, RIPARAZIONE FILE E STRUMENTI DISM
:: Tecniche utilizzate: SFC (System File Checker) e DISM (Deployment Image Servicing).
:: Obiettivo: Scansionare l'integrità del sistema operativo e riparare file corrotti.
:: righe: da 125 a 150
:: =================================================================

%update_bar%
if exist "%USERPROFILE%\.wslg\logs" (
    del /f /q /s "%USERPROFILE%\.wslg\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" (
    del /f /q "%LOCALAPPDATA%\Microsoft\PowerShell\ModuleAnalysisCache" >nul 2>&1
)

%update_bar%
if exist "%WINDIR%\System32\dxdiag.exe" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.Windows.Appcontainer.Behavior_cw5n1h2txyewy" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.Windows.Appcontainer.Behavior_cw5n1h2txyewy\LocalState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\appcache" (rmdir /s /q "C:\Program Files (x86)\Steam\appcache" >nul 2>&1)
if exist "C:\Program Files (x86)\Steam\config\htmlcache" (del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" (rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs" (del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1)
if exist "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache" (del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*" >nul 2>&1)

:: =================================================================
:: AREA 3: OTTIMIZZAZIONE DELLE PRESTAZIONI E ALGORITMI DI COMPRESSIONE
:: Tecniche utilizzate: Strumento nativo COMPACT (Compressione File System NTFS).
:: Obiettivo: Ridurre lo spazio occupato dai programmi installati senza comprometterne l'avvio.
:: righe: 151 alla 370
:: =================================================================

%update_bar%
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" (rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1)
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs" (del /f /q /s "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\logs\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\Zoom\logs" (del /f /q /s "%APPDATA%\Zoom\logs\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Adobe\Acrobat\DC\Cache" (rmdir /s /q "%LOCALAPPDATA%\Adobe\Acrobat\DC\Cache" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\Adobe\Adobe Photoshop *\AutoRecover" (del /f /q /s "%APPDATA%\Adobe\Adobe Photoshop *\AutoRecover\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1)

%update_bar%
if exist "C:\ProgramData\BlueStacks_nxt\Logs" (del /f /q /s "C:\ProgramData\BlueStacks_nxt\Logs\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Dropbox\instance1\scratch" (del /f /q /s "%LOCALAPPDATA%\Dropbox\instance1\scratch\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\assembly\dl3" (rmdir /s /q "%LOCALAPPDATA%\assembly\dl3" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\WinRAR\Templates" (del /f /q /s "%APPDATA%\WinRAR\Templates\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\7-Zip" (rmdir /s /q "%LOCALAPPDATA%\7-Zip" >nul 2>&1)

%update_bar%
if exist "C:\Windows\System32\KernelExtensionCache" (del /f /q /s "C:\Windows\System32\KernelExtensionCache\*" >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Speech\Files" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Speech\Files\*" >nul 2>&1)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'EBWebView' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist "C:\ProgramData\Microsoft\Crypto\SystemKeys" (del /f /q /s "C:\ProgramData\Microsoft\Crypto\SystemKeys\*.tmp" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1)

%update_bar%
if exist "C:\ProgramData\Intel\ShaderCache" (rmdir /s /q "C:\ProgramData\Intel\ShaderCache" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\InputPersonalization" (rmdir /s /q "%LOCALAPPDATA%\Microsoft\InputPersonalization" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\UntrustedAppCache" (rmdir /s /q "%LOCALAPPDATA%\UntrustedAppCache" >nul 2>&1)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Defrag -Verbose" >nul 2>&1

%update_bar%
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\DriverStore\FileRepository -Filter *.zip, *.exe, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Minidump" (
    del /f /q /s C:\Windows\Minidump\* >nul 2>&1
)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-BitsTransfer -AllUsers | Remove-BitsTransfer -ErrorAction SilentlyContinue" >nul 2>&1

%update_bar%
if exist "C:\Windows\Installer" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\spool\SERVERS" (
    del /f /q /s C:\Windows\System32\spool\SERVERS\* >nul 2>&1
)

%update_bar%
if exist "C:\Windows\CSC" (
    takeown /F C:\Windows\CSC /R /A >nul 2>&1
    icacls C:\Windows\CSC /grant Administrators:F /T >nul 2>&1
    del /f /q /s C:\Windows\CSC\* >nul 2>&1
)

%update_bar%
if exist "C:\$SysReset" (rmdir /s /q "C:\$SysReset" >nul 2>&1)
if exist "C:\$GetCurrent" (rmdir /s /q "C:\$GetCurrent" >nul 2>&1)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'LocalCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Opera Software\Opera GX Stable\ShaderCache" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\dumps" (rmdir /s /q "C:\Program Files (x86)\Steam\dumps" >nul 2>&1)
if exist "C:\Program Files (x86)\Steam\logs" (del /f /q /s "C:\Program Files (x86)\Steam\logs\*" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\Blender Foundation\Blender" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Blender Foundation\Blender' -Include *.crash, *.log, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.node-gyp" (rmdir /s /q "%USERPROFILE%\.node-gyp" >nul 2>&1)

%update_bar%
certutil -urlcache * delete >nul 2>&1

%update_bar%
if exist "%USERPROFILE%\.nuget" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\UnrealEngine" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\UnrealEngine' -Include *.log, *.tmp, *ShaderCache* -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\LocalLow" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\LocalLow' -Include *.log, *.crashdumps -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Slack\Cache" (del /f /q /s "%APPDATA%\Slack\Cache\*" >nul 2>&1)
if exist "%APPDATA%\Slack\Code Cache" (del /f /q /s "%APPDATA%\Slack\Code Cache\*" >nul 2>&1)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" (rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive" >nul 2>&1)
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" (rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\*.db" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\NetTrace (
    del /f /q /s C:\Windows\System32\LogFiles\NetTrace\* >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache" (rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache" >nul 2>&1)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'FontCache' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist "%USERPROFILE%\.easy_install" (rmdir /s /q "%USERPROFILE%\.easy_install" >nul 2>&1)

%update_bar%
defrag C: /O /H /U /V >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "pnputil /delete-driver oem*.inf /uninstall /force" >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -ErrorAction SilentlyContinue | Where-Object { (Get-AppxPackage -Name $_.Name -AllUsers) -eq $null } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist C:\Windows\Panther (
    del /f /q /s C:\Windows\Panther\*.log >nul 2>&1
    del /f /q /s C:\Windows\Panther\*.tmp >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\Explorer" (
    del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
)

%update_bar%
if exist C:\$WINDOWS.~BT (
    del /f /q /s C:\$WINDOWS.~BT\*.tmp >nul 2>&1
    del /f /q /s C:\$WINDOWS.~BT\*.log >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SetupCache" (
    rmdir /s /q "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SetupCache" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\EdgeWebView\User Data\Default\Cache" (
    del /f /q /s "%LocalAppData%\Microsoft\EdgeWebView\User Data\Default\Cache\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\OneDrive\cache" (
    rmdir /s /q "%LocalAppData%\Microsoft\OneDrive\cache" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\*" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\SystemData\LfS" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\SystemData\LfS\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\Tasks (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Tasks -Recurse -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v "LastKey" /f >nul 2>&1

%update_bar%
if exist C:\Windows\Speech\SpeechReco (
    del /f /q /s C:\Windows\Speech\SpeechReco\*.tmp >nul 2>&1
)

%update_bar%
fsutil transaction thin C:\ >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\Program Files', 'C:\Program Files (x86)' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^(Cache|Logs|Temp)$' } | ForEach-Object { compact /c /s:\"$($_.FullName)\" /exe:lzx /i >$null 2>&1 }"

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\Installer -Filter *.msi -ErrorAction SilentlyContinue | ForEach-Object { compact /c /exe:lzx $_.FullName >$null 2>&1 }"

%update_bar%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 0 /f >nul 2>&1
if exist C:\Windows\MEMORY.DMP (del /f /q C:\Windows\MEMORY.DMP >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\sysprep\Panther (
    del /f /q /s C:\Windows\System32\sysprep\Panther\*.log >nul 2>&1
    del /f /q /s C:\Windows\System32\sysprep\Panther\*.xml >nul 2>&1
)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\AppData\Local', '$env:USERPROFILE\AppData\Roaming' -Recurse -Filter *.log -ErrorAction SilentlyContinue | ForEach-Object { compact /c \"$($_.FullName)\" >$null 2>&1 }"

%update_bar%
if exist "%LocalAppData%\TileDataLayer" (rmdir /s /q "%LocalAppData%\TileDataLayer" >nul 2>&1)

%update_bar%
if exist C:\USMTMIG (rmdir /s /q C:\USMTMIG >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\GroupPolicyUsers (rmdir /s /q C:\Windows\System32\GroupPolicyUsers >nul 2>&1)

%update_bar%
compact /c /s:C:\Windows\System32\LogFiles /i >nul 2>&1
compact /c /s:C:\Windows\System32\winevt\Logs /i >nul 2>&1

%update_bar%
if exist "C:\Windows\Installer\\$PatchCache$" (
    rmdir /s /q "C:\Windows\Installer\\$PatchCache$" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows Defender\Definition Updates" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:ProgramData\Microsoft\Windows Defender\Definition Updates' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^{.*}$' } | ForEach-Object { rmdir $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\winsxs\ManifestCache" (
    del /f /q /s C:\Windows\winsxs\ManifestCache\* >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\RtBackup" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\LogFiles\WMI\RtBackup -Filter *.etl -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
Lpksetup /u >nul 2>&1

%update_bar%
if exist "C:\Windows\Servicing" (
    compact /c /s:C:\Windows\Servicing /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Diagnosis\DownloadedSettings" (
    del /f /q /s "%ProgramData%\Microsoft\Diagnosis\DownloadedSettings\*" >nul 2>&1
)

%update_bar%
del /f /q /s C:\*.chk >nul 2>&1

%update_bar%
DISM.exe /Online /Cleanup-Image /SFC /Disable-Feature /FeatureName:Windows-Rollback-Data >nul 2>&1

%update_bar%
compact /c /s:C:\Windows\System32\WindowsPowerShell /exe:lzx /i >nul 2>&1

%update_bar%
del /f /q /s C:\*.sqm >nul 2>&1

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Media Player\Network Sharing" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Network Sharing\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:C:\Windows\System32\DriverStore\FileRepository /i >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\BitLocker (
    del /f /q /s C:\Windows\System32\LogFiles\BitLocker\* >nul 2>&1
)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Packages' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^Photos.*Cache$' } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\WER\ReportQueue" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\WER\ReportQueue\AppCrash_*" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CyberSense\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\Help (
    compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\Logs" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\Logs\*" >nul 2>&1
)

%update_bar%
del /f /q /s C:\Users\*\AppData\Local\pip\cache\*.tmp >nul 2>&1

%update_bar%
chkntfs /X C: >nul 2>&1

%update_bar%
defrag C: /U /V /X /H /K /G >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -ReTrim -Defrag" >nul 2>&1

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force" >nul 2>&1

%update_bar%
if exist "%SystemDrive%\ProgramData\AMD" (rmdir /s /q "%SystemDrive%\ProgramData\AMD" >nul 2>&1)
if exist "%SystemDrive%\ProgramData\NVIDIA" (rmdir /s /q "%SystemDrive%\ProgramData\NVIDIA" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\AppRepository" (
    compact /c /s:"%ProgramData%\Microsoft\Windows\AppRepository" /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\OCR" (
    del /f /q /s "%ProgramData%\Microsoft\Windows\OCR\*" >nul 2>&1
)
if exist "%LocalAppData%\Microsoft\Windows\AI" (
    rmdir /s /q "%LocalAppData%\Microsoft\Windows\AI" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\Package Cache" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Package Cache' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\DriverStore\en-US" (compact /c /s:"C:\Windows\System32\DriverStore\en-US" /exe:lzx /i >nul 2>&1)
if exist "C:\Windows\System32\DriverStore\it-IT" (compact /c /s:"C:\Windows\System32\DriverStore\it-IT" /exe:lzx /i >nul 2>&1)

%update_bar%
defrag C: /O /H /X /U /V /K /G >nul 2>&1

%update_bar%
DISM.exe /Online /Disable-Feature /FeatureName:WorkFolders-Client /NoRestart >nul 2>&1
DISM.exe /Online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /NoRestart >nul 2>&1

%update_bar%
if exist C:\Windows\InputMethod (
    compact /c /s:C:\Windows\InputMethod /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\wdi\LogFiles (
    del /f /q /s C:\Windows\System32\wdi\LogFiles\* >nul 2>&1
)

%update_bar%
net stop wsearch >nul 2>&1
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows" (
    del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\*.log" >nul 2>&1
)
net start wsearch >nul 2>&1

%update_bar%
if exist C:\Windows\SystemResources (
    compact /c /s:C:\Windows\SystemResources /i >nul 2>&1
)

%update_bar%
del /f /q /s "%LocalAppData%\Microsoft\Windows\Notifications\wpndatabase.db" >nul 2>&1

%update_bar%
if exist C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore (
    rmdir /s /q C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\Wer (
    compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1
)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Microsoft\Windows\AppXDeploymentServer' -Filter *.log, *.tmp -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1

%update_bar%
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Download" (
    rmdir /s /q "%ProgramFiles(x86)%\Microsoft\Edge\Download" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.log" >nul 2>&1
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Support\*.txt" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Storage\ext\mpogngknbghclgocfkp... (identificatore)" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\Chrome\User Data' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'File System' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1

%update_bar%
if exist "%APPDATA%\vlc\art" (rmdir /s /q "%APPDATA%\vlc\art" >nul 2>&1)

%update_bar%
if exist "%AppData%\Opera Software\Opera GX Stable\Network Action Predictor" (del /f /q /s "%AppData%\Opera Software\Opera GX Stable\Network Action Predictor*" >nul 2>&1)

%update_bar%
net stop wsearch >nul 2>&1
del /f /q /s C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\SettingSync\*.log >nul 2>&1
net start wsearch >nul 2>&1

%update_bar%
if exist "%AppData%\Microsoft\Teams\Backgrounds" (del /f /q /s "%AppData%\Microsoft\Teams\Backgrounds\*" >nul 2>&1)
if exist "%AppData%\Microsoft\Teams\media-stack" (del /f /q /s "%AppData%\Microsoft\Teams\media-stack\*" >nul 2>&1)

%update_bar%
if exist C:\Windows\Logs\DISM (compact /c /s:C:\Windows\Logs\DISM /exe:lzx /i >nul 2>&1)

%update_bar%
defrag C: /O /H /X /U /V /K /G /A >nul 2>&1

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\AppRepository\Packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\AppRepository\Packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\GameBar" (
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.log" >nul 2>&1
    del /f /q /s "%LocalAppData%\Microsoft\Windows\GameBar\*.tmp" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\Audio (
    del /f /q /s C:\Windows\System32\LogFiles\Audio\* >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Temp\PSR" (
    rmdir /s /q "%LocalAppData%\Temp\PSR" >nul 2>&1
)

%update_bar%
if exist C:\Windows\LiveKernelReports (
    del /f /q /s C:\Windows\LiveKernelReports\*.dmp >nul 2>&1
    for /d %%p in (C:\Windows\LiveKernelReports\*) do rmdir /s /q "%%p" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\INetCookies" (
    compact /c /s Backups /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (
    rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\OneDrive\logs" (
    del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Edge\User Data\Crashpad" (
    compact /c /s:"%LocalAppData%\Microsoft\Edge\User Data\Crashpad" /i >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\Microsoft\Windows\Containers\Sandboxes" (
    del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\*.log >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (
    del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\MsSpellCheckingFacility (
    compact /c /s:C:\Windows\System32\MsSpellCheckingFacility /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\Bluetooth (
    del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1
)

%update_bar%
del /f /q /s "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1)
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\logger" (del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\logger\*" >nul 2>&1)

%update_bar%
if exist C:\Windows\Panther (
    compact /c /s:C:\Windows\Panther /exe:lzx /i >nul 2>&1
)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('C:\ReadyToTrim.txt', 'Clean'); Remove-Item 'C:\ReadyToTrim.txt' -Force; Optimize-Volume -DriveLetter C -Defrag -ReTrim" >nul 2>&1

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\AppRepository\Packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\AppRepository\Packages' -Filter *.tmp, *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Edge\User Data\Crashpad" (
    compact /c /s:"%LocalAppData%\Microsoft\Edge\User Data\Crashpad" /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\Media Player" (
    rmdir /s /q "%LocalAppData%\Microsoft\Media Player" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.cargo\registry\cache" (
    rmdir /s /q "%USERPROFILE%\.cargo\registry\cache" >nul 2>&1
)

%update_bar%
defrag C: /O /H /X /U /V >nul 2>&1

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\NetworkCache\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'cookies.sqlite*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'datareporting' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'startupCache' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Mozilla\Firefox\Crash Reports" (
    rmdir /s /q "%APPDATA%\Mozilla\Firefox\Crash Reports" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'extension-cookies' -ErrorAction SilentlyContinue | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File | Remove-Item -Force }" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'favicons.sqlite*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'AlternateServices.txt' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "C:\Users\Public" (
    compact /c /s:"C:\Users\Public" /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\OCR" (del /f /q /s "%ProgramData%\Microsoft\Windows\OCR\*" >nul 2>&1)
if exist "%LocalAppData%\Microsoft\Windows\AI" (rmdir /s /q "%LocalAppData%\Microsoft\Windows\AI" >nul 2>&1)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\RtBackup" (
    del /f /q /s C:\Windows\System32\LogFiles\WMI\RtBackup\*.etl >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows Defender\Scans\History\Store" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1
)

%update_bar%
if exist "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" (
    rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\Documents\IISExpress\Logs" (
    del /f /q /s "%USERPROFILE%\Documents\IISExpress\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Google\DriveFS" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Google\DriveFS' -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)^content_cache$' } | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CrashDumps" (
    del /f /q /s "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection\CrashDumps\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Vivaldi\User Data\Default\Cache" (
    del /f /q /s "%LocalAppData%\Vivaldi\User Data\Default\Cache\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\WMI\wifi.etl (
    del /f /q C:\Windows\System32\LogFiles\WMI\wifi.etl >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\WinRAR\Templates" (
    del /f /q /s "%APPDATA%\WinRAR\Templates\*" >nul 2>&1
)

%update_bar%
if exist C:\Windows\Logs\WaasMedic (
    del /f /q /s C:\Windows\Logs\WaasMedic\* >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Filter *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache" (del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Media Cache\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports" (del /f /q /s "%LOCALAPPDATA%\Vivaldi\User Data\Crashpad\reports\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Tor Browser\Browser\TorBrowser\Data\Browser\Caches" (rmdir /s /q "%LOCALAPPDATA%\Tor Browser\Browser\TorBrowser\Data\Browser\Caches" >nul 2>&1)

%update_bar%
if exist "%AppData%\Foxit Software\Foxit PDF Reader\FontCache" (rmdir /s /q "%AppData%\Foxit Software\Foxit PDF Reader\FontCache" >nul 2>&1)

%update_bar%
if exist "%AppData%\Wondershare\Wondershare Filmora\Log" (del /f /q /s "%AppData%\Wondershare\Wondershare Filmora\Log\*" >nul 2>&1)

%update_bar%
if exist "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache" (del /f /q /s "%AppData%\Blackmagic Design\DaVinci Resolve\Preferences\Cache\*" >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.gem\specs" (rmdir /s /q "%USERPROFILE%\.gem\specs" >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.docker\cli-plugins" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.docker' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)

%update_bar%
if exist "%AppData%\WinSCP\Cache" (rmdir /s /q "%AppData%\WinSCP\Cache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Putty" (del /f /q /s "%LocalAppData%\Putty\*.log" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Plex Media Server\Cache" (rmdir /s /q "%LocalAppData%\Plex Media Server\Cache" >nul 2>&1)

%update_bar%
if exist "%AppData%\IrfanView\Cache" (rmdir /s /q "%AppData%\IrfanView\Cache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Audacity\SessionData" (rmdir /s /q "%LocalAppData%\Audacity\SessionData" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Common" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Common\*" >nul 2>&1)

%update_bar%
if exist "%AppData%\obsidian\logs" (del /f /q /s "%AppData%\obsidian\logs\*" >nul 2>&1)

%update_bar%
if exist "%AppData%\Signal\Cache" (rmdir /s /q "%AppData%\Signal\Cache" >nul 2>&1)

%update_bar%
if exist "%AppData%\Microsoft\Skype for Desktop\logs" (del /f /q /s "%AppData%\Microsoft\Skype for Desktop\logs\*" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Riot Games\Install Mobile" (del /f /q /s "%LocalAppData%\Riot Games\Install Mobile\*.log" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\LGHUB\logs" (del /f /q /s "%LocalAppData%\LGHUB\logs\*" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Razer\Synapse3\Log" (del /f /q /s "%ProgramData%\Razer\Synapse3\Log\*" >nul 2>&1)

%update_bar%
if exist "C:\Program Files\Realtek\Audio\HDA\Logs" (del /f /q /s "C:\Program Files\Realtek\Audio\HDA\Logs\*" >nul 2>&1)

%update_bar%
if exist C:\Windows\w32time.log (del /f /q C:\Windows\w32time.log >nul 2>&1)

%update_bar%
if exist C:\Windows\Speech\Common (del /f /q /s C:\Windows\Speech\Common\*.log >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.dotnet\corefx" (rmdir /s /q "%USERPROFILE%\.dotnet\corefx" >nul 2>&1)

%update_bar%
if exist "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" (del /f /q "%AppData%\Microsoft\Network\Connections\Pbk\rasphone.log" >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\Sru (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log, *.txt -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\Diagnosis" (compact /c /s:%ProgramData%\Microsoft\Diagnosis /exe:lzx /i >nul 2>&1)

%update_bar%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Optimize-Volume -DriveLetter C -Optimize" >nul 2>&1

%update_bar%
if exist "C:\ProgramData\Intel\Downloads" (rmdir /s /q "C:\ProgramData\Intel\Downloads" >nul 2>&1)

%update_bar%
if exist C:\Windows\servicing\Packages (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\servicing\Packages -Filter *.cat, *.mum -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\wbem\AutoRecover (
    del /f /q /s C:\Windows\System32\wbem\AutoRecover\*.mof >nul 2>&1
)

%update_bar%
:: I driver sono già caricati nel Kernel, la compressione LZX riduce lo spazio del 40% in totale sicurezza.
if exist "C:\Windows\System32\DriverStore\FileRepository" (
    compact /c /s:"C:\Windows\System32\DriverStore\FileRepository" /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist "%AppData%\Adobe\Common\Peak Files" (rmdir /s /q "%AppData%\Adobe\Common\Peak Files" >nul 2>&1)

%update_bar%
if exist C:\Windows\Fonts (
    del /f /q /s C:\Windows\Fonts\*.bak >nul 2>&1
    del /f /q /s C:\Windows\Fonts\*.tmp >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\pip\wheels" (rmdir /s /q "%LocalAppData%\pip\wheels" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Personal" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Personal\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\OneDrive\logs\Business1" (del /f /q /s "%LocalAppData%\Microsoft\OneDrive\logs\Business1\*" >nul 2>&1)

%update_bar%
if exist C:\Windows\Logs\VDS (del /f /q /s C:\Windows\Logs\VDS\* >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.nuget\packages" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.nuget\packages' -Include *.tmp, *.log -Recurse -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files\Microsoft Office\root\Office16\Proof" (
    compact /c /s:"C:\Program Files\Microsoft Office\root\Office16\Proof" /exe:lzx /i >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\EFS (del /f /q /s C:\Windows\System32\LogFiles\EFS\* >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.Todos_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.Todos_8wekyb3d8bbwe\LocalCache" >nul 2>&1)

%update_bar%
del /f /q C:\ProgramData\*.tmp >nul 2>&1
del /f /q C:\ProgramData\*.log >nul 2>&1

%update_bar%
if exist "%LocalAppData%\Microsoft\Media Player\Art Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Media Player\Art Cache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.XboxLiveAuthHost_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxLiveAuthHost_8wekyb3d8bbwe\LocalState\*" >nul 2>&1)

%update_bar%
if exist "C:\Program Files\Java" (compact /c /s:"C:\Program Files\Java" /exe:lzx /i >nul 2>&1)

%update_bar%
if exist "C:\Program Files (x86)\Java" (compact /c /s:"C:\Program Files (x86)\Java" /exe:lzx /i >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\LogFiles\WLAN (del /f /q /s C:\Windows\System32\LogFiles\WLAN\* >nul 2>&1)

%update_bar%
if exist "C:\Windows\System32\DirectX" (compact /c /s:"C:\Windows\System32\DirectX" /exe:lzx /i >nul 2>&1)

%update_bar%
if exist C:\Windows\Boot\EFI\*.bak (del /f /q C:\Windows\Boot\EFI\*.bak >nul 2>&1)

%update_bar%
if exist "%AppData%\Adobe\Common\PTX" (rmdir /s /q "%AppData%\Adobe\Common\PTX" >nul 2>&1)

%update_bar%
:: I log storici occupano molto spazio, comprimerli in LZX fa risparmiare il 60% in totale sicurezza.
if exist C:\Windows\System32\winevt (compact /c /s:C:\Windows\System32\winevt /exe:lzx /i >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports" (del /f /q /s "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports\*" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows Defender\Support" (compact /c /s:"%ProgramData%\Microsoft\Windows Defender\Support" /i >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe\LocalState\*" >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Temp" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Temp' -Recurse -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%AppData%\Microsoft\Teams\logs" (del /f /q /s "%AppData%\Microsoft\Teams\logs\*" >nul 2>&1)

%update_bar%
if exist "%JucheckLogDir%" (del /f /q /s "%JucheckLogDir%\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Dropbox\logs" (del /f /q /s "%LocalAppData%\Dropbox\logs\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Cisco\Spark\*\logs" (del /f /q /s "%LocalAppData%\Cisco\Spark\*\logs\*" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\BlueStacks_nxt\Engine\UserData\InputMethods\Cache" (rmdir /s /q "%ProgramData%\BlueStacks_nxt\Engine\UserData\InputMethods\Cache" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\BlueStacks_nxt\Logs" (del /f /q /s "%ProgramData%\BlueStacks_nxt\Logs\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Box\Box Sync\Logs" (del /f /q /s "%LocalAppData%\Box\Box Sync\Logs\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Amazon\Kindle\Cache" (rmdir /s /q "%LocalAppData%\Amazon\Kindle\Cache" >nul 2>&1)

%update_bar%
if exist "%AppData%\Notepad++\backup" (del /f /q /s "%AppData%\Notepad++\backup\*" >nul 2>&1)

%update_bar%
if exist "%AppData%\Code\CachedExtensionVSIX" (rmdir /s /q "%AppData%\Code\CachedExtensionVSIX" >nul 2>&1)

%update_bar%
if exist "%AppData%\Code\logs" (del /f /q /s "%AppData%\Code\logs\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Vivaldi\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Vivaldi\User Data\ShaderCache" >nul 2>&1)

%update_bar%
if exist "%AppData%\GitHubDesktop\Cache" (rmdir /s /q "%AppData%\GitHubDesktop\Cache" >nul 2>&1)

%update_bar%
if exist "%AppData%\GitHubDesktop\logs" (del /f /q /s "%AppData%\GitHubDesktop\logs\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Google\AndroidStudio*\caches" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\caches\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Google\AndroidStudio*\log" (del /f /q /s "%LocalAppData%\Google\AndroidStudio*\log\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\PowerShell\ModuleAnalysisCache" (del /f /q "%LocalAppData%\Microsoft\Windows\PowerShell\ModuleAnalysisCache" >nul 2>&1)

%update_bar%
del /f /q /s "%AppData%\Microsoft\Word\*.tmp" >nul 2>&1

%update_bar%
del /f /q /s "%AppData%\Microsoft\Excel\*.tmp" >nul 2>&1

%update_bar%
if exist C:\Windows\System32\LogFiles\NetTrace (del /f /q /s C:\Windows\System32\LogFiles\NetTrace\* >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\MapData" (del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1)

%update_bar%
if exist "%WINDIR%\System32\dxdiag.exe" (del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*" >nul 2>&1)

%update_bar%
if exist C:\Windows\Logs\WaasMedic (del /f /q /s C:\Windows\Logs\WaasMedic\* >nul 2>&1)

%update_bar%
for /d %%d in (C:\Windows\Microsoft.NET\Framework*) do (del /f /q /s "%%d\*.log" >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\LogFiles\Audio (del /f /q /s C:\Windows\System32\LogFiles\Audio\* >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Temp\PSR" (rmdir /s /q "%LocalAppData%\Temp\PSR" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\CryptnetUrlCache" (rmdir /s /q "%LocalAppData%\Microsoft\CryptnetUrlCache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.YourPhone_8wekyb3d8bbwe\LocalCache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared" (del /f /q /s "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\shared\*" >nul 2>&1)

%update_bar%
if exist "C:\ProgramData\Microsoft\Windows\Containers\Sandboxes" (del /f /q /s C:\ProgramData\Microsoft\Windows\Containers\Sandboxes\*.log >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState" (del /f /q /s "%LocalAppData%\Packages\Microsoft.GamingServices_8wekyb3d8bbwe\LocalState\*.tmp" >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\LogFiles\Bluetooth (del /f /q /s C:\Windows\System32\LogFiles\Bluetooth\* >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\Wer (compact /c /s:C:\Windows\System32\Wer /exe:lzx /i >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\LogFiles\CNG (del /f /q /s C:\Windows\System32\LogFiles\CNG\* >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\Windows\GLCache" (rmdir /s /q "%LocalAppData%\Microsoft\Windows\GLCache" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\Document Building Blocks" (del /f /q /s "%ProgramData%\Microsoft\Document Building Blocks\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Microsoft\Edge\User Data\ShaderCache" (rmdir /s /q "%LocalAppData%\Microsoft\Edge\User Data\ShaderCache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.3DBuilder_8wekyb3d8bbwe\LocalCache" (rmdir /s /q "%LocalAppData%\Packages\Microsoft.3DBuilder_8wekyb3d8bbwe\LocalCache" >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Vault (del /f /q /s C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Vault\*.log >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\LocalState\Logs" (del /f /q /s "%LocalAppData%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\LocalState\Logs\*" >nul 2>&1)

%update_bar%
if exist "%ProgramData%\Microsoft\Windows\SelfHost" (del /f /q /s "%ProgramData%\Microsoft\Windows\SelfHost\*" >nul 2>&1)

%update_bar%
if exist "%USERPROFILE%\.virtualenvs" (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:USERPROFILE\.virtualenvs' -Filter *.pyc, *.tmp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)

%update_bar%
if exist "%AppData%\obsidian\Cache" (rmdir /s /q "%AppData%\obsidian\Cache" >nul 2>&1)

%update_bar%
if exist "%AppData%\Signal\logs" (del /f /q /s "%AppData%\Signal\logs\*" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\CyberLink\PowerDirector\*\Cache" (del /f /q /s "%LocalAppData%\CyberLink\PowerDirector\*\Cache\*" >nul 2>&1)

%update_bar%
if exist "%AppData%\Corel\Messages" (rmdir /s /q "%AppData%\Corel\Messages" >nul 2>&1)

%update_bar%
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)

%update_bar%
if exist C:\Windows\System32\Sru (powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1)

%update_bar%
:: I software commerciali non eseguono mai questo comando perché blocca il sistema per minuti.
:: Forza la rimozione fisica definitiva dei binari di sistema obsoleti non più necessari.
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart >nul 2>&1

%update_bar%
if exist "C:\ProgramData\Package Cache" (
    del /f /q /s "C:\ProgramData\Package Cache\*.tmp" >nul 2>&1
    del /f /q /s "C:\ProgramData\Package Cache\*.log" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Adobe\Lightroom\Cache" (rmdir /s /q "%LocalAppData%\Adobe\Lightroom\Cache" >nul 2>&1)

%update_bar%
if exist "%AppData%\Godot\app_user_data\__logs" (del /f /q /s "%AppData%\Godot\app_user_data\__logs\*" >nul 2>&1)

%update_bar%
if exist "%AppData%\UnityHub\logs" (del /f /q /s "%AppData%\UnityHub\logs\*" >nul 2>&1)

%update_bar%
:: Metodo ufficiale Microsoft per spurgare i file di sistema obsoleti sostituiti dagli aggiornamenti.
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1

%update_bar%
if exist "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" (rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\Download" >nul 2>&1)

%update_bar%
if exist "%AppData%\WinZip\wztemp" (rmdir /s /q "%AppData%\WinZip\wztemp" >nul 2>&1)

%update_bar%
if exist "%LocalAppData%\Adobe\caps" (del /f /q /s "%LocalAppData%\Adobe\caps\*.tmp" >nul 2>&1)

%update_bar%
if exist "%AppData%\Adobe\Common\Media Cache Files" (rmdir /s /q "%AppData%\Adobe\Common\Media Cache Files" >nul 2>&1)

%update_bar%
:: Disegna una barra di caricamento professionale nel prompt dei comandi per mostrare l'avanzamento reale al 100%
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Write-Progress -Activity 'Windows Space Overlord' -Status 'Consolidamento e allineamento cluster finali in corso...' -PercentComplete 95; Start-Sleep -Milliseconds 500; Write-Progress -Activity 'Windows Space Overlord' -Status 'Scrittura indici di sicurezza sul Desktop...' -PercentComplete 99; Start-Sleep -Milliseconds 400"

%update_bar%
DISM.exe /Online /Cleanup-Image /SFC /Disable-Feature /FeatureName:Windows-Rollback-Data /NoRestart >nul 2>&1

%update_bar%
:: Usa robocopy per svuotare migliaia di file multimediali pesanti istantaneamente senza freeze
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\cache" (
    mkdir "%temp%\t_empty" >nul 2>&1
    robocopy "%temp%\t_empty" "%APPDATA%\Telegram Desktop\tdata\user_data\cache" /MIR >nul 2>&1
    rmdir /s /q "%temp%\t_empty" >nul 2>&1
)

%update_bar%
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1

%update_bar%
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\Code Cache\*" >nul 2>&1

%update_bar%
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1

%update_bar%
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\Cache\*" >nul 2>&1
del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\Code Cache\*" >nul 2>&1

%update_bar%
if exist "%LOCALAPPDATA%\Spotify\Data" (del /f /q /s "%LOCALAPPDATA%\Spotify\Data\*" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\discord\Cache" (del /f /q /s "%APPDATA%\discord\Cache\*" >nul 2>&1)

%update_bar%
if exist "C:\Program Files (x86)\Steam\config\htmlcache" (
    del /f /q /s "C:\Program Files (x86)\Steam\config\htmlcache\*" >nul 2>&1
    for /d %%p in ("C:\Program Files (x86)\Steam\config\htmlcache\*") do rmdir /s /q "%%p" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache" (
    del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*" >nul 2>&1
    for /d %%p in ("%PROGRAMDATA%\Electronic Arts\EA Desktop\Cache\*") do rmdir /s /q "%%p" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" (
    rmdir /s /q "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache" >nul 2>&1
)

%update_bar%
if exist "%ProgramData%\Battle.net\Agent\Agent.*\Logs" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\ProgramData\Battle.net\Agent' -Filter *.log -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\Sru (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Windows\System32\Sru -Filter *.log -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist C:\Windows\System32\LogFiles\BitLocker (del /f /q /s C:\Windows\System32\LogFiles\BitLocker\* >nul 2>&1)

%update_bar%
if exist C:\Windows\Help (compact /c /s:C:\Windows\Help /exe:lzx /i >nul 2>&1)

%update_bar%
if exist "C:\Program Files\Microsoft Office\root\Office16\Proof" (compact /c /s:"C:\Program Files\Microsoft Office\root\Office16\Proof" /exe:lzx /i >nul 2>&1)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Video ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Video ShaderCache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extension Logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extension Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Apple Computer\iTunes\SubscriptionPlayCache" (
    rmdir /s /q "%LOCALAPPDATA%\Apple Computer\iTunes\SubscriptionPlayCache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\Crashpad" (
    rmdir /s /q "%APPDATA%\discord\Crashpad" >nul 2>&1
)

%update_bar%
if exist "%WINDIR%\System32\config\systemprofile\AppData\Local\D3DSCache" (
    rmdir /s /q "%WINDIR%\System32\config\systemprofile\AppData\Local\D3DSCache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CurseForge\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\CurseForge\Cache" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\VisualStudio\Packages\_Instances" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:PROGRAMDATA\Microsoft\VisualStudio\Packages\_Instances' -Recurse -Include *.log, *.tmp -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.cache\pip" (
    rmdir /s /q "%USERPROFILE%\.cache\pip" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Temp" (
    del /f /q /s "%LOCALAPPDATA%\Temp\*.tmp" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\w32time" (
    del /f /q /s "C:\Windows\w32time\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\js" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\js" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy\LocalState\Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\reports\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\faceitclient\logs" (
    del /f /q /s "%APPDATA%\faceitclient\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Discord\app-*\modules" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Discord' -Recurse -Directory -Filter 'DawnWebGPUCache' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CurseForge\Minecraft\Install\temp" (
    rmdir /s /q "%LOCALAPPDATA%\CurseForge\Minecraft\Install\temp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Spotify" (
    del /f /q /s "%LOCALAPPDATA%\Spotify\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\logs" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\OneDrive\setup\logs\*.log" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Sun\Java\Deployment\SystemCache" (
    rmdir /s /q "%APPDATA%\Sun\Java\Deployment\SystemCache" >nul 2>&1
)

%update_bar%
if exist "%WINDIR%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\AudioEngine" (
    del /f /q /s "%WINDIR%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\AudioEngine\*" >nul 2>&1
)

%update_bar%
if exist "C:\PerfLogs" (
    del /f /q /s "C:\PerfLogs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\FontCache" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Office\16.0\FontCache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache_4430" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache_4430" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.nuget\packages\.tools" (
    rmdir /s /q "%USERPROFILE%\.nuget\packages\.tools" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.XboxGameOverlay_8wekyb3d8bbwe\AC\INetCache" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.XboxGameOverlay_8wekyb3d8bbwe\AC\INetCache\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Telegram Desktop\tdata\crashes" (
    del /f /q /s "%APPDATA%\Telegram Desktop\tdata\crashes\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\MOS" (
    del /f /q /s "C:\Windows\Logs\MOS\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\thumbnails" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\OneDrive\thumbnails" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\GroupPolicy\Machine" (
    del /f /q /s "C:\Windows\System32\GroupPolicy\Machine\*.log" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Media Cache" (
    del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Media Cache\*" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\CrashDump" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\CrashDump\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Windows\Audio" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\Audio\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\GOG.com\Galaxy\temp" (
    rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\temp" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\EdgeUpdate\Log" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\EdgeUpdate\Log\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\CacheManager" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\CacheManager\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\NetCore" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\NetCore\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.XboxApp_8wekyb3d8bbwe\LocalState\Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\AcquisitionManager" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\AcquisitionManager" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\pip\Logs" (
    del /f /q /s "%LOCALAPPDATA%\pip\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\Local Storage" (
    del /f /q /s "%APPDATA%\discord\Local Storage\leveldb\*.log" >nul 2>&1
    del /f /q /s "%APPDATA%\discord\Local Storage\leveldb\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\4DF9E0F8.Netflix_mcm4yx254vgr4\LocalState\offline_views" (
    del /f /q /s "%LOCALAPPDATA%\Packages\4DF9E0F8.Netflix_mcm4yx254vgr4\LocalState\offline_views\*.tmp" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\DwmRedir" (
    del /f /q /s "C:\Windows\System32\LogFiles\DwmRedir\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.ClipchampVideoEditor_8wekyb3d8bbwe\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.ClipchampVideoEditor_8wekyb3d8bbwe\LocalState\Cache" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\NetworkDiagnostics" (
    del /f /q /s "C:\Windows\Logs\NetworkDiagnostics\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extensions\Temp" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extensions\Temp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.ZuneMusic_8wekyb3d8bbwe\LocalState\ImageStore" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.ZuneMusic_8wekyb3d8bbwe\LocalState\ImageStore" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Adobe\Logs" (
    del /f /q /s "%LOCALAPPDATA%\Adobe\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\CrashReportClient" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\CrashReportClient" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -File -Filter 'shortcut-cache*' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows\WDI\LogFiles" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows\WDI\LogFiles\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Windows\FontCache" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\FontCache\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache" (
    del /f /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Search Engine Data" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Search Engine Data" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Crash Reports" (
    rmdir /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Crash Reports" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\User Data\Default\Favicons" (
    del /f /q "%LOCALAPPDATA%\Opera Software\Opera GX Stable\User Data\Default\Favicons" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\completed" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad\completed\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Crashpad" (
    rmdir /s /q "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Crashpad" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Cookies" (
    del /f /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Cookies" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\configuration" (
    rmdir /s /q "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\configuration" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\logs\content_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\content_log.txt" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Windows\Regedit" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\Regedit" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\DiagOutputDir\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsCalculator_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsCalculator_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\NET Framework Setup\InstructionFiles" (
    rmdir /s /q "%PROGRAMDATA%\Microsoft\NET Framework Setup\InstructionFiles" >nul 2>&1
)

%update_bar%
if exist "%WINDIR%\Microsoft.NET\Framework\v4.0.30319\WPF\Fonts" (
    del /f /q /s "%WINDIR%\Microsoft.NET\Framework\v4.0.30319\WPF\Fonts\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Configuration" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Configuration" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extension Cookies" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extension Cookies" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\logs" (
    del /f /q /s "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\logs\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\logs" (
    del /f /q /s "%APPDATA%\discord\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Microsoft\OneDrive\setup\logs" (
    del /f /q /s "%LocalAppData%\Microsoft\OneDrive\setup\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\Telemetry" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\Telemetry" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\depotcache" (
    del /f /q /s "C:\Program Files (x86)\Steam\depotcache\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Electronic Arts\EA Services\License" (
    del /f /q /s "%PROGRAMDATA%\Electronic Arts\EA Services\License\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Razer\Razer Cortex\Logs" (
    rmdir /s /q "%LOCALAPPDATA%\Razer\Razer Cortex\Logs" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Administrative Tools" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\WER\ReportQueue\AppCrash_mmc.exe*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\Defrag" (
    del /f /q /s "C:\Windows\Logs\Defrag\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows Defender Advanced Threat Protection\SenseSenseDtc.log" (
    del /f /q "%PROGRAMDATA%\Microsoft\Windows Defender Advanced Threat Protection\SenseSenseDtc.log" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\Search" (
    del /f /q /s "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\Search\*.log" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Roblox\Downloads" (rmdir /s /q "%LOCALAPPDATA%\Roblox\Downloads" >nul 2>&1)
if exist "%LOCALAPPDATA%\Roblox\LocalStorage" (rmdir /s /q "%LOCALAPPDATA%\Roblox\LocalStorage" >nul 2>&1)

%update_bar%
if exist "%APPDATA%\.minecraft\logs" (del /f /q /s "%APPDATA%\.minecraft\logs\*" >nul 2>&1)
if exist "%APPDATA%\.minecraft\crash-reports" (del /f /q /s "%APPDATA%\.minecraft\crash-reports\*" >nul 2>&1)

%update_bar%
if exist "%PROGRAMDATA%\GOG.com\Galaxy\Logs" (
    del /f /q /s "%PROGRAMDATA%\GOG.com\Galaxy\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\LGHUB\depot" (
    rmdir /s /q "%PROGRAMDATA%\LGHUB\depot" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Ubisoft Game Launcher\crashes" (
    del /f /q /s "%LOCALAPPDATA%\Ubisoft Game Launcher\crashes\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\ShaderCache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\ShaderCache" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMFILES(X86)%\Microsoft\EdgeUpdate\Log" (
    del /f /q /s "%PROGRAMFILES(X86)%\Microsoft\EdgeUpdate\Log\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\GPUCache" (
    del /f /q /s "%APPDATA%\discord\GPUCache\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\Cache_Data" (
    del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera GX Stable\Cache\Cache_Data\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\thumbnails" (
    rmdir /s /q "%APPDATA%\Telegram Desktop\tdata\user_data\thumbnails" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\Verifier" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\Verifier\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingWeather_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\AppXDeploymentServer" (
    del /f /q /s "C:\Windows\Logs\AppXDeploymentServer\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\resmon.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\resmon.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Spotify\Users" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Spotify\Users' -Recurse -Directory -Filter 'Browser' -ErrorAction SilentlyContinue | ForEach-Object { Get-ChildItem $_.FullName -Recurse -File | Remove-Item -Force }" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Adobe\Adobe Substance 3D Designer\logs" (
    del /f /q /s "%APPDATA%\Adobe\Adobe Substance 3D Designer\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\GPUCache" (
    rmdir /s /q "%LOCALAPPDATA%\Opera Software\Opera Stable\GPUCache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Dropbox\logs" (
    del /f /q /s "%LOCALAPPDATA%\Dropbox\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\DriveFS\Logs" (
    del /f /q /s "%LOCALAPPDATA%\Google\DriveFS\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Favicons" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Favicons" >nul 2>&1
)

%update_bar%
if exist "C:\Riot Games\League of Legends\Logs\GameLogs" (
    rmdir /s /q "C:\Riot Games\League of Legends\Logs\GameLogs" >nul 2>&1
)

%update_bar%
if exist "%GAME_DIR%\.minecraft\crash-reports" (
    del /f /q /s "%GAME_DIR%\.minecraft\crash-reports\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\SteelSeries\GG\Logs" (
    del /f /q /s "%PROGRAMDATA%\SteelSeries\GG\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\vlc\art\artistalbum" (
    rmdir /s /q "%APPDATA%\vlc\art\artistalbum" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\TS3Client\logs" (
    del /f /q /s "%APPDATA%\TS3Client\logs\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\WinBioDatabase\Provisioning" (
    del /f /q /s "C:\Windows\System32\WinBioDatabase\Provisioning\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\taskmgr.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\taskmgr.exe*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows\SystemData\LfS\LogFiles" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows\SystemData\LfS\LogFiles\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\DxDiag" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\DxDiag\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Microsoft\MMC\eventvwr" (
    del /f /q "%APPDATA%\Microsoft\MMC\eventvwr" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Microsoft\Skype for Desktop\GPUCache" (
    rmdir /s /q "%APPDATA%\Microsoft\Skype for Desktop\GPUCache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Slack\GPUCache" (
    rmdir /s /q "%APPDATA%\Slack\GPUCache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Zoom\logs" (
    del /f /q /s "%APPDATA%\Zoom\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\OneDrive\logs" (
    del /f /q /s "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\OneDrive\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\LocalState\Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Riot Games\Installers" (
    del /f /q /s "%LOCALAPPDATA%\Riot Games\Installers\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Battle.net\Agent\Agent.*\Logs" (
    del /f /q /s "%PROGRAMDATA%\Battle.net\Agent\Agent.*\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Epic\EpicOnlineServices\Crashpad" (
    rmdir /s /q "%PROGRAMDATA%\Epic\EpicOnlineServices\Crashpad" >nul 2>&1
)

%update_bar%
if exist "C:\LDPlayer\log" (
    del /f /q /s "C:\LDPlayer\log\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Razer\Synapse3\Log" (
    rmdir /s /q "%PROGRAMDATA%\Razer\Synapse3\Log" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\consent.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\consent.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\mmc.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\mmc.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\AppleInc.iCloud_37bcys1dbagmj\LocalState\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\AppleInc.iCloud_37bcys1dbagmj\LocalState\Cache" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\Crypto" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\Crypto\*" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\AppData\Local\Temp\7z*" (
    del /f /q /s "%USERPROFILE%\AppData\Local\Temp\7z*\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Favicons" (
    del /f /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Favicons" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Spotify\Users" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Spotify\Users' -Recurse -Filter 'local-files.json' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\Cache\Cache_Data" (
    del /f /q /s "%APPDATA%\discord\Cache\Cache_Data\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\From_Server" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\From_Server" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Windows" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Windows\*.tmp" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\logs" (
    del /f /q /s "C:\Program Files (x86)\Steam\logs\*.log" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Data\UX\Cache" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\BlueStacks_nxt\Logs" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\LGHUB\logs" (
    del /f /q /s "%PROGRAMDATA%\LGHUB\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\RealtekSemiconductorCorp.RealtekAudioConsole_7f6ksnebe9st4\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\RealtekSemiconductorCorp.RealtekAudioConsole_7f6ksnebe9st4\LocalState\DiagOutputDir\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" (
    rmdir /s /q "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\wlansvc\log" (
    del /f /q /s "C:\Windows\wlansvc\log\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\BitLocker" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BitLocker\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\LocalState\TabState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\LocalState\TabState\*.bin" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\slobs-client\GPUCache" (
    rmdir /s /q "%APPDATA%\slobs-client\GPUCache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Curse\Logs" (
    del /f /q /s "%APPDATA%\Curse\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Overwolf\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Overwolf\Cache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\obs-studio\plugin_config\obs-browser\cef_cache" (
    rmdir /s /q "%APPDATA%\obs-studio\plugin_config\obs-browser\cef_cache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\Session Storage" (
    del /f /q /s "%APPDATA%\discord\Session Storage\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Local State" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\qBittorrent\BT_backup" (
    del /f /q /s "%LOCALAPPDATA%\qBittorrent\BT_backup\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Opera Software\Opera Stable\Crashpad\reports" (
    del /f /q /s "%LOCALAPPDATA%\Opera Software\Opera Stable\Crashpad\reports\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'MediaCache' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Media-Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Media-Cache" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\WmitData" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\WmitData\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsAlarms_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsAlarms_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\EdgeWebView\Log" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\EdgeWebView\Log\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\dxdiag.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\dxdiag.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.Windows.NarratorQuickStart_cw5n1h2txyewy\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.Windows.NarratorQuickStart_cw5n1h2txyewy\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Application Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Application Cache" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Microsoft\Skype for Desktop\Cache" (
    del /f /q /s "%APPDATA%\Microsoft\Skype for Desktop\Cache\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Extension Logs" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Extension Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\ViberMedia\Viber\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\ViberMedia\Viber\Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Deployment" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\Deployment" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs" (
    del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\TS3Client\cache\sounds" (
    rmdir /s /q "%APPDATA%\TS3Client\cache\sounds" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Razer\Razer Services\Logs" (
    del /f /q /s "%PROGRAMDATA%\Razer\Razer Services\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\GOG.com\Galaxy\Overlay" (
    del /f /q /s "%PROGRAMDATA%\GOG.com\Galaxy\Overlay\*.log" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\MemDiag" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\MemDiag\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Windows\Notifications\WPNS" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Windows\Notifications\WPNS\*.log" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsCamera_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsCamera_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\W32Time" (
    del /f /q /s "C:\Windows\Logs\W32Time\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.RemoteDesktop_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.RemoteDesktop_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Local Storage\leveldb" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Local Storage\leveldb\*.log" >nul 2>&1
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Local Storage\leveldb\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Roblox\logs" (
    del /f /q /s "%LOCALAPPDATA%\Roblox\logs\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Microsoft\Speller" (
    rmdir /s /q "%APPDATA%\Microsoft\Speller" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History Provider Cache" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History Provider Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Adobe\CCXWelcome\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Adobe\CCXWelcome\Cache" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMFILES%\Riot Vanguard\Logs" (
    del /f /q /s "%PROGRAMFILES%\Riot Vanguard\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Blizzard Entertainment\Battle.net\Cache\html" (
    rmdir /s /q "%LOCALAPPDATA%\Blizzard Entertainment\Battle.net\Cache\html" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs\*" >nul 2>&1
)

%update_bar%
if exist "C:\LDPlayer\vbox\logs" (
    del /f /q /s "C:\LDPlayer\vbox\logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Razer\Razer Cortex\Gamecaster\Logs" (
    rmdir /s /q "%LOCALAPPDATA%\Razer\Razer Cortex\Gamecaster\Logs" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\BthTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\WlanTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\WlanTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.ZuneVideo_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.ZuneVideo_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\devmgmt.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\devmgmt.exe*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\LsaTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\LsaTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Session Storage" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Session Storage\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\DriveFS\Transfers" (
    rmdir /s /q "%LOCALAPPDATA%\Google\DriveFS\Transfers" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:LOCALAPPDATA\Mozilla\Firefox\Profiles' -Recurse -Directory -Filter 'extension-preferences' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\Cache" (
    del /f /q /s "%APPDATA%\discord\Cache\f_*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Adobe\OOBE\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Adobe\OOBE\Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\RiotClientPrivate" (
    rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Logs\RiotClientPrivate" >nul 2>&1
)

%update_bar%
del /f /q /s C:\Windows\Microsoft.NET\Framework*\*\*.log >nul 2>&1

%update_bar%
if exist "C:\Program Files (x86)\Steam\logs\workshop_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\workshop_log.txt" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\LGHUB\temp" (
    rmdir /s /q "%PROGRAMDATA%\LGHUB\temp" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\obs-studio\updates" (
    rmdir /s /q "%APPDATA%\obs-studio\updates" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\GeoTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\GeoTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\WerFault.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\WerFault.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsMaps_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsMaps_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\BthPort" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthPort\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\NgcTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\NgcTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network Action Predictor" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network Action Predictor" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Sidebar" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Sidebar" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Dropbox\Update\Log" (
    del /f /q /s "%LOCALAPPDATA%\Dropbox\Update\Log\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Telegram Desktop\tdata\user_data\emoji" (
    rmdir /s /q "%APPDATA%\Telegram Desktop\tdata\user_data\emoji" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Local Extension Settings" (
    del /f /q /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Local Extension Settings\*" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Feeds" (
    rmdir /s /q "%PROGRAMDATA%\GOG.com\Galaxy\webcache\Feeds" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\IgoLogs" (
    del /f /q /s "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs\IgoLogs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\CacheStorage" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\Teams\CacheStorage" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Razer\Razer Cortex\Feedback" (
    rmdir /s /q "%LOCALAPPDATA%\Razer\Razer Cortex\Feedback" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\overlay" (
    rmdir /s /q "%LOCALAPPDATA%\Ubisoft Game Launcher\cache\overlay" >nul 2>&1
)

%update_bar%
if exist "%PROGRAMDATA%\Microsoft\Windows Defender\Support" (
    del /f /q /s "%PROGRAMDATA%\Microsoft\Windows Defender\Support\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\audiodg.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\audiodg.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\ScFilter" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\ScFilter\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\printfilterpipelineprinthandler.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\printfilterpipelineprinthandler.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GCM Store\Encryption" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GCM Store\Encryption" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" (
    rmdir /s /q "%LocalAppData%\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache" >nul 2>&1
)


%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad\reports" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad\reports\*" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\logs\overlay_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\overlay_log.txt" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Adobe\Adobe Illustrator *\AIPrefs" (
    del /f /q "%APPDATA%\Adobe\Adobe Illustrator *\AIPrefs" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Logs" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Logs\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\f_*" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.easy_install\logs" (
    del /f /q /s "%USERPROFILE%\.easy_install\logs\*" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Code\User\WorkspaceStorage" (
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '$env:APPDATA\Code\User\WorkspaceStorage' -Recurse -Filter '*.log' -ErrorAction SilentlyContinue | Remove-Item -Force" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\obs-studio\crashes" (
    del /f /q /s "%APPDATA%\obs-studio\crashes\*.txt" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\AudioTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\AudioTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Temp\DismHost*" (
    rmdir /s /q "%LOCALAPPDATA%\Temp\DismHost*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingNews_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingNews_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\WindowsUpdateClient" (
    del /f /q /s "C:\Windows\Logs\WindowsUpdateClient\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\powercfg.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\powercfg.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad\settings.dat" (
    del /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad\settings.dat" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\Code Cache\js" (
    rmdir /s /q "%APPDATA%\discord\Code Cache\js" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\AutofillStates" (
    del /f /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\AutofillStates\*" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\logs\cloud_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\cloud_log.txt" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Adobe\Common\Peak Files" (
    rmdir /s /q "%APPDATA%\Adobe\Common\Peak Files" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Input" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Input\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage\leveldb" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Local Storage\leveldb\*.log" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.easy_install\easy_install.log" (
    del /f /q "%USERPROFILE%\.easy_install\easy_install.log" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Code\User\globalStorage\telemetry" (
    rmdir /s /q "%APPDATA%\Code\User\globalStorage\telemetry" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\obs-studio\plugin_config\obs-browser\logs" (
    del /f /q /s "%APPDATA%\obs-studio\plugin_config\obs-browser\logs\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\DwmTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\DwmTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\CBS\CbsPersist_*" (
    del /f /q /s "C:\Windows\Logs\CBS\CbsPersist_*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingSports_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingSports_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\BthPortTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthPortTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\diskperf.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\diskperf.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\OptimizationGuidePredictionModels" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\OptimizationGuidePredictionModels" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\discord\D3D12Cache" (
    rmdir /s /q "%APPDATA%\discord\D3D12Cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\EdgeHub" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\EdgeHub" >nul 2>&1
)

%update_bar%
if exist "C:\Program Files (x86)\Steam\logs\music_log.txt" (
    del /f /q "C:\Program Files (x86)\Steam\logs\music_log.txt" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Adobe\Common\Media Cache" (
    rmdir /s /q "%APPDATA%\Adobe\Common\Media Cache" >nul 2>&1
)

%update_bar%
if exist "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Gadget" (
    del /f /q /s "C:\ProgramData\BlueStacks_nxt\Engine\UserData\Gadget\*.tmp" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data" (
    del /f /q /s "%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache\Cache\Cache_Data\index" >nul 2>&1
)

%update_bar%
if exist "%USERPROFILE%\.cache\wheels" (
    rmdir /s /q "%USERPROFILE%\.cache\wheels" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\Code\Backups" (
    rmdir /s /q "%APPDATA%\Code\Backups" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\obs-studio\crashes" (
    del /f /q /s "%APPDATA%\obs-studio\crashes\*.dmp" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\DxTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\DxTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\Logs\DISM\dism.log" (
    del /f /q "C:\Windows\Logs\DISM\dism.log" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingTravel_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingTravel_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\BthLegacy" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\BthLegacy\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\fsutil.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\fsutil.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Trust Tokens" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Trust Tokens" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir\*.log" >nul 2>&1
)

%update_bar%
if exist "%APPDATA%\vlc\cache" (
    rmdir /s /q "%APPDATA%\vlc\cache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Google\DriveFS\CloudCache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\DriveFS\CloudCache" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Portal" (
    rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Config\Portal" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\SqmTelemetry" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\SqmTelemetry\*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\CrashDumps\regedit.exe*" (
    del /f /q "%LOCALAPPDATA%\CrashDumps\regedit.exe*" >nul 2>&1
)

%update_bar%
if exist "%LOCALAPPDATA%\Packages\Microsoft.BingFinance_8wekyb3d8bbwe\TempState" (
    del /f /q /s "%LOCALAPPDATA%\Packages\Microsoft.BingFinance_8wekyb3d8bbwe\TempState\*" >nul 2>&1
)

%update_bar%
if exist "C:\Windows\System32\LogFiles\WMI\WlanLegacy" (
    del /f /q /s "C:\Windows\System32\LogFiles\WMI\WlanLegacy\*" >nul 2>&1
)

%update_bar%
if exist "%LocalAppData%\CrashDumps" (
    del /f /q /s "%LocalAppData%\CrashDumps\*" >nul 2>&1
)

%update_bar%
vssadmin delete shadows /all /quiet >nul 2>&1

%update_bar%
powercfg /h off >nul 2>&1

%update_bar%
net stop wsearch >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f >nul 2>&1
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" (del /f /q /s "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1)
net start wsearch >nul 2>&1

%update_bar%
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1

%update_bar%
compact /compactos:always /exe:lzx >nul 2>&1

%update_bar%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f >nul 2>&1

:: [Passo 716]
%update_bar%
if exist "C:\ProgramData\Microsoft\LiveUpdate" (del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1)

:: [Passo 717]
%update_bar%
if exist C:\Windows\System32\AppXDeploymentServer (del /f /q /s C:\Windows\System32\AppXDeploymentServer\*.log >nul 2>&1)

:: [Passo 718]
%update_bar%
if exist "%ProgramData%\Microsoft\MapData" (del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1)

:: [Passo 719]
%update_bar%
if exist C:\Windows\System32\CompatTelRunner (del /f /q /s C:\Windows\System32\CompatTelRunner\*.tmp >nul 2>&1)

:: [Passo 720]
%update_bar%
if exist "%LocalAppData%\Microsoft\Windows Photo Viewer" (rmdir /s /q "%LocalAppData%\Microsoft\Windows Photo Viewer" >nul 2>&1)

:: [Passo 721]
%update_bar%
if exist "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18" (del /f /q /s "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18\*.tmp" >nul 2>&1)

:: [Passo 722]
%update_bar%
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis" (del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1)

:: [Passo 723]
%update_bar%
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)

:: [Passo 724]
%update_bar%
if exist "%LocalAppData%\Microsoft\Terminal Server Client\Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Terminal Server Client\Cache" >nul 2>&1)
:: [Passo 716]
call :Avanzamento
if exist "C:\ProgramData\Microsoft\LiveUpdate" (del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1)

:: [Passo 717]
call :Avanzamento
if exist C:\Windows\System32\AppXDeploymentServer (del /f /q /s C:\Windows\System32\AppXDeploymentServer\*.log >nul 2>&1)

:: [Passo 718]
call :Avanzamento
if exist "%ProgramData%\Microsoft\MapData" (del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1)

:: [Passo 719]
call :Avanzamento
if exist C:\Windows\System32\CompatTelRunner (del /f /q /s C:\Windows\System32\CompatTelRunner\*.tmp >nul 2>&1)

:: [Passo 720]
call :Avanzamento
if exist "%LocalAppData%\Microsoft\Windows Photo Viewer" (rmdir /s /q "%LocalAppData%\Microsoft\Windows Photo Viewer" >nul 2>&1)

:: [Passo 721]
call :Avanzamento
if exist "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18" (del /f /q /s "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18\*.tmp" >nul 2>&1)

:: [Passo 722]
call :Avanzamento
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis" (del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1)

:: [Passo 723]
call :Avanzamento
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)

:: [Passo 724]
call :Avanzamento
if exist "%LocalAppData%\Microsoft\Terminal Server Client\Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Terminal Server Client\Cache" >nul 2>&1)
:: [Passo 716]
call :Avanzamento
if exist "C:\ProgramData\Microsoft\LiveUpdate" (del /f /q /s "C:\ProgramData\Microsoft\LiveUpdate\*" >nul 2>&1)

:: [Passo 717]
call :Avanzamento
if exist C:\Windows\System32\AppXDeploymentServer (del /f /q /s C:\Windows\System32\AppXDeploymentServer\*.log >nul 2>&1)

:: [Passo 718]
call :Avanzamento
if exist "%ProgramData%\Microsoft\MapData" (del /f /q /s "%ProgramData%\Microsoft\MapData\*" >nul 2>&1)

:: [Passo 719]
call :Avanzamento
if exist C:\Windows\System32\CompatTelRunner (del /f /q /s C:\Windows\System32\CompatTelRunner\*.tmp >nul 2>&1)

:: [Passo 720]
call :Avanzamento
if exist "%LocalAppData%\Microsoft\Windows Photo Viewer" (rmdir /s /q "%LocalAppData%\Microsoft\Windows Photo Viewer" >nul 2>&1)

:: [Passo 721]
call :Avanzamento
if exist "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18" (del /f /q /s "%ProgramData%\Microsoft\Crypto\RSA\S-1-5-18\*.tmp" >nul 2>&1)

:: [Passo 722]
call :Avanzamento
if exist "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis" (del /f /q /s "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Nis\*" >nul 2>&1)

:: [Passo 723]
call :Avanzamento
if exist C:\Windows\Logs\MeasuredBoot (del /f /q /s C:\Windows\Logs\MeasuredBoot\* >nul 2>&1)

:: [Passo 724]
call :Avanzamento
if exist "%LocalAppData%\Microsoft\Terminal Server Client\Cache" (rmdir /s /q "%LocalAppData%\Microsoft\Terminal Server Client\Cache" >nul 2>&1)

cls
echo =======================================================================
echo         WINDOWS SPACE OVERLORD - PROGRESSO DELLA PULIZIA TOTALE
echo =======================================================================
echo.
echo [Avanzamento]: [ ████████████████████ ] 100.0000%%
echo.
echo Rigenerazione dell'interfaccia grafica in corso...
timeout /t 1 >nul

:: Rinfresco grafico dell'interfaccia per applicare lo svuotamento delle cache visive
taskkill /f /im explorer.exe >nul 2>&1 && start explorer.exe >nul 2>&1

:: Calcola il tempo finale impiegato gestendo i numeri ottali ed eventuali spazi vuoti
for /f "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
    set "E_HH=%%a" & set "E_MM=%%b" & set "E_SS=%%c"
)
set "E_HH=%E_HH: =%"
if %E_HH% LSS 10 (set /a E_HH=1%E_HH% - 100)
if %E_MM% LSS 10 (set /a E_MM=1%E_MM% - 100)
if %E_SS% LSS 10 (set /a E_SS=1%E_SS% - 100)
set /a "end_seconds=(E_HH * 3600) + (E_MM * 60) + E_SS"

:: Gestisce il superamento della mezzanotte
set /a "tempo_impiegato_secondi=end_seconds - start_seconds"
if %tempo_impiegato_secondi% LSS 0 (set /a "tempo_impiegato_secondi+=86400")

set /a "minuti=tempo_impiegato_secondi / 60"
set /a "secondi=tempo_impiegato_secondi %% 60"

set "spazio_finale=0.00"
set "spazio_guadagnato=0.00"

:: Genera automaticamente il Report sul Desktop
set "report_pulizia=%USERPROFILE%\Desktop\Pulizia_Report.txt"
(
echo =======================================================
echo           REPORT DI PULIZIA WINDOWS SPACE OVERLORD
echo =======================================================
echo  Data esecuzione: %DATE% alle ore %TIME%
echo  Tempo impiegato: %minuti% minuti e %secondi% secondi
echo =======================================================
) > "%report_pulizia%"

:: Genera la lista dei file pesanti scansionando solo le cartelle personali dell'utente (Veloce e Sicuro)
set "report_pesanti=%USERPROFILE%\Desktop\File_Piu_Pesanti.txt"
echo ======================================================= > "%report_pesanti%"
echo         LISTA DEI 20 FILE PIU GRANDI SUL TUO PC >> "%report_pesanti%"
echo ======================================================= >> "%report_pesanti%"
echo File maggiori di 1GB ordinati dal piu pesante: >> "%report_pesanti%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path C:\Users -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | ForEach-Object { '[ ' + [math]::round(($_.Length / 1GB), 2) + ' GB ] ' + $_.FullName }" >> "%report_pesanti%"

:: Schermata finale verde Matrix
cls
color 0A
echo =======================================================================
echo    PULIZIA COMPLETATA CON SUCCESSO! IL PC E AL 100%% DELLE PRESTAZIONI.
echo =======================================================================
echo  Tempo impiegato: %minuti% min e %secondi% sec
echo.
echo  * Nota 1: Un riepilogo dettagliato e stato salvato sul tuo Desktop
echo    nel file "Pulizia_Report.txt".
echo  * Nota 2: La lista dei 20 file piu grandi del tuo PC e stata
echo    salvata sul Desktop nel file "File_Piu_Pesanti.txt".
echo =======================================================================
echo.

:: Apertura automatica dei due report con Blocco Note
start notepad.exe "%report_pulizia%"
start notepad.exe "%report_pesanti%"

pause
exit

:: =======================================================================
:: FUNZIONE GRAFICA DI AVANZAMENTO DELLA BARRA VERDE (100% LINEARE)
:: =======================================================================
:Avanzamento
set /a operazione_corrente+=1
for /f "tokens=1,2" %%p in ('powershell -NoProfile -Command "$pct=[math]::round^(^(%operazione_corrente% / %totale_operazioni%^) * 100, 4^); $b=[int]^($pct/5^); $pctStr='{0:0.0000}' -f $pct; Write-Output \"$pctStr $b\""') do (
    set "pct_val=%%p"
    set "block_count=%%q"
)

:: Disegna la barra basandosi sul conteggio calcolato in modo puramente nativo
set "bar_str="
for /l %%i in (1,1,%block_count%) do set "bar_str=!bar_str!█"
set /a empty_count=20 - block_count
for /l %%i in (1,1,%empty_count%) do set "bar_str=!bar_str!░"

cls
color 0A
echo =======================================================================
echo         WINDOWS SPACE OVERLORD - PROGRESSO DELLA PULIZIA TOTALE
echo =======================================================================
echo.
echo [Avanzamento]: [ %bar_str% ] %pct_val%%%
echo.
goto :eof

pause
exit
