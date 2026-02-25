#!/bin/bash
# Hacking-Station Vocal Interface

# 1. Run the Ollama query and save output
# We use 'stdbuf' to ensure we get the text as it's generated
RESPONSE=$(ollama run qwen2.5-coder:1.5b "$1")

# 2. Print the full response to the terminal so you can see the code
echo -e "\n$RESPONSE\n"

# 3. Clean the response for speech (Remove code blocks ```...```)
# This keeps the 'Brotherly' advice but skips reading the raw code
SPOKEN_TEXT=$(echo "$RESPONSE" | sed '/^```/,/^```/d')

# 4. Speak the explanation
~/AI/speak.sh "$SPOKEN_TEXT"
