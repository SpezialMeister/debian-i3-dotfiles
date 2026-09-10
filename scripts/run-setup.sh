#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte dieses Skript mit sudo ausführen: sudo bash run-setup.sh"
    exit 1
fi

TARGET_USER="${SUDO_USER:-}"
if [[ -z "$TARGET_USER" ]]; then
    echo "Fehler: SUDO_USER nicht gesetzt. Skript mit sudo ausführen."
    exit 1
fi

echo "================================================="
echo "Starte komplettes System-Setup für: $TARGET_USER"
echo "================================================="

echo ""
echo "-------------------------------------------------"
echo "Schritt 1: Pakete installieren"
echo "-------------------------------------------------"
bash "$SCRIPT_DIR/install-packages.sh"

echo ""
echo "-------------------------------------------------"
echo "Schritt 2: better_autotile bauen und installieren"
echo "-------------------------------------------------"
bash "$SCRIPT_DIR/build-better-autotile.sh"

echo ""
echo "-------------------------------------------------"
echo "Schritt 3: Symlinks setzen"
echo "-------------------------------------------------"
bash "$SCRIPT_DIR/setup-symlinks.sh"

echo ""
echo "-------------------------------------------------"
echo "Schritt 4: Systemumgebung konfigurieren"
echo "-------------------------------------------------"
bash "$SCRIPT_DIR/configure-environment.sh"

echo ""
echo "-------------------------------------------------"
echo "Schritt 5: System überprüfen"
echo "-------------------------------------------------"
su - "$TARGET_USER" -c "bash \"$SCRIPT_DIR/check-system.sh\""

echo ""
echo "================================================="
echo "Setup komplett! Bitte neu starten."
echo "================================================="
