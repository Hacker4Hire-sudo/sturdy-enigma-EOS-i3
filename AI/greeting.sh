#!/bin/bash
# Hacking-Station Official Handshake

# Wait for the audio server (Pipewire/Pulse) to fully initialize
sleep 2

# Play the iconic Ubuntu drum flourish
mpv --no-video --volume=80 ~/AI/sounds/startup.ogg

# Station Security Greeting - Official Version
~/AI/speak.sh "Biometric handshake successful. Welcome back, Brother Rodney. Monitoring network traffic. Remember: a silent system is a secure system."
