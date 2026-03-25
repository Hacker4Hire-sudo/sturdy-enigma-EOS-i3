#!/bin/bash
# Fred TV Player Helper - 2026 Titanium Stability
LOGFILE="/tmp/tv_player.log"
echo "--- $(date) ---" >> "$LOGFILE"
echo "Called with: $@" >> "$LOGFILE"

LINE_NUM=$1
PLAYLIST_FILE=$2

# Fallback to default if second argument is missing
[[ -z "$PLAYLIST_FILE" ]] && PLAYLIST_FILE="$HOME/.cache/fred_tv/playlist.m3u"
[[ -z "$LINE_NUM" ]] && { echo "No line num provided" >> "$LOGFILE"; exit 1; }

# Extract Stream URL and Name
SELECTION=$(sed -n "${LINE_NUM}p" "$PLAYLIST_FILE")
STREAM_URL=$(sed -n "$((LINE_NUM+1))p" "$PLAYLIST_FILE" | tr -d '\r\n')

# Cleanly extract name (everything after the last comma)
NAME=$(echo "$SELECTION" | sed 's/.*,//')

echo "Playing: $NAME from $PLAYLIST_FILE" >> "$LOGFILE"
echo "URL: $STREAM_URL" >> "$LOGFILE"

# Hardened Live-Stream Flags
FLAGS=(
    "--user-agent=TiviMate/5.1.0 (Linux; Android 12)"
    "--no-ytdl"
    "--network-timeout=90"
    "--cache=yes"
    "--demuxer-max-bytes=640MiB"
    "--demuxer-max-back-bytes=256MiB"
    "--demuxer-readahead-secs=400"
    "--cache-pause=yes"
    "--cache-pause-initial=yes"
    "--cache-pause-wait=15"
    "--framedrop=vo"
    "--vd-lavc-fast"
    "--stream-lavf-o=reconnect=1,reconnect_at_eof=1,reconnect_streamed=1,reconnect_delay_max=5,timeout=90000000"
)

# Kill previous Fred TV streams to avoid overlap
pkill -f "mpv.*Fred TV -"

# Launch mpv in background
mpv "${FLAGS[@]}" --title="Fred TV - $NAME" "$STREAM_URL" >/dev/null 2>&1 &

# Refocus the channel list (matches window title "Fred TV")
(sleep 1 && i3-msg '[title="Fred TV"] focus') >/dev/null 2>&1 &
