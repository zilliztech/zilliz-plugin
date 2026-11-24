# ----------------------------------------------------------------------
#  Zilliz CLI Local Plugin Installer (Windows PowerShell)
#
#  Bundled with zilliz-plugin so AI coding agents can install or upgrade
#  zilliz-cli without remote pipe-to-shell execution or registry mutation.
#
#  Usage:
#    powershell -ExecutionPolicy Bypass -File .\install-cli.ps1
#
#  Options (via environment variables):
#    $env:ZILLIZ_VERSION = "v2.0.0"          Install a specific version (default: latest)
#    $env:ZILLIZ_INSTALL_DIR = "C:\mypath"   Override install directory
#    $env:ZILLIZ_RELEASE_BASE_URL            Override release asset base URL (requires ZILLIZ_VERSION)
# ----------------------------------------------------------------------

$ErrorActionPreference = "Stop"

$BinName           = "zilliz"
$Repo              = "zilliztech/zilliz-cli"
$DefaultInstallDir = Join-Path $env:LOCALAPPDATA "Programs\Zilliz"
$InstallDir        = if ($env:ZILLIZ_INSTALL_DIR) { $env:ZILLIZ_INSTALL_DIR } else { $DefaultInstallDir }
$RequestedVersion  = if ($env:ZILLIZ_VERSION) { $env:ZILLIZ_VERSION } else { "latest" }

function Write-Info { param($Msg) Write-Host "==> $Msg" }
function Write-Warn { param($Msg) Write-Warning $Msg }
function Write-Err  { param($Msg) Write-Error $Msg; exit 1 }

function Main {
    if (-not $InstallDir -or $InstallDir -eq "\" -or $InstallDir -eq $HOME) {
        Write-Err "Unsafe ZILLIZ_INSTALL_DIR path: '$InstallDir'."
    }

    $arch = switch ($env:PROCESSOR_ARCHITECTURE) {
        "AMD64" { "x86_64" }
        "ARM64" { "x86_64" }
        default { Write-Err "Unsupported architecture: $env:PROCESSOR_ARCHITECTURE" }
    }

    $tag = $RequestedVersion
    if ($tag -eq "latest") {
        if ($env:ZILLIZ_RELEASE_BASE_URL) {
            Write-Err "ZILLIZ_VERSION must be set explicitly when ZILLIZ_RELEASE_BASE_URL is used."
        }
        Write-Info "Resolving latest Zilliz CLI release..."
        $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -Headers @{ "User-Agent" = "zilliz-plugin-installer" }
        $tag = $release.tag_name
        if (-not $tag) { Write-Err "Failed to resolve latest version from GitHub Releases." }
    }

    $version = $tag -replace '^zilliz-v', '' -replace '^v', ''
    if ($version -notmatch '^[0-9A-Za-z._-]+$') {
        Write-Err "Invalid version string: '$version'"
    }
    if ($tag -notmatch '^zilliz-v') {
        $tag = "zilliz-v$version"
    }

    $target = "${arch}-pc-windows-msvc"
    $archive = "${BinName}-${version}-${target}.zip"
    $baseUrl = if ($env:ZILLIZ_RELEASE_BASE_URL) {
        $u = $env:ZILLIZ_RELEASE_BASE_URL.TrimEnd("/")
        if ($u -notmatch '^(https://|file://)') {
            Write-Err "ZILLIZ_RELEASE_BASE_URL must use https:// (or file:// for local testing)."
        }
        $u
    } else {
        "https://github.com/$Repo/releases/download/$tag"
    }

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "zilliz-install-$([guid]::NewGuid())"
    $extractDir = Join-Path $tmpDir "extracted"
    New-Item -ItemType Directory -Path $extractDir -Force | Out-Null

    try {
        Write-Info "Downloading $baseUrl/$archive..."
        Invoke-WebRequest -Uri "$baseUrl/$archive" -OutFile (Join-Path $tmpDir $archive) -UseBasicParsing

        if ($env:ZILLIZ_SKIP_CHECKSUM -eq "1") {
            Write-Warn "Skipping checksum verification because ZILLIZ_SKIP_CHECKSUM=1."
        } else {
            $checksumsUrl = "$baseUrl/sha256sums.txt"
            try {
                Invoke-WebRequest -Uri $checksumsUrl -OutFile (Join-Path $tmpDir "sha256sums.txt") -UseBasicParsing
            } catch {
                Write-Err "Failed to download $checksumsUrl; refusing unverified installation."
            }

            $expectedHash = $null
            foreach ($line in (Get-Content (Join-Path $tmpDir "sha256sums.txt"))) {
                $trimmed = $line.Trim()
                if (-not $trimmed) { continue }
                $parts = $trimmed -split '\s+', 2
                if ($parts.Length -ge 2) {
                    $fname = $parts[1].Trim() -replace '^\*', ''
                    if ($fname -eq $archive) {
                        $expectedHash = $parts[0].ToLower()
                        break
                    }
                }
            }

            if (-not $expectedHash) {
                Write-Err "Archive $archive is missing from sha256sums.txt; refusing unverified installation."
            }
            if ($expectedHash -notmatch '^[0-9a-f]{64}$') {
                Write-Err "Malformed SHA-256 entry '$expectedHash' in sha256sums.txt for $archive."
            }

            $actualHash = (Get-FileHash -Path (Join-Path $tmpDir $archive) -Algorithm SHA256).Hash.ToLower()
            if ($actualHash -ne $expectedHash) {
                Write-Err "Checksum verification failed for $archive (expected $expectedHash, got $actualHash)."
            }
            Write-Info "Verified SHA-256 checksum ($actualHash)"
        }

        Expand-Archive -Path (Join-Path $tmpDir $archive) -DestinationPath $extractDir -Force
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

        $oldInternal = Join-Path $InstallDir "_internal"
        if (Test-Path $oldInternal) {
            Remove-Item -Path $oldInternal -Recurse -Force
        }

        Copy-Item -Path (Join-Path $extractDir "${BinName}.exe") -Destination (Join-Path $InstallDir "${BinName}.exe") -Force
        if (Test-Path (Join-Path $extractDir "zz.exe")) {
            Copy-Item -Path (Join-Path $extractDir "zz.exe") -Destination (Join-Path $InstallDir "zz.exe") -Force
        } else {
            Copy-Item -Path (Join-Path $InstallDir "${BinName}.exe") -Destination (Join-Path $InstallDir "zz.exe") -Force
        }

        $newInternal = Join-Path $extractDir "_internal"
        if (Test-Path $newInternal) {
            Copy-Item -Path $newInternal -Destination $oldInternal -Recurse -Force
        }

        $installedExe = Join-Path $InstallDir "${BinName}.exe"
        Write-Info "Installed $BinName $version to $installedExe"
        & $installedExe --version

        $pathEntries = ($env:PATH -split ";") | Where-Object { $_ -ne "" }
        if ($pathEntries -notcontains $InstallDir) {
            Write-Warn "$InstallDir is not on PATH. Add it to your user PATH environment variable to invoke 'zilliz' directly."
        }
    }
    finally {
        Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Main
