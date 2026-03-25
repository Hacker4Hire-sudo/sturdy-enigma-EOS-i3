#!/bin/bash
# --- Hacking Station Intel Update Script (32GB Optimized) ---
# Purpose: Deep system update including CPU microcode and firmware.

echo -e "\e[1;34m[UPDATE] Initiating Full System Synchronization...\e[0m"

# 1. Update Pacman Repos and Packages
echo -e "\e[1;32m[1/5] Synchronizing Pacman Repositories...\e[0m"
sudo pacman -Syu --noconfirm

# 2. Update AUR Packages (Yay)
if command -v yay &> /dev/null; then
    echo -e "\e[1;32m[2/5] Synchronizing AUR Packages...\e[0m"
    yay -Sua --noconfirm
fi

# 3. Check for Intel Microcode Updates
echo -e "\e[1;32m[3/5] Verifying Intel Microcode Status...\e[0m"
if pacman -Qs intel-ucode > /dev/null; then
    echo "[+] intel-ucode is installed and monitored."
else
    echo "[!] intel-ucode missing. Installing for hardware stability..."
    sudo pacman -S --needed --noconfirm intel-ucode
fi

# 4. Firmware / Flatpak updates
if command -v fwupdmgr &> /dev/null; then
    echo -e "\e[1;32m[4/5] Checking Device Firmware...\e[0m"
    sudo fwupdmgr get-updates 2>/dev/null
fi

if command -v flatpak &> /dev/null; then
    echo -e "\e[1;32m[5/5] Updating Flatpak Runtime...\e[0m"
    flatpak update -y
fi

# Final Cleanup
echo -e "\e[1;34m[UPDATE] Cleanup and Optimization...\e[0m"
sudo pacman -Sc --noconfirm
yay -Sc --noconfirm

echo -e "\e[1;32m--- ✅ System Update Complete. High-Performance State Maintained. ---\e[0m"
