#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$ROOT_DIR/docs/POCKET_SD_STAGING_CHECK_REPORT.md"
SOURCE_ROOT="$ROOT_DIR/openfpga/FPGA_Pocket_SegaCD"
POCKET_SD_ROOT="${POCKET_SD_ROOT:-}"

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

to_rel() {
  local input_path="$1"
  if [[ "$input_path" == "$ROOT_DIR"* ]]; then
    input_path="${input_path#$ROOT_DIR}"
  fi
  if [[ "$input_path" == /* ]]; then
    input_path=".$input_path"
  fi
  echo "$input_path"
}

header() {
  : > "$REPORT_FILE"
  {
    echo "# Pocket SD staging report"
    echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    echo "Tool: tools/check_pocket_sd_staging.sh"
    echo ""
  } >> "$REPORT_FILE"
}

check_presence() {
  local path="$1"
  local label="$2"
  if [ -e "$path" ]; then
    log "PASS: $label exists -> $(to_rel "$path")"
  else
    log "WARN: $label missing -> $(to_rel "$path")"
  fi
}

has_match() {
  local root="$1"
  local expr="$2"
  if [ -n "$(find "$root" -type f \( $expr \) 2>/dev/null | head -n 1)" ]; then
    return 0
  fi
  return 1
}

check_forbidden_payloads() {
  local root="$1"
  local label="$2"
  local expr="$3"
  if has_match "$root" "$expr"; then
    log "WARN: forbidden payloads found in $label ($(to_rel "$root"))"
    find "$root" -type f \( $expr \) | sed 's#^#  - #' >> "$REPORT_FILE"
  else
    log "PASS: no forbidden payloads found in $label ($(to_rel "$root"))"
  fi
}

check_forbidden_md_without_exemptions() {
  local root="$1"
  local label="$2"
  if ! [ -d "$root" ]; then
    log "WARN: $label root missing, skipping."
    return
  fi
  local matches=0
  while IFS= read -r md_file; do
    [ -z "$md_file" ] && continue
  matches=$((matches + 1))
    if [ "$matches" -eq 1 ]; then
      log "WARN: non-exempt .md files found in $label:"
    fi
    log "  - $(to_rel "$md_file")"
  done < <(find "$root" -type f -iname '*.md' \
    ! -name 'README.md' \
    ! -path "$root/docs/*" \
    ! -path "$root/apf/*" \
    ! -path "$root/quartus/*" \
    ! -path "$root/build/*" \
    | head -n 20)

  if [ "$matches" -eq 0 ]; then
    log "PASS: .md payload policy check complete for $label (only expected metadata files present)."
  else
    log "WARN: payload-like .md files found in $label. Confirm none are ROM/BIOS payloads."
  fi
}

check_forbidden_feature_names() {
  local root="$1"
  local label="$2"
  if ! [ -d "$root" ]; then
    log "WARN: $label does not exist."
    return
  fi

  local forbidden_found=0
  while IFS= read -r path; do
    [ -z "$path" ] && continue
    local basename
    basename="$(basename "$path")"
    case "$basename" in
      SegaCD|MegaCD|32X|32x|segaCD|megacd|Megacd)
        if [ "$path" != "$root" ]; then
        log "  - $(to_rel "$path")"
          forbidden_found=1
        fi
        ;;
      *)
        :
        ;;
    esac
  done < <(find "$root" -type d -o -type f)

  if [ "$forbidden_found" -ne 0 ]; then
    log "WARN: $label still contains Sega-CD / Mega-CD / 32X-named paths or files."
    find "$root" -type d -o -type f | {
      while IFS= read -r path; do
        [ -z "$path" ] && continue
        local basename
        basename="$(basename "$path")"
        case "$basename" in
          SegaCD|MegaCD|32X|32x|segaCD|megacd|Megacd)
            if [ "$path" != "$root" ]; then
              echo "  - $(to_rel "$path")"
            fi
            ;;
          *)
            :
            ;;
        esac
      done
    } >> "$REPORT_FILE"
  else
    log "PASS: no Sega-CD / Mega-CD / 32X-named paths found in $label."
  fi
}

header

if [ -d "$SOURCE_ROOT" ]; then
  log "Repository skeleton check:"
  check_presence "$SOURCE_ROOT" "openfpga package root"
  check_presence "$SOURCE_ROOT/README.md" "package README"
  check_presence "$SOURCE_ROOT/apf/README.md" "apf package README"
  check_presence "$SOURCE_ROOT/quartus/README.md" "quartus package README"
  check_presence "$SOURCE_ROOT/build/README.md" "build package README"
  check_presence "$SOURCE_ROOT/docs/README.md" "docs package README"
  check_presence "$ROOT_DIR/docs/POCKET_FILE_LAYOUT_GENESIS_ONLY.md" "layout doc"
  check_presence "$ROOT_DIR/docs/TASK6Q_OPENFPGA_PACKAGE_SKELETON.md" "6Q package task doc"
  check_forbidden_payloads "$SOURCE_ROOT" "skeleton source" "-iname '*.sof' -o -iname '*.pof' -o -iname '*.jic' -o -iname '*.rpd' -o -iname '*.rbf' -o -iname '*.rbf_r'"
  check_forbidden_payloads "$SOURCE_ROOT" "skeleton ROM/BIOS/CD payload candidates" "-iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' -o -iname '*bios*'"
else
  log "WARN: source skeleton missing: $(to_rel "$SOURCE_ROOT")"
fi

if [ "$POCKET_SD_ROOT" != "" ]; then
  log ""
  log "Pocket SD check for POCKET_SD_ROOT=$POCKET_SD_ROOT"
  if [ ! -d "$POCKET_SD_ROOT" ]; then
    log "WARN: POCKET_SD_ROOT missing or not a directory."
  else
    SD_ROOT="$POCKET_SD_ROOT/openfpga/FPGA_Pocket_SegaCD"
    if [ -d "$SD_ROOT" ]; then
      log "PASS: staged package directory exists"
      check_forbidden_payloads "$SD_ROOT" "staged package" "-iname '*.sof' -o -iname '*.pof' -o -iname '*.jic' -o -iname '*.rpd' -o -iname '*.rbf' -o -iname '*.rbf_r'"
      check_forbidden_payloads "$SD_ROOT" "staged ROM/BIOS/CD payloads" "-iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' -o -iname '*bios*'"
      check_forbidden_md_without_exemptions "$SD_ROOT" "staged package metadata payload policy"
      check_forbidden_feature_names "$SD_ROOT" "staged package"
    else
      log "WARN: expected staged package directory missing: $(to_rel "$SD_ROOT")"
    fi
  fi
else
  log "INFO: POCKET_SD_ROOT is unset; skipping on-host staged layout checks."
fi

check_forbidden_feature_names "$SOURCE_ROOT" "Genesis-only package root"

log ""
log "Check completed. Advisory exit code is always 0."
exit 0
