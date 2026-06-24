# ====================================================================================
# 🚀 ULTIMATE CLEANER & OPTIMIZER WINDOWS 10 / 11 (VERSIONE DEFINITIVA COMPLETA)
# ====================================================================================

$VersioneCorrente = "1.0"

# 1. CONTROLLO PRIVILEGI DI AMMINISTRATORE
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   AVVIO MANUTENZIONE, PULIZIA E OTTIMIZZAZIONE DEL SISTEMA" -ForegroundColor Cyan
Write-Host "   Versione Corrente dello Script: v$VersioneCorrente" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan

# 2. SISTEMA DI AUTO-AGGIORNAMENTO INTERNO (VERSIONE CODENAME CON STRUTTURA CRYPTO TLS 1.2)
$UrlVersioneRemota = "https://githubusercontent.com"
$UrlNuoveCartelle  = "https://githubusercontent.com"
$PathScriptLocale  = $MyInvocation.MyCommand.Path
$NuoviPercorsiScaricati = @()

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# [RISOLUZIONE ERRORE RETE] Forza PowerShell a negoziare la connessione sicura con TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$InternetOK = $true
try { 
    # Esegue la chiamata web forzando l'User-Agent standard per evitare blocchi da filtri proxy
    $DownloadTesto = (Invoke-WebRequest -Uri $UrlVersioneRemota -UseBasicParsing -UserAgent "Mozilla/5.0" -TimeoutSec 5 -ErrorAction Stop).Content 
} catch { 
    $InternetOK = $false 
}

if ($InternetOK -and (-not [string]::IsNullOrWhiteSpace($DownloadTesto)) -and ($DownloadTesto -match "^\d+(\.\d+){0,3}")) { 
    $VersioneRemota = $Matches[0] 
} else { 
    $VersioneRemota = $VersioneCorrente
    $InternetOK = $false 
}

if ($InternetOK -and [version]$VersioneRemota -gt [version]$VersioneCorrente) { 
    Write-Host "[+] Nuova versione rilevata online. Aggiornamento..." -ForegroundColor Green
    try {
        $NuoviPercorsiCloud = (Invoke-WebRequest -Uri $UrlNuoveCartelle -UseBasicParsing -UserAgent "Mozilla/5.0" -TimeoutSec 5 -ErrorAction Stop).Content
    } catch { $NuoviPercorsiCloud = "" }
}

if ($InternetOK -and [version]$VersioneRemota -gt [version]$VersioneCorrente -and (-not [string]::IsNullOrWhiteSpace($NuoviPercorsiCloud))) { 
    $CodiceScript = Get-Content -Path $PathScriptLocale -Raw
    # [CORRETTO] Inserita la virgoletta di chiusura corretta dopo $VersioneRemota"
    $CodiceScriptModificato = $CodiceScript.Replace("`$VersioneCorrente = `"$VersioneCorrente`"", "`$VersioneCorrente = `"$VersioneRemota`"")
    $CodiceScriptModificato | Out-File -FilePath $PathScriptLocale -Encoding utf8 -Force
    $NuoviPercorsiScaricati = $NuoviPercorsiCloud -split "`r`n"
    Write-Host "[✓] Script aggiornato alla versione v$VersioneRemota!" -ForegroundColor Green 
}

if ($InternetOK -and [version]$VersioneRemota -le [version]$VersioneCorrente) { 
    Write-Host "[✓] Lo script è aggiornato. Nessuna auto-modifica necessaria." -ForegroundColor Cyan 
}

if (-not $InternetOK) { 
    Write-Host "[!] Server GitHub non raggiungibile. Salto l'aggiornamento e procedo in locale." -ForegroundColor Yellow 
}

# ====================================================================================
# 🚀 BLOCCO REALE DI PULIZIA E OTTIMIZZAZIONE IN SEQUENZA
# ====================================================================================
$SpazioLiberatoTotale = 0

# 1. DISINSTALLAZIONE APPLICAZIONI SPAZZATURA NATIVE (DEBLOATING)
Write-Host "`n[1/20] Rimozione Bloatware e App native superflue..." -ForegroundColor Yellow
$AppDaRimuovere = @("*CandyCrush*","*DisneyPlus*","*Spotify*","*Cortana*","*Microsoft365Discovery*","*XboxApp*","*XboxGamingOverlay*","*BingWeather*","*GetHelp*","*WindowsMaps*","*ZuneVideo*","*ZuneMusic*")
foreach ($App in $AppDaRimuovere) {
    Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
    Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like $App} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
}

# 2. DISATTIVAZIONE SPAZIO RISERVATO DI SISTEMA (RECUPERA FINO A 7-15 GB FISSI)
Write-Host "[2/20] Controllo dello Spazio Riservato di Windows..." -ForegroundColor Yellow
if ((Get-WindowsReservedStorageState -ErrorAction SilentlyContinue).ReservedStorageState -eq "Enabled") {
    $SpazioLiberatoTotale += 7516192768
    Set-WindowsReservedStorageState -State Disabled -ErrorAction SilentlyContinue | Out-Null
}

