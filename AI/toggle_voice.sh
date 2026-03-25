#!/bin/bash
# Hacking-Station Voice Toggle (Fixed for Configs)

VOICE_DIR="/home/hacker4hire/AI/voices"
AMY="$VOICE_DIR/amy_medium.onnx"
RYAN="$VOICE_DIR/ryan_high.onnx"

CURRENT=$(readlink -f "$VOICE_DIR/active_voice.onnx")

if [[ "$CURRENT" == *"$RYAN"* ]]; then
    # Link Amy's Voice AND Config
    ln -sf "$AMY" "$VOICE_DIR/active_voice.onnx"
    ln -sf "$AMY.json" "$VOICE_DIR/active_voice.onnx.json"
    echo "Sultry mode activated (Amy)."
else
    # Link Ryan's Voice AND Config
    ln -sf "$RYAN" "$VOICE_DIR/active_voice.onnx"
    ln -sf "$RYAN.json" "$VOICE_DIR/active_voice.onnx.json"
    echo "Brotherly mode activated (Ryan)."
fi
