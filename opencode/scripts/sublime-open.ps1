# Opens files in Sublime Text. Supports exact paths or partial filenames.
param([string[]]$Files)

$cfgDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Get-Content (Join-Path $cfgDir "config.json") -Raw | ConvertFrom-Json
$subl = $cfg.sublime_exe
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { $root = (Get-Location).Path }

function Resolve-File($name) {
    # 1. Exact match (relative to project root)
    $exact = Join-Path $root $name
    if (Test-Path -PathType Leaf $exact) { return $exact }

    # 2. Search via git ls-files (fast, project-only, partial matches)
    try {
        $matches = git ls-files "*$name*" 2>$null
        if ($matches) {
            $found = $matches -split '\n' | Where-Object { $_ -ne '' } | Select-Object -First 1
            return (Join-Path $root $found)
        }
    } catch {}

    # 3. Nothing found — return original, Sublime will show empty/new file
    return $exact
}

$resolved = @()
foreach ($f in $Files) {
    $r = Resolve-File $f
    $resolved += $r
    if ($r -match [regex]::Escape($f)) {
        Write-Output "  $f -> found"
    } else {
        Write-Output "  $f -> NOT FOUND (opening as new)"
    }
}

# Call subl.exe ONCE with all files — avoids race conditions
& $subl $resolved
Write-Output "Opened $($Files.Count) file(s) in Sublime"
