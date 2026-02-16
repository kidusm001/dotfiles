#!/bin/sh

FILE="$HOME/.cache/eww.volumepopup"
CFG="$HOME/.config/eww/volume"
EWW=$(which eww) # Changed from backticks to $()
WIDGET_NAME="my-widget"
TIMEOUT_DURATION="2" # Seconds - adjust as needed (was 1s)

sleep "$TIMEOUT_DURATION"

# Only close and remove lock file if it still exists
# (i.e., the timer wasn't reset by another key press)
if [ -f "$FILE" ]; then
  rm "$FILE"
  ${EWW} --config "$CFG" close "$WIDGET_NAME"
fi
