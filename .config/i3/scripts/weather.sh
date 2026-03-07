#!/bin/bash
# Direct Open-Meteo API - No VPN Caching
WEATHER_JSON=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=28.4769&longitude=-82.5253&current=temperature_2m,is_day&temperature_unit=fahrenheit&forecast_days=1")

# Extract Temp and Is_Day
TEMP=$(echo "$WEATHER_JSON" | grep -oP '"temperature_2m":\K[0-9.]+' | cut -d. -f1)
IS_DAY=$(echo "$WEATHER_JSON" | grep -oP '"is_day":\K[0-9]')

# Icon logic (1 = Day, 0 = Night)
if [ "$IS_DAY" -eq 1 ]; then
    ICON="☀️"
else
    ICON="🌙"
fi

# Clean output: Icon followed by Temp (no signs)
echo "$ICON $TEMP°F"
