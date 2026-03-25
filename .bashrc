# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Aliases & Paths ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias music='xfce4-terminal --title ncmpcpp --command ncmpcpp'
source ~/.env
alias workmode='protonvpn-app & study'
alias vibe='~/AI/toggle_voice.sh'
alias talk='read -p "Ask Brother Rodney: " msg && gemini -p "You are Brother Rodney, the System Architect. Give a concise, technical response. If the user asks for a Bible verse, provide only the reference and the scripture text without any extra commentary or Technical Mapping: $msg" | tee /tmp/ai_resp.txt && ~/AI/speak.sh "$(cat /tmp/ai_resp.txt)"'
alias speech='~/.gemini/hooks/speech_control.sh'
alias guard="~/guard.sh"
alias ytm='yt-dlp -x --audio-format mp3 --audio-quality 0 -o "/home/hacker4hire/Music/YTMusic/%(title)s.%(ext)s"'
alias yt="mpv --ytdl-format='bestvideo[height<=720]+bestaudio/best' --cache=yes --demuxer-max-bytes=64M --demuxer-readahead-secs=30"
alias sync='/home/hacker4hire/AI/sync_context.sh'

# --- Performance & Memory Management ---
alias flush='sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches; echo "Memory Flushed."'
alias clean='sudo pacman -Sc --noconfirm; yay -Sc --noconfirm; sudo journalctl --vacuum-time=1d; rm -rf ~/.cache/mozilla/firefox/*.default-release/cache2/*; rm -rf ~/.cache/open_tv/*'
alias vitals='free -h | awk "/Mem:/ {print \"🧠 RAM: \"\$3\"/\"\$2}"; zramctl | awk "NR==2 {print \"🚀 ZRAM: \"\$4}"; sensors | grep "Core 0" | awk "{print \"🌡️  CPU: \"\$3}"'
alias mem='ps -eo size,rss,comm --sort -rss | head -n 15'
alias turbo='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo "🚀 Turbo Mode Engaged"'
alias cool='echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo "🧊 Cooling Down"'

lean() {
    echo "--- 🍃 Entering Lean Mode ---"
    # Close memory heavy apps
    pkill -f firefox
    pkill -f vlc
    pkill -f code
    pkill -f thunar
    
    # Stop non-essential services
    sudo systemctl stop ollama
    sudo systemctl stop bluetooth
    sudo systemctl stop avahi-daemon
    
    # Clear caches and optimize
    sudo sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    
    echo "--- ✅ Station is now Lean & Mean ---"
    free -h
}

# Restore full functionality
full() {
    echo "--- 🚀 Restoring Full Functionality ---"
    sudo systemctl start bluetooth
    sudo systemctl start avahi-daemon
    # ollama is on-demand or usually left off in lean
    echo "--- ✅ Services Restored ---"
}

# --- Media Session Optimizations (2026) ---
export TERMV_DEFAULT_MPV_FLAGS="--hwdec=vaapi --no-ytdl --cache=yes --cache-pause=yes --cache-pause-initial=yes --cache-pause-wait=15 --demuxer-thread=yes --demuxer-max-bytes=640MiB --demuxer-readahead-secs=400 --network-timeout=90 --user-agent='TiviMate/5.1.0 (Linux; Android 12)' --vd-lavc-fast --framedrop=vo --stream-lavf-o=reconnect=1,reconnect_at_eof=1,reconnect_streamed=1,reconnect_delay_max=5"
alias mpv="mpv --hwdec=vaapi"

export PATH="$HOME/.local/bin:$PATH"
PS1='\[\e[1;32m\][hacker4hire@Hacking-Station]\[\e[0m\] \[\e[1;36m\][\T]\[\e[0m\] \[\e[1;33m\]\W\[\e[0m\]\$ '

