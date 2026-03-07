#!/bin/bash
# Lightweight Gemini API caller
API_KEY=$(grep "export API_KEY" ~/.env | cut -d'"' -f2)
MODEL="gemini-1.5-flash" # Using Flash for speed on mobile hardware
QUERY="$*"
if [[ -z "$QUERY" ]]; then read -p "Ask Gemini: " QUERY; fi

DATA=$(cat <<EOF
{
  "contents": [{"parts": [{"text": "$QUERY"}]}]
}
