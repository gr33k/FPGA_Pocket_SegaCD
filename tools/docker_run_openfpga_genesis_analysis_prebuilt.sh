#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_PATH="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_ANALYSIS_STATUS.md"
RUNNER_SCRIPT="$ROOT_DIR/tools/run_openfpga_genesis_analysis_only.sh"
CHECK_SCRIPT="$ROOT_DIR/tools/check_openfpga_genesis_analysis_runner.sh"
IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
FALLBACK_IMAGE="${QUARTUS_PREBUILT_IMAGE_FALLBACK:-no2chem/quartuslite:latest}"
TIMESTAMP="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"

log() {
  printf "%s\n" "$1" | tee -a "$STATUS_PATH"
}

: > "$STATUS_PATH"
{
  echo "# Prebuilt Quartus Docker analysis status"
  echo "Generated: $TIMESTAMP"
  echo "Image: $IMAGE"
  echo "Fallback image: $FALLBACK_IMAGE"
  echo
} > "$STATUS_PATH"

log "docker pull attempted: no"
log "docker run attempted: no"
log "analysis attempted: no"
log "analysis ran: no"
log "analysis result: not run"

if ! command -v docker >/dev/null 2>&1; then
  log "BLOCKED: docker command not found in PATH."
  exit 0
fi

if [[ ! -x "$RUNNER_SCRIPT" ]]; then
  log "BLOCKED: runner missing or not executable: tools/run_openfpga_genesis_analysis_only.sh"
  exit 0
fi

if [[ ! -f "$CHECK_SCRIPT" ]]; then
  log "BLOCKED: checker missing: tools/check_openfpga_genesis_analysis_runner.sh"
  exit 0
fi

pull_image() {
  local image="$1"
  if docker pull "$image" >/dev/null 2>&1; then
    log "docker pull result for $image: ok"
    return 0
  fi

  log "docker pull result for $image: failed"
  return 1
}

run_analysis() {
  local image="$1"
  local runner_cmd="./tools/run_openfpga_genesis_analysis_only.sh || true; ./tools/check_openfpga_genesis_analysis_runner.sh"

  if docker run --rm -v "$ROOT_DIR":/work -w /work "$image" bash -lc "$runner_cmd"; then
    log "docker run result for $image: ok"
    return 0
  else
    log "docker run result for $image: failed"
    return 1
  fi
}

log "docker pull attempted: yes"
if ! pull_image "$IMAGE"; then
  if ! pull_image "$FALLBACK_IMAGE"; then
    log "analysis result: both prebuilt images failed to pull"
    log "No fitter, assembler, timing, or bitstream commands were run."
    exit 0
  fi
  IMAGE="$FALLBACK_IMAGE"
  log "switching image to fallback: $IMAGE"
fi

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  log "BLOCKED: image inspect failed for $IMAGE"
  exit 0
fi

log "docker run attempted: yes"
if run_analysis "$IMAGE"; then
  log "analysis attempted: yes"
  log "analysis ran: yes"
  log "analysis result: completed (runner executed in container)"
  log "No fitter, assembler, timing, or bitstream commands were run by this wrapper."
else
  log "analysis attempted: yes"
  log "analysis ran: no"
  log "analysis result: docker container run failed"
  log "No fitter, assembler, timing, or bitstream commands were run by this wrapper."
fi

exit 0
