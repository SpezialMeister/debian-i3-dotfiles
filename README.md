# debian-i3-dotfiles

Dotfiles und Setup-Scripts für eine frische Debian i3-Installation.

## Was wird installiert

- **Window Manager**: i3
- **Login Manager**: lightdm
- **Terminal**: alacritty
- **Editor**: Sublime Text
- **Browser**: Firefox (Mozilla-Repo)
- **Sync**: Dropbox
- **Notizen**: Obsidian
- **GTK Theme**: Arc-Dark + Papirus-Dark Icons
- **Autotiling**: [better_autotile](vendor/better-autotile-c) (wird aus vendortem Quellcode gebaut)
- Weitere Tools: rofi, dunst, thunar, picom, nitrogen, arandr, ...

## Bootstrap auf einer frischen Debian-Installation

### 1. Als root einloggen und Grundvoraussetzungen installieren

```bash
su -
apt install -y sudo git
usermod -aG sudo laurenz
exit
```

### 2. Neu als nutzer einloggen

Achtung: der benutzername ist in den dotfiles hardcoded. bei bedarf muss dieser einfach per suchen-ersetzen global ersetzt werden.
Die sudo-Gruppe wird erst nach einem neuen Login aktiv.

### 3. Repo klonen

```bash
git clone https://github.com/metzna/debian-i3-dotfiles.git ~/.dotfiles/debian-i3-dotfiles
cd ~/.dotfiles/debian-i3-dotfiles
```

### 4. Setup ausführen

```bash
sudo bash scripts/run-setup.sh
```

### 5. Neu starten

```bash
reboot
```

### 6. Firefox einrichten (nach erstem Firefox-Start)

```bash
bash ~/.dotfiles/debian-i3-dotfiles/scripts/setup-firefox.sh
```

## Repo-Struktur

```
config/         Konfigurationsdateien (werden per Symlink eingebunden)
  i3/           i3 Window Manager
  rofi/         Rofi App-Launcher
  alacritty/    Terminal
  sublime-text/ Sublime Text Packages/User
  nitrogen/     Hintergrundbild
  firefox/      userChrome.css
  bashrc        Shell-Konfiguration
  gitconfig     Git-Konfiguration
data/           Wallpaper und andere statische Dateien
scripts/        Setup-Scripts
vendor/
  better-autotile-c/  Vendorter Quellcode von better_autotile (wird von
                       scripts/build-better-autotile.sh gebaut und nach
                       /usr/local/bin installiert)
```
