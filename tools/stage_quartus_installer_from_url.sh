#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_PATH="$ROOT_DIR/docs/QUARTUS_INSTALLER_STAGING_STATUS.md"
DEST_DIR="/root/fpga/installers"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

log() {
  printf '%s\n' "$1" | tee -a "$STATUS_PATH"
}

write_status_template() {
  local result="$1"
  local detail="$2"
  : > "$STATUS_PATH"
  {
    echo "# Quartus installer staging status"
    echo "Generated: $TIMESTAMP"
    echo "Destination: $DEST_DIR"
    printf 'Result: %s\n' "$result"
    if [[ -n "$detail" ]]; then
      echo "$detail"
    fi
    echo
  } > "$STATUS_PATH"
}

if [[ ! -d "$DEST_DIR" ]]; then
  mkdir -p "$DEST_DIR"
fi

if [[ -z "${QUARTUS_INSTALLER_URL:-}" ]]; then
  write_status_template "BLOCKED" "Reason: QUARTUS_INSTALLER_URL is required."
  log "No staging performed."
  log "BLOCKED: QUARTUS_INSTALLER_URL env var is empty or missing."
  exit 0
fi

URL="$QUARTUS_INSTALLER_URL"
NAME="${QUARTUS_INSTALLER_NAME:-}"
EXPECTED_SHA256="${QUARTUS_INSTALLER_SHA256:-}"

if [[ "$URL" =~ ^[a-zA-Z][a-zA-Z0-9+.-]*://([^/]+)/.*$ ]]; then
  URL_HOST="${BASH_REMATCH[1]}"
else
  URL_HOST="URL host not parseable"
fi

DERIVED_NAME=""
if [[ -n "$NAME" ]]; then
  DERIVED_NAME="$(basename "$NAME")"
elif [[ "$URL" == *"?"* ]]; then
  URL_PATH="${URL%%\?*}"
  DERIVED_NAME="$(printf '%s' "${URL_PATH##*/}")"
else
  DERIVED_NAME="$(printf '%s' "${URL##*/}")"
fi

if [[ -z "$DERIVED_NAME" || "$DERIVED_NAME" == *"/"* || "$DERIVED_NAME" == *"?"* ]]; then
  DERIVED_NAME="quartus_installer_downloaded.run"
fi

DEST_FILE="$DEST_DIR/$DERIVED_NAME"

write_status_template "IN_PROGRESS" "Staging source host: $URL_HOST"
log "Attempting staged download from host: $URL_HOST"
log "Destination path: $DEST_FILE"

if command -v curl >/dev/null 2>&1; then
  DL_CMD="curl"
  DOWNLOAD_OK=0
  set +e
  curl -L --fail --retry 3 --retry-delay 5 -o "$DEST_FILE" "$URL"
  DOWNLOAD_OK=$?
  set -e
elif command -v wget >/dev/null 2>&1; then
  DL_CMD="wget"
  DOWNLOAD_OK=0
  set +e
  wget --tries=3 --waitretry=5 -O "$DEST_FILE" "$URL"
  DOWNLOAD_OK=$?
  set -e
else
  write_status_template "BLOCKED" "No curl/wget available in runtime environment."
  log "BLOCKED: neither curl nor wget available."
  exit 0
fi

if [[ "$DOWNLOAD_OK" -ne 1 ]]; then
  write_status_template "BLOCKED" "download failed using ${DL_CMD}."
  log "BLOCKED: download failed."
  rm -f "$DEST_FILE"
  exit 0
fi

if [[ "${DEST_FILE##*.}" == "run" || "${DEST_FILE##*.}" == "sh" ]]; then
  chmod +x "$DEST_FILE"
fi

if command -v file >/dev/null 2>&1; then
  FILE_TYPE="$(file -b "$DEST_FILE")"
else
  FILE_TYPE="file utility unavailable"
fi

SIZE_BYTES="$(wc -c < "$DEST_FILE")"

if [[ -n "$EXPECTED_SHA256" ]]; then
  if ! command -v sha256sum >/dev/null 2>&1; then
    write_status_template "BLOCKED" "sha256 verification requested but sha256sum unavailable."
    log "BLOCKED: sha256sum missing for integrity check."
    rm -f "$DEST_FILE"
    exit 0
  fi

  ACTUAL_SHA256="$(sha256sum "$DEST_FILE" | awk '{print $1}')"
  if [[ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]]; then
    write_status_template "BLOCKED" "sha256 mismatch."
    log "BLOCKED: SHA-256 mismatch. expected=$EXPECTED_SHA256 actual=$ACTUAL_SHA256"
    rm -f "$DEST_FILE"
    exit 0
  fi
fi

: > "$STATUS_PATH"
{
  echo "# Quartus installer staging status"
  echo "Generated: $TIMESTAMP"
  echo "Result: OK"
  echo "Destination: $DEST_FILE"
  echo "URL provided: host=$URL_HOST (url redacted)"
  echo "Executable: download staged and permission-normalized if needed"
  echo "File size (bytes): $SIZE_BYTES"
  if [[ -n "${FILE_TYPE}" ]]; then
    echo "File type: $FILE_TYPE"
  fi
  if [[ -n "$EXPECTED_SHA256" ]]; then
    echo "SHA-256: $EXPECTED_SHA256"
  fi
  echo "chmod +x: applied when extension is .run or .sh"
  echo "Note: this script does not bypass authentication and does not commit installer files."
} >> "$STATUS_PATH"

log "Download and staging complete"
log "Destination: $DEST_FILE"
if [[ -n "$EXPECTED_SHA256" ]]; then
  log "SHA-256: $EXPECTED_SHA256"
fi

exit 0
