#!/bin/bash
MODEL="/home/hacker4hire/whisper.cpp-bin/whisper.cpp-git/src/whisper.cpp-git/models/ggml-base.en.bin"
WHISPER_BIN="/home/hacker4hire/whisper.cpp-bin/whisper.cpp-git/src/build/bin/whisper-cli"
TEMP_WAV="/tmp/gemini_input.wav"

# Send status messages to stderr to keep stdout clean for the transcript
echo -e "\e[1;35m[Listening... Press Ctrl+C to stop and process]\e[0m" >&2
# Record until Ctrl+C
rec -q -c 1 -r 16000 "$TEMP_WAV" 2>/dev/null

if [ -f "$TEMP_WAV" ]; then
    echo -e "\e[1;36m[Processing voice...]\e[0m" >&2
    # Extract only the text, strip timestamps
    TRANSCRIPT=$($WHISPER_BIN -m "$MODEL" -f "$TEMP_WAV" -nt 2>/dev/null | sed 's/\[.*\] //g' | tr -d '\n' | sed 's/^ *//;s/ *$//')
    rm -f "$TEMP_WAV"
    
    if [ -n "$TRANSCRIPT" ]; then
        echo -e "\e[1;32mYou said: $TRANSCRIPT\e[0m" >&2
        echo "$TRANSCRIPT"
    else
        echo -e "\e[1;31m(No speech detected)\e[0m" >&2
    fi
fi
