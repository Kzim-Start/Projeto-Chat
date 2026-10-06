#!/usr/bin/env bash
set -euo pipefail

# Run from the repository root. Supply GODOT_BIN when Godot is not on PATH.
godot_bin="${GODOT_BIN:-godot}"
test_log="$(mktemp)"
trap 'rm -f "$test_log"' EXIT

has_pattern() {
  if command -v rg >/dev/null 2>&1; then
    rg -q "$1" "$test_log"
  else
    grep -Eq "$1" "$test_log"
  fi
}

run_checked() {
  "$godot_bin" "$@" 2>&1 | tee "$test_log"
  if has_pattern 'SCRIPT ERROR:|^ERROR:|FAIL:'; then
    return 1
  fi
}

run_checked --headless --editor --path . --import
run_checked --headless --path . --quit-after 1800 res://tests/test_runner.tscn -- --test-mode
has_pattern '^RESULT: [0-9]+ checks, 0 failures$'
run_checked --headless --path . --quit-after 2400 res://tests/test_stage_10_15.tscn -- --test-mode
has_pattern '^MENU RESULT: [0-9]+ checks, 0 failures$'
run_checked --headless --path . --quit-after 60 -- --test-mode
for probe in --probe-reset --probe-device --probe-write=pt_BR --probe-read=pt_BR --probe-write=en --probe-read=en; do
  run_checked --headless --path . --quit-after 1800 res://tests/preference_probe.tscn -- --test-mode "$probe"
  has_pattern '^PROBE PASS:'
done
