# LG HUB Restart Script

PowerShell script to restart Logitech G HUB in a specific order after login to counteract perpetual loading bug.

## Why this exists

On some PCs, G HUB does not start cleanly on boot. This script automates a reliable workaround:

1. stop existing LG HUB processes
2. wait briefly
3. start `lghub_updater.exe`, then `lghub_agent.exe`, then `lghub.exe`

## Setup

Save the script somewhere like:

```text
C:\Scripts\restart-lghub.ps1
```

Confirm these match your machine:

- install folder: `C:\Program Files\LGHUB`
- process names:
  - `lghub.exe`
  - `lghub_agent.exe`
  - `lghub_system_tray.exe`
  - `lghub_updater.exe`

You can verify process names with:

```powershell
Get-Process | Where-Object { $_.ProcessName -like "*lghub*" } | Select-Object ProcessName, Id, Path
```

## Recommended Task Scheduler setup

- **Trigger:** At log on
- **Delay:** 30–60 seconds
- **Run only when user is logged on**
- **Run with highest privileges**

Program:

```text
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

Arguments:

```text
-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Scripts\restart-lghub.ps1"
```

## Notes

- timings may need adjustment on another computer
- disable normal G HUB auto-start if it conflicts with this task
- if G HUB starts normally on your machine, this script is probably unnecessary

## Log file

The script writes to:

```text
C:\Scripts\restart-lghub-log.txt
```
