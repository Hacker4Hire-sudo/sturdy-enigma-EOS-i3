#!/bin/bash
TRANSCRIPT=$(/home/hacker4hire/AI/listen.sh)
if [ -n "$TRANSCRIPT" ] && [[ "$TRANSCRIPT" != "(No speech detected)"* ]]; then
    echo -e "\e[1;33mSending to Gemini...\e[0m"
    gemini "$TRANSCRIPT"
fi
