<#
.SYNOPSIS
    Runs one warm-up pass so Neovim's plugin files stay in Defender's scan cache.

.DESCRIPTION
    On this machine Neovide takes ~10-16s to start if it has not been run for a
    while, but ~1s if run again shortly after. That gap is Microsoft Defender for
    Endpoint + DLP inspecting each plugin file on first access; Defender caches
    the result per file until the file changes or signatures update (which
    happens several times a day, hence the "slow after a while" pattern).

    Measured on this machine, force-loading all 46 plugins:
        cold: 16748 ms
        warm:  1112 ms

    The proper fix - Defender path exclusions - is unavailable: Tamper Protection
    is enabled and the exclusion list is centrally managed, so locally added
    exclusions are silently discarded. This script is the fallback: a cheap (~1s)
    pass that re-opens the plugin files, scheduled often enough that the scan
    cache is already populated by the time Neovide is launched.

    Nothing about the Neovim configuration is changed and no plugin behaviour is
    altered - this only affects filesystem cache state.

.EXAMPLE
    pwsh -NoProfile -File utils\nvim-warmup.ps1
    Run a single warm-up pass and log how long it took.

.NOTES
    Scheduled with utils\install-warmup.ps1 (Task Scheduler, task 'NvimWarmup').
    Log file: %LOCALAPPDATA%\nvim-warmup.log
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$warmupLua = Join-Path $PSScriptRoot 'warmup.lua'
$logFile = Join-Path $env:LOCALAPPDATA 'nvim-warmup.log'

if (-not (Test-Path -LiteralPath $warmupLua)) {
    throw "Missing warm-up script: $warmupLua"
}

function Write-WarmupLog {
    param([string] $Message)

    $line = '{0}  {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    try {
        # Keep the log from growing without bound.
        if ((Test-Path -LiteralPath $logFile) -and (Get-Item -LiteralPath $logFile).Length -gt 256KB) {
            Remove-Item -LiteralPath $logFile -ErrorAction SilentlyContinue
        }
        Add-Content -LiteralPath $logFile -Value $line -ErrorAction SilentlyContinue
    } catch {
        # Logging must never take the pass down.
    }
    Write-Verbose $line
}

function Resolve-Nvim {
    # The task runs without an interactive session, where PATH may be leaner than
    # in a normal shell, so fall back to the known install location.
    $command = Get-Command nvim -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $candidates = @(
        'C:\tools\neovim\nvim-win64\bin\nvim.exe'
        (Join-Path $env:ProgramFiles 'Neovim\bin\nvim.exe')
        (Join-Path $env:LOCALAPPDATA 'Programs\Neovim\bin\nvim.exe')
    )
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }

    return $null
}

# Guard against a manual run overlapping a scheduled one.
$mutex = New-Object System.Threading.Mutex($false, 'Local\NvimWarmup')
if (-not $mutex.WaitOne(0)) {
    Write-WarmupLog 'another warm-up pass is already running - skipping'
    return
}

try {
    $nvim = Resolve-Nvim
    if (-not $nvim) {
        Write-WarmupLog 'nvim not found - skipping'
        return
    }

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    # Pass the script path via the environment so paths containing spaces survive
    # Vim's command-line parsing.
    $env:NVIM_WARMUP_LUA = $warmupLua
    # Marker so the config can cheaply detect a warm-up session if it ever needs to.
    $env:NVIM_WARMUP = '1'

    $proc = Start-Process -FilePath $nvim -ArgumentList @(
        '--headless'
        '-c', 'lua dofile(vim.env.NVIM_WARMUP_LUA)'
        '-c', 'qa!'
    ) -WindowStyle Hidden -PassThru

    # Stay out of the way of interactive work.
    try { $proc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal } catch { }

    if (-not $proc.WaitForExit(300000)) {
        try { $proc.Kill() } catch { }
        Write-WarmupLog 'warm-up timed out after 300s - killed'
        return
    }

    $stopwatch.Stop()
    Write-WarmupLog ('warm-up completed in {0} ms' -f [math]::Round($stopwatch.Elapsed.TotalMilliseconds))
} finally {
    try { $mutex.ReleaseMutex() } catch { }
    $mutex.Dispose()
}
