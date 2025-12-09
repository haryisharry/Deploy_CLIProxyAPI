# Stop CLI Proxy API

$process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue

if ($process) {
    Write-Host "Stopping CLI Proxy API (PID: $($process.Id))..." -ForegroundColor Cyan
    Stop-Process -Name "cli-proxy-api" -Force
    Write-Host "Stopped." -ForegroundColor Green
} else {
    Write-Host "CLI Proxy API is not running." -ForegroundColor Yellow
}
