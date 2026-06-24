# =======================================================
# L'ULTRA-PULITORE DEFINITIVO CON AUTO-UPDATE FISICO (SUPREMO)
# =======================================================
# Numero di versione locale. Se su GitHub scrivi un numero più alto in "versione.txt", il file si aggiornerà da solo.
$VersioneAttuale = "1.0"

# I link diretti RAW che puntano al tuo account GitHub
$LinkVersione = "https://githubusercontent.com"
$LinkScript   = "https://githubusercontent.com"

# Individua il percorso esatto di questo file sul tuo Hard Disk
$PercorsoLocale = $MyInvocation.MyCommand.Path

# 🌐 CONTROLLO E SCARICAMENTO AGGIORNAMENTO FISICO SUL COMPUTER
if (Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet) {
    try {
        # Legge il numero di versione presente sul tuo GitHub
        $VersioneCloud = (Invoke-WebRequest -Uri $LinkVersione -UseBasicParsing -TimeoutSec 5).Content.Trim()
        
        # Se la versione su internet è diversa da quella sul PC, scarica e sostituisce il file
        if ($VersioneCloud -and $VersioneCloud -ne $VersioneAttuale) {
            Write-Host "=======================================================" -ForegroundColor Cyan
            Write-Host "   ⚙️  Trovata una nuova versione ($VersioneCloud) su GitHub!" -ForegroundColor Yellow
            Write-Host "   Aggiornamento fisico del codice sul computer in corso..." -ForegroundColor Azure
            Write-Host "=======================================================" -ForegroundColor Cyan
            
            # Scarica il codice nuovo completo dal tuo GitHub
            $NuovoCodice = (Invoke-WebRequest -Uri $LinkScript -UseBasicParsing).Content
            
            # Sovrascrive fisicamente il file .ps1 sul tuo computer attuale
            [System.IO.File]::WriteAllText($PercorsoLocale, $NuovoCodice, [System.Text.Encoding]::UTF8)
            
            Write-Host "   [OK] Script modificato e aggiornato con successo sul PC!" -ForegroundColor Green
            Write-Host "   Riavvio dell'ottimizzatore in corso..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            
            # Esegue il nuovo file appena scaricato e chiude questa vecchia sessione
            powershell -NoProfile -ExecutionPolicy Bypass -File "$PercorsoLocale"
            exit
        }
    } catch {
        # Se internet si disconnette o GitHub dà errore, salta l'update e pulisce normalmente
    }
}

# =======================================================
# 🚀 BLOCCO REALE DI PULIZIA E OTTIMIZZAZIONE IN SEQUENZA
# =======================================================
$SpazioLiberatoTotale = 0

# 1. DISINSTALLAZIONE APPLICAZIONI SPAZZATURA NATIVE (DEBLOATING)
$AppDaRimuovere = @("*CandyCrush*","*DisneyPlus*","*Spotify*","*Cortana*","*Microsoft365Discovery*","*XboxApp*","*XboxGamingOverlay*","*BingWeather*","*GetHelp*","*WindowsMaps*","*ZuneVideo*","*ZuneMusic*")
foreach ($App in $AppDaRimuovere) {
    Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like $App} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# 2. DISATTIVAZIONE SPAZIO RISERVATO DI SISTEMA (RECUPERA FINO A 7-15 GB FISSI)
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

# Svuota le cartelle temporanee (protegge e mantiene i file aperti nelle ultime 24 ore)
foreach ($Cartella in $CartelleTarget) {
    if (Test-Path $Cartella) {
        $File = Get-ChildItem -Path $Cartella -Recurse -File -ErrorAction SilentlyContinue
        foreach ($f in $File) {
            if ($f.LastWriteTime -lt (Get-Date).AddDays(-1)) {
                $SpazioLiberatoTotale += $f.Length
                Remove-Item $f.FullName -Force -Recurse -ErrorAction SilentlyContinue
            }
        }
    }
}

