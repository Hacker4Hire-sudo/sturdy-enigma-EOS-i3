#!/bin/bash
# ==============================================================================
# Hacking-Station Desktop Bootstrap Script
# ==============================================================================
# Target: 32GB RAM / 1TB SSD Performance Machine
# OS: Arch Linux / EndeavourOS
# ==============================================================================

set -e

REPO_URL="https://github.com/Hacker4Hire-sudo/sturdy-enigma-EOS-i3.git"
DOTFILES_DIR="$HOME/dotfiles"

echo "--- 🚀 Starting Bootstrap for High-Performance Desktop ---"

# 1. Update System
echo "[+] Updating system..."
sudo pacman -Syu --noconfirm

# 2. Install Essential Dependencies
echo "[+] Installing core dependencies..."
sudo pacman -S --needed --noconfirm git base-devel rsync wget curl

# 3. Install Yay (AUR Helper)
if ! command -v yay &> /dev/null; then
    echo "[+] Installing yay..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
    cd -
fi

# 4. Clone Dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "[+] Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "[!] Dotfiles directory already exists. Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull origin main
fi

# 5. Install Packages from pkglist.txt
if [ -f "$DOTFILES_DIR/pkglist.txt" ]; then
    echo "[+] Installing packages from list..."
    # Filter out potential missing packages and install
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist.txt"
fi

# 6. Run Dotfiles Installation
echo "[+] Deploying dotfiles..."
bash "$DOTFILES_DIR/install.sh"

# 7. Performance Optimizations for 32GB RAM / 1TB SSD
echo "[+] Applying performance tweaks..."

# A. Enable ZRAM (Better than disk swap for 32GB RAM)
echo "[*] Setting up ZRAM..."
sudo pacman -S --needed --noconfirm zram-generator
sudo bash -c 'cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF'
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

# B. Ananicy-cpp (Auto-nice daemon for better responsiveness)
echo "[*] Installing Ananicy-cpp..."
yay -S --needed --noconfirm ananicy-cpp
sudo systemctl enable --now ananicy-cpp

# C. Prelockd (Keep important binaries in RAM)
echo "[*] Installing Prelockd..."
yay -S --needed --noconfirm prelockd
sudo systemctl enable --now prelockd

# D. Adjust Swappiness (Minimize disk swapping)
echo "[*] Optimizing swappiness..."
sudo bash -c 'echo "vm.swappiness=10" > /etc/sysctl.d/99-swappiness.conf'
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf

# E. Paccache (Auto-clean package cache)
echo "[*] Enabling paccache timer..."
sudo systemctl enable --now paccache.timer

echo "--- ✅ Bootstrap Complete! ---"
echo "Restart your system to apply all performance tweaks."
echo "Welcome to your new powerful Hacking Station!"
