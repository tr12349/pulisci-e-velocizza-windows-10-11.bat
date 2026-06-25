# =========================================================
# 🚀 ULTIMATE CLEANER PRO WINDOWS 10 / 11
# =========================================================

$VersioneCorrente = "1.0.1"

# =========================
# 🔐 ADMIN CHECK
# =========================
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Start-Process powershell.exe -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", "`"$PSCommandPath`""
    ) -Verb RunAs
    exit
}
# =========================
# ⚙️ SETUP
# =========================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$VersioneCorrente = "1.0.1"

$PathScript = $MyInvocation.MyCommand.Path
$LogFile = "$env:TEMP\cleaner_log.txt"

$UrlVersione = "https://raw.githubusercontent.com/tr12349/pulisci-e-velocizza-windows-10-11.bat/main/versione.txt"

$UrlScript = "https://raw.githubusercontent.com/tr12349/pulisci-e-velocizza-windows-10-11.bat/main/velocizza%20e%20pulisci%20windows%2010-11.ps1"

$SpazioLiberato = 0

function Log($msg) {
$msg | Tee-Object -FilePath $LogFile -Append
}

# =========================
# 🌐 AUTO UPDATE
# =========================

$VersioneRemota = $VersioneCorrente

try {

```
$VersioneRemota = (
    Invoke-WebRequest `
        -Uri $UrlVersione `
        -UseBasicParsing `
        -TimeoutSec 5
).Content.Trim()

if ([version]$VersioneRemota -gt [version]$VersioneCorrente) {

    Write-Host ""
    Write-Host "Nuova versione disponibile: $VersioneRemota" -ForegroundColor Yellow

    $Risposta = Read-Host "Vuoi aggiornare? (S/N)"

    if ($Risposta -match '^[Ss]$') {

        Log "[UPDATE] Aggiornamento avviato"

        $TempScript = Join-Path $env:TEMP "ultimate_cleaner_update.ps1"

        Invoke-WebRequest `
            -Uri $UrlScript `
            -OutFile $TempScript `
            -UseBasicParsing

        if (!(Test-Path $TempScript)) {
            throw "Download fallito"
        }

        Copy-Item $PathScript "$PathScript.bak" -Force

        $UpdaterPath = Join-Path $env:TEMP "ultimate_cleaner_updater.ps1"

        @"
```

Start-Sleep -Seconds 2

Copy-Item '$TempScript' '$PathScript' -Force

Start-Process powershell.exe `
-ArgumentList '-ExecutionPolicy Bypass -File ""$PathScript""'
"@ | Set-Content $UpdaterPath -Encoding UTF8

```
        Start-Process powershell.exe `
            -WindowStyle Hidden `
            -ArgumentList "-ExecutionPolicy Bypass -File `"$UpdaterPath`""

        Log "[UPDATE] Aggiornamento completato"

        exit
    }
    else {
        Log "[UPDATE] Aggiornamento rifiutato"
    }
}
else {
    Log "[INFO] Nessun aggiornamento disponibile"
}
```

}
catch {
Log "[UPDATE] Errore: $_"
}

# =========================
# 🧹 1. DEBLOAT APPS
# =========================
Log "[1] Rimozione app inutili..."

$Apps = @(
"Microsoft.XboxApp",
"*CandyCrush*",
"*Disney*",
"*Spotify*",
"*Zune*",
"*BingWeather*"
)

foreach ($app in $Apps) {
    Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue |
        Remove-AppxPackage -ErrorAction SilentlyContinue
}

# =========================
# 🧹 2. TEMP CLEAN REAL
# =========================
Log "[2] Pulizia cartelle temporanee..."

$paths = @(
$env:TEMP,
"C:\Windows\Temp"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        Get-ChildItem $p -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $SpazioLiberato += $_.Length
                Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
            } catch {}
        }
    }
}

# =========================
# 🧹 3. CACHE ICONS
# =========================
Log "[3] Cache Explorer..."

Stop-Process explorer -Force -ErrorAction SilentlyContinue
Start-Sleep 1

Get-ChildItem "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache*" -ErrorAction SilentlyContinue |
Remove-Item -Force -ErrorAction SilentlyContinue

Start-Process explorer.exe

# =========================
# 🧹 4. RECYCLE BIN
# =========================
Log "[4] Cestino..."

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# =========================
# 🧹 5. SYSTEM CLEANUP SAFE
# =========================
Log "[5] System cleanup..."

cmd /c "powercfg /h off" | Out-Null
cmd /c "vssadmin delete shadows /all /quiet" | Out-Null

# =========================
# 🧹 6. DISK OPTIMIZATION
# =========================
Log "[6] Ottimizzazione dischi..."

Get-Volume | Where-Object DriveLetter | ForEach-Object {
    if ($_.DriveType -eq "Fixed") {

        if ($_.MediaType -eq "SSD") {
            Optimize-Volume -DriveLetter $_.DriveLetter -ReTrim -ErrorAction SilentlyContinue
        } else {
            Optimize-Volume -DriveLetter $_.DriveLetter -Defrag -ErrorAction SilentlyContinue
        }
    }
}

# =========================
# 📦 FINAL REPORT
# =========================
$GB = [math]::Round($SpazioLiberato / 1GB, 2)

Log "==============================="
Log "OPERAZIONE COMPLETATA"
Log "Spazio liberato (reale): $GB GB"
Log "Versione: $VersioneCorrente"
Log "==============================="

Write-Host "`n✔ Pulizia completata - $GB GB liberati" -ForegroundColor Green
Read-Host "Premi INVIO per uscire"
