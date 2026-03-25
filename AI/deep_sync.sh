#!/bin/bash
# --- Hacking-Station Deep Sync 2.0 (2026 Optimized) ---
# Purpose: Context Injection for local AI (Qwen)

PROMPT="$1"
[ -z "$PROMPT" ] && { echo "Usage: deep_sync <prompt>"; exit 1; }

# Context Gathering (Minimized for Token Efficiency)
BASHRC=$(grep -vE '^#|^$' ~/.bashrc | tail -n 50) # Last 50 active lines
BIBLE=$(grep -vE '^#|^$' ~/bible_functions.sh)
I3CONF=$( [ -f ~/.config/i3/config ] && grep -vE '^#|^$' ~/.config/i3/config | tail -n 50 || echo "i3 config not found" )

# The System Matrix
read -r -d '' SYSTEM_DATA << EOM
SYSTEM: You are the Hacking-Station AI / Architect. 
USER: Brother Rodney.
ENV: EndeavourOS i3wm (32GB RAM).
CONTEXT:
--- .bashrc (Active) ---
$BASHRC
--- bible_functions.sh ---
$BIBLE
--- i3/config (Partial) ---
$I3CONF

RODNEY'S REQUEST: $PROMPT
INSTRUCTION: Be concise, technical, and architectural.
EOM

# Execute Sync with Qwen (Fast local inference)
echo -e "\e[1;36m[SYNCING WITH LOCAL ARCHITECT...]\e[0m"
ollama run qwen2.5-coder:1.5b "$SYSTEM_DATA"
