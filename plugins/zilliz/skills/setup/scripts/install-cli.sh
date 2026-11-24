#!/usr/bin/env bash
# ----------------------------------------------------------------------
#  Zilliz CLI Local Plugin Installer (macOS / Linux)
#
#  Bundled with zilliz-plugin so AI coding agents can install or upgrade
#  zilliz-cli without remote pipe-to-shell execution or shell RC mutation.
#
#  Usage:
#    bash ./install-cli.sh
#
#  Options (via environment variables):
#    ZILLIZ_VERSION=v2.0.1       Install a specific version (default: latest)
#    ZILLIZ_INSTALL_DIR          Directory for zilliz/zz symlinks (default: ~/.local/bin)
#    ZILLIZ_HOME                 Directory for runtime bundle (default: ~/.local/share/zilliz)
#    ZILLIZ_RELEASE_BASE_URL     Override release asset base URL (requires ZILLIZ_VERSION)
#    ZILLIZ_SKIP_CHECKSUM=1      Skip SHA-256 verification (legacy pre-2.0 releases only)
# ----------------------------------------------------------------------
set -euo pipefail

BIN_NAME="zilliz"
REPO="zilliztech/zilliz-cli"
INSTALL_DIR="${ZILLIZ_INSTALL_DIR:-${HOME}/.local/bin}"
SHARE_DIR="${ZILLIZ_HOME:-${HOME}/.local/share/zilliz}"
REQUESTED_VERSION="${ZILLIZ_VERSION:-latest}"

info()  { printf '==> %s\n' "$*"; }
warn()  { printf 'Warning: %s\n' "$*" >&2; }
error() { printf 'Error: %s\n' "$*" >&2; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

validate_paths() {
    if [ -z "${SHARE_DIR}" ] || [ "${SHARE_DIR}" = "/" ] || [ "${SHARE_DIR}" = "${HOME}" ]; then
        error "Unsafe ZILLIZ_HOME path: '${SHARE_DIR}'."
    fi
    if [ -z "${INSTALL_DIR}" ] || [ "${INSTALL_DIR}" = "/" ] || [ "${INSTALL_DIR}" = "${HOME}" ]; then
        error "Unsafe ZILLIZ_INSTALL_DIR path: '${INSTALL_DIR}'."
    fi
}

detect_target_triple() {
    local os arch
    os="$(uname -s)"
    arch="$(uname -m)"

    case "${os}" in
        Linux*)  os="linux" ;;
        Darwin*) os="darwin" ;;
        *)       error "Unsupported operating system: ${os}. Use install-cli.ps1 on Windows." ;;
    esac

    case "${arch}" in
        x86_64|amd64)  arch="x86_64" ;;
        aarch64|arm64) arch="aarch64" ;;
        *)             error "Unsupported architecture: ${arch}" ;;
    esac

    case "${os}-${arch}" in
        darwin-x86_64)  printf 'x86_64-apple-darwin' ;;
        darwin-aarch64) printf 'aarch64-apple-darwin' ;;
        linux-x86_64)   printf 'x86_64-unknown-linux-gnu' ;;
        linux-aarch64)  printf 'aarch64-unknown-linux-gnu' ;;
        *)              error "No prebuilt archive for ${os}/${arch}" ;;
    esac
}

resolve_latest_tag() {
    local latest_url=""
    local resolved=""
    latest_url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${REPO}/releases/latest" 2>/dev/null || true)
    case "${latest_url}" in
        */releases/tag/*)
            resolved="${latest_url##*/releases/tag/}"
            resolved="${resolved%%\?*}"
            resolved="${resolved%%#*}"
            ;;
    esac
    if [ -z "${resolved}" ]; then
        resolved=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null \
            | grep '"tag_name"' | head -1 | cut -d'"' -f4 || true)
    fi
    [ -n "${resolved}" ] || error "Failed to resolve latest version from GitHub Releases. Set ZILLIZ_VERSION=v2.0.1 explicitly to bypass version lookup."
    printf '%s' "${resolved}"
}

verify_checksum() {
    local dir="$1"
    local archive="$2"
    local sums_file="$3"

    local expected=""
    expected=$(awk -v f="${archive}" '$2 == f || $2 == ("*" f) { print tolower($1); exit }' "${sums_file}")
    if [ -z "${expected}" ]; then
        error "Archive ${archive} is missing from sha256sums.txt; refusing unverified installation."
    fi
    if ! printf '%s' "${expected}" | grep -Eq '^[0-9a-f]{64}$'; then
        error "Malformed SHA-256 entry '${expected}' in sha256sums.txt for ${archive}."
    fi

    local actual=""
    if has shasum; then
        actual=$(shasum -a 256 "${dir}/${archive}" | awk '{print tolower($1)}')
    elif has sha256sum; then
        actual=$(sha256sum "${dir}/${archive}" | awk '{print tolower($1)}')
    else
        error "Neither 'shasum' nor 'sha256sum' is available to verify archive integrity."
    fi

    if [ "${actual}" != "${expected}" ]; then
        error "Checksum verification failed for ${archive} (expected ${expected}, got ${actual})."
    fi
    info "Verified SHA-256 checksum (${actual})"
}

