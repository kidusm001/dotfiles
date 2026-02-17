#!/bin/bash

nord_status=$(nordvpn status)

if echo "$nord_status" | grep -q "Status: Connected"; then
  country=$(echo "$nord_status" | grep "Country:" | awk '{print $2}')
  server=$(echo "$nord_status" | grep "Current server:" | awk '{print $3}')
  echo "{\"text\": \"󰖂 VPN\", \"tooltip\": \"NordVPN: Connected\nCountry: $country\nServer: $server\", \"class\": \"connected\"}"
elif echo "$nord_status" | grep -q "Status: Disconnected"; then
  echo "{\"text\": \"󰖂 Off\", \"tooltip\": \"NordVPN: Disconnected\", \"class\": \"disconnected\"}"
else
  # Handle other states, e.g., connecting, or if the status command fails
  echo "{\"text\": \"󰖂 ?\", \"tooltip\": \"NordVPN: Status Unknown\", \"class\": \"unknown\"}"
fi