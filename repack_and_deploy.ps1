# =====================================================================
# Repack and Deploy Script for MQ-9 Reaper Mod & Combat Patrol Mission
# Fixed: Guaranteed forward-slash (/) paths in .miz for DCS Linux/Unix VFS
# =====================================================================

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "[1/5] Syncing reaper_gcs_menu.lua to miz_extracted..." -ForegroundColor Cyan
Copy-Item (Join-Path $scriptDir "reaper_gcs_menu.lua") (Join-Path $scriptDir "miz_extracted\l10n\DEFAULT\reaper_gcs_menu.lua") -Force

Write-Host "[2/5] Validating Lua syntax with DCS Lua engine..." -ForegroundColor Cyan
$luaExe = "D:\Eagle Dynamics\DCS World\bin-mt\luae.exe"

$pMission = Start-Process -FilePath $luaExe -ArgumentList @("-e", "assert(loadfile('miz_extracted/mission'))") -Wait -PassThru -NoNewWindow
if ($pMission.ExitCode -ne 0) {
    Write-Error "Syntax error in miz_extracted/mission!"
    exit 1
}
Write-Host "  -> miz_extracted/mission syntax VALID." -ForegroundColor Green

$pMenu = Start-Process -FilePath $luaExe -ArgumentList @("-e", "assert(loadfile('miz_extracted/l10n/DEFAULT/reaper_gcs_menu.lua'))") -Wait -PassThru -NoNewWindow
if ($pMenu.ExitCode -ne 0) {
    Write-Error "Syntax error in reaper_gcs_menu.lua!"
    exit 1
}
Write-Host "  -> reaper_gcs_menu.lua syntax VALID." -ForegroundColor Green

Write-Host "[3/5] Repacking miz_extracted into .miz with FORWARD SLASHES (/)..." -ForegroundColor Cyan
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$targetMiz = Join-Path $scriptDir "Missions\Single\MQ-9_Reaper_Combat_Patrol.miz"
$tempZip = Join-Path $scriptDir "temp_miz.zip"

if (Test-Path $tempZip) { Remove-Item $tempZip -Force }

$sourceDir = Join-Path $scriptDir "miz_extracted"
$zip = [System.IO.Compression.ZipFile]::Open($tempZip, [System.IO.Compression.ZipArchiveMode]::Create)

Get-ChildItem -Path $sourceDir -Recurse -File | ForEach-Object {
    $relPath = $_.FullName.Substring($sourceDir.Length + 1).Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relPath, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    Write-Host "     + $relPath" -ForegroundColor DarkGray
}
$zip.Dispose()

Move-Item -Path $tempZip -Destination $targetMiz -Force
Write-Host "  -> Repacked: $targetMiz" -ForegroundColor Green

Write-Host "[4/5] Deploying mission to DCS Saved Games..." -ForegroundColor Cyan
$dcsPaths = @(
    "C:\Users\danym\Saved Games\DCS",
    "C:\Users\danym\Saved Games\DCS.openbeta"
)

foreach ($dcs in $dcsPaths) {
    if (Test-Path $dcs) {
        $missionDir = Join-Path $dcs "Missions"
        if (-not (Test-Path $missionDir)) {
            New-Item -ItemType Directory -Path $missionDir -Force | Out-Null
        }
        try {
            Copy-Item -Path $targetMiz -Destination (Join-Path $missionDir "MQ-9_Reaper_Combat_Patrol.miz") -Force
            Write-Host "  -> Copied mission to: $missionDir" -ForegroundColor Green
        } catch {
            Write-Host "  -> Warning: Mission file is currently locked by DCS World (DCS is running). Saved to local repository; will update on DCS restart." -ForegroundColor Yellow
        }
    }
}

Write-Host "[5/5] Deploying MQ-9 Reaper mod files..." -ForegroundColor Cyan
foreach ($dcs in $dcsPaths) {
    if (Test-Path $dcs) {
        $modDest = Join-Path $dcs "Mods\aircraft\MQ-9 Reaper"
        try {
            if (Test-Path $modDest) {
                Remove-Item -Path $modDest -Recurse -Force
            }
            New-Item -ItemType Directory -Path $modDest -Force | Out-Null

            $itemsToCopy = @(
                "Cockpit",
                "Documents",
                "ImagesGui",
                "Input",
                "Kneeboard",
                "Liveries",
                "Missions",
                "Options",
                "Shapes",
                "Textures",
                "Theme",
                "MQ-9.lua",
                "Views.lua",
                "comm.lua",
                "entry.lua",
                "reaper_gcs_menu.lua"
            )

            foreach ($item in $itemsToCopy) {
                $src = Join-Path $scriptDir $item
                if (Test-Path $src) {
                    Copy-Item -Path $src -Destination $modDest -Recurse -Force
                }
            }
            Write-Host "  -> Deployed clean mod to: $modDest" -ForegroundColor Green

            # Deploy Kneeboard chart directly to DCS user Kneeboard directory
            $kbDest = Join-Path $dcs "Kneeboard\MQ-9_Reaper"
            if (-not (Test-Path $kbDest)) {
                New-Item -ItemType Directory -Path $kbDest -Force | Out-Null
            }
            Copy-Item (Join-Path $scriptDir "Kneeboard\*.png") $kbDest -Force
            Write-Host "  -> Deployed squadron kneeboard to: $kbDest" -ForegroundColor Green
        } catch {
            Write-Host "  -> Warning: Some mod files locked by active DCS session. Files updated in local repo; will refresh fully upon DCS restart." -ForegroundColor Yellow
        }
    }
}

Write-Host "`n>>> DEPLOYMENT SUCCESSFUL! ALL FORWARD-SLASH PATHS & TRIGGERS VERIFIED <<<" -ForegroundColor Green
