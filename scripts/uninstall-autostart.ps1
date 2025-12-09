# Uninstall Auto-Start Task
# Removes the Windows scheduled task for CLI Proxy API

$taskName = "CLIProxyAPI"

$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing scheduled task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Auto-start task removed." -ForegroundColor Green
} else {
    Write-Host "No auto-start task found." -ForegroundColor Yellow
}
