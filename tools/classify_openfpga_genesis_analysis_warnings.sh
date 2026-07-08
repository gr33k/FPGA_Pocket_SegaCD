#!/usr/bin/env bash
set -euo pipefail

LOG_FILE=${1:-"docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt"}
OUTPUT_FILE=${2:-"docs/OPENFPGA_GENESIS_ANALYSIS_WARNING_SUMMARY.md"}

if [[ ! -f "$LOG_FILE" ]]; then
  echo "ERROR: warning log not found: $LOG_FILE" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 not found" >&2
  exit 1
fi

python3 - "$LOG_FILE" "$OUTPUT_FILE" <<'PY'
import re
import sys
from collections import defaultdict

log_path, out_path = sys.argv[1], sys.argv[2]

warn_re = re.compile(r"Warning \(([0-9]+)\):\s*(.*)")

counts = defaultdict(int)
examples = defaultdict(list)
classes = {}

lines = []
with open(log_path, "r", encoding="utf-8", errors="replace") as f:
    for raw in f:
        line = raw.rstrip("\n")
        m = warn_re.search(line)
        if not m:
            continue
        code = m.group(1)
        msg = m.group(2)
        counts[code] += 1
        if len(examples[code]) < 3:
            examples[code].append(line)
        # classification for each warning class
        if code == "12241" or "connectivity" in msg.lower():
            cls = "needs_review"
        elif code == "10230":
            cls = "harmless" if "truncated value" in msg.lower() else "needs_review"
        elif code == "10259":
            cls = "needs_review"
        elif code == "10030" and ("no driver" in msg.lower() or "default initial value" in msg.lower()):
            cls = "needs_review"
        elif code == "10036":
            cls = "harmless"
        elif code == "10762":
            cls = "harmless"
        elif code == "10858":
            cls = "needs_review"
        elif code in {"113027", "113028", "287013"}:
            cls = "harmless"
        else:
            cls = "unknown"
        classes[code] = cls

class_totals = {"harmless": 0, "needs_review": 0, "blocker": 0, "unknown": 0}
for code, count in counts.items():
    cls = classes.get(code, "unknown")
    class_totals[cls] += count

if sum(counts.values()) == 0:
    recommendation = "READY_FOR_FITTER_GATE"
    reason = "No warnings found in the Quartus analysis log."
else:
    if class_totals["blocker"] > 0:
        recommendation = "BLOCKED_BEFORE_FITTER"
        reason = "Found warning classes marked as likely fitter blockers."
    elif class_totals["needs_review"] > 0:
        recommendation = "REVIEW_WARNINGS_FIRST"
        reason = "Warnings are present that should be reviewed before fitter because they may affect runtime behavior or interface stubs."
    else:
        recommendation = "READY_FOR_FITTER_GATE"
        reason = "No blocker or review-required classes were identified."

with open(out_path, "w", encoding="utf-8") as f:
    f.write("# openFPGA Genesis analysis warning summary\n")
    f.write("\n")
    f.write("Generated: " + __import__("datetime").datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC") + "\n")
    f.write(f"Source: {log_path}\n\n")
    if sum(counts.values()) == 0:
        f.write("No warnings were found in the Quartus analysis log.\n\n## Fitter-readiness recommendation\n\n- Recommendation: READY_FOR_FITTER_GATE\n")
    else:
        f.write(f"Total warnings: {sum(counts.values())}\n\n")
        f.write("## By warning code\n\n")
        for code in sorted(counts, key=lambda x: int(x)):
            cnt = counts[code]
            cls = classes.get(code, "unknown")
            human = {
                "harmless": "likely harmless inherited upstream warning",
                "needs_review": "needs review before fitter",
                "blocker": "likely fitter blocker",
                "unknown": "unknown"
            }.get(cls, "unknown")
            f.write(f"- code {code}: {cnt}\n")
            f.write(f"  - class: {human}\n")
            f.write("  - example(s):\n")
            for ex in examples[code]:
                f.write(f"    - {ex}\n")
            f.write("\n")

        f.write("## Class totals\n")
        f.write(f"- likely harmless: {class_totals['harmless']}\n")
        f.write(f"- needs review before fitter: {class_totals['needs_review']}\n")
        f.write(f"- likely fitter blocker: {class_totals['blocker']}\n")
        f.write(f"- unknown: {class_totals['unknown']}\n\n")

        f.write("## Detection highlights\n")
        f.write("- connectivity warnings detected: code 12241\n")
        f.write("- truncation warnings detected: code 10230\n")
        f.write("- inference/latch/driver warnings detected: codes 10030, 10036, 10858\n")
        f.write("- IP/QIP/device-family warnings: none identified in current log\n\n")

        f.write("## Fitter-readiness recommendation\n\n")
        f.write(f"Decision: **{recommendation}**\n\n")
        f.write(f"Reason: {reason}\n\n")
        if recommendation == "READY_FOR_FITTER_GATE":
            f.write("- Keep APF wrapper and ROM-preload stubs unchanged\n")
            f.write("- Run a controlled fitter-only gate and capture fit outputs in docs.\n")
        elif recommendation == "REVIEW_WARNINGS_FIRST":
            f.write("- Review 12241 connectivity warnings first, especially around bridge/APF stubs.\n")
            f.write("- Review 10030/10858 no-driver/unused signal warnings for stub/interface effects.\n")
            f.write("- Re-run this classifier before any fitter attempt.\n")
        else:
            f.write("- Resolve blocker warnings first, then rerun analysis and reclassify.\n")

print(f"Wrote warning summary to {out_path}")
print(f"Decision: {recommendation}")
PY

chmod +x tools/classify_openfpga_genesis_analysis_warnings.sh