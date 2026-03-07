#!/bin/bash
MODEL="/home/hacker4hire/AI/voices/active_voice.onnx"
PIPER_BIN="/opt/piper-tts/piper"

# --- SPEED SETTINGS ---
# Length Scale: > 1.0 is slower, < 1.0 is faster. Default is 1.0.
# A value of 0.95 or 0.9 makes it sound a bit more energetic and natural.
LENGTH_SCALE="0.95"

# --- THE PRONUNCIATION MAP ---
if [ -n "$1" ]; then
    RAW_TEXT="$1"
else
    RAW_TEXT=$(cat)
fi

# Log the received text for debugging
echo "[$(date)] speak.sh received: $RAW_TEXT" >> /home/hacker4hire/AI/speak_debug.log

# Skip lines that are likely code or technical artifacts
# (e.g., starting with indentation, containing many symbols, or markers)
if [[ "$RAW_TEXT" =~ ^\s*(\`{3,}|[{}();]) ]]; then
    echo "[$(date)] speak.sh: Skipped code/technical line." >> /home/hacker4hire/AI/speak_debug.log
    exit 0
fi

# Clean text: remove markdown, URLs, and special symbols
CLEAN_TEXT=$(echo "$RAW_TEXT" | perl -0777 -pe '
    s/```[\s\S]*?```//g;       # Remove multiline code blocks
    s/`.*?`//g;                # Remove inline code
    s/\[([^\]]+)\]\([^\)]+\)/$1/g; # Keep only text part of markdown links
    s/https?:\/\/\S+//g;       # Remove URLs
    s/(\*\*|\*|__|_)//g;       # Remove bold/italic markers
    s/^#+\s+//mg;              # Remove headers
    s/^[*-]\s+//mg;            # Remove list bullets
    s/^\d+\.\s+//mg;           # Remove numbered lists
    s/^[|>]\s+//mg;            # Remove blockquotes and line starts
    s/[✦•·]//g;                # Remove special bullet points
    s/[^\x00-\x7F]//g;         # Remove non-ASCII
    s/[.\-=_]{4,}/ /g;         # Replace long repeats of punctuation with a space
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
    s/\s+/ /g;                 # Collapse all whitespace
')

# Check length after cleaning
CLEAN_LEN=${#CLEAN_TEXT}
echo "[$(date)] speak.sh: Cleaned text: $CLEAN_TEXT (Length: $CLEAN_LEN)" >> /home/hacker4hire/AI/speak_debug.log
if [ "$CLEAN_LEN" -lt 2 ]; then
    echo "[$(date)] speak.sh: Text too short, skipping." >> /home/hacker4hire/AI/speak_debug.log
    exit 0
fi

# Stream to pacat for proper PulseAudio routing
printf "%s" "$CLEAN_TEXT" | $PIPER_BIN --model "$MODEL" --length_scale "$LENGTH_SCALE" --output_raw 2>/dev/null | pacat --raw --rate=22050 --format=s16le --channels=1
