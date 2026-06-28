@echo off
:: Chiude Explorer per evitare file bloccati durante la pulizia
taskkill /f /im explorer.exe

echo --- PULIZIA CARTELLE TEMPORANEE IN CORSO ---

:: Cartelle temporanee generiche
del /f /s /q "%temp%\*.*"
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p"

del /f /s /q "C:\Windows\Temp\*.*"
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p"

del /f /s /q "C:\Windows\Prefetch\*.*"
for /d %%p in ("C:\Windows\Prefetch\*") do rmdir /s /q "%%p"

:: Aggiornamenti Windows Update (Download e Ottimizzazione)
net stop wuauserv
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*"
for /d %%p in ("C:\Windows\SoftwareDistribution\Download\*") do rmdir /s /q "%%p"

del /f /s /q "C:\Windows\SoftwareDistribution\DeliveryOptimization\*.*"
for /d %%p in ("C:\Windows\SoftwareDistribution\DeliveryOptimization\*") do rmdir /s /q "%%p"
net start wuauserv

:: Cestino di sistema
del /f /s /q "C:\$Recycle.Bin\*.*"
for /d %%p in ("C:\$Recycle.Bin\*") do rmdir /s /q "%%p"

:: Log e Report Errori Windows
del /f /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*.*"
for /d %%p in ("C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*") do rmdir /s /q "%%p"

del /f /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*.*"
for /d %%p in ("C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*") do rmdir /s /q "%%p"

del /f /s /q "C:\Windows\Logs\CBS\*.*"

:: Cache Grafica (D3D) e Indici
del /f /s /q "%localappdata%\D3DSCache\*.*"
for /d %%p in ("%localappdata%\D3DSCache\*") do rmdir /s /q "%%p"

del /f /s /q "%localappdata%\LocalComputeIndex\*.*"
for /d %%p in ("%localappdata%\LocalComputeIndex\*") do rmdir /s /q "%%p"

:: Cache temporanea .NET Framework
del /f /s /q "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\*.*"
for /d %%p in ("C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\*") do rmdir /s /q "%%p"

:: Riavvia Explorer graficamente
start explorer.exe

echo --- PULIZIA COMPLETATA CON SUCCESSO! ---
pause
