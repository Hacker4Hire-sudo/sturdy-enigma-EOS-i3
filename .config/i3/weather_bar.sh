#!/bin/bash
# Fetch fresh GPS-based weather for Spring Hill (Bypasses VPN)
WEATHER_JSON=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=28.4769&longitude=-82.5253&current=temperature_2m,is_day&temperature_unit=fahrenheit&forecast_days=1")

# Extract data
TEMP=$(echo "$WEATHER_JSON" | grep -oP '"temperature_2m":\K[0-9.]+' | cut -d. -f1)
IS_DAY=$(echo "$WEATHER_JSON" | grep -oP '"is_day":\K[0-9]')

# Icon logic (matches your terminal)
if [ "$IS_DAY" -eq 1 ]; then ICON="☀️"; else ICON="🌙"; fi

# Final output for the bar (No signs, as requested)
echo "$ICON $TEMP°F"
