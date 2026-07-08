#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_PATH="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_ANALYSIS_STATUS.md"
RUN_LOG="$ROOT_DIR/docs/PREBUILT_QUARTUS_DOCKER_RUN_LOG.txt"
RUNNER_SCRIPT="$ROOT_DIR/tools/run_openfpga_genesis_analysis_only.sh"
CHECK_SCRIPT="$ROOT_DIR/tools/check_openfpga_genesis_analysis_runner.sh"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
IMAGE="${QUARTUS_PREBUILT_IMAGE:-theypsilon/quartus-lite-c5:19.1-heavy}"
FALLBACK_IMAGE="${QUARTUS_PREBUILT_IMAGE_FALLBACK:-no2chem/quartuslite:latest}"
TIMESTAMP="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"

log_status() {
  printf "%s\n" "$1" | tee -a "$STATUS_PATH"
}

run_analysis_in_container() {
  local image="$1"
  local container_cmd

  container_cmd=$(cat <<'CMDS'
set -euo pipefail
printf "command -v quartus_map => "
command -v quartus_map || true
echo
if command -v quartus_map >/dev/null 2>&1; then
  quartus_map --version || true
fi
printf "pwd in container: "
pwd
echo
ls -lh tools/run_openfpga_genesis_analysis_only.sh
printf "runner invocation: ./tools/run_openfpga_genesis_analysis_only.sh\n"
./tools/run_openfpga_genesis_analysis_only.sh
printf "checker invocation: ./tools/check_openfpga_genesis_analysis_runner.sh\n"
./tools/check_openfpga_genesis_analysis_runner.sh
printf "checker completed.\n"
CMDS
)

  docker run --rm -v "$ROOT_DIR":/work -w /work "$image" bash -lc "$container_cmd" >> "$RUN_LOG" 2>&1
}

classify_openfpga_status() {
  local analysis_status="UNKNOWN"
  local analysis_exit=""
  local quartus_path=""

  if [[ -f "$STATUS_FILE" ]]; then
    if rg -q "BLOCKED: quartus_map not found" "$STATUS_FILE"; then
      analysis_status="BLOCKED"
    elif rg -q "Analysis exit: 0" "$STATUS_FILE"; then
      analysis_status="PASS"
    elif rg -q "Analysis exit:" "$STATUS_FILE"; then
      analysis_status="FAIL"
    elif rg -q "analysis result:" "$STATUS_FILE"; then
      analysis_status="STALE"
    fi

    analysis_exit="$(awk '/Analysis exit:/{print $3; exit}' "$STATUS_FILE" || true)"
    quartus_path="$(rg "Selected quartus_map:" "$STATUS_FILE" | head -n 1 | sed -E 's/Selected quartus_map: //' || true)"
  else
    analysis_status="MISSING"
  fi

  log_status "analysis status classification: $analysis_status"
  if [[ -n "$analysis_exit" ]]; then
    log_status "analysis exit code: $analysis_exit"
  else
    log_status "analysis exit code: not found"
  fi

  if [[ -n "$quartus_path" ]]; then
    log_status "quartus_map path found in status file: $quartus_path"
  else
    log_status "quartus_map path found in status file: no"
  fi
}

: > "$STATUS_PATH"
{
  echo "# Prebuilt Quartus Docker analysis status"
  echo "Generated: $TIMESTAMP"
  echo "Image: $IMAGE"
  echo "Fallback image: $FALLBACK_IMAGE"
  echo
  echo "docker pull attempted: no"
  echo "docker run attempted: no"
  echo "analysis attempted: no"
  echo "analysis ran: no"
  echo "analysis result: not run"
  echo "fallback used: no"
} > "$STATUS_PATH"

echo "# Prebuilt Quartus Docker run log" > "$RUN_LOG"
echo "Generated: $TIMESTAMP" >> "$RUN_LOG"
echo "Host cwd: $ROOT_DIR" >> "$RUN_LOG"
echo "===== wrapper start =====" >> "$RUN_LOG"

if ! command -v docker >/dev/null 2>&1; then
  log_status "BLOCKED: docker command not found in PATH."
  log_status "No fitter, assembler, timing, or bitstream commands were run by this wrapper."
  exit 0
fi

if [[ ! -x "$RUNNER_SCRIPT" ]]; then
  log_status "BLOCKED: runner missing or not executable: tools/run_openfpga_genesis_analysis_only.sh"
  exit 0
fi

if [[ ! -f "$CHECK_SCRIPT" ]]; then
  log_status "BLOCKED: checker missing: tools/check_openfpga_genesis_analysis_runner.sh"
  exit 0
fi

log_status "docker pull attempted: yes"
if docker pull "$IMAGE" >/dev/null 2>&1; then
  log_status "docker pull result for $IMAGE: ok"
else
  log_status "docker pull result for $IMAGE: failed"
  if docker pull "$FALLBACK_IMAGE" >/dev/null 2>&1; then
    IMAGE="$FALLBACK_IMAGE"
    log_status "fallback used: yes"
    log_status "switching image to fallback: $IMAGE"
    log_status "docker pull result for fallback: ok"
  else
    log_status "docker pull result for fallback: $FALLBACK_IMAGE failed"
    log_status "analysis result: both prebuilt images failed to pull"
    log_status "No fitter, assembler, timing, or bitstream commands were run."
    exit 0
  fi
fi

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  log_status "BLOCKED: image inspect failed for $IMAGE"
  exit 0
fi

log_status "docker run attempted: yes"
if run_analysis_in_container "$IMAGE"; then
  log_status "docker run result for $IMAGE: ok"
  log_status "analysis attempted: yes"
  log_status "analysis ran: yes"
  log_status "analysis result: completed (runner/checker executed in container)"
else
  local_rc=$?
  log_status "docker run result for $IMAGE: failed"
  log_status "analysis attempted: yes"
  log_status "analysis ran: partial"
  log_status "analysis result: docker container run failed (rc=$local_rc)"
fi

classify_openfpga_status

if rg -n "command -v quartus_map|quartus_map --version|quartus_map" "$RUN_LOG" >/dev/null 2>&1; then
  log_status "quartus_map version/path probes ran in container and were logged."
else
  log_status "quartus_map version/path probes did not run or were not captured."
fi

log_status "No fitter, assembler, timing, or bitstream commands were run by this wrapper."
log_status "No bitstream outputs were produced by this wrapper run."

exit 0
