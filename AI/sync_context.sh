#!/bin/bash
# Hacking-Station Context Sync V5 (The Hammer)

USER_PROMPT="$1"
BASHRC=$(cat ~/.bashrc 2>/dev/null)
BIBLE_FUNC=$(cat ~/bible_functions.sh 2>/dev/null)
I3_CONF=$(cat ~/.config/i3/config 2>/dev/null)

# Construct the payload
PAYLOAD="CONTEXT INITIALIZATION: You are the Hacking-Station AI.
I am providing my actual system files below. Index them and use them to answer the user request at the very end.

FILE: .bashrc
$BASHRC

FILE: bible_functions.sh
$BIBLE_FUNC

FILE: i3_config
$I3_CONF

USER REQUEST FOR BROTHER RODNEY:
$USER_PROMPT"

# Send the whole payload as a single argument
ollama run qwen2.5-coder:1.5b "$PAYLOAD"
