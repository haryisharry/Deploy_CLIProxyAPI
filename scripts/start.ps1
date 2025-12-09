# Start CLI Proxy API
# Starts the proxy server in the background

$ErrorActionPreference = "Stop"
$rootDir = Split-Path $PSScriptRoot -Parent
$exePath = Join-Path $rootDir "bin\cli-proxy-api.exe"
$configPath = Join-Path $rootDir "config.yaml"

# Check if binary exists
if (-not (Test-Path $exePath)) {
    Write-Host "cli-proxy-api.exe not found. Run download-cli.ps1 first." -ForegroundColor Red
    exit 1
}

# Check if config exists
if (-not (Test-Path $configPath)) {
    Write-Host "config.yaml not found. Copying from template..." -ForegroundColor Yellow
    $templatePath = Join-Path $rootDir "config.template.yaml"
    if (Test-Path $templatePath) {
        Copy-Item $templatePath $configPath
        Write-Host "Created config.yaml from template." -ForegroundColor Green
    } else {
        Write-Host "config.template.yaml not found!" -ForegroundColor Red
        exit 1
    }
}

# Check if already running
$existing = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "cli-proxy-api is already running (PID: $($existing.Id))" -ForegroundColor Yellow
    $response = Read-Host "Restart? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Stop-Process -Name "cli-proxy-api" -Force
        Start-Sleep -Seconds 1
    } else {
        exit 0
    }
}

Write-Host "Starting CLI Proxy API..." -ForegroundColor Cyan

# Start in background
Start-Process -FilePath $exePath -ArgumentList "--config", $configPath -WindowStyle Hidden

Start-Sleep -Seconds 2

# Verify it's running
$process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "CLI Proxy API started successfully! (PID: $($process.Id))" -ForegroundColor Green
    Write-Host ""
    Write-Host "Endpoints:" -ForegroundColor Cyan
    Write-Host "  API:        http://localhost:8317/v1" -ForegroundColor White
    Write-Host "  Management: http://localhost:8317/management.html" -ForegroundColor White
} else {
    Write-Host "Failed to start CLI Proxy API. Check logs." -ForegroundColor Red
    exit 1
}
