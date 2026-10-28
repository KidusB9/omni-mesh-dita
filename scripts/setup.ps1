<#
.SYNOPSIS
  Downloads the pinned DITA Open Toolkit release, verifies its checksum, and
  installs this repository's publishing plugins into it.

.DESCRIPTION
  DITA-OT is unpacked to .tools/dita-ot-<version> (git-ignored). The plugins in
  plugins/ are copied into the toolkit's plugins folder and integrated with
  `dita install`, so re-running this script after editing a plugin picks up the
  change. Requires Java 17 or later on PATH (DITA-OT 4.x requirement).

.EXAMPLE
  .\scripts\setup.ps1
  .\scripts\setup.ps1 -Force      # re-download and re-unpack the toolkit
#>
[CmdletBinding()]
param(
  [string]$Version = '4.4.1',
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# SHA-256 of the official release zip from github.com/dita-ot/dita-ot/releases.
$PinnedSha256 = @{
  '4.4.1' = '154414c1debb548e923bf77e9a09019e249a8887680ff4bfbd8e137de9e8e250'
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$ToolsDir = Join-Path $RepoRoot '.tools'
$DitaHome = Join-Path $ToolsDir "dita-ot-$Version"
$Zip      = Join-Path $ToolsDir "dita-ot-$Version.zip"
$Url      = "https://github.com/dita-ot/dita-ot/releases/download/$Version/dita-ot-$Version.zip"

function Assert-Java {
  $java = Get-Command java -ErrorAction SilentlyContinue
  if (-not $java) { throw 'Java 17+ is required on PATH. Install a JDK (for example Temurin 17) and re-run.' }
  # java -version prints to stderr; Windows PowerShell 5.1 would turn that into
  # a terminating error under 'Stop', so relax the preference for this call.
  $saved = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  $line = & java -version 2>&1 | Select-Object -First 1 | ForEach-Object { "$_" }
  $ErrorActionPreference = $saved
  if ($line -match '"(\d+)') {
    if ([int]$Matches[1] -lt 17) { throw "Java 17+ is required; found: $line" }
  }
  Write-Host "Java   : $line"
}

Assert-Java
New-Item -ItemType Directory -Force -Path $ToolsDir | Out-Null

if ($Force -and (Test-Path $DitaHome)) { Remove-Item -Recurse -Force $DitaHome }

if (-not (Test-Path (Join-Path $DitaHome 'bin\dita.bat'))) {
  if (-not (Test-Path $Zip)) {
    Write-Host "Download: $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Zip -UseBasicParsing
  }
  $actual = (Get-FileHash -Algorithm SHA256 -Path $Zip).Hash.ToLowerInvariant()
  $expected = $PinnedSha256[$Version]
  if ($expected -and $expected -ne '__PIN_ME__' -and $actual -ne $expected) {
    Remove-Item -Force $Zip
    throw "Checksum mismatch for $Zip`n expected $expected`n actual   $actual"
  }
  Write-Host "SHA-256: $actual"
  Write-Host "Unpack : $DitaHome"
  Expand-Archive -Path $Zip -DestinationPath $ToolsDir -Force
}

# Copy each plugin into the toolkit, replacing any earlier copy, then integrate.
$pluginsSrc = Join-Path $RepoRoot 'plugins'
foreach ($plugin in Get-ChildItem -Directory $pluginsSrc) {
  $dest = Join-Path $DitaHome "plugins\$($plugin.Name)"
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item -Recurse -Path $plugin.FullName -Destination $dest
  Write-Host "Plugin : $($plugin.Name)"
}

$dita = Join-Path $DitaHome 'bin\dita.bat'
& $dita install
if ($LASTEXITCODE -ne 0) { throw "dita install failed with exit code $LASTEXITCODE" }

$transtypes = (& $dita transtypes) -join ' '
foreach ($t in 'omni-pdf', 'omni-html5') {
  if ($transtypes -notmatch "\b$t\b") { throw "Transtype '$t' is not registered after install." }
}
Write-Host "Ready  : DITA-OT $Version with transtypes omni-pdf and omni-html5"
