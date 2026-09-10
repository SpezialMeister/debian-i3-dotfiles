#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Bitte als root ausführen (z.B. mittels su -)."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/apt-packages.txt"

if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "Fehler: Die Datei $PACKAGES_FILE wurde nicht gefunden."
    exit 1
fi

echo "Teil 1: APT-Pakete installieren"
echo "APT Paketlisten werden aktualisiert..."
apt-get update

echo "Lese Pakete aus $PACKAGES_FILE und installiere..."
# Lese die Datei zeilenweise, ignoriere Kommentare und leere Zeilen
PACKAGES=$(grep -vE "^\s*#" "$PACKAGES_FILE" | grep -vE "^\s*$" | tr '\n' ' ')
# shellcheck disable=SC2086
apt-get install -y $PACKAGES

echo "Installation der apt-Liste abgeschlossen."
echo ""

echo "Teil 2: Firefox, Sublime Text und Dropbox"
echo "Vorbereitung..."
apt-get install -y curl ca-certificates

# Repos im deb822-Format (.sources), Schlüssel ASCII-armored als .asc.
# apt liest .asc direkt, ein gpg --dearmor ist nicht nötig.
install -d -m 0755 /etc/apt/keyrings

# Dateien älterer Script-Versionen (.list + dearmorte .gpg) entfernen,
# sonst kollidieren die Signed-By-Werte für dasselbe Repo.
rm -f /etc/apt/sources.list.d/mozilla.list \
      /etc/apt/sources.list.d/sublime-text.list \
      /etc/apt/sources.list.d/dropbox.list \
      /etc/apt/keyrings/mozilla.gpg \
      /etc/apt/keyrings/sublimehq.gpg \
      /etc/apt/keyrings/dropbox.gpg

# -------------------------------------------------
# Mozilla Repo (aktuelles Firefox, nicht ESR)
# -------------------------------------------------
echo "Mozilla Repository wird eingerichtet..."
# Endung .gpg in der URL, Inhalt ist trotzdem ASCII-armored
curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
    -o /etc/apt/keyrings/packages.mozilla.org.asc

cat > /etc/apt/sources.list.d/mozilla.sources <<EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

# Pinning (damit Mozilla-Version bevorzugt wird)
cat > /etc/apt/preferences.d/mozilla <<EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

# -------------------------------------------------
# Sublime Text Repo
# -------------------------------------------------
echo "Sublime Repository wird eingerichtet..."
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg \
    -o /etc/apt/keyrings/sublimehq-pub.asc

# Flat-Repo: Suite endet auf "/", daher keine Components
cat > /etc/apt/sources.list.d/sublime-text.sources <<EOF
Types: deb
URIs: https://download.sublimetext.com/
Suites: apt/stable/
Signed-By: /etc/apt/keyrings/sublimehq-pub.asc
EOF

# -------------------------------------------------
# Dropbox Repo
# -------------------------------------------------
echo "Dropbox Repository wird eingerichtet..."
curl -fsSL https://linux.dropbox.com/fedora/rpm-public-key.asc \
    -o /etc/apt/keyrings/dropbox.asc

# Dropbox's Debian repo uses 'sid' regardless of the actual Debian version
cat > /etc/apt/sources.list.d/dropbox.sources <<EOF
Types: deb
URIs: https://linux.dropbox.com/debian
Suites: sid
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/dropbox.asc
EOF

# -------------------------------------------------
# Installation
# -------------------------------------------------
echo "APT aktualisieren..."
apt-get update

echo "Installiere Firefox (latest), Sublime Text und Dropbox..."
apt-get install -y firefox sublime-text dropbox

echo "Installation von Firefox, Sublime Text und Dropbox beendet."

# -------------------------------------------------
# Teil 3: Obsidian AppImage
# -------------------------------------------------
echo "Teil 3: Obsidian AppImage installieren..."

OBSIDIAN_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | grep "browser_download_url" \
    | grep "\.AppImage" \
    | grep -v "arm64" \
    | cut -d '"' -f 4)

if [[ -z "$OBSIDIAN_URL" ]]; then
    echo "Fehler: Obsidian AppImage URL konnte nicht ermittelt werden."
    exit 1
fi

echo "Lade Obsidian herunter: $OBSIDIAN_URL"
curl -fsSL "$OBSIDIAN_URL" -o /opt/obsidian.AppImage
chmod +x /opt/obsidian.AppImage

# Desktop Entry erstellen
cat > /usr/share/applications/obsidian.desktop <<EOF
[Desktop Entry]
Name=Obsidian
Exec=/opt/obsidian.AppImage %u
Terminal=false
Type=Application
Icon=obsidian
StartupWMClass=obsidian
MimeType=x-scheme-handler/obsidian;
Categories=Office;
EOF

echo "Obsidian installiert."

# -------------------------------------------------
# Teil 4: Quarto .deb
# -------------------------------------------------
echo "Teil 4: Quarto installieren..."

QUARTO_URL=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest \
    | grep "browser_download_url" \
    | grep "amd64\.deb" \
    | cut -d '"' -f 4)

if [[ -z "$QUARTO_URL" ]]; then
    echo "Fehler: Quarto .deb URL konnte nicht ermittelt werden."
    exit 1
fi

echo "Lade Quarto herunter: $QUARTO_URL"
curl -fsSL "$QUARTO_URL" -o /tmp/quarto.deb
dpkg -i /tmp/quarto.deb
rm /tmp/quarto.deb

echo "Quarto installiert."
