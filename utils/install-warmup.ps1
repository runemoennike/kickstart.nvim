<#
.SYNOPSIS
    Installs (or removes) the Neovim warm-up as a scheduled task.

.DESCRIPTION
    Registers utils\nvim-warmup.ps1 with Task Scheduler so the plugin files are
    re-opened periodically, keeping them in Defender's scan cache. See
    utils\nvim-warmup.ps1 for why that is necessary.

    The task runs with an Interactive principal, i.e. inside the logged-on user's
    session. That detail matters: an S4U principal was tried first because it runs
    with no console window at all, but warming from session 0 does not help. DLP
    re-inspects the files under the interactive token, so a warm-up run as S4U
    left an interactive load still taking ~7.9s versus ~0.6s when warmed from the
    user's own session. Only same-session warming populates the right cache.

    StartWhenAvailable is set so a pass missed while the machine was asleep runs
    promptly after resume - that is the case that matters most, since an overnight
    sleep plus a signature update is exactly when the cache goes cold.

    Requires administrator rights to register the task.

.PARAMETER IntervalMinutes
    Minutes between warm-up passes. Default 20.

.PARAMETER Uninstall
    Remove the scheduled task instead of installing it.

.EXAMPLE
    pwsh -NoProfile -File utils\install-warmup.ps1
    Install with the default 20 minute interval.

.EXAMPLE
    pwsh -NoProfile -File utils\install-warmup.ps1 -Uninstall
    Remove the scheduled task.
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 1440)]
    [int] $IntervalMinutes = 20,

    [switch] $Uninstall
)

$ErrorActionPreference = 'Stop'

$taskName = 'NvimWarmup'
$warmupScript = Join-Path $PSScriptRoot 'nvim-warmup.ps1'
$startupDir = [Environment]::GetFolderPath('Startup')

function Remove-LegacyLoginItems {
    # Earlier revisions of this script used a Startup item, because Task Scheduler
    # registration was denied at the time. Clean those up if still present.
    foreach ($name in @('nvim-warmup.lnk', 'nvim-warmup.vbs')) {
        $path = Join-Path $startupDir $name
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
            Write-Host "Removed legacy login item: $path"
        }
    }

    $running = Get-CimInstance Win32_Process -Filter "Name='pwsh.exe' OR Name='powershell.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -and $_.CommandLine -match 'nvim-warmup\.ps1' -and $_.ProcessId -ne $PID }
    foreach ($proc in $running) {
        Stop-Process -Id $proc.ProcessId -Force -ErrorAction SilentlyContinue
        Write-Host "Stopped legacy warm-up loop (pid $($proc.ProcessId))"
    }
}

if ($Uninstall) {
    Remove-LegacyLoginItems

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Host "Removed scheduled task: $taskName"
    } else {
        Write-Host 'Scheduled task was not installed - nothing to do.'
    }
    return
}

if (-not (Test-Path -LiteralPath $warmupScript)) {
    throw "Missing warm-up script: $warmupScript"
}

$pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
if (-not $pwsh) {
    $pwsh = (Get-Command powershell -ErrorAction Stop).Source
}

Remove-LegacyLoginItems

$userId = '{0}\{1}' -f $env:USERDOMAIN, $env:USERNAME

$action = New-ScheduledTaskAction -Execute $pwsh `
    -Argument ('-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File "{0}"' -f $warmupScript) `
    -WorkingDirectory (Split-Path -Parent $warmupScript)

# Two triggers: one so a freshly booted session is warmed without waiting a full
# interval, and one that repeats for the rest of the time.
$atLogon = New-ScheduledTaskTrigger -AtLogOn -User $userId
$atLogon.Delay = 'PT1M'

$repeating = New-ScheduledTaskTrigger -Once -At (Get-Date).Date.AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) `
    -RepetitionDuration (New-TimeSpan -Days 3650)

# Interactive, not S4U: the warm-up only populates the cache that an interactive
# Neovide launch benefits from if it runs in the same session. See the comment
# block at the top of this file.
$principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType Interactive -RunLevel Limited

$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -MultipleInstances IgnoreNew `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10) `
    -Hidden

Register-ScheduledTask -TaskName $taskName `
    -Action $action `
    -Trigger @($atLogon, $repeating) `
    -Principal $principal `
    -Settings $settings `
    -Description 'Keeps Neovim plugin files in Defender''s scan cache so Neovide starts fast. See utils\nvim-warmup.ps1.' `
    -Force | Out-Null

Write-Host "Installed scheduled task: $taskName"
Write-Host "Interval: every $IntervalMinutes minutes, plus 1 minute after logon"
Write-Host "Log file: $(Join-Path $env:LOCALAPPDATA 'nvim-warmup.log')"
Write-Host ''
Write-Host 'Running one pass now...'

Start-ScheduledTask -TaskName $taskName
Write-Host 'Done. Verify with:  Get-Content $env:LOCALAPPDATA\nvim-warmup.log -Tail 5'
