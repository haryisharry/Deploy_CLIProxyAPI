# Start CLI Proxy API (Hidden)
# Used by scheduled task to run without visible window

$rootDir = Split-Path $PSScriptRoot -Parent
$exePath = Join-Path $rootDir "bin\cli-proxy-api.exe"
$configPath = Join-Path $rootDir "config.yaml"

if (Test-Path $exePath) {
    Start-Process -FilePath $exePath -ArgumentList "--config", "`"$configPath`"" -WindowStyle Hidden
}
