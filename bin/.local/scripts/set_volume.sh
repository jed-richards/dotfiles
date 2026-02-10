#!/usr/bin/env bash

VOLUME=${1:-30} # default to 30% if no volume is given

if system_profiler SPAudioDataType | grep -A 5 "Scarlett Solo USB" | grep -q "Default Output Device: Yes"; then
    # Scarlett Focusrite is the current audio output, so do nothing
    exit 0
else
    # Otherwise, set the volume
    osascript -e "set volume output volume ${VOLUME}"
fi