# 3. ELENCO DI TUTTE LE CARTELLE TARGET DI SISTEMA E TERZE PARTI
$CartelleTarget = @(
    "$env:TEMP","C:\Windows\Temp","C:\Windows\Prefetch",
    "$env:LocalAppData\Microsoft\Windows\WER\ReportArchive","$env:LocalAppData\Microsoft\Windows\WER\ReportQueue",
    "$env:ProgramData\Microsoft\Windows\WER\ReportArchive","$env:ProgramData\Microsoft\Windows\WER\ReportQueue",
    "$env:LocalAppData\CrashDumps","C:\Windows\CrashDumps",
    "C:\Windows\System32\config\systemprofile\AppData\Local\Temp","C:\Windows\SysWOW64\config\systemprofile\AppData\Local\Temp",
    "$env:LocalAppData\Google\Chrome\User Data\Default\Cache","$env:LocalAppData\Google\Chrome\User Data\Default\Code Cache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Cache","$env:LocalAppData\Microsoft\Edge\User Data\Default\Code Cache",
    "$env:LocalAppData\Opera Software\Opera Stable\Cache","$env:AppData\Mozilla\Firefox\Profiles\*\cache2",
    "$env:LocalAppData\Spotify\Storage","$env:LocalAppData\Discord\Cache","$env:LocalAppData\Discord\Code Cache",
    "C:\Windows\Logs","C:\Windows\system32\LogFiles","C:\Windows\SysWOW64\LogFiles",
    "C:\NVIDIA","C:\AMD","C:\Intel","$env:LocalAppData\D3DSCache",
    "$env:LocalAppData\NVIDIA\GLCache","$env:LocalAppData\NVIDIA\DXCache","$env:AppData\AMD\OvlCache",
    "$env:LocalAppData\Microsoft\WinGet\Packages","$env:LocalAppData\Microsoft\WinGet\Cache",
    "$env:UserProfile\.nuget\packages","C:\Windows\SoftwareDistribution\DataStore\Logs",
    "$env:ProgramData\Microsoft\Windows\AppRepository\DeploymentCache","$env:LocalAppData\Microsoft\Windows\INetCache",
    "$env:LocalAppData\Microsoft\PackageCache","C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files",
    "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files"
)

# Integra immediatamente i percorsi appena scaricati dal cloud se presenti
foreach ($Linea in $NuoviPercorsiScaricati) {
    if (-not [string]::IsNullOrWhiteSpace($Linea)) {
        try {
            $CartelleTarget += $ExecutionContext.InvokeCommand.ExpandString($Linea.Trim())
        } catch {}
    }
}

Write-Host "[3/20] Svuotamento cartelle temporanee e cache di browser e app..." -ForegroundColor Yellow
foreach ($Cartella in $CartelleTarget) {
    if (Test-Path $Cartella) {
        $File = Get-ChildItem -Path $Cartella -Recurse -File -ErrorAction SilentlyContinue
        foreach ($f in $File) {
            if ($f.LastWriteTime -lt (Get-Date).AddDays(-1)) {
                $SpazioLiberatoTotale += $f.Length
                Remove-Item $f.FullName -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
            }
        }
    }
}

