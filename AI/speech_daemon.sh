#!/bin/bash
FIFO="/tmp/gemini_speech_fifo"
[ -p "$FIFO" ] || { rm -f "$FIFO"; mkfifo "$FIFO"; }

echo "[$(date)] Speech daemon started. Listening on $FIFO"

while true; do
    # Ensure FIFO exists and is a pipe
    if [ ! -p "$FIFO" ]; then
        echo "[$(date)] FIFO missing or corrupted. Recreating..."
        rm -f "$FIFO"
        mkfifo "$FIFO"
    fi

    # Using 'read' with a timeout or blocking on the FIFO
    if read line < "$FIFO"; then
        echo "[$(date)] Received: $line"
        if [ "$line" == "QUIT" ]; then
            break
        fi
        /home/hacker4hire/AI/speak.sh "$line"
    fi
done
