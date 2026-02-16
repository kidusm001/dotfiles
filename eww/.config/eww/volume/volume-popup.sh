#!/bin/sh

FILE="$HOME/.cache/eww.volumepopup"
CFG="$HOME/.config/eww/volume"
EWW=$(which eww) # Changed from backticks to $()
WIDGET_NAME="my-widget"
TIMEOUT_SCRIPT_PATH="$CFG/volume-popup2.sh" # Assuming volume-popup2.sh is in the CFG directory

# Ensure Eww daemon is running and aware of this config
# If an eww process is not running, start it with the specific config.
# If it is running, subsequent eww --config commands should target it.
if ! pgrep -x eww > /dev/null; then
	${EWW} --config "$CFG" daemon # Ensure daemon starts with this config context
	sleep 0.1 # Give daemon a moment to start
fi

run_eww() {
	${EWW} --config "$CFG" open "$WIDGET_NAME"
}

# If the popup is active (signaled by FILE or running timeout script), reset the timer.
# Otherwise, show the popup and start the timer.

if [ ! -f "$FILE" ]; then
	touch "$FILE"
	run_eww # Opens the widget
	# The case statement for hyprctl activewindow seemed to always call run_eww.
	# If specific monitor logic is needed beyond what Eww's Yuck config provides,
	# it can be re-added here. For now, run_eww handles opening.
else
	# If FILE exists, it means the widget is likely open and its timer is running.
	# Kill the existing timer to reset it.
	pkill -f "$(basename "$TIMEOUT_SCRIPT_PATH")" # Kill existing timeout script
fi

# Start (or restart) the timeout script
"$TIMEOUT_SCRIPT_PATH" &
