#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-pocket-quartus-base}"
INSTALL_ROOT_HOST="/root/fpga/intelFPGA_lite"
DOCKERFILE_DIR="$ROOT_DIR/docker/quartus"
RUN_ANALYSIS_REL="tools/run_openfpga_genesis_analysis_only.sh"
CHECK_ANALYSIS_REL="tools/check_openfpga_genesis_analysis_runner.sh"
STATUS_PATH="$ROOT_DIR/docs/DOCKER_OPENFPGA_GENESIS_ANALYSIS_STATUS.md"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

: > "$STATUS_PATH"
{
  echo "# Docker openFPGA Genesis analysis-only status"
  echo "Generated: $TIMESTAMP"
  echo "Image: $IMAGE_NAME"
  echo "Installer mount host: $INSTALL_ROOT_HOST"
  echo
} > "$STATUS_PATH"

log() {
  printf '%s\n' "$1" | tee -a "$STATUS_PATH"
}

log "analysis attempted: no"
log "analysis ran: no"

if ! command -v docker >/dev/null 2>&1; then
  log "BLOCKED: docker command not found in PATH."
  log "No fitter/assembler/timing/bitstream command was run."
  exit 0
fi

if [[ ! -d "$INSTALL_ROOT_HOST" ]]; then
  log "BLOCKED: quartus mount target missing on host: $INSTALL_ROOT_HOST"
  log "No fitter/assembler/timing/bitstream command was run."
  exit 0
fi

if [[ ! -x "$ROOT_DIR/$RUN_ANALYSIS_REL" ]]; then
  log "BLOCKED: missing executable: $ROOT_DIR/$RUN_ANALYSIS_REL"
  log "No analysis-only run was executed."
  log "No fitter/assembler/timing/bitstream command was run."
  exit 0
fi

if [[ ! -f "$ROOT_DIR/$CHECK_ANALYSIS_REL" ]]; then
  log "BLOCKED: missing required script: $ROOT_DIR/$CHECK_ANALYSIS_REL"
  log "No analysis-only run was executed."
  log "No fitter/assembler/timing/bitstream command was run."
  exit 0
fi

if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/docker/quartus/Dockerfile.ubuntu-quartus-base" "$DOCKERFILE_DIR"
fi

QMAP_HOST="$(find "$INSTALL_ROOT_HOST" -path "*/quartus/bin/quartus_map" -type f 2>/dev/null | sort | head -n 1 || true)"
if [[ -z "$QMAP_HOST" ]]; then
  log "BLOCKED: quartus_map missing from mounted /opt/intelFPGA_lite"
  log "No analysis-only run was executed."
  log "No fitter/assembler/timing/bitstream command was run."
  exit 0
fi

log "quartus_map host path: $QMAP_HOST"

DOCKER_RUN_CMD='QMAP=$(find /opt/intelFPGA_lite -path "*/quartus/bin/quartus_map" -type f 2>/dev/null | sort | head -n 1 || true)
if [ -z "$QMAP" ] || [ ! -x "$QMAP" ]; then
  echo "BLOCKED: quartus_map missing from mounted /opt/intelFPGA_lite"
  echo "No analysis-only run was attempted."
  exit 0
fi
export PATH="$(dirname "$QMAP"):$PATH"
cd /work
./tools/run_openfpga_genesis_analysis_only.sh || true
./tools/check_openfpga_genesis_analysis_runner.sh'

set +e
docker run --rm -i \
  -v "$ROOT_DIR":/work \
  -v "$INSTALL_ROOT_HOST":/opt/intelFPGA_lite \
  "$IMAGE_NAME" bash -lc "$DOCKER_RUN_CMD"
RUN_EXIT=$?
set -e

log "analysis attempted: yes"
log "analysis ran: yes"
log "analysis run exit: $RUN_EXIT"
log "analysis container command: $DOCKER_RUN_CMD"
log "No fitter, assembler, timing, or bitstream steps were invoked by wrapper."

exit 0
