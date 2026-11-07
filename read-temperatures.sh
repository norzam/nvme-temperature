#!/usr/bin/env bash
for sensor in /sys/class/hwmon/hwmon*; do
  [[ $(cat "$sensor/name" 2>/dev/null) == nvme ]] || continue
  controller=$(basename "$(readlink -f "$sensor/device")")
  [[ $controller =~ ^nvme[0-9]+$ ]] || continue
  if read -r temperature < "$sensor/temp1_input" && [[ $temperature =~ ^-?[0-9]+$ ]]; then
    printf '%s %s\n' "$controller" "$temperature"
  fi
done | sort -V
