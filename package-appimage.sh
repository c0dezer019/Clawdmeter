#!/usr/bin/env bash
# Package Clawdmeter as a Linux AppImage.
# Requires dist/Clawdmeter (run ./build.sh first).
# Downloads appimagetool to build/ if not on PATH.
# Output: dist/Clawdmeter-<version>-x86_64.AppImage
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root"

version="$(sed -n 's/^APP_VERSION = "\(.*\)"/\1/p' src/app_settings.py)"
version="${version:-0.0.0}"

if [ ! -f dist/Clawdmeter ]; then
    echo "dist/Clawdmeter missing. Run ./build.sh first." >&2
    exit 1
fi

# Locate appimagetool: PATH, else download into build/.
tool="$(command -v appimagetool || true)"
if [ -z "$tool" ]; then
    tool="build/appimagetool"
    if [ ! -x "$tool" ]; then
        echo "Downloading appimagetool..."
        mkdir -p build
        curl -fsSL -o "$tool" \
            "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
        chmod +x "$tool"
    fi
fi

# Assemble AppDir.
appdir="build/Clawdmeter.AppDir"
rm -rf "$appdir"
mkdir -p "$appdir/usr/bin"
cp dist/Clawdmeter "$appdir/usr/bin/Clawdmeter"

# Icon (top-level + hicolor theme path).
cp assets/icon.png "$appdir/clawdmeter.png"
mkdir -p "$appdir/usr/share/icons/hicolor/512x512/apps"
cp assets/icon.png "$appdir/usr/share/icons/hicolor/512x512/apps/clawdmeter.png"

# Desktop entry (top-level + standard path).
cp assets/clawdmeter.desktop "$appdir/clawdmeter.desktop"
mkdir -p "$appdir/usr/share/applications"
cp assets/clawdmeter.desktop "$appdir/usr/share/applications/clawdmeter.desktop"

# AppRun launches the bundled binary.
cat > "$appdir/AppRun" <<'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
exec "$HERE/usr/bin/Clawdmeter" "$@"
EOF
chmod +x "$appdir/AppRun"

out="dist/Clawdmeter-${version}-x86_64.AppImage"
ARCH=x86_64 APPIMAGE_EXTRACT_AND_RUN=1 "$tool" "$appdir" "$out"

echo ""
echo "Built: $root/$out"
