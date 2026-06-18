# Opens specified files in Sublime Text with absolute paths
param([string[]]$Files)

$cfgDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Get-Content (Join-Path $cfgDir "config.json") -Raw | ConvertFrom-Json
$subl = $cfg.sublime_exe
$root = (Get-Location).Path

foreach ($f in $Files) {
    $full = Join-Path $root $f
    & $subl $full
}
Write-Output "Opened $($Files.Count) file(s) in Sublime"