main() {
    has curl || error "'curl' is required to download Zilliz CLI."
    has tar  || error "'tar' is required to extract Zilliz CLI."
    validate_paths

    local tag="${REQUESTED_VERSION}"
    if [ "${tag}" = "latest" ]; then
        if [ -n "${ZILLIZ_RELEASE_BASE_URL:-}" ]; then
            error "ZILLIZ_VERSION must be set explicitly when ZILLIZ_RELEASE_BASE_URL is used."
        fi
        info "Resolving latest Zilliz CLI release..."
        tag="$(resolve_latest_tag)"
    fi

    local version="${tag}"
    version="${version#zilliz-v}"
    version="${version#v}"
    case "${version}" in
        *[!0-9A-Za-z._-]*|"")
            error "Invalid version string: '${version}'"
            ;;
    esac
    case "${tag}" in
        zilliz-v*) ;;
        v*) tag="zilliz-${tag}" ;;
        *)  tag="zilliz-v${version}" ;;
    esac

    local target
    target="$(detect_target_triple)"
    local archive="${BIN_NAME}-${version}-${target}.tar.gz"
    local base_url="${ZILLIZ_RELEASE_BASE_URL:-https://github.com/${REPO}/releases/download/${tag}}"
    base_url="${base_url%/}"
    case "${base_url}" in
        https://*|file://*) ;;
        *) error "ZILLIZ_RELEASE_BASE_URL must use https:// (or file:// for local testing)." ;;
    esac

    TMPDIR_CLEANUP="$(mktemp -d)"
    trap 'rm -rf "${TMPDIR_CLEANUP}"' EXIT

    info "Downloading ${base_url}/${archive}..."
    curl -fsSL "${base_url}/${archive}" -o "${TMPDIR_CLEANUP}/${archive}"

    if [ "${ZILLIZ_SKIP_CHECKSUM:-0}" = "1" ]; then
        warn "Skipping checksum verification because ZILLIZ_SKIP_CHECKSUM=1."
    else
        local checksums_url="${base_url}/sha256sums.txt"
        if ! curl -fsSL "${checksums_url}" -o "${TMPDIR_CLEANUP}/sha256sums.txt" 2>/dev/null; then
            error "Failed to download ${checksums_url}; refusing unverified installation."
        fi
        verify_checksum "${TMPDIR_CLEANUP}" "${archive}" "${TMPDIR_CLEANUP}/sha256sums.txt"
    fi

    mkdir -p "${TMPDIR_CLEANUP}/extracted"
    tar -xzf "${TMPDIR_CLEANUP}/${archive}" -C "${TMPDIR_CLEANUP}/extracted"
    mkdir -p "${INSTALL_DIR}"

    if [ -d "${TMPDIR_CLEANUP}/extracted/_internal" ]; then
        mkdir -p "${SHARE_DIR}"
        local staging_internal="${SHARE_DIR}/.internal-staging-$$"
        rm -rf "${staging_internal}"
        mv "${TMPDIR_CLEANUP}/extracted/_internal" "${staging_internal}"
        install -m 755 "${TMPDIR_CLEANUP}/extracted/${BIN_NAME}" "${SHARE_DIR}/${BIN_NAME}"
        rm -f "${SHARE_DIR}/zz"
        ln -s "${BIN_NAME}" "${SHARE_DIR}/zz"
        rm -rf "${SHARE_DIR}/_internal"
        mv "${staging_internal}" "${SHARE_DIR}/_internal"

        rm -f "${INSTALL_DIR}/${BIN_NAME}" "${INSTALL_DIR}/zz"
        ln -s "${SHARE_DIR}/${BIN_NAME}" "${INSTALL_DIR}/${BIN_NAME}"
        ln -s "${SHARE_DIR}/${BIN_NAME}" "${INSTALL_DIR}/zz"
    else
        rm -rf "${SHARE_DIR}/_internal" "${SHARE_DIR}/${BIN_NAME}" "${SHARE_DIR}/zz"
        rmdir "${SHARE_DIR}" 2>/dev/null || true
        rm -f "${INSTALL_DIR}/${BIN_NAME}" "${INSTALL_DIR}/zz"
        install -m 755 "${TMPDIR_CLEANUP}/extracted/${BIN_NAME}" "${INSTALL_DIR}/${BIN_NAME}"
        ln -s "${INSTALL_DIR}/${BIN_NAME}" "${INSTALL_DIR}/zz"
    fi

    info "Installed ${BIN_NAME} ${version} to ${INSTALL_DIR}/${BIN_NAME}"
    "${INSTALL_DIR}/${BIN_NAME}" --version

    if ! printf '%s' "${PATH}" | tr ':' '\n' | grep -qx "${INSTALL_DIR}"; then
        warn "${INSTALL_DIR} is not on PATH in this shell. Add it with: export PATH=\"${INSTALL_DIR}:\$PATH\""
    fi
}

main "$@"
