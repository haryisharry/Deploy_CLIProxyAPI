# Add Antigravity Account
# Runs the OAuth login flow to add a Gmail account

$ErrorActionPreference = "Stop"
$rootDir = Split-Path $PSScriptRoot -Parent
$exePath = Join-Path $rootDir "bin\cli-proxy-api.exe"

if (-not (Test-Path $exePath)) {
    Write-Host "cli-proxy-api.exe not found. Run download-cli.ps1 first." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Antigravity OAuth login..." -ForegroundColor Cyan
Write-Host "A browser will open for Google login." -ForegroundColor Yellow
Write-Host ""

& $exePath -antigravity-login

Write-Host ""
Write-Host "Account added! Auth file saved to ~/.cli-proxy-api/" -ForegroundColor Green
