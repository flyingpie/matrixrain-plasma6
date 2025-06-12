#!/usr/bin/env bash
set -euo pipefail

PACKAGE_DIR="package/"

# Check if kpackagetool6 is installed
if command -v kpackagetool6 >/dev/null 2>&1; then
    echo "Found kpackagetool6; installing wallpaper package..."
    kpackagetool6 --type Plasma/Wallpaper --install "${PACKAGE_DIR}"
    echo "Installation complete."
else
    echo "Error: kpackagetool6 is not installed or not in PATH." >&2
    exit 1
fi
