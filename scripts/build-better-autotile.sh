#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Bitte als root ausführen (sudo)."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../vendor/better-autotile-c"

if [[ ! -f "$SRC_DIR/Makefile" ]]; then
    echo "Fehler: $SRC_DIR/Makefile wurde nicht gefunden."
    exit 1
fi

echo "Baue better_autotile aus $SRC_DIR ..."
make -C "$SRC_DIR" clean
make -C "$SRC_DIR"

echo "Installiere better_autotile nach /usr/local/bin ..."
make -C "$SRC_DIR" install PREFIX=/usr/local

INSTALLED_VERSION="$(/usr/local/bin/better_autotile -v 2>/dev/null || echo unknown)"
echo "better_autotile installiert: $INSTALLED_VERSION"