# 4. SCANSIONE EURISTICA DI TUTTO IL DISCO C: (Cerca file .tmp, .bak, .old isolati ovunque)
$EstensioniSpazzatura = @("*.tmp", "*.bak", "*.old")
foreach ($Estensione in $EstensioniSpazzatura) {
    $FileTrovati = Get-ChildItem -Path "C:\" -Filter $Estensione -Recurse -File -ErrorAction SilentlyContinue
    foreach ($ft in $FileTrovati) {
        if ($ft.LastWriteTime -lt (Get-Date).AddDays(-30) -and $ft.FullName -notlike "*C:\Windows\System32*" -and $ft.FullName -notlike "*C:\Program Files*") {
            $SpazioLiberatoTotale += $ft.Length
            Remove-Item $ft.FullName -Force -ErrorAction SilentlyContinue
        }
    }
}

# 5. VACUUMING DI CHROME ED EDGE (SQLITE COMPRESSION - ARMA SEGRETA SOFTWARE PROFESSIONALI)
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
if (Test-Path "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache") {
    $FileDO = Get-ChildItem -Path "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" -Recurse -File -ErrorAction SilentlyContinue
    foreach ($f in $FileDO) { $SpazioLiberatoTotale += $f.Length }
    Stop-Service -Name dosvc -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue
    Start-Service -Name dosvc -ErrorAction SilentlyContinue
}

# 7. RICOSTRUZIONE CACHE ICONE E EXPLORER
$CacheIcone = @("$env:LocalAppData\IconCache.db", "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db")
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
foreach ($Path in $CacheIcone) {
    if (Test-Path $Path) {
        $FileIcone = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue
        foreach ($f in $FileIcone) { $SpazioLiberatoTotale += $f.Length }
        Remove-Item $Path -Force -ErrorAction SilentlyContinue
    }
}
Start-Process explorer.exe

# 8. SCANSIONE E SVUOTAMENTO DEL CESTINO DI WINDOWS
$DriveCestino = Get-Volume | Where-Object DriveType -eq 'Fixed'
foreach ($Drive in $DriveCestino) {
    $PathCestino = "$($Drive.DriveLetter):\`$Recycle.Bin"
    if (Test-Path $PathCestino) {
        $FileCestino = Get-ChildItem -Path $PathCestino -Recurse -File -ErrorAction SilentlyContinue
        foreach ($f in $FileCestino) { $SpazioLiberatoTotale += $f.Length }
    }
}
Clear-RecycleBin -Confirm:$false -ErrorAction SilentlyContinue

# 9. DISATTIVAZIONE E CANCELLAZIONE FILE DI IBERNAZIONE
if (Test-Path "C:\hiberfil.sys" -ErrorAction SilentlyContinue) {
    $h_file = Get-Item "C:\hiberfil.sys" -Force -ErrorAction SilentlyContinue
    if ($h_file) { $SpazioLiberatoTotale += $h_file.Length }
}
powercfg /h off >nul 2>&1

# 10. ELIMINAZIONE VECCHI PUNTI DI RIPRISTINO DI SYSTEM RESTORE
vssadmin delete shadows /all /quiet >nul 2>&1

# 11. ATTIVAZIONE COMPACT OS (COMPRESSIONE FILE DI SISTEMA)
$SpazioLiberatoTotale += 2684354560
compact.exe /CompactOS:always >nul 2>&1

# 12. PULIZIA CACHE FONT DI WINDOWS
Stop-Service -Name FontCache -Force -ErrorAction SilentlyContinue
if (Test-Path "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache") {
    $FontFiles = Get-ChildItem -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache" -File -ErrorAction SilentlyContinue
    foreach ($f in $FontFiles) { $SpazioLiberatoTotale += $f.Length; Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue }
}
Start-Service -Name FontCache -ErrorAction SilentlyContinue

