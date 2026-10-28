<#
.SYNOPSIS
  Validates the DITA source, then publishes the deliverables defined in
  project.xml: the HTML5 help site and the user and technical PDFs.

.DESCRIPTION
  Fails fast: validation and every publish run in strict processing mode, so a
  broken reference, missing key, or invalid element stops the build with a
  non-zero exit code. After publishing, the PDFs are copied into the help site
  (out/site/pdf) so one folder holds everything that gets deployed, and each
  expected artifact is checked before the script reports success.

.PARAMETER Deliverable
  Publish one deliverable by id: site, pdf-user, or pdf-technical. Default: all.

.PARAMETER SkipValidation
  Skip the up-front `dita validate` pass.

.EXAMPLE
  .\scripts\build.ps1
  .\scripts\build.ps1 -Deliverable pdf-user
#>
[CmdletBinding()]
param(
  [ValidateSet('all', 'site', 'pdf-user', 'pdf-technical')]
  [string]$Deliverable = 'all',
  [string]$Version = '4.4.1',
  [switch]$SkipValidation
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$DitaHome = Join-Path $RepoRoot ".tools\dita-ot-$Version"
$Dita     = if ($env:OS -eq 'Windows_NT') { Join-Path $DitaHome 'bin\dita.bat' } else { Join-Path $DitaHome 'bin/dita' }
$Project  = Join-Path $RepoRoot 'project.xml'
$Map      = Join-Path $RepoRoot 'dita\omni-mesh-user-guide.ditamap'
$Out      = Join-Path $RepoRoot 'out'

if (-not (Test-Path $Dita)) {
  throw "DITA-OT $Version not found at $DitaHome. Run scripts\setup.ps1 (or setup.bat) first."
}

function Invoke-Dita {
  param([string[]]$Arguments)
  & $Dita @Arguments
  if ($LASTEXITCODE -ne 0) { throw "dita $($Arguments -join ' ') failed with exit code $LASTEXITCODE" }
}

$clock = [Diagnostics.Stopwatch]::StartNew()

if (-not $SkipValidation) {
  foreach ($filter in 'user', 'technical') {
    Write-Host "== Validate ($filter edition)"
    Invoke-Dita @('validate', "--input=$Map", "--filter=$(Join-Path $RepoRoot "filters\$filter.ditaval")")
  }
}

$targets = if ($Deliverable -eq 'all') { @('site', 'pdf-user', 'pdf-technical') } else { @($Deliverable) }
foreach ($target in $targets) {
  Write-Host "== Publish $target"
  Invoke-Dita @("--project=$Project", "--deliverable=$target", "--output=$Out", '--processing-mode=strict')
}

# Ship the PDFs inside the help site so a single folder is deployed.
$site = Join-Path $Out 'site'
if (Test-Path $site) {
  $sitePdf = Join-Path $site 'pdf'
  New-Item -ItemType Directory -Force -Path $sitePdf | Out-Null
  Get-ChildItem -Path (Join-Path $Out 'pdf') -Filter *.pdf -ErrorAction SilentlyContinue |
    Copy-Item -Destination $sitePdf -Force
}

# Every deliverable that was requested must have produced a non-empty file.
$expected = @{
  'site'          = 'site\index.html'
  'pdf-user'      = 'pdf\OMNI-MESH-User-Guide.pdf'
  'pdf-technical' = 'pdf\OMNI-MESH-Technical-Edition.pdf'
}
foreach ($target in $targets) {
  $file = Join-Path $Out $expected[$target]
  if (-not (Test-Path $file) -or (Get-Item $file).Length -eq 0) { throw "Expected output is missing or empty: $file" }
  Write-Host ("OK     : {0} ({1:n0} KB)" -f $expected[$target], ((Get-Item $file).Length / 1KB))
}

Write-Host ("Done in {0:n1}s" -f $clock.Elapsed.TotalSeconds)
