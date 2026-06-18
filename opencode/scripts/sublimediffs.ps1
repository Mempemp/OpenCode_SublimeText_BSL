# Opens git-changed files in Sublime Text
param([string]$Mask)

$cfgDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Get-Content (Join-Path $cfgDir "config.json") -Raw | ConvertFrom-Json
$subl = $cfg.sublime_exe

# Resolve git root (not CWD)
$gitRoot = git rev-parse --show-toplevel 2>$null
if (-not $gitRoot) { Write-Output "Not a git repository"; exit 1 }

# Get changed files: staged + unstaged vs HEAD, exclude deleted
$files = git diff HEAD --name-only --diff-filter=ACMRT 2>$null
if (-not $files) { Write-Output "No changed files"; exit 0 }

$list = $files -split '\r?\n' | Where-Object { $_ -ne '' }

if ($Mask) {
    $re = '^' + [regex]::Escape($Mask).Replace('\*','.*') + '$'
    $list = $list | Where-Object { $_ -match $re }
}

if ($list.Count -eq 0) { Write-Output "No files matching '$Mask'"; exit 0 }

$paths = @()
foreach ($f in $list) {
    $paths += Join-Path $gitRoot $f
}
& $subl $paths
Write-Output "Opened $($list.Count) file(s) in Sublime"
