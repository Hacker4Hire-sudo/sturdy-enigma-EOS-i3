#!/bin/bash
# Hacking-Station Context Sync V6 (2026 High-Performance)
# Purpose: Deep Context Injection for local AI (Qwen)

USER_PROMPT="$1"
[ -z "$USER_PROMPT" ] && { echo "Usage: sync_context <prompt>"; exit 1; }

# Context Gathering (Minimized for Efficiency)
BASHRC=$(grep -vE '^#|^$' ~/.bashrc | tail -n 50)
BIBLE_FUNC=$(grep -vE '^#|^$' ~/bible_functions.sh 2>/dev/null)
I3_CONF=$( [ -f ~/.config/i3/config ] && grep -vE '^#|^$' ~/.config/i3/config | tail -n 50 || echo "i3 config not found" )

# Construct the System Matrix
read -r -d '' PAYLOAD << EOM
SYSTEM: You are the Hacking-Station AI / Architect. 
USER: Brother Rodney.
ENV: EndeavourOS i3wm (32GB RAM).
CONTEXT:
--- .bashrc (Active) ---
$BASHRC
--- bible_functions.sh ---
$BIBLE_FUNC
--- i3/config (Partial) ---
$I3_CONF

RODNEY'S REQUEST: $USER_PROMPT
INSTRUCTION: Be concise, technical, and architectural.
EOM

# Execute Sync with Qwen
echo -e "\e[1;36m[HAMMER SYNCING WITH ARCHITECT...]\e[0m"
ollama run qwen2.5-coder:1.5b "$PAYLOAD"
