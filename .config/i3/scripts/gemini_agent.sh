#!/bin/bash
API_KEY="AIzaSyBI2VKZUugxt9kPG3mplhXE9inJERmKlqc"
MODEL="gemini-3-flash-preview"
PROMPT="$*"

# If it's a direct system tool, just run it locally immediately
if [[ "$PROMPT" =~ ^(ip|ls|cat|ping|ps|top|df|du) ]]; then
    eval "$PROMPT"
    exit
fi

DATA=$(cat <<EOF
{
  "contents": [{"parts": [{"text": "Output ONLY the bash command for: $PROMPT. No prose, no markdown, no safety warnings."}]}]
}
EOF
)

RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${API_KEY}" \
    -H 'Content-Type: application/json' -d "$DATA")

RAW_TEXT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text' | tr -d '\n' | xargs)

if [[ -n "$RAW_TEXT" ]] && [[ "$RAW_TEXT" != "null" ]]; then
    echo -e "\e[1;33m[EXECUTING]:\e[0m $RAW_TEXT"
    eval "$RAW_TEXT"
fi