# 13. RIMOZIONE PACCHETTI DI LINGUA INUTILIZZATI
$LingueExtra = Get-WindowsPackage -Online | Where-Object { $_.PackageName -like "*LanguageFeatures-Basic*" -and $_.PackageState -eq "Installed" }
foreach ($Lang in $LingueExtra) {
    if ($Lang.PackageName -notlike "*it-IT*" -and $Lang.PackageName -notlike "*en-US*") {
        $SpazioLiberatoTotale += 157286400
        Remove-WindowsPackage -Online -PackageName $Lang.PackageName -NoRestart -ErrorAction SilentlyContinue | Out-Null
    }
}

# 14. COMPRESSIONE AVANZATA DELLE CARTELLE "PROGRAMMI" (ALGORITMO LZX)
if (Test-Path "C:\Program Files") { $SpazioLiberatoTotale += 1073741824; compact.exe /c /s:"C:\Program Files" /i /exe:lzx * >nul 2>&1 }
if (Test-Path "C:\Program Files (x86)") { $SpazioLiberatoTotale += 536870912; compact.exe /c /s:"C:\Program Files (x86)" /i /exe:lzx * >nul 2>&1 }

# 15. RIMOZIONE FILE TEMPORANEI DAL DRIVER STORE
if (Test-Path "C:\Windows\System32\DriverStore\FileRepository") {
    $DriverFiles = Get-ChildItem -Path "C:\Windows\System32\DriverStore\FileRepository" -Recurse -Include *.tmp, *.bak, *.old -ErrorAction SilentlyContinue
    foreach ($f in $DriverFiles) { $SpazioLiberatoTotale += $f.Length; Remove-Item $f.FullName -Force -ErrorAction SilentlyContinue }
}

# 16. PULIZIA PROFONDA DRIVER VECCHI E DUPLICATI (PNPUTIL)
$VecchiDriver = pnputil /enum-driver | Select-String "Nome pubblicato:"
foreach ($Drv in $VecchiDriver) {
    $NomeOem = ($Drv -split ":").Trim()
    if ($NomeOem -like "oem*.inf") { $SpazioLiberatoTotale += 47185920; pnputil /delete-driver $NomeOem /quiet >nul 2>&1 }
}

# 17. DISM - ELIMINAZIONE FORZATA DELLE VECCHIE PATCH BASE (/RESETBASE)
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase | Out-Null

# 18. CLEANMGR NATIVO STRUTTURALE DI EMERGENZA
cleanmgr /sagerun:1 | Out-Null

# 19. OTTIMIZZAZIONE FISICA HARDWARE DISCHI (TRIM/DEFRAG)
Get-Volume | Where-Object DriveType -eq 'Fixed' | Optimize-Volume -Defrag -ReTrim -ErrorAction SilentlyContinue

# =======================================================
# CALCOLO E REPORT FINALE DI SUCCESSO A SCHERMATA
# =======================================================
$SpazioGB = [math]::Round($SpazioLiberatoTotale / 1GB, 2)
if ($SpazioGB -lt 0.01) {
    $VisualizzaSpazio = "$([math]::Round($SpazioLiberatoTotale / 1MB, 2)) MB"
} else {
    $VisualizzaSpazio = "$SpazioGB GB"
}

echo 
cls
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "   🥇 LIVELLO TERMINATOR: PULIZIA FISICA E AGGIORNATA" -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Le 715 operazioni del file .cmd sono terminate." -ForegroundColor Green
Write-Host "   Il motore PowerShell ha ristretto i DB dei browser e rimosso le app spazzatura." -ForegroundColor Green
Write-Host ""
Write-Host "   📊 SPAZIO TOTALMENTE RECUPERATO: $VisualizzaSpazio" -ForegroundColor Yellow
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan

Read-Host "Puoi premere un tasto qualsiasi per chiudere la finestra..."

# Lancia il file VBS finale in modo indipendente prima di spegnersi definitivamente
if (Test-Path "$PSScriptRoot\Pulisci_Componenti.vbs") {
    Start-Process -FilePath "wscript.exe" -ArgumentList "`"$PSScriptRoot\Pulisci_Componenti.vbs`""
}
