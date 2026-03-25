#!/bin/bash
MODEL="/home/hacker4hire/AI/voices/active_voice.onnx"
PIPER_BIN="/opt/piper-tts/piper"

# --- SPEED SETTINGS ---
LENGTH_SCALE="1.0"

# Function to clean and speak a single line/chunk of text
speak_chunk() {
    local RAW_TEXT="$1"
    
    # Skip lines that are likely code or technical artifacts
    if [[ "$RAW_TEXT" =~ ^\s*(\`{3,}|[{}();]) ]] || [[ -z "$RAW_TEXT" ]]; then
        return
    fi

    # Clean text
    local CLEAN_TEXT=$(echo "$RAW_TEXT" | perl -0777 -pe '
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

    if [ ${#CLEAN_TEXT} -gt 1 ]; then
        TEMP_WAV="/tmp/speak_$(date +%s%N).wav"
        # Using paplay for better compatibility with Pulse/PipeWire
        printf "%s" "$CLEAN_TEXT " | $PIPER_BIN --model "$MODEL" --length_scale "$LENGTH_SCALE" --output_file "$TEMP_WAV" >/dev/null 2>&1
        if [ -f "$TEMP_WAV" ]; then
            pw-play "$TEMP_WAV"
            rm -f "$TEMP_WAV"
        fi
    fi
}

if [ -n "$1" ]; then
    speak_chunk "$1"
else
    # Continuous mode (line by line)
    while IFS= read -r line; do
        speak_chunk "$line"
    done
fi
