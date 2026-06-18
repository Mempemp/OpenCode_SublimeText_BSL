# Opens git-changed files in Sublime Text
param([string]$Mask)

$cfgDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Get-Content (Join-Path $cfgDir "config.json") -Raw | ConvertFrom-Json
$subl = $cfg.sublime_exe
$root = (Get-Location).Path
$files = git diff --name-only

if (-not $files) { Write-Output "No changed files"; exit 0 }

$list = $files -split '\n' | Where-Object { $_ -ne '' }

if ($Mask) {
    $re = '^' + [regex]::Escape($Mask).Replace('\*','.*') + '$'
    $list = $list | Where-Object { $_ -match $re }
}

if ($list.Count -eq 0) { Write-Output "No files matching '$Mask'"; exit 0 }

foreach ($f in $list) {
    & $subl (Join-Path $root $f)
}
Write-Output "Opened $($list.Count) file(s) in Sublime"
