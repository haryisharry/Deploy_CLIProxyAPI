# Full Setup Script
# Downloads CLI, creates config, adds accounts, starts server

$ErrorActionPreference = "Stop"
$rootDir = Split-Path $PSScriptRoot -Parent

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CLIProxyAPI Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Download CLI
Write-Host "[1/4] Downloading CLI Proxy API..." -ForegroundColor Yellow
& "$PSScriptRoot\download-cli.ps1"
Write-Host ""

# Step 2: Create config
Write-Host "[2/4] Setting up configuration..." -ForegroundColor Yellow
$configPath = Join-Path $rootDir "config.yaml"
$templatePath = Join-Path $rootDir "config.template.yaml"

if (-not (Test-Path $configPath)) {
    if (Test-Path $templatePath) {
        Copy-Item $templatePath $configPath
        Write-Host "Created config.yaml from template." -ForegroundColor Green
    }
} else {
    Write-Host "config.yaml already exists." -ForegroundColor Green
}
Write-Host ""

# Step 3: Add accounts
Write-Host "[3/4] Adding Gmail accounts..." -ForegroundColor Yellow
Write-Host "You can add multiple Gmail accounts for load balancing." -ForegroundColor Cyan

$accountCount = 0
$addMore = "y"

while ($addMore -eq "y" -or $addMore -eq "Y") {
    $accountCount++
    Write-Host ""
    Write-Host "Adding account #$accountCount..." -ForegroundColor Cyan
    & "$PSScriptRoot\add-account.ps1"
    
    Write-Host ""
    $addMore = Read-Host "Add another Gmail account? (y/N)"
}

Write-Host ""
Write-Host "Added $accountCount account(s)." -ForegroundColor Green
Write-Host ""

# Step 4: Start server
Write-Host "[4/4] Starting proxy server..." -ForegroundColor Yellow
& "$PSScriptRoot\start.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Quick test:" -ForegroundColor Cyan
Write-Host '  Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{Authorization="Bearer tuyen"}' -ForegroundColor White
Write-Host ""
