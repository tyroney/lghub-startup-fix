$log = "C:\Scripts\restart-lghub-log.txt"
$dir = "C:\Program Files\LGHUB"

# Overwrite log each run
"Started: $(Get-Date)" | Out-File -FilePath $log

$adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
"IsAdmin=$adminCheck User=$env:USERNAME" | Out-File -FilePath $log -Append

if (-not $adminCheck) {
    "Not elevated. Exiting." | Out-File -FilePath $log -Append
    [Environment]::Exit(1)
}

try {
    Set-Location $dir

    taskkill /F /IM lghub.exe /T 2>$null | Out-Null
    taskkill /F /IM lghub_agent.exe /T 2>$null | Out-Null
    taskkill /F /IM lghub_system_tray.exe /T 2>$null | Out-Null
    taskkill /F /IM lghub_updater.exe /T 2>$null | Out-Null

    Start-Sleep -Seconds 12

    Start-Process "$dir\lghub_updater.exe" -WorkingDirectory $dir
    Start-Sleep -Seconds 6

    Start-Process "$dir\lghub_agent.exe" -WorkingDirectory $dir
    Start-Sleep -Seconds 6

    Start-Process "$dir\lghub.exe" -WorkingDirectory $dir

    "Finished OK: $(Get-Date)" | Out-File -FilePath $log -Append
    [Environment]::Exit(0)
}
catch {
    "ERROR: $($_.Exception.Message)" | Out-File -FilePath $log -Append
    [Environment]::Exit(1)
}
