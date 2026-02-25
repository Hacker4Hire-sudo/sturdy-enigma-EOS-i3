#!/bin/bash

# --- Hacking-Station Deep Sync ---
PROMPT="$1"
BASHRC=$(cat ~/.bashrc)
BIBLE=$(cat ~/bible_functions.sh)
I3CONF=$(cat ~/.config/i3/config)

# The "Injection" - Telling the AI exactly who it is and what it sees
read -r -d '' SYSTEM_DATA << EOM
INSTRUCTIONS: You are the Hacking-Station AI. You MUST use the provided configuration data to answer Brother Rodney.

MY SYSTEM DATA:
--- .bashrc ---
$BASHRC
--- bible_functions.sh ---
$BIBLE
--- i3_config ---
$I3CONF

QUESTION FROM BROTHER RODNEY:
$PROMPT
EOM

# Send the entire block to the coder model
ollama run qwen2.5-coder:1.5b "$SYSTEM_DATA"
