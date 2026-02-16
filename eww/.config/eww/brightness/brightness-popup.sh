#!/bin/sh

# File used as a lock/signal for the popup's visibility
FILE_LOCK="$HOME/.cache/eww.brightnesspopup"
# Configuration directory for the brightness Eww widget
CONFIG_DIR="$HOME/.config/eww/brightness"
# Eww executable path
EWW_EXEC=$(which eww)
# Name of the Eww window to control (must match your eww.yuck)
BRIGHTNESS_WIDGET_NAME="brightness_widget_window"
# Full path to the timeout script
TIMEOUT_SCRIPT_PATH="$CONFIG_DIR/brightness-popup2.sh"

# Ensure Eww daemon is running.
# If not, start it with the specific brightness configuration.
if ! pgrep -x eww > /dev/null; then
    ${EWW_EXEC} --config "$CONFIG_DIR" daemon
    sleep 0.1 # Give the daemon a moment to initialize
fi

# Function to open the Eww brightness widget
open_brightness_widget() {
    ${EWW_EXEC} --config "$CONFIG_DIR" open "$BRIGHTNESS_WIDGET_NAME"
}

# If the lock file does not exist, it means the popup is not currently active.
# So, create the lock file, open the widget.
if [ ! -f "$FILE_LOCK" ]; then
    touch "$FILE_LOCK"
    open_brightness_widget
else
    # If the lock file exists, the widget is likely open and its timer is running.
    # Kill the existing timeout script to reset the timer.
    # pkill -f will find processes by the script name.
    pkill -f "$(basename "$TIMEOUT_SCRIPT_PATH")"
fi

# Start (or restart) the timeout script in the background
"$TIMEOUT_SCRIPT_PATH" &