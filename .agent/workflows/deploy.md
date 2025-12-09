---
description: Deploy CLIProxyAPI proxy with Antigravity OAuth
---

# Deploy CLIProxyAPI Workflow

This workflow sets up the CLI Proxy API with Antigravity OAuth for Gemini Pro access.

## Prerequisites
- Windows OS
- PowerShell 5.1+
- Gmail account(s) with Gemini Pro access

## Steps

// turbo-all

### 1. Navigate to repo directory
```powershell
cd <repo_root>
```

### 2. Download the CLI binary
```powershell
.\scripts\download-cli.ps1
```

### 3. Create config from template (if needed)
```powershell
if (-not (Test-Path "config.yaml")) { Copy-Item "config.template.yaml" "config.yaml" }
```

### 4. Add Gmail accounts via Antigravity OAuth
Run this for EACH Gmail account (user interaction required - browser login):
```powershell
.\scripts\add-account.ps1
```
Repeat for each account. Auth files are saved to `~/.cli-proxy-api/`

### 5. Start the proxy server
```powershell
.\scripts\start.ps1
```

### 6. Verify the setup
```powershell
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{Authorization="Bearer tuyen"}
```

### 7. Test chat completion
```powershell
$body = @{model="gemini-2.5-flash"; messages=@(@{role="user"; content="Hello!"})} | ConvertTo-Json -Depth 5
(Invoke-RestMethod -Uri "http://localhost:8317/v1/chat/completions" -Method POST -Headers @{Authorization="Bearer tuyen"; "Content-Type"="application/json"} -Body $body).choices[0].message.content
```

## Connection Details
- **API URL:** http://localhost:8317/v1
- **API Keys:** tuyen, tuyenqwe
- **Management Panel:** http://localhost:8317/management.html
- **Management Password:** tuyenqwe

## Troubleshooting
- If no models appear, ensure at least one Gmail account is logged in
- If management login fails, stop proxy, set plaintext secret-key in config.yaml, restart
- To stop: `.\scripts\stop.ps1`
