#!/bin/bash

# Configuration
LOCATION="Spring+Hill+Florida"
UNITS="u" # Imperial (Fahrenheit)

# Fetch weather data
# %S = Sunrise, %s = Sunset, %T = Local current time, %t = Temperature, %C = Condition
weather_info=$(curl -s "wttr.in/${LOCATION}?format=%S+%s+%T+%t+%C&${UNITS}")

if [[ -z "$weather_info" || "$weather_info" == *"Error"* || "$weather_info" == *"Wait"* ]]; then
    echo "Weather Unavailable"
    exit 0
fi

# Parse components
# Example output: 07:44:01 19:35:49 15:23:31-0400 +88°F Sunny
sunrise=$(echo "$weather_info" | awk '{print $1}')
sunset=$(echo "$weather_info" | awk '{print $2}')
# Extract local time (strip timezone offset if present)
local_time=$(echo "$weather_info" | awk '{print $3}' | sed 's/[-+].*//')
temp=$(echo "$weather_info" | awk '{print $4}' | sed -E 's/[\+\-]//g; s/°[FC]/°/g')
condition=$(echo "$weather_info" | cut -d' ' -f5-)

# Helper to convert HH:MM:SS to seconds for comparison
to_seconds() {
    IFS=: read -r h m s <<< "$1"
    # Use 10# to force base 10 (avoid octal issues with leading zeros)
    echo $((10#$h * 3600 + 10#$m * 60 + 10#$s))
}

curr_sec=$(to_seconds "$local_time")
rise_sec=$(to_seconds "$sunrise")
set_sec=$(to_seconds "$sunset")

if (( curr_sec >= rise_sec && curr_sec < set_sec )); then
    is_day=true
else
    is_day=false
fi

# Icon Mapping (Font Awesome 6 Solid codes)
# Sun: \uf185, Moon: \uf186, Cloud: \uf0c2, Rain: \uf73d, Fog/Smog: \uf75f, Wind: \uf72e, Snowflake: \uf2dc, Cloud-Bolt: \uf76c
case "$condition" in
    "Clear" | "Sunny")
        if [ "$is_day" = true ]; then
            icon=$(printf "\uF185") # sun
        else
            icon=$(printf "\uF186") # moon
        fi
        ;;
    "Partly cloudy")
        if [ "$is_day" = true ]; then
            icon=$(printf "\uF6C4") # cloud-sun
        else
            icon=$(printf "\uF6C3") # cloud-moon
        fi
        ;;
    "Cloudy" | "Overcast" | "Mostly cloudy")
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
        if [ "$is_day" = true ]; then
            icon=$(printf "\uF185")
        else
            icon=$(printf "\uF186")
        fi
        ;;
esac

echo "$icon $temp"
