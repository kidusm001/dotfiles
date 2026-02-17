#!/bin/bash

if [ "$(playerctl --player=spotify status 2>/dev/null)" = "Playing" ]; then
    STATUS="▶"
elif [ "$(playerctl --player=spotify status 2>/dev/null)" = "Paused" ]; then
    STATUS="⏸"
else
    STATUS="⏹"
fi

ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)
TITLE=$(playerctl --player=spotify metadata title 2>/dev/null)

if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
    echo "{\"text\": \"$STATUS $ARTIST - $TITLE\", \"class\": \"spotify\", \"tooltip\": \"Click to play/pause\"}"
else
    echo "{\"text\": \"No Spotify\", \"class\": \"no-spotify\"}"
fi
