#!/bin/bash
# Hacking-Station Voice Toggle (Fixed for Configs)

VOICE_DIR="/home/hacker4hire/AI/voices"
CURRENT=$(readlink -f "$VOICE_DIR/active_voice.onnx")

if [[ "$CURRENT" == *"ryan_high"* ]]; then
    # Link Amy's Voice AND Config
    ln -sf "$VOICE_DIR/amy_medium.onnx" "$VOICE_DIR/active_voice.onnx"
    ln -sf "$VOICE_DIR/amy_medium.onnx.json" "$VOICE_DIR/active_voice.onnx.json"
    echo "Sultry mode activated."
else
    # Link Ryan's Voice AND Config
    ln -sf "$VOICE_DIR/ryan_high.onnx" "$VOICE_DIR/active_voice.onnx"
    ln -sf "$VOICE_DIR/ryan_high.onnx.json" "$VOICE_DIR/active_voice.onnx.json"
    echo "Brotherly mode activated."
fi
