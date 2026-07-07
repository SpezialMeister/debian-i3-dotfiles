#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Bitte als root ausführen (sudo)."
    exit 1
fi

TARGET_USER="${SUDO_USER:-}"
if [[ -z "$TARGET_USER" ]]; then
    echo "Fehler: SUDO_USER nicht gesetzt. Skript mit sudo ausführen."
    exit 1
fi

USER_HOME="/home/$TARGET_USER"
REPO_DIR="$USER_HOME/.dotfiles/debian-i3-dotfiles"

echo "Setze Symlinks..."

runuser -u "$TARGET_USER" -- bash -lc "
set -euo pipefail
mkdir -p \"\$HOME/.config\"
ln -sfn \"$REPO_DIR/config/i3\"   \"\$HOME/.config/i3\"
ln -sfn \"$REPO_DIR/config/rofi\" \"\$HOME/.config/rofi\"
ln -sfn \"$REPO_DIR/config/alacritty\" \"\$HOME/.config/alacritty\"
mkdir -p \"\$HOME/.config/sublime-text/Packages\"
ln -sfn \"$REPO_DIR/config/sublime-text\" \"\$HOME/.config/sublime-text/Packages/User\"
ln -sfn \"$REPO_DIR/config/bashrc\"    \"\$HOME/.bashrc\"
ln -sfn \"$REPO_DIR/config/gitconfig\" \"\$HOME/.gitconfig\"
ln -sfn \"$REPO_DIR/config/nitrogen\"  \"\$HOME/.config/nitrogen\"
echo \"Symlinks für i3, rofi, alacritty, Sublime Text, bashrc, gitconfig und nitrogen gesetzt.\"
"

echo "Symlink-Einrichtung beendet."
