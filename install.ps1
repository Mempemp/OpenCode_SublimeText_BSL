# Opencode+Sublime -- Master Installer
# Run from the distribution directory (where this script lives)
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== Opencode+Sublime Installer ===" -ForegroundColor Cyan
Write-Host "Source: $root" -ForegroundColor Gray

# ── Step 0: Config + download BSL Language Server ──
$configSrc = Join-Path $root "opencode\scripts\config.json"
$configDst = "$HOME\.config\opencode\scripts"
New-Item -ItemType Directory -Force -Path $configDst | Out-Null
Copy-Item $configSrc $configDst -Force

# Download latest BSL Language Server JAR from GitHub
$lspJarDst = "$HOME\tools\bsl-lsp"
New-Item -ItemType Directory -Force -Path $lspJarDst | Out-Null
$jarPath = ""
try {
    Write-Host "Downloading latest BSL Language Server..." -ForegroundColor Yellow
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/1c-syntax/bsl-language-server/releases/latest"
    $asset = $release.assets | Where-Object { $_.name -like "*-exec.jar" } | Select-Object -First 1
    if ($asset) {
        $jarPath = Join-Path $lspJarDst $asset.name
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $jarPath
        Write-Host "  -> $jarPath" -ForegroundColor Green
    } else {
        Write-Host "  WARNING: no exec jar found in release" -ForegroundColor Red
    }
} catch {
    Write-Host "  WARNING: download failed ($($_.Exception.Message))" -ForegroundColor Red
    Write-Host "  Download manually from https://github.com/1c-syntax/bsl-language-server/releases" -ForegroundColor Gray
}

# ── Step 1: OpenCode commands ──
Write-Host "`n[1/5] OpenCode commands..." -ForegroundColor Yellow
$ocCmdSrc = Join-Path $root "opencode\commands"
$ocCmdDst = "$HOME\.config\opencode\commands"
New-Item -ItemType Directory -Force -Path $ocCmdDst | Out-Null
Copy-Item "$ocCmdSrc\*" $ocCmdDst -Force
Write-Host "  -> $ocCmdDst" -ForegroundColor Green

# ── Step 2: OpenCode PowerShell scripts ──
Write-Host "`n[2/5] OpenCode scripts..." -ForegroundColor Yellow
$ocScrSrc = Join-Path $root "opencode\scripts"
$ocScrDst = "$HOME\.config\opencode\scripts"
Copy-Item "$ocScrSrc\*" $ocScrDst -Force
Write-Host "  -> $ocScrDst" -ForegroundColor Green

# ── Step 3: Sublime Text packages ──
Write-Host "`n[3/5] Sublime Text packages..." -ForegroundColor Yellow
$stPkgSrc = Join-Path $root "sublime\packages"
$stPkgDst = "$env:APPDATA\Sublime Text\Packages"
New-Item -ItemType Directory -Force -Path $stPkgDst | Out-Null
foreach ($pkg in @("LSP", "1C (BSL)")) {
    $src = Join-Path $stPkgSrc $pkg
    $dst = Join-Path $stPkgDst $pkg
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse $src $dst
    Write-Host "  -> $dst" -ForegroundColor Green
}

# ── Step 4: LSP config (replace placeholder with real jar path) ──
Write-Host "`n[4/5] LSP config..." -ForegroundColor Yellow
$lspConfigSrc = Join-Path $root "sublime\config\LSP.sublime-settings"
$lspConfigDst = "$env:APPDATA\Sublime Text\Packages\User"
New-Item -ItemType Directory -Force -Path $lspConfigDst | Out-Null
if (Test-Path $lspConfigSrc) {
    $lspConfig = Get-Content $lspConfigSrc -Raw
    if ($jarPath) {
        $lspConfig = $lspConfig -replace '__BSL_LSP_JAR__', $jarPath.Replace('\', '\\')
    }
    Set-Content -Path (Join-Path $lspConfigDst "LSP.sublime-settings") -Value $lspConfig
    Write-Host "  -> jar: $jarPath" -ForegroundColor Green
    Write-Host "  -> $(Join-Path $lspConfigDst 'LSP.sublime-settings')" -ForegroundColor Green
}

# ── Step 5: Verify ──
Write-Host "`n[5/5] Verification..." -ForegroundColor Yellow
$ok = $true
if (-not (Test-Path "$HOME\.config\opencode\commands\OpenEditor.md")) { Write-Host "  MISSING: OpenEditor.md" -ForegroundColor Red; $ok = $false }
if (-not (Test-Path "$HOME\.config\opencode\scripts\sublime-open.ps1")) { Write-Host "  MISSING: sublime-open.ps1" -ForegroundColor Red; $ok = $false }
if (-not (Test-Path "$HOME\.config\opencode\scripts\config.json")) { Write-Host "  MISSING: config.json" -ForegroundColor Red; $ok = $false }
if (-not (Test-Path "$env:APPDATA\Sublime Text\Packages\LSP")) { Write-Host "  MISSING: LSP package" -ForegroundColor Red; $ok = $false }
if (-not (Test-Path "$env:APPDATA\Sublime Text\Packages\1C (BSL)")) { Write-Host "  MISSING: 1C (BSL) package" -ForegroundColor Red; $ok = $false }
if (-not $jarPath) { Write-Host "  MISSING: bsl-language-server jar" -ForegroundColor Red; $ok = $false }

if ($ok) {
    Write-Host "`n=== INSTALL COMPLETE ===" -ForegroundColor Green
    Write-Host "Restart OpenCode to use /OpenEditor and /OpenEditorDiffs" -ForegroundColor Cyan
    Write-Host "Restart Sublime Text to use LSP + BSL syntax highlighting" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Customize paths in:" -ForegroundColor Gray
    Write-Host "  $(Join-Path $configDst 'config.json')" -ForegroundColor White
} else {
    Write-Host "`n=== INSTALL INCOMPLETE -- check errors above ===" -ForegroundColor Red
}
