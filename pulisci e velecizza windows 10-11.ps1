# =========================================================
# 🚀 ULTIMATE CLEANER PRO WINDOWS 10 / 11
# =========================================================

$VersioneCorrente = "1.0.0"

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

$PathScript = $MyInvocation.MyCommand.Path
$LogFile = "$env:TEMP\cleaner_log.txt"

$UrlVersione = "https://raw.githubusercontent.com/UTENTE/REPO/main/versione.txt"
$UrlCartelle = "https://raw.githubusercontent.com/UTENTE/REPO/main/cartelle.json"

$SpazioLiberato = 0
$NuoviPercorsi = @()

function Log($msg) {
    $msg | Tee-Object -FilePath $LogFile -Append
}

# =========================
# 🌐 AUTO UPDATE SICURO (FIX DEFINITIVO)
# =========================

$VersioneRemota = $VersioneCorrente
$InternetOK = $true

try {
    $r = Invoke-WebRequest -Uri $UrlVersione -UseBasicParsing -TimeoutSec 5
    $v = $r.Content.Trim()

    if ($v -match "^\d+(\.\d+){0,2}$") {
        $VersioneRemota = $matches[0]
    }
}
catch {
    $InternetOK = $false
}

if ($InternetOK -and ([version]$VersioneRemota -gt [version]$VersioneCorrente)) {

    Log "[UPDATE] Nuova versione: $VersioneRemota"

    try {
        # ✔ LEGGE SOLO UNA VOLTA
        $lines = Get-Content $PathScript

        # ✔ MODIFICA SOLO LA RIGA VERSIONE
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\$VersioneCorrente\s*=') {
                $lines[$i] = "`$VersioneCorrente = `"$VersioneRemota`""
            }
        }

        # ✔ BACKUP PRIMA DI SCRIVERE
        Copy-Item $PathScript "$PathScript.bak" -Force

        # ✔ SCRITTURA UNICA (NON DOPPIA!)
        $lines | Set-Content $PathScript -Encoding UTF8

        Log "[UPDATE] Aggiornamento completato"
    }
    catch {
        Copy-Item "$PathScript.bak" $PathScript -Force
        Log "[UPDATE] Fallito → rollback eseguito"
    }
}
elseif ($InternetOK) {
    Log "[INFO] Già aggiornato"
}
else {
    Log "[INFO] Offline mode"
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