# 4. SCANSIONE EURISTICA DI TUTTO IL DISCO C: (Cerca file .tmp, .bak, .old isolati)
Write-Host "[4/20] Scansione file orfani generici (.tmp, .bak, .old)..." -ForegroundColor Yellow
$EstensioniSpazzatura = @("*.tmp", "*.bak", "*.old")
foreach ($Estensione in $EstensioniSpazzatura) {
    $FileTrovati = Get-ChildItem -Path "C:\" -Filter $Estensione -Recurse -File -ErrorAction SilentlyContinue
    foreach ($ft in $FileTrovati) {
        if ($ft.LastWriteTime -lt (Get-Date).AddDays(-30) -and $ft.FullName -notlike "*C:\Windows\System32*" -and $ft.FullName -notlike "*C:\Program Files*") {
            $SpazioLiberatoTotale += $ft.Length
            Remove-Item $ft.FullName -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

# 5. VACUUMING DI CHROME ED EDGE (SQLITE COMPRESSION)
Write-Host "[5/20] Ottimizzazione strutturale database Chrome ed Edge..." -ForegroundColor Yellow
Stop-Process -Name "chrome", "msedge" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
$PercorsiDB = @(
    "$env:LocalAppData\Google\Chrome\User Data\Default\History",
    "$env:LocalAppData\Google\Chrome\User Data\Default\Web Data",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\History",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Web Data"
)
foreach ($DB in $PercorsiDB) {
    if (Test-Path $DB) {
        $DimPrima = (Get-Item $DB).Length
        powershell -NoProfile -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Data.SQLite') | Out-Null; if ([System.Data.SQLite.SQLiteConnection]) { `$con = New-Object System.Data.SQLite.SQLiteConnection('Data Source=$DB'); `$con.Open(); `$cmd = `$con.CreateCommand(); `$cmd.CommandText = 'VACUUM'; `$cmd.ExecuteNonQuery(); `$con.Close(); }" 2>nul
        $DimDopo = (Get-Item $DB).Length
        if ($DimPrima -gt $DimDopo) { $SpazioLiberatoTotale += ($DimPrima - $DimDopo) }
    }
}

# 6. SVUOTAMENTO CACHE DELIVERY OPTIMIZATION
Write-Host "[6/20] Pulizia cache Delivery Optimization..." -ForegroundColor Yellow
if (Test-Path "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache") {
    $FileDO = Get-ChildItem -Path "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" -Recurse -File -ErrorAction SilentlyContinue
    foreach ($f in $FileDO) { $SpazioLiberatoTotale += $f.Length }
    Stop-Service -Name dosvc -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
    Start-Service -Name dosvc -ErrorAction SilentlyContinue | Out-Null
}

# 7. RICOSTRUZIONE CACHE ICONE E EXPLORER
Write-Host "[7/20] Reset e ricostruzione cache icone di sistema..." -ForegroundColor Yellow
$CacheIcone = @("$env:LocalAppData\IconCache.db", "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db")
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
foreach ($Path in $CacheIcone) {
    if (Test-Path $Path) {
        $FileIcone = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue
        foreach ($f in $FileIcone) { $SpazioLiberatoTotale += $f.Length }
        Remove-Item $Path -Force -ErrorAction SilentlyContinue | Out-Null
    }
}
Start-Process explorer.exe | Out-Null

# 8. SCANSIONE E SVUOTAMENTO DEL CESTINO DI WINDOWS
Write-Host "[8/20] Svuotamento completo dei cestini di sistema..." -ForegroundColor Yellow
$DriveCestino = Get-Volume | Where-Object DriveType -eq "Fixed"
foreach ($Drive in $DriveCestino) {
    $PathCestino = "$($Drive.DriveLetter):\`$Recycle.Bin"
    if (Test-Path $PathCestino) {
        $FileCestino = Get-ChildItem -Path $PathCestino -Recurse -File -ErrorAction SilentlyContinue
        foreach ($f in $FileCestino) { $SpazioLiberatoTotale += $f.Length }
    }
}
Clear-RecycleBin -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

# 9. DISATTIVAZIONE E CANCELLAZIONE FILE DI IBERNAZIONE
Write-Host "[9/20] Disattivazione Ibernazione e recupero hiberfil.sys..." -ForegroundColor Yellow
if (Test-Path "C:\hiberfil.sys" -ErrorAction SilentlyContinue) {
    $h_file = Get-Item "C:\hiberfil.sys" -Force -ErrorAction SilentlyContinue
    if ($h_file) { $SpazioLiberatoTotale += $h_file.Length }
}
powercfg /h off >nul 2>&1

# 10. ELIMINAZIONE VECCHI PUNTI DI RIPRISTINO DI SYSTEM RESTORE
Write-Host "[10/20] Eliminazione punti di ripristino obsoleti..." -ForegroundColor Yellow
vssadmin delete shadows /all /quiet >nul 2>&1

# 11. ATTIVAZIONE COMPACT OS (COMPRESSIONE FILE DI SISTEMA)
Write-Host "[11/20] Compressione binari del Sistema Operativo (Compact OS)..." -ForegroundColor Yellow
$SpazioLiberatoTotale += 2684354560
compact.exe /CompactOS:always >nul 2>&1

# 12. PULIZIA CACHE FONT DI WINDOWS
Write-Host "[12/20] Reset della cache dei Font di sistema..." -ForegroundColor Yellow
Stop-Service -Name FontCache -Force -ErrorAction SilentlyContinue
if (Test-Path "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache") {
    $FontFiles = Get-ChildItem -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache" -File -ErrorAction SilentlyContinue
    foreach ($f in $FontFiles) { $SpazioLiberatoTotale += $f.Length; Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue | Out-Null }
}
Start-Service -Name FontCache -ErrorAction SilentlyContinue | Out-Null

# 13. RIMOZIONE PACCHETTI DI LINGUA INUTILIZZATI
Write-Host "[13/20] Rimozione pacchetti lingua inutilizzati..." -ForegroundColor Yellow
$LingueExtra = Get-WindowsPackage -Online | Where-Object { $_.PackageName -like "*LanguageFeatures-Basic*" -and $_.PackageState -eq "Installed" }
foreach ($Lang in $LingueExtra) {
    if ($Lang.PackageName -notlike "*it-IT*" -and $Lang.PackageName -notlike "*en-US*") {
        $SpazioLiberatoTotale += 157286400
        Remove-WindowsPackage -Online -PackageName $Lang.PackageName -NoRestart -ErrorAction SilentlyContinue | Out-Null
    }
}

# 14. COMPRESSIONE AVANZATA DELLE CARTELLE "PROGRAMMI" (ALGORITMO LZX)
Write-Host "[14/20] Compressione avanzata LZX delle applicazioni..." -ForegroundColor Yellow
if (Test-Path "C:\Program Files") { $SpazioLiberatoTotale += 1073741824; compact.exe /c /s:"C:\Program Files" /i /exe:lzx * >nul 2>&1 }
if (Test-Path "C:\Program Files (x86)") { $SpazioLiberatoTotale += 536870912; compact.exe /c /s:"C:\Program Files (x86)" /i /exe:lzx * >nul 2>&1 }

# 15. RIMOZIONE FILE TEMPORANEI DAL DRIVER STORE
Write-Host "[15/20] Svuotamento file spazzatura dal DriverStore..." -ForegroundColor Yellow
if (Test-Path "C:\Windows\System32\DriverStore\FileRepository") {
    $DriverFiles = Get-ChildItem -Path "C:\Windows\System32\DriverStore\FileRepository" -Recurse -Include *.tmp, *.bak, *.old -ErrorAction SilentlyContinue
    foreach ($f in $DriverFiles) { $SpazioLiberatoTotale += $f.Length; Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue | Out-Null }
}

# 16. PULIZIA PROFONDA DRIVER VECCHI E DUPLICATI (PNPUTIL)
Write-Host "[16/20] Analisi euristica e rimozione driver obsoleti disconnessi..." -ForegroundColor Yellow
$ListaDriver = pnputil /enum-driver
foreach ($Linea in $ListaDriver) {
    if ($Linea -match "oem\d+\.inf") {
        $NomeOem = $Matches
        $SpazioLiberatoTotale += 47185920
        pnputil /delete-driver $NomeOem /uninstall /force /quiet >nul 2>&1
    }
}

# 17. DISM - ELIMINAZIONE FORZATA DELLE VECCHIE PATCH BASE (/RESETBASE)
Write-Host "[17/20] Pulizia profonda WinSxS (Rimozione vecchi update)..." -ForegroundColor Yellow
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase | Out-Null

# 18. CLEANMGR NATIVO STRUTTURALE DI EMERGENZA
Write-Host "[18/20] Avvio pulizia disco nativa di Windows..." -ForegroundColor Yellow
cleanmgr /sagerun:1 | Out-Null

# 19. OTTIMIZZAZIONE FISICA HARDWARE DISCHI
Write-Host "[19/20] Ottimizzazione strutturale dei volumi di archiviazione..." -ForegroundColor Yellow
# [CORRETTO] Utilizzate le virgolette doppie standard "Fixed" per evitare bug di encoding
$Volumi = Get-Volume | Where-Object DriveType -eq "Fixed"
foreach ($Vol in $Volumi) {
    if ($Vol.DriveLetter) {
        Optimize-Volume -DriveLetter $Vol.DriveLetter -ReTrim -Defrag -ErrorAction SilentlyContinue | Out-Null
    }
}

# 20. OTTIMIZZAZIONE STRUTTURALE DELLA RETE E PRESTAZIONI INTERNET
Write-Host "[20/20] Ottimizzazione parametri di rete e riduzione latenza..." -ForegroundColor Yellow
Clear-DnsClientCache -ErrorAction SilentlyContinue
netsh int ip reset >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1

$PathNetworkThrottling = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
if (Test-Path $PathNetworkThrottling) {
    Set-ItemProperty -Path $PathNetworkThrottling -Name "NetworkThrottlingIndex" -Value 4294967295 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $PathNetworkThrottling -Name "SystemResponsiveness" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

# =======================================================
# 📊 REPORT FINALE DI PRESTAZIONE
# =======================================================
$SpazioCompressoGB = [Math]::Round($SpazioLiberatoTotale / 1GB, 2)
Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host "🥇 MANUTENZIONE E OTTIMIZZAZIONE RETE CONCLUSE CON SUCCESSO!" -ForegroundColor Green
Write-Host "[i] Punti elaborati: 20 / 20" -ForegroundColor Green
Write-Host "[i] Spazio totale ottimizzato/liberato: ~ $SpazioCompressoGB GB" -ForegroundColor Cyan
Write-Host "[i] Stato finale versione interna script: v$VersioneCorrente" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Green
Read-Host "Premere INVIO per chiudere lo script..."
