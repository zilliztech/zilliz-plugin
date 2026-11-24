# ----------------------------------------------------------------------
#  Zilliz CLI Local Plugin Installer (Windows PowerShell)
#
#  Bundled with zilliz-plugin so AI coding agents can install or upgrade
#  zilliz-cli without remote pipe-to-shell execution or registry mutation.
#
#  Note: Windows ARM64 runs the x86_64 standalone build via Windows x64 emulation.
#
#  Usage:
#    powershell -ExecutionPolicy Bypass -File .\install-cli.ps1
#
#  Options (via environment variables):
#    $env:ZILLIZ_VERSION = "v2.0.1"          Install a specific version (default: latest)
#    $env:ZILLIZ_INSTALL_DIR = "C:\mypath"   Override install directory
#    $env:ZILLIZ_RELEASE_BASE_URL            Override release asset base URL (requires ZILLIZ_VERSION)
#    $env:ZILLIZ_SKIP_CHECKSUM = "1"         Skip SHA-256 verification (legacy pre-2.0 releases only)
# ----------------------------------------------------------------------

$ErrorActionPreference = "Stop"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
} catch {}

$BinName           = "zilliz"
$Repo              = "zilliztech/zilliz-cli"
$DefaultInstallDir = Join-Path $env:LOCALAPPDATA "Programs\Zilliz"
$InstallDir        = if ($env:ZILLIZ_INSTALL_DIR) { $env:ZILLIZ_INSTALL_DIR } else { $DefaultInstallDir }
$RequestedVersion  = if ($env:ZILLIZ_VERSION) { $env:ZILLIZ_VERSION } else { "latest" }

function Write-Info { param($Msg) Write-Host "==> $Msg" }
function Write-Warn { param($Msg) Write-Warning $Msg }
function Write-Err  { param($Msg) Write-Error $Msg; exit 1 }

function Resolve-LatestTag {
    $resolved = $null
    try {
        $req = [System.Net.HttpWebRequest]::Create("https://github.com/$Repo/releases/latest")
        $req.Method = "HEAD"
        $req.AllowAutoRedirect = $false
        $req.UserAgent = "zilliz-plugin-installer"
        $resp = $req.GetResponse()
        $loc = $resp.Headers["Location"]
        $resp.Close()
        if ($loc -and ($loc -match '/releases/tag/([^/?#]+)')) {
            $resolved = $Matches[1]
        }
    } catch {
        if ($_.Exception.Response) {
            $loc = $_.Exception.Response.Headers["Location"]
            if ($loc -and ($loc -match '/releases/tag/([^/?#]+)')) {
                $resolved = $Matches[1]
            }
        }
    }

    if (-not $resolved) {
        try {
            $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -Headers @{ "User-Agent" = "zilliz-plugin-installer" }
            $resolved = $release.tag_name
        } catch {}
    }

    if (-not $resolved) {
        Write-Err "Failed to resolve latest version from GitHub Releases. Set `$env:ZILLIZ_VERSION = 'v2.0.1' explicitly to bypass version lookup."
    }
    return $resolved
}

function Install-StagedBundle {
    param([string]$ExtractDir, [string]$TargetDir)

    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    $suffix = "$PID-$([guid]::NewGuid().ToString('N').Substring(0, 6))"

    $newInternal = Join-Path $ExtractDir "_internal"
    $destInternal = Join-Path $TargetDir "_internal"
    $stagingInternal = Join-Path $TargetDir "_internal.new-$suffix"
    $oldInternalBackup = Join-Path $TargetDir "_internal.old-$suffix"

    if (Test-Path -LiteralPath $newInternal) {
        Copy-Item -LiteralPath $newInternal -Destination $stagingInternal -Recurse -Force
    }

    if (Test-Path -LiteralPath $destInternal) {
        Move-Item -LiteralPath $destInternal -Destination $oldInternalBackup -Force
    }
    if (Test-Path -LiteralPath $stagingInternal) {
        Move-Item -LiteralPath $stagingInternal -Destination $destInternal -Force
    }

    foreach ($exeName in @("${BinName}.exe", "zz.exe")) {
        $srcExe = Join-Path $ExtractDir $exeName
        if (-not (Test-Path -LiteralPath $srcExe)) {
            $srcExe = Join-Path $ExtractDir "${BinName}.exe"
        }
        $dstExe = Join-Path $TargetDir $exeName
        $bakExe = Join-Path $TargetDir "${exeName}.old-$suffix"
        if (Test-Path -LiteralPath $dstExe) {
            try {
                Remove-Item -LiteralPath $dstExe -Force -ErrorAction Stop
            } catch {
                Move-Item -LiteralPath $dstExe -Destination $bakExe -Force
            }
        }
        Copy-Item -LiteralPath $srcExe -Destination $dstExe -Force
        if (Test-Path -LiteralPath $bakExe) {
            Remove-Item -LiteralPath $bakExe -Force -ErrorAction SilentlyContinue
        }
    }

    if (Test-Path -LiteralPath $oldInternalBackup) {
        Remove-Item -LiteralPath $oldInternalBackup -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Main {
    if (-not $InstallDir -or $InstallDir -eq "\" -or $InstallDir -eq $HOME) {
        Write-Err "Unsafe ZILLIZ_INSTALL_DIR path: '$InstallDir'."
    }

    $rawArch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
    $arch = switch ($rawArch) {
        "AMD64" { "x86_64" }
        "ARM64" { "x86_64" }
        default { Write-Err "Unsupported architecture: $rawArch" }
    }

    $tag = $RequestedVersion
    if ($tag -eq "latest") {
        if ($env:ZILLIZ_RELEASE_BASE_URL) {
            Write-Err "ZILLIZ_VERSION must be set explicitly when ZILLIZ_RELEASE_BASE_URL is used."
        }
        Write-Info "Resolving latest Zilliz CLI release..."
        $tag = Resolve-LatestTag
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
        Install-StagedBundle -ExtractDir $extractDir -TargetDir $InstallDir

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
