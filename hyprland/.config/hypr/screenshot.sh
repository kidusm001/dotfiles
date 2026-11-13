#!/usr/bin/env bash
set -euo pipefail

fail() {
	printf 'Screenshot failed: %s\n' "$1" >&2
	notify-send -a Screenshot -u critical "Screenshot failed" "$1" ||
		printf 'Could not display the error notification.\n' >&2
	exit 1
}

capture_args=()
case "${1:-}" in
	region)
		# Cancelling the selection leaves the clipboard and screenshot folder untouched.
		geometry=$(slurp) || exit "$?"
		[[ -n "$geometry" ]] || fail "The selected region is empty."
		capture_args=(-g "$geometry")
		;;
	all)
		;;
	*)
		fail "Expected screenshot mode: region or all."
		;;
esac

directory="$HOME/Pictures/Screenshots"
mkdir -p "$directory" || fail "Could not create $directory."
filename=$(date +%Y%m%d-%H%M%S-%N) || fail "Could not generate a screenshot filename."
file="$directory/$filename.png"

grim "${capture_args[@]}" "$file" || fail "Could not capture the screenshot."
wl-copy --type image/png < "$file" || fail "Saved to $file, but could not copy the image to the clipboard."
notify-send -a Screenshot -t 5000 -i "$file" \
	"Screenshot saved" "Saved to $file and copied to the clipboard."
