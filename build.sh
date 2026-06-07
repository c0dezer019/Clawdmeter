#!/usr/bin/env bash
# Build script for Clawdmeter on Linux.
# Creates a venv, installs deps, and produces dist/Clawdmeter.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root"

if [ ! -d .venv ]; then
    python3 -m venv .venv
fi

.venv/bin/python -m pip install --upgrade pip
.venv/bin/pip install -r requirements.txt
.venv/bin/pip install pyinstaller==6.20.0

.venv/bin/pyinstaller --clean Clawdmeter.spec

echo ""
echo "Built: $root/dist/Clawdmeter"
