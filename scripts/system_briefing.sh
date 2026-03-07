#!/bin/bash
# --- Brother Rodney's System Briefing ---
# Lead Architect's health check for 4GB Station

clear
echo -e "\e[1;34m====================================================\e[0m"
echo -e "\e[1;32m       🛰️  HACKING-STATION COMMAND BRIEFING\e[0m"
echo -e "\e[1;34m====================================================\e[0m"

# 1. Performance Mode
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
if [ "$GOVERNOR" == "performance" ]; then
    MODE="\e[1;31m🚀 TURBO\e[0m"
else
    MODE="\e[1;36m🧊 COOL\e[0m"
fi

# 2. Vitals
UPTIME=$(uptime -p)
LOAD=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
TEMP=$(sensors | grep "Core 0" | awk '{print $3}' | tr -d '+')

echo -e "   \e[1;33mMode:\e[0m $MODE   |   \e[1;33mTemp:\e[0m $TEMP   |   \e[1;33mLoad:\e[0m $LOAD"
echo -e "   \e[1;33mUptime:\e[0m $UPTIME"

echo -e "\e[1;34m----------------------------------------------------\e[0m"

# 3. Memory & ZRAM (The Critical Part)
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_PCT=$(( MEM_USED * 100 / MEM_TOTAL ))

ZRAM_TOTAL=$(zramctl | awk 'NR==2 {print $3}' | tr -d 'M' | tr -d 'G')
# Simple conversion if needed, but zramctl output is usually readable
ZRAM_INFO=$(zramctl | awk 'NR==2 {printf "%s (Data: %s, Compr: %s)", $3, $4, $5}')

echo -e "   \e[1;32mRAM Usage:\e[0m  $MEM_USED MB / $MEM_TOTAL MB (\e[1;36m$MEM_PCT%\e[0m)"
echo -e "   \e[1;32mZRAM State:\e[0m $ZRAM_INFO"

echo -e "\e[1;34m----------------------------------------------------\e[0m"

# 4. Storage & Network
DISK=$(df -h / | awk 'NR==2 {print $3" / "$2" ("$5")"}')
IP=$(ip addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
[ -z "$IP" ] && IP=$(ip addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
[ -z "$IP" ] && IP="OFFLINE"

echo -e "   \e[1;35mSSD Space:\e[0m  $DISK"
echo -e "   \e[1;35mStation IP:\e[0m $IP"

echo -e "\e[1;34m====================================================\e[0m"
echo -e "\e[1;30m   Type 'optimize' to reclaim RAM or 'lean' for focus.\e[0m"
echo -e "\e[1;34m====================================================\e[0m"
