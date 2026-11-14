#!/usr/bin/env bash
# Run hyprlock with this machine's config if it has one (hosts/<name>-hyprlock.conf),
# otherwise the shared ~/.config/hypr/hyprlock.conf. Keep in sync with host.lua.

case "$(cat /sys/class/dmi/id/product_name 2>/dev/null)" in
	"Alienware m17 R5 AMD") host=alienware ;;
	*) host= ;;
esac

conf="$HOME/.config/hypr/hosts/${host}-hyprlock.conf"
if [[ -n "$host" && -f "$conf" ]]; then
	exec hyprlock -c "$conf" "$@"
fi
exec hyprlock "$@"
