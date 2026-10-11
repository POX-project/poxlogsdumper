#!/bin/sh
# ==============================================================================
# POX LOGS DUMPER (Standalone Shell Wrapper)
# Can be executed via:
# 1) Recovery flashable zip
# 2) adb shell / Terminal Emulator: su -c "sh poxlogsdumper.sh"
# ==============================================================================

DIRNAME="$(dirname "$0")"
UPDATE_BIN="$DIRNAME/META-INF/com/google/android/update-binary"

if [ -f "$UPDATE_BIN" ]; then
  exec sh "$UPDATE_BIN" 3 1 ""
else
  echo "[!] Cannot find update-binary in $DIRNAME"
  exit 1
fi
