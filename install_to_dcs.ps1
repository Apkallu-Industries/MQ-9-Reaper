# Install MQ-9 Reaper Mod to DCS Saved Games (Release & OpenBeta)
$source = $PSScriptRoot

$possibleDCSPaths = @(
    "$HOME\Saved Games\DCS",
    "$HOME\Saved Games\DCS.openbeta"
)

$installedCount = 0

foreach ($dcsRoot in $possibleDCSPaths) {
    if (Test-Path $dcsRoot) {
        $destParent = Join-Path $dcsRoot "Mods\aircraft"
        $target = Join-Path $destParent "MQ-9 Reaper"

        if (-not (Test-Path $destParent)) {
            New-Item -ItemType Directory -Path $destParent -Force | Out-Null
        }

        if (-not (Test-Path $target)) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }

        robocopy $source $target /E /XD "MQ-9 Reaper" /R:1 /W:1 /NP /NDL /NJH /NJS | Out-Null
        Write-Host "Successfully deployed MQ-9 Reaper mod to: $target"

        # Also deploy mission files directly to user's DCS Missions folder for convenient access
        $sourceMissions = Join-Path $source "Missions\Single"
        $destMissions = Join-Path $dcsRoot "Missions"
        if (Test-Path $sourceMissions) {
            if (-not (Test-Path $destMissions)) {
                New-Item -ItemType Directory -Path $destMissions -Force | Out-Null
            }
            robocopy $sourceMissions $destMissions "*.miz" /R:1 /W:1 /NP /NDL /NJH /NJS | Out-Null
            Write-Host "Successfully deployed MQ-9 combat missions to: $destMissions"
        }

        $installedCount++
    }
}

if ($installedCount -eq 0) {
    # Default to standard DCS if neither directory existed yet
    $defaultDest = "$HOME\Saved Games\DCS\Mods\aircraft\MQ-9 Reaper"
    New-Item -ItemType Directory -Path (Split-Path $defaultDest) -Force | Out-Null
    Copy-Item -Path $source -Destination $defaultDest -Recurse -Force
    Write-Host "Successfully deployed MQ-9 Reaper mod to: $defaultDest"
}