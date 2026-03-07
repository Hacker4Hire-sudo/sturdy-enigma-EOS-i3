#!/bin/bash
# Fred TV Launcher - 2026 Titanium Stability 2.5 (Persistent Edition)
BASE_DIR="/home/hacker4hire/organized_m3u"
CACHE_DIR="$HOME/.cache/fred_tv"
PLAYER_SCRIPT="$HOME/.config/i3/scripts/tv_player.sh"
mkdir -p "$CACHE_DIR"

play_category() {
    local m3u_file="$1"
    local prompt_text="$2"
    
    # Use fzf to select and play, keeping fzf open (--bind enter:execute-silent)
    grep -n -E '^#EXTINF' "$m3u_file" | \
        sed 's/tvg-logo="[^"]*"//g; s/group-title="[^"]*"//g' | \
        fzf --height 100% \
            --reverse \
            --prompt="📺 $prompt_text: " \
            --header="[ENTER] Play Selection | [ESC] Back to Menu" \
            --with-nth 2.. \
            --delimiter ":" \
            --bind "enter:execute-silent($PLAYER_SCRIPT {1} $m3u_file)" \
            --bind "double-click:execute-silent($PLAYER_SCRIPT {1} $m3u_file)"
}

# Main Menu
while true; do
    choice=$(echo -e "1. Live TV\n2. Movies\n3. TV Shows\n4. Radio\n5. Exit" | fzf --height 100% --reverse --prompt="📺 Fred TV Main Menu: " --header="Select content type")
    
    case "$choice" in
        "1. Live TV")
            play_category "$BASE_DIR/live_tv.m3u" "Live TV"
            ;;
        "2. Movies")
            play_category "$BASE_DIR/movies.m3u" "Movies"
            ;;
        "3. TV Shows")
            play_category "$BASE_DIR/series.m3u" "TV Shows"
            ;;
        "4. Radio")
            play_category "$BASE_DIR/radio.m3u" "Radio"
            ;;
        "5. Exit")
            exit 0
            ;;
        *)
            [ -z "$choice" ] && exit 0
            ;;
    esac
done
