#!/bin/bash
# ==============================================================================
# Dotfiles Installation Script
# ==============================================================================
# This script creates symlinks from the dotfiles directory to their home targets
# It will backup existing files by appending `.backup` to them.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "\e[1;36m[+] Starting Dotfiles Installation...\e[0m"

mkdir -p "$BACKUP_DIR"

# Function to link a file or directory
# $1: Source path relative to DOTFILES_DIR
# $2: Target path relative to HOME
link_item() {
    local src="$DOTFILES_DIR/$1"
    local target="$HOME/$2"
    local target_dir="$(dirname "$target")"

    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"

    # Backup existing item if it's not a symlink pointing to our dotfiles
    if [ -e "$target" ] || [ -h "$target" ]; then
        if [ "$(readlink "$target")" != "$src" ]; then
            echo -e "\e[1;33m[!] Backing up existing $2 to $BACKUP_DIR\e[0m"
            mv "$target" "$BACKUP_DIR/"
        else
            echo -e "\e[1;32m[-] $2 already linked. Skipping.\e[0m"
            return
        fi
    fi

    echo -e "\e[1;32m[+] Linking $2 -> $1\e[0m"
    ln -s "$src" "$target"
}

# --- Core Files ---
link_item ".bashrc" ".bashrc"
link_item ".profile" ".profile"

# --- Configs ---
link_item ".config/i3" ".config/i3"
link_item ".config/picom" ".config/picom"
link_item ".config/rofi" ".config/rofi"

# --- Scripts ---
link_item "scripts/config_launcher.sh" "scripts/config_launcher.sh"

# --- Local Binaries ---
mkdir -p "$HOME/.local/bin"
for bin_file in "$DOTFILES_DIR/.local/bin/"*; do
    if [ -f "$bin_file" ]; then
        filename=$(basename "$bin_file")
        link_item ".local/bin/$filename" ".local/bin/$filename"
        chmod +x "$HOME/.local/bin/$filename"
    fi
done

# --- AI Scripts ---
mkdir -p "$HOME/AI"
for ai_file in "$DOTFILES_DIR/AI/"*; do
    if [ -f "$ai_file" ]; then
        filename=$(basename "$ai_file")
        link_item "AI/$filename" "AI/$filename"
        if [[ "$filename" == *.sh ]]; then
            chmod +x "$HOME/AI/$filename"
        fi
    fi
done

echo -e "
\e[1;32m[✓] Installation Complete!\e[0m"
echo -e "\e[1;34m[i] Backups stored in: $BACKUP_DIR\e[0m"
echo -e "\e[1;34m[i] Restart your terminal or run 'source ~/.bashrc' to apply changes.\e[0m"
