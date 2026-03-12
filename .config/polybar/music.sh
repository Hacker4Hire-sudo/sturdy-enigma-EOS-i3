#!/bin/bash

# Function to get metadata from a specific source (playerctl or mpc)
get_info() {
    local source=$1
    local p_name=$2
    local status=""
    local title=""
    local artist=""
    local file=""

    if [ "$source" = "playerctl" ]; then
        status=$(playerctl -p "$p_name" status 2>/dev/null)
        title=$(playerctl -p "$p_name" metadata title 2>/dev/null | xargs)
        artist=$(playerctl -p "$p_name" metadata artist 2>/dev/null | xargs)
        
        if [ -n "$title" ] && [ -n "$artist" ]; then
            info="$title - $artist"
        elif [ -n "$title" ]; then
            info="$title"
        elif [ -n "$artist" ]; then
            info="$artist"
        elif [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
            # Check for generic stream/video info if xesam metadata is missing
            info="Stream"
        else
            return 1
        fi
    elif [ "$source" = "mpc" ]; then
        mpc_status=$(mpc status 2>/dev/null)
        if ! echo "$mpc_status" | grep -q "\[playing\]" && ! echo "$mpc_status" | grep -q "\[paused\]"; then
            return 1
        fi
        
        status=$(echo "$mpc_status" | grep -oP '\[\K[^\]]+')
        # Capitalize for consistency
        status="${status^}" 

        title=$(mpc -f "%title%" current | xargs)
        artist=$(mpc -f "%artist%" current | xargs)
        file=$(mpc -f "%file%" current | sed 's/.*\///')

        if [ -n "$title" ] && [ -n "$artist" ]; then
            info="$title - $artist"
        elif [ -n "$title" ]; then
            info="$title"
        else
            info="$file"
        fi
    fi

    # Truncate
    if [ ${#info} -gt 35 ]; then
        info="${info:0:32}..."
    fi

    if [ "$status" = "Playing" ]; then
        echo " $info "
        return 0
    elif [ "$status" = "Paused" ]; then
        echo " $info "
        return 2 # Signal paused
    fi
    return 1
}

while true; do
    best_paused=""
    found_playing=false

    # 1. Check Playerctl (KDE Connect, etc)
    players=$(playerctl -l 2>/dev/null)
    for p in $players; do
        output=$(get_info "playerctl" "$p")
        res=$?
        if [ $res -eq 0 ]; then
            echo "$output"
            found_playing=true
            break
        elif [ $res -eq 2 ] && [ -z "$best_paused" ] && [ "$output" != " Stream " ]; then
            best_paused="$output"
        fi
    done

    # 2. Check MPC (MPD) if no active playerctl playing
    if [ "$found_playing" = false ]; then
        output=$(get_info "mpc")
        res=$?
        if [ $res -eq 0 ]; then
            echo "$output"
            found_playing=true
        elif [ $res -eq 2 ] && [ -z "$best_paused" ]; then
            best_paused="$output"
        fi
    fi

    # 3. If nothing playing, show the best paused source
    if [ "$found_playing" = false ]; then
        if [ -n "$best_paused" ]; then
            echo "$best_paused"
        else
            echo "🎵 Waiting for MPD...  "
        fi
    fi

    sleep 2
done
