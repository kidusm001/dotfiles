#!/bin/bash
# HyprVim Mode Display for Waybar (Polling-based detection)
# Infers current vim mode from various indicators

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
HYPRVIM_DIR="$RUNTIME_DIR/hyprvim"

# Icon mappings
ICON_NORMAL=""
ICON_ACTIVE=""

# Check if hyprvim is even active
# Look for hyprvim state directory activity
if [[ ! -d "$HYPRVIM_DIR" ]]; then
    # HyprVim not initialized
    echo '{"text":"","class":"mode-hidden","tooltip":"HyprVim: Not active"}'
    exit 0
fi

# Detection logic - check various indicators
MODE="UNKNOWN"
CLASS="mode-hidden"
TOOLTIP="HyprVim: Ready"

# Check for active hyprvim prompt windows (indicates active vim session)
ACTIVE_WINDOW=$(hyprctl -j activewindow 2>/dev/null)
if [[ -n "$ACTIVE_WINDOW" ]]; then
    ACTIVE_CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class // ""')
    
    if [[ "$ACTIVE_CLASS" =~ hyprvim-find|hyprvim-command|hyprvim-open-vim|floating-help ]]; then
        # Special hyprvim window is active
        MODE="ACTIVE"
        CLASS="mode-normal"
        TOOLTIP="HyprVim: Prompt Active"
    fi
fi

# Check find state (recent activity = likely in visual/navigation mode)
FIND_STATE="$HYPRVIM_DIR/find-state.json"
if [[ -f "$FIND_STATE" ]]; then
    FIND_ACTIVE=$(jq -r '.active // "false"' "$FIND_STATE" 2>/dev/null || echo "false")
    if [[ "$FIND_ACTIVE" == "true" ]]; then
        MODE="ACTIVE"
        CLASS="mode-normal"
        TOOLTIP="HyprVim: Search Active"
    fi
fi

# Check for recent register activity (file modified recently)
REGISTER_DIR="$HYPRVIM_DIR/registers"
if [[ -d "$REGISTER_DIR" ]]; then
    # Check if any file was modified in the last 3 seconds
    RECENT_FILES=$(find "$REGISTER_DIR" -type f -mtime -3s 2>/dev/null | wc -l)
    if [[ $RECENT_FILES -gt 0 ]]; then
        MODE="ACTIVE"
        CLASS="mode-normal"
        TOOLTIP="HyprVim: Register Active"
    fi
fi

# If still unknown, assume ready but not active
if [[ "$MODE" == "UNKNOWN" ]]; then
    MODE="READY"
    CLASS="mode-hidden"
    TOOLTIP="HyprVim: Ready (Super+Esc to activate)"
fi

# Format output based on detection
case "$MODE" in
    "ACTIVE")
        TEXT="$ICON_ACTIVE VIM"
        CLASS="mode-normal"
        ;;
    "READY"|*)
        # Hide when not actively in use
        TEXT=""
        CLASS="mode-hidden"
        ;;
esac

# Output JSON for Waybar
jq -n \
    --arg text "$TEXT" \
    --arg class "$CLASS" \
    --arg tooltip "$TOOLTIP" \
    '{text: $text, class: $class, tooltip: $tooltip}'
