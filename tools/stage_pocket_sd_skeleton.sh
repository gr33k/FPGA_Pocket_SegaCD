#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_ROOT="$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD"
DEST_PARENT_DEFAULT="${POCKET_SD_ROOT:-}"
DRY_RUN="${DRY_RUN:-1}"
REPORT_FILE="$ROOT_DIR/docs/POCKET_SD_STAGING_CHECK_REPORT.md"

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

header() {
  : > "$REPORT_FILE"
  cat <<'EOF' > "$REPORT_FILE"
# Pocket SD staging report
EOF
  log "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  log "Tool: tools/stage_pocket_sd_skeleton.sh"
  log ""
}

abs_path() {
  local p="$1"
  /bin/realpath "$p"
}

safe_exit_warn() {
  log "WARN: $1"
  return 0
}

safe_exit_fail() {
  log "FAIL: $1"
  exit 1
}

collect_payload_warnings() {
  local path="$1"
  if find "$path" -type f \( -iname '*.sof' -o -iname '*.pof' -o -iname '*.jic' -o -iname '*.rpd' -o -iname '*.rbf' -o -iname '*.rbf_r' \) | grep -q .; then
    safe_exit_warn "Real bitstream artifact was found in skeleton source. No bitstream copy is expected in this stage."
  else
    log "PASS: no packaged bitstream artifacts found in source."
  fi
}

collect_actions() {
  local action_log="$1"
  log "$action_log"
}

header

if [ ! -d "$SOURCE_ROOT" ]; then
  safe_exit_fail "Missing source skeleton directory: $SOURCE_ROOT"
fi

if [ "${DRY_RUN:-1}" = "1" ] && [ "${POCKET_SD_ROOT:-}" = "" ]; then
  log "DRY-RUN MODE: POCKET_SD_ROOT not set."
  log "Expected action: stage skeleton into <PocketSD>/openfpga/FPGA_Pocket_SegaCD"
  log "No file operations performed."
  collect_payload_warnings "$SOURCE_ROOT"
  exit 0
fi

POCKET_SD_ROOT="${POCKET_SD_ROOT:-}"
if [ "$POCKET_SD_ROOT" = "" ]; then
  safe_exit_fail "POCKET_SD_ROOT is required when DRY_RUN=0."
fi

if [ ! -d "$POCKET_SD_ROOT" ]; then
  safe_exit_fail "POCKET_SD_ROOT is not a directory: $POCKET_SD_ROOT"
fi

REPO_ROOT="$(abs_path "$ROOT_DIR")"
SD_ROOT="$(abs_path "$POCKET_SD_ROOT")"

if [ "$SD_ROOT" = "$REPO_ROOT" ]; then
  safe_exit_fail "POCKET_SD_ROOT must not be the repository root: $POCKET_SD_ROOT"
fi

if [ "$SD_ROOT" = "/" ] || [ "$SD_ROOT" = "/System" ] || [ "$SD_ROOT" = "/Volumes" ]; then
  safe_exit_fail "POCKET_SD_ROOT looks like a system root path: $POCKET_SD_ROOT"
fi

TARGET_ROOT="$SD_ROOT/openfpga/FPGA_Pocket_SegaCD"
log "Mode: ${DRY_RUN:-1}"
log "Source: $SOURCE_ROOT"
log "Destination root: $TARGET_ROOT"
collect_payload_warnings "$SOURCE_ROOT"

mapfile -t COPY_FILES < <(find "$SOURCE_ROOT" -type f | sort)
if [ "${#COPY_FILES[@]}" -eq 0 ]; then
  safe_exit_fail "No source files found under $SOURCE_ROOT"
fi

if [ "${DRY_RUN:-1}" = "1" ]; then
  for src in "${COPY_FILES[@]}"; do
    rel="${src#"$SOURCE_ROOT"/}"
    collect_actions "DRY-RUN: would copy $rel -> $TARGET_ROOT/$rel"
  done
  safe_exit_warn "DRY-RUN complete. Set DRY_RUN=0 to perform copy."
  exit 0
fi

log "Performing copy operations..."
copied_count=0
skipped_count=0

for src in "${COPY_FILES[@]}"; do
  rel="${src#"$SOURCE_ROOT"/}"
  dst="$TARGET_ROOT/$rel"
  dst_dir="$(dirname "$dst")"

  case "$src" in
    *.rbf|*.rbf_r|*.sof|*.pof|*.jic|*.rpd)
      safe_exit_warn "Skipping known forbidden build artifact pattern from source copy: $rel"
      skipped_count=$((skipped_count + 1))
      continue
      ;;
  esac
  case "$(basename "$src")" in
    *.bin|*.gen|*.md|*.smd|*.iso|*.cue|*.chd)
      if [[ "$src" == *"/README.md" || "$src" == *"/openfpga/FPGA_Pocket_SegaCD/docs/"* || "$src" == *"/openfpga/FPGA_Pocket_SegaCD/README.md" ]]; then
        :
      else
        safe_exit_warn "Skipping non-skeleton payload-like extension from source copy: $rel"
        skipped_count=$((skipped_count + 1))
        continue
      fi
      ;;
  esac

  if [ -e "$dst" ]; then
    safe_exit_warn "Refusing overwrite of existing destination path: $dst"
    skipped_count=$((skipped_count + 1))
    continue
  fi

  mkdir -p "$dst_dir"
  cp -p "$src" "$dst"
  log "COPIED: $rel"
  copied_count=$((copied_count + 1))
done

if ! find "$SOURCE_ROOT" -type f | grep -qE '\.rbf$|\.rbf_r$|\.sof$|\.pof$|\.jic$|\.rpd$'; then
  log "WARN: No real bitstream file found in source. This is expected for Task 6R."
fi

log "Copy summary:"
log "Copied: $copied_count"
log "Skipped: $skipped_count"
log "POCKET_SD_ROOT check passed."
log "Task 6R staging mode complete."
exit 0
