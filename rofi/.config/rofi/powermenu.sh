#!/bin/bash

options="Shutdown\0icon\x1fsystem-shutdown\nReboot\0icon\x1fsystem-reboot\nSuspend\0icon\x1fsystem-suspend\nLogout\0icon\x1fsystem-log-out\nLock\0icon\x1fsystem-lock-screen\nCancel\0icon\x1fdialog-cancel"

chosen=$(echo -e "$options" | rofi -dmenu -i -theme ~/.config/rofi/power.rasi -p "Power Menu")

case $chosen in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Lock)
        hyprlock
        ;;
    Cancel)
        exit 0
        ;;
esac
