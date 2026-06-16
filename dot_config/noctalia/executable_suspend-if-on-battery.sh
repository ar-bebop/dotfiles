#!/bin/sh
# Idle-suspend guard for noctalia: suspend ONLY when on battery.
# If any AC mains adapter is plugged in (online=1), do nothing.
for ps in /sys/class/power_supply/*; do
    [ "$(cat "$ps/type" 2>/dev/null)" = "Mains" ] || continue
    [ "$(cat "$ps/online" 2>/dev/null)" = "1" ] && exit 0  # on AC -> skip suspend
done
systemctl suspend || loginctl suspend
