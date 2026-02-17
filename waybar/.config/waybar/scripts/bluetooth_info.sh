#!/usr/bin/env python3

import dbus
import json
import sys


def get_bluetooth_status():
    try:
        bus = dbus.SystemBus()
        # Get the Object Manager interface on the root object path
        manager = dbus.Interface(
            bus.get_object("org.bluez", "/"), "org.freedesktop.DBus.ObjectManager"
        )
        objects = manager.GetManagedObjects()
    except Exception as e:
        # DBus error usually means bluetoothd is not running or permissions issue
        print(
            json.dumps(
                {
                    "text": "󰂲",
                    "tooltip": "Bluetooth Off (Service Error)",
                    "class": "off",
                }
            )
        )
        return

    # Variables to track state
    connected_device_props = None
    battery_percentage = None
    device_name = "Unknown"
    device_address = ""
    is_powered_on = False  # Start assuming off until proven otherwise by adapter check

    # 1. Check Adapter Power Status First
    # Iterate through all objects to find an Adapter1 interface
    for path, interfaces in objects.items():
        if "org.bluez.Adapter1" in interfaces:
            adapter_props = interfaces["org.bluez.Adapter1"]
            if adapter_props.get("Powered") == 1:
                is_powered_on = True
                break  # Found adapter, stop looking for power state

    # 2. Iterate through all managed objects to find a connected device
    for path, interfaces in objects.items():
        if "org.bluez.Device1" in interfaces:
            device_props = interfaces["org.bluez.Device1"]

            # Check connection status
            # dbus-python returns dbus.Boolean(1) for true, so direct check works
            if device_props.get("Connected"):
                connected_device_props = device_props
                device_name = str(
                    device_props.get(
                        "Alias", device_props.get("Name", "Unknown Device")
                    )
                )
                device_address = str(device_props.get("Address", ""))

                # Check for Battery info on the SAME object path
                if "org.bluez.Battery1" in interfaces:
                    battery_props = interfaces["org.bluez.Battery1"]
                    # dbus.Byte wraps the percentage, cast to int
                    try:
                        percentage_val = battery_props.get("Percentage")
                        if percentage_val is not None:
                            battery_percentage = int(percentage_val)
                    except:
                        pass

                break  # Stop at first connected device

    # Construct Output JSON for Waybar
    if connected_device_props:
        text = f" {device_name}"
        tooltip = f"Connected: {device_name} ({device_address})"

        if battery_percentage is not None:
            text += f" {battery_percentage}%"
            tooltip += f"\nBattery: {battery_percentage}%"

        print(
            json.dumps(
                {
                    "text": text,
                    "tooltip": tooltip,
                    "class": "connected",
                    "percentage": battery_percentage
                    if battery_percentage is not None
                    else 0,
                }
            )
        )
    elif is_powered_on:
        print(
            json.dumps(
                {
                    "text": "",
                    "tooltip": "Bluetooth On (Disconnected)",
                    "class": "disconnected",
                }
            )
        )
    else:
        print(json.dumps({"text": "󰂲", "tooltip": "Bluetooth Off", "class": "off"}))


if __name__ == "__main__":
    try:
        get_bluetooth_status()
    except Exception as e:
        # Fallback error output
        print(
            json.dumps({"text": " err", "tooltip": f"Error: {str(e)}", "class": "off"})
        )
