#!/usr/bin/env bash

# Location (optional: auto-detect if omitted)
LOCATION="${1:-}"

# F = no forecast, q = quiet, m = metric, u = SI units
WTTR_PARAMS="Fqu"

# c    Weather condition,
# C    Weather condition textual name,
# x    Weather condition, plain-text symbol,
# h    Humidity,
# t    Temperature (Actual),
# f    Temperature (Feels Like),
# w    Wind,
# l    Location,
# m    Moon phase 🌑🌒🌓🌔🌕🌖🌗🌘,
# M    Moon day,
# p    Precipitation (mm/3 hours),
# P    Pressure (hPa),
# u    UV index (1-12),
#
# D    Dawn*,
# S    Sunrise*,
# z    Zenith*,
# s    Sunset*,
# d    Dusk*,
# T    Current time*,
# Z    Local timezone.
# WTTR_FORMAT="format=+%c+%t"
WTTR_FORMAT="format=1" # same as +%c+%t

# Get weather data from wttr.in
WEATHER=$(curl -s "wttr.in/${LOCATION}?${WTTR_FORMAT}&${WTTR_PARAMS}")

# Print output (Waybar will read this line)
echo "$WEATHER"
