#!/usr/bin/env python3
"""
HyprVim Mode Listener - Listens to Hyprland socket2 for submap changes
Writes current mode to a state file for Waybar to read
"""

import socket
import os
import json
import sys
from pathlib import Path

# Configuration
RUNTIME_DIR = os.getenv("XDG_RUNTIME_DIR", "/tmp")
STATE_FILE = Path(RUNTIME_DIR) / "hyprvim" / "waybar-mode-state.json"
HYPR_INSTANCE_SIG = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")

if not HYPR_INSTANCE_SIG:
    print("ERROR: HYPRLAND_INSTANCE_SIGNATURE not set", file=sys.stderr)
    sys.exit(1)

SOCKET_PATH = f"{RUNTIME_DIR}/hypr/{HYPR_INSTANCE_SIG}/.socket2.sock"

# Mode mappings
MODE_MAP = {
    "": "reset",  # Default/reset mode
    "NORMAL": "NORMAL",
    "INSERT": "INSERT",
    "VISUAL": "VISUAL",
    "V-LINE": "V-LINE",
    "D-MOTION": "NORMAL",  # Operator modes show as NORMAL
    "C-MOTION": "NORMAL",
    "Y-MOTION": "NORMAL",
    "G-MOTION": "NORMAL",
    "G-VISUAL": "VISUAL",
    "R-CHAR": "NORMAL",
    "SET-MARK": "NORMAL",
    "JUMP-MARK": "NORMAL",
    "GET-REGISTER": "NORMAL",
}


def write_state(mode):
    """Write current mode to state file"""
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)

    # Map internal submap names to display modes
    display_mode = MODE_MAP.get(mode, "NORMAL")

    state = {
        "mode": display_mode,
        "raw_submap": mode,
    }

    # Atomic write
    tmp_file = STATE_FILE.with_suffix(".tmp")
    with open(tmp_file, "w") as f:
        json.dump(state, f)
    tmp_file.replace(STATE_FILE)

    print(f"Mode changed: {mode} -> {display_mode}", file=sys.stderr)


def main():
    print(f"Connecting to Hyprland socket: {SOCKET_PATH}", file=sys.stderr)

    # Initialize with reset mode
    write_state("")

    sock = None
    try:
        # Connect to Hyprland event socket
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(SOCKET_PATH)
        print("Connected to Hyprland socket2", file=sys.stderr)

        buffer = ""

        while True:
            # Read data from socket
            data = sock.recv(4096).decode("utf-8")

            if not data:
                print("Socket closed, reconnecting...", file=sys.stderr)
                break

            buffer += data

            # Process complete lines
            while "\n" in buffer:
                line, buffer = buffer.split("\n", 1)

                # Parse event format: "EVENT>>DATA"
                if ">>" in line:
                    event, data = line.split(">>", 1)

                    # Handle submap events
                    if event == "submap":
                        write_state(data)

    except KeyboardInterrupt:
        print("\nShutting down gracefully...", file=sys.stderr)
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        if sock:
            sock.close()


if __name__ == "__main__":
    main()
