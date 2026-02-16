#!/bin/sh

# File used as a lock/signal for the popup's visibility
FILE_LOCK="$HOME/.cache/eww.brightnesspopup"
# Configuration directory for the brightness Eww widget
CONFIG_DIR="$HOME/.config/eww/brightness"
# Eww executable path
EWW_EXEC=$(which eww)
# Name of the Eww window to control (must match your eww.yuck)
BRIGHTNESS_WIDGET_NAME="brightness_widget_window"
# Duration in seconds before the popup closes automatically
TIMEOUT_DURATION="2"

# Wait for the specified duration
sleep "$TIMEOUT_DURATION"

# Only close the widget and remove the lock file if the lock file still exists
# This prevents closing if the popup was re-triggered (timer reset)
if [ -f "$FILE_LOCK" ]; then
  rm "$FILE_LOCK"
  ${EWW_EXEC} --config "$CONFIG_DIR" close "$BRIGHTNESS_WIDGET_NAME"
fi