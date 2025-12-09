# CLIProxyAPI Setup

A ready-to-deploy OpenAI-compatible proxy for Gemini Pro via Antigravity OAuth.

## 🚀 Quick Deploy

Clone this repo and run:
```powershell
.\scripts\setup.ps1
.\scripts\install-autostart.ps1
```

Or tell an AI agent:
```
Deploy the CLIProxyAPI proxy from this repo using /deploy
```

## 📋 What This Does

1. Downloads the latest `cli-proxy-api` binary
2. Creates config from template
3. Prompts you to login with Gmail accounts (Antigravity OAuth)
4. Starts the proxy server
5. (Optional) Enables auto-start on Windows login

## 🔧 Manual Setup

### Step 1: Download CLI
```powershell
.\scripts\download-cli.ps1
```

### Step 2: Configure
Edit `config.yaml` with your preferred settings:
- `api-keys`: Keys clients use to authenticate
- `secret-key`: Management panel password

### Step 3: Add Gmail Accounts
```powershell
.\scripts\add-account.ps1
```
Run this for each Gmail account with Gemini Pro access.

### Step 4: Start Proxy
```powershell
.\scripts\start.ps1
```

### Step 5: Enable Auto-Start (Optional)
```powershell
.\scripts\install-autostart.ps1
```
This creates a Windows scheduled task to start the proxy on login.

To disable auto-start:
```powershell
.\scripts\uninstall-autostart.ps1
```

## 📡 Connection Details

| Setting | Value |
|---------|-------|
| Base URL | `http://localhost:8317/v1` |
| API Keys | `tuyen`, `tuyenqwe` |
| Management Panel | `http://localhost:8317/management.html` |
| Management Password | `tuyenqwe` |

## ✅ Available Models

- `gemini-2.5-flash` / `gemini-2.5-flash-lite`
- `gemini-3-pro-preview` / `gemini-3-pro-image-preview`
- `gemini-claude-sonnet-4-5` / `gemini-claude-sonnet-4-5-thinking`
- `gemini-claude-opus-4-5-thinking`
- `gpt-oss-120b-medium`

## 📁 Folder Structure

```
CLIProxyAPI/
├── README.md
├── config.yaml              # Your active config
├── config.template.yaml     # Template for new installs
├── .gitignore
├── bin/                     # CLI binary (not in git)
│   └── cli-proxy-api.exe
├── scripts/
│   ├── setup.ps1            # Full auto-setup
│   ├── download-cli.ps1     # Download binary
│   ├── start.ps1            # Start proxy
│   ├── stop.ps1             # Stop proxy
│   ├── add-account.ps1      # Add Gmail account
│   ├── install-autostart.ps1    # Enable auto-start
│   └── uninstall-autostart.ps1  # Disable auto-start
└── .agent/
    └── workflows/
        └── deploy.md        # Agent deployment workflow
```

## 🔑 Test Commands

```powershell
# List models
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{Authorization="Bearer tuyen"}

# Chat completion
$body = @{model="gemini-2.5-flash"; messages=@(@{role="user"; content="Hello!"})} | ConvertTo-Json -Depth 5
(Invoke-RestMethod -Uri "http://localhost:8317/v1/chat/completions" -Method POST -Headers @{Authorization="Bearer tuyen"; "Content-Type"="application/json"} -Body $body).choices[0].message.content
```

## 🔧 OpenCode Integration

Add this to your `~/.config/opencode/opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "myprovider": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Antigravity - CLIProxyAPI",
      "options": {
        "baseURL": "http://localhost:8317/v1",
        "apiKey": "tuyen"
      },
      "models": {
        "gemini-2.5-flash": { "name": "Gemini 2.5 Flash" },
        "gemini-3-pro-preview": { "name": "Gemini 3 Pro Preview" },
        "gemini-claude-sonnet-4-5": { "name": "Claude Sonnet 4.5" },
        "gemini-claude-opus-4-5-thinking": { "name": "Claude Opus 4.5 (Thinking)" }
      }
    }
  }
}
```

## 📚 Links

- [CLIProxyAPI GitHub](https://github.com/luispater/CLIProxyAPI)
- [Documentation](https://help.router-for.me/)
