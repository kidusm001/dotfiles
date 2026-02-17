#!/bin/bash

# Ensure hyprsunset service is running
systemctl --user start hyprsunset.service

# Check if service started successfully
if ! systemctl --user is-active --quiet hyprsunset.service; then
    echo "Failed to start hyprsunset service"
    exit 1
fi

# Enable or disable blue light filter
case "$1" in
    enable)
        TEMP=${2:-2550}  # Default to 2550K if no temperature provided
        hyprctl hyprsunset temperature "$TEMP"
        if [ $? -eq 0 ]; then
            echo "Blue light filter enabled with temperature $TEMP"
        else
            echo "Failed to enable blue light filter"
            exit 1
        fi
        ;;
    disable)
        hyprctl hyprsunset identity
        if [ $? -eq 0 ]; then
            echo "Blue light filter disabled"
        else
            echo "Failed to disable blue light filter"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {enable [temperature]|disable}"
        exit 1
        ;;
esac
