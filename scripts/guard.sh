#!/bin/bash
# --- Hacking Station Guard 2026 ---
# Monitors VPN, System Integrity, and Critical Services

echo -e "\e[1;33m[GUARD] Station Security Sweep Initiated...\e[0m"

# 1. VPN Status
VPN_STATUS=$(ip addr | grep -i "proton" || ip addr | grep -i "tun0")
if [ -n "$VPN_STATUS" ]; then
    echo -e "\e[1;32m[+] VPN Active.\e[0m"
else
    echo -e "\e[1;31m[!] VPN INACTIVE. System vulnerable.\e[0m"
fi

# 2. Firewall Check
if systemctl is-active --quiet firewalld; then
    echo -e "\e[1;32m[+] Firewall (firewalld) Engaged.\e[0m"
elif command -v ufw >/dev/null && sudo ufw status | grep -q "active"; then
    echo -e "\e[1;32m[+] Firewall (ufw) Engaged.\e[0m"
else
    echo -e "\e[1;31m[!] Firewall DISENGAGED.\e[0m"
fi

# 3. Critical Services
SERVICES=("sshd" "mpd" "ollama")
for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc"; then
        echo -e "\e[1;32m[+] $svc is running.\e[0m"
    else
        echo -e "\e[1;33m[-] $svc is dormant.\e[0m"
    fi
done

# 4. Storage Health
ROOT_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$ROOT_USAGE" -gt 90 ]; then
    echo -e "\e[1;31m[!] CRITICAL: Disk space at ${ROOT_USAGE}%.\e[0m"
else
    echo -e "\e[1;32m[+] Storage healthy (${ROOT_USAGE}%).\e[0m"
fi

echo -e "\e[1;33m[GUARD] Sweep complete.\e[0m"
