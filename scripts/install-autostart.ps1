# Install Auto-Start Task
# Creates a Windows scheduled task to start CLI Proxy API on login

$ErrorActionPreference = "Stop"
$rootDir = Split-Path $PSScriptRoot -Parent
$exePath = Join-Path $rootDir "bin\cli-proxy-api.exe"
$configPath = Join-Path $rootDir "config.yaml"
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

Write-Host "Creating auto-start task..." -ForegroundColor Cyan

# Create the scheduled task
$action = New-ScheduledTaskAction -Execute $exePath -Argument "--config `"$configPath`"" -WorkingDirectory $rootDir
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 0)
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "CLI Proxy API for Antigravity OAuth" | Out-Null

Write-Host ""
Write-Host "Auto-start task created successfully!" -ForegroundColor Green
Write-Host "CLI Proxy API will start automatically when you log in." -ForegroundColor Cyan
Write-Host ""
Write-Host "To remove auto-start, run: .\scripts\uninstall-autostart.ps1" -ForegroundColor Gray
