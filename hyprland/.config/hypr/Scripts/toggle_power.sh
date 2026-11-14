#!/bin/bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"

# 1. Read the active power profile
CURRENT_PROFILE=$(cat "$PROFILE_FILE")

# 2. Determine the new profile target
if [ "$CURRENT_PROFILE" = "balanced" ]; then
    NEW_PROFILE="performance"
    ICON="speedometer"  # Icon for performance mode
else
    NEW_PROFILE="balanced"
    ICON="battery"      # Icon for balanced mode
fi

# 3. Apply the change using sudo (passwordless via sudoers config below)
echo "$NEW_PROFILE" | sudo tee "$PROFILE_FILE" > /dev/null

# 4. Send visual desktop notification
if command -v notify-send &> /dev/null; then
    notify-send "Power Profile Changed" "System is now running in $NEW_PROFILE mode." -i "$ICON" -u normal
fi

echo "System switched to $NEW_PROFILE"
