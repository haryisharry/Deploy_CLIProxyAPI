# Install Auto-Start Task
# Creates a Windows scheduled task to start CLI Proxy API on login (hidden, no window)

$ErrorActionPreference = "Stop"
$rootDir = Split-Path $PSScriptRoot -Parent
$exePath = Join-Path $rootDir "bin\cli-proxy-api.exe"
$configPath = Join-Path $rootDir "config.yaml"
$hiddenScript = Join-Path $rootDir "scripts\start-hidden.ps1"
$taskName = "CLIProxyAPI"

# Check if binary exists
if (-not (Test-Path $exePath)) {
    Write-Host "cli-proxy-api.exe not found. Run download-cli.ps1 first." -ForegroundColor Red
    exit 1
}

# Remove existing task if present
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing scheduled task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

Write-Host "Creating auto-start task (hidden mode)..." -ForegroundColor Cyan

# Create the scheduled task using PowerShell with hidden window
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$hiddenScript`"" -WorkingDirectory $rootDir
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 0) -Hidden
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "CLI Proxy API for Antigravity OAuth (Hidden)" | Out-Null

Write-Host ""
Write-Host "Auto-start task created successfully!" -ForegroundColor Green
Write-Host "CLI Proxy API will start automatically when you log in (no visible window)." -ForegroundColor Cyan
Write-Host ""
Write-Host "To remove auto-start, run: .\scripts\uninstall-autostart.ps1" -ForegroundColor Gray
