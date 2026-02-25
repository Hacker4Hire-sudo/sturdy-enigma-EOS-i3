#!/usr/bin/env bash
# Background weather updater for hacker4hire

CACHE_FILE="/home/hacker4hire/.cache/weather.txt"
LAT="28.4769"
LON="-82.5253"

update_weather() {
    WEATHER_JSON=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,is_day&temperature_unit=fahrenheit&forecast_days=1")
    if [ $? -eq 0 ]; then
        TEMP=$(echo "$WEATHER_JSON" | grep -oP '"temperature_2m":\K[0-9.]+' | cut -d. -f1)
        IS_DAY=$(echo "$WEATHER_JSON" | grep -oP '"is_day":\K[0-9]')
        if [ "$IS_DAY" -eq 1 ]; then ICON="☀️"; else ICON="🌙"; fi
        echo -e "\e[1;36m$ICON  $TEMP°F\e[0m" > "$CACHE_FILE"
    fi
}

# Run update
update_weather
