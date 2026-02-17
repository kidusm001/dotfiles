#!/bin/bash
# HyprVim Mode Display for Waybar (Event-driven)
# Reads mode from listener state file and formats for Waybar

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
STATE_FILE="$RUNTIME_DIR/hyprvim/waybar-mode-state.json"

# Icon mappings (Nerd Font icons)
ICON_NORMAL=""
ICON_INSERT=""
ICON_VISUAL=""
ICON_VLINE=""

# Color class mappings (for CSS styling)
CLASS_NORMAL="mode-normal"
CLASS_INSERT="mode-insert"
CLASS_VISUAL="mode-visual"
CLASS_VLINE="mode-vline"
CLASS_RESET="mode-reset"

# Check if state file exists and is recent (< 5 seconds old)
if [[ ! -f "$STATE_FILE" ]]; then
    # Listener not running or no state yet
    echo '{"text":"","class":"mode-hidden","tooltip":"HyprVim: Inactive (listener not running)"}'
    exit 0
fi

# Read current mode from state file
MODE=$(jq -r '.mode // "reset"' "$STATE_FILE" 2>/dev/null || echo "reset")

# Format output based on mode
case "$MODE" in
    "NORMAL")
        TEXT="$ICON_NORMAL NORMAL"
        CLASS="$CLASS_NORMAL"
        TOOLTIP="HyprVim: Normal Mode (vim navigation)"
        ;;
    "INSERT")
        TEXT="$ICON_INSERT INSERT"
        CLASS="$CLASS_INSERT"
        TOOLTIP="HyprVim: Insert Mode (typing)"
        ;;
    "VISUAL")
        TEXT="$ICON_VISUAL VISUAL"
        CLASS="$CLASS_VISUAL"
        TOOLTIP="HyprVim: Visual Mode (selection)"
        ;;
    "V-LINE")
        TEXT="$ICON_VLINE V-LINE"
        CLASS="$CLASS_VLINE"
        TOOLTIP="HyprVim: Visual Line Mode"
        ;;
    "reset"|*)
        # Hide indicator when in reset/default mode
        TEXT=""
        CLASS="$CLASS_RESET"
        TOOLTIP="HyprVim: Ready (press Super+Esc to activate)"
        ;;
esac

# Output JSON for Waybar
jq -n \
    --arg text "$TEXT" \
    --arg class "$CLASS" \
    --arg tooltip "$TOOLTIP" \
    '{text: $text, class: $class, tooltip: $tooltip}'

# Ensure output is flushed
exit 0
