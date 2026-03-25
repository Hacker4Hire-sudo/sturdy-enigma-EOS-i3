#!/bin/bash
LISTEN_SH="/home/hacker4hire/AI/listen.sh"
SPEAK_SH="/home/hacker4hire/AI/speak.sh"

# Get user voice input
TRANSCRIPT=$($LISTEN_SH)

if [ -n "$TRANSCRIPT" ] && [[ "$TRANSCRIPT" != "(No speech detected)"* ]]; then
    echo -e "\e[1;33mGemini is thinking...\e[0m"
    
    # Run Gemini in headless mode, stream to terminal and speaker
    # Using -o text for clean output, piping to speak.sh for TTS
    gemini -p "$TRANSCRIPT" -o text | tee /dev/stderr | $SPEAK_SH
fi
