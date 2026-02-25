#!/bin/bash
MODEL="/home/hacker4hire/AI/voices/active_voice.onnx"
PIPER_BIN="/opt/piper-tts/piper"

# --- THE PRONUNCIATION MAP ---
if [ -n "$1" ]; then
    RAW_TEXT="$1"
else
    RAW_TEXT=$(cat)
fi

# Clean text: remove markdown, URLs, and special symbols
# We use perl for more robust regex handling
CLEAN_TEXT=$(echo "$RAW_TEXT" | perl -pe '
    s/https?:\/\/\S+//g;
    s/\*\*\*//g; s/\*\*//g; s/\*//g;
    s/___//g; s/__//g; s/_//g;
    s/`//g;
    s/\[//g; s/\]//g;
    s/\(//g; s/\)//g;
    s/#//g;
    s/---+//g; s/===+//g;
    s/[|✦•·>]//g;
    s/[^\x00-\x7F]//g;
    s/\bKJV\b/K J V/g;
    s/\bPhilippians\b/Fill-ip-pe-ans/g;
    s/\bEcclesiastes\b/Ee-cleez-ee-as-teez/g;
    s/\bArch\b/Arch/g;
    s/\bi3\b/I 3/g;
    s/\bwttr\.in\b/weather dot in/g;
    s/&/ and /g;
    s/%/ percent /g;
    s/\+/ plus /g;
    s/@/ at /g;
')

# Fallback for empty text
if [ -z "$CLEAN_TEXT" ]; then
    CLEAN_TEXT="${RAW_TEXT:0:200}"
fi

# --- AUDIO GENERATION ---
TEMP_VOICE=$(mktemp -p /dev/shm --suffix=.wav)

# Generate and play
echo "$CLEAN_TEXT" | $PIPER_BIN --model "$MODEL" --output-file "$TEMP_VOICE" 2>/dev/null
aplay -q "$TEMP_VOICE" 2>/dev/null

# Cleanup
rm -f "$TEMP_VOICE"