# --- Hacking-Station Welcome Sequence ---
if [[ $- == *i* ]]; then
    clear
    echo -e "\e[1;32mWelcome back, Brother Rodney.\e[0m"
    echo -e "\e[1;36mSystem Time: $(date +'%I:%M %p') | $(date +'%A, %B %d, %Y')\e[0m"

    # Fast Weather (cached)
    if [ -f ~/.cache/weather.txt ]; then
        cat ~/.cache/weather.txt
    fi
    # Background update for next terminal
    (/home/hacker4hire/.local/bin/update-weather.sh &) >/dev/null 2>&1

    # The Daily Bread (Script call)
    ~/.local/bin/daily-bread

    # --- System Briefing (Optimized Vitals) ---
    MEM_USAGE=$(awk '/MemTotal:/ {total=$2} /MemAvailable:/ {avail=$2} END {printf("%3.0f%%", (total-avail)/total*100)}' /proc/meminfo)
    CPU_TEMP=$(sensors | grep 'Core 0' | awk '{print $3}' | tr -d '+')
    printf "\e[1;36m🧠 Memory: %-4s | 🌡️  CPU: %-7s\e[0m\n" "$MEM_USAGE" "$CPU_TEMP"
fi

# --- Completion & History ---
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# --- Gemini AI Integration ---
alias manage='gemini'

# --- The Master Brain (Unified AI Switchboard) ---
source ~/.bash_movie_logic

# --- Souped-up Brother Rodney (System Agent) ---
coder() {
    local PROMPT
    read -p "Ask Brother Rodney: " PROMPT
    if [ -n "$PROMPT" ]; then
        local VITALS="[TEMP: $(sensors | grep 'Core 0' | awk '{print $3}' | tr -d '+') | MEM: $(awk '/MemTotal:/ {total=$2} /MemAvailable:/ {avail=$2} END {printf("%3.0f%%", (total-avail)/total*100)}' /proc/meminfo)] "
        echo -e "\e[1;33mFeeding vitals to Rodney...\e[0m"
        ~/AI/deep_sync.sh "$VITALS $PROMPT"
    fi
}

alias vbg='cmatrix -C cyan -b'
alias matrix='cmatrix -C cyan -b'
alias toggle-bg='echo "Live wallpaper disabled. Use '\''matrix'\'' for terminal visualizer."'

# --- The Master Brain (Architect Integrated) ---
brain() {
    local opt=$1
    local agent_name=""
    local ARCH_PROMPT="You are the Lead Architect for this EndeavourOS i3 station. Full R/W access granted. Focus on performance for 4GB RAM. You are authorized to modify system files and scripts."

    if [[ -z "$opt" ]]; then
        echo -e "\n\e[1;34m[MISSION SELECT - 2026 STABLE]\e[0m"
        echo "1) Gemini (The Architect)"
        echo "2) Claude (The Builder)"
        echo "3) Qwen (Local Coder)"
        echo "4) Deep Sync (Knowledge)"
        echo -n "Select Agent [1-4]: "
        read -r choice
        case $choice in
            1) opt="--gemini" ; agent_name="Architect" ;;
            2) opt="-c" ; agent_name="Claude" ;;
            3) opt="-l" ; agent_name="Qwen" ;;
            4) opt="-s" ; agent_name="Deep Sync" ;;
            *) echo "Invalid selection."; return 1 ;;
        esac
    fi

    echo -e "\e[1;32m--- $agent_name Session Active (type 'dismiss' to exit) ---\e[0m"
    while true; do
        echo -n "[$agent_name] > "
        read -e -r query
        [[ "$query" =~ ^(exit|quit|dismiss|bye)$ ]] && echo "Session dismissed." && break
        [[ -z "$query" ]] && continue

        case $opt in
            -g|--gemini) gemini -i "$ARCH_PROMPT" ;;
            -c|--claude) ~/.local/bin/claude "$query" ;;
            -l|--local)  ollama run qwen2.5-coder:1.5b "$query" ;;
            -s|--sync)   ~/AI/deep_sync.sh "$query" ;;
        esac
    done
}
alias update='~/.local/bin/intel-update.sh'
alias tv='xfce4-terminal --title "Fred TV" --command "/home/hacker4hire/.config/i3/scripts/tv_launcher.sh"'
alias upgrade-gemini='sudo npm install -g @google/gemini-cli@latest'
source ~/.bash_brain
export BROWSER=google-chrome-stable
export GOOGLE_API_KEY="AIzaSyBKXbkvjmu89MIfjyYq5ai22nkI57Xifxs"
