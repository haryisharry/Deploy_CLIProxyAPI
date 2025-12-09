# Download CLI Proxy API
# Downloads the latest cli-proxy-api binary for Windows

$ErrorActionPreference = "Stop"
$binDir = Join-Path $PSScriptRoot "..\bin"
$exePath = Join-Path $binDir "cli-proxy-api.exe"

# Create bin directory
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir -Force | Out-Null
}

# Check if already exists
if (Test-Path $exePath) {
    Write-Host "cli-proxy-api.exe already exists in bin/" -ForegroundColor Yellow
    $response = Read-Host "Re-download latest version? (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Skipping download." -ForegroundColor Cyan
        exit 0
    }
}

Write-Host "Fetching latest release info..." -ForegroundColor Cyan

# Get latest release from GitHub API
$apiUrl = "https://api.github.com/repos/luispater/CLIProxyAPI/releases/latest"
$release = Invoke-RestMethod -Uri $apiUrl -Headers @{"User-Agent"="PowerShell"}

$version = $release.tag_name
Write-Host "Latest version: $version" -ForegroundColor Green

# Find Windows x64 asset
$asset = $release.assets | Where-Object { $_.name -like "*windows*x64*.zip" -or $_.name -like "*windows*amd64*.zip" }

if (-not $asset) {
    Write-Host "Could not find Windows x64 binary in release assets." -ForegroundColor Red
    Write-Host "Available assets:"
    $release.assets | ForEach-Object { Write-Host "  - $($_.name)" }
    exit 1
}

$downloadUrl = $asset.browser_download_url
$zipPath = Join-Path $binDir "cli-proxy-api.zip"

Write-Host "Downloading $($asset.name)..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

Write-Host "Extracting..." -ForegroundColor Cyan
Expand-Archive -Path $zipPath -DestinationPath $binDir -Force

# Find and move the exe to bin root
$extractedExe = Get-ChildItem -Path $binDir -Recurse -Filter "cli-proxy-api.exe" | Select-Object -First 1
if ($extractedExe -and $extractedExe.FullName -ne $exePath) {
    Move-Item -Path $extractedExe.FullName -Destination $exePath -Force
}

# Cleanup
Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $binDir -Directory | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Downloaded cli-proxy-api $version to bin/" -ForegroundColor Green
