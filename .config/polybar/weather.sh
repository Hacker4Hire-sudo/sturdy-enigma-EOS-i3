#!/bin/bash

# Configuration
# Coordinates for Spring Hill, FL (found via Nominatim)
LAT="28.4635"
LON="-82.5363"
# Weather.gov grid points for these coordinates
GRID_ENDPOINT="https://api.weather.gov/gridpoints/TBW/66,120/forecast/hourly"
USER_AGENT="Polybar-Weather-Script (Gemini-CLI)"

# Fetch weather data
weather_json=$(curl -s -H "User-Agent: $USER_AGENT" "$GRID_ENDPOINT")

if [[ -z "$weather_json" || "$weather_json" == *"error"* ]]; then
    echo "Weather Unavailable"
    exit 0
fi

# Parse components using jq
# Extract the first period (current)
current_period=$(echo "$weather_json" | jq -c '.properties.periods[0]' 2>/dev/null)

if [[ -z "$current_period" || "$current_period" == "null" ]]; then
    echo "Weather Unavailable"
    exit 0
fi

is_day=$(echo "$current_period" | jq -r '.isDaytime')
temp=$(echo "$current_period" | jq -r '.temperature')
condition=$(echo "$current_period" | jq -r '.shortForecast')

# Icon Mapping (Font Awesome 7 Solid codes as seen in config_pill.ini)
# config_pill.ini uses font-1 = "Font Awesome 7 Free:style=Solid:size=14;4"
# Icons used in original script:
# Sun: \uf185, Moon: \uf186, Cloud: \uf0c2, Rain: \uf73d, Fog/Smog: \uf75f, Wind: \uf72e, Snowflake: \uf2dc, Cloud-Bolt: \uf76c

case "$condition" in
    "Clear" | "Sunny" | "Mostly Sunny" | "Mostly Clear")
        if [ "$is_day" = "true" ]; then
            icon=$(printf "\uF185") # sun
        else
            icon=$(printf "\uF186") # moon
        fi
        ;;
    "Partly Cloudy" | "Partly Sunny" | "Scattered Clouds")
        if [ "$is_day" = "true" ]; then
            icon=$(printf "\uF6C4") # cloud-sun
        else
            icon=$(printf "\uF6C3") # cloud-moon
        fi
        ;;
    "Cloudy" | "Overcast" | "Mostly Cloudy")
        icon=$(printf "\uF0C2") # cloud
        ;;
    *"Rain"* | *"Showers"* | *"Drizzle"*)
        icon=$(printf "\uF73D") # cloud-showers-heavy
        ;;
    *"Thunderstorm"* | *"Thundery"*)
        icon=$(printf "\uF76C") # cloud-bolt
        ;;
    "Fog" | "Mist" | "Haze")
        icon=$(printf "\uF75F") # smog
        ;;
    *"Snow"* | *"Sleet"*)
        icon=$(printf "\uF2DC") # snowflake
        ;;
    "Wind" | "Windy" | "Breezy")
        icon=$(printf "\uF72E") # wind
        ;;
    *)
        # Fallback
        if [ "$is_day" = "true" ]; then
            icon=$(printf "\uF185")
        else
            icon=$(printf "\uF186")
        fi
        ;;
esac

echo "$icon ${temp}°F"
