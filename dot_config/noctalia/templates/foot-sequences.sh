#!/usr/bin/env bash
set -euo pipefail

# This file is intended to be rendered by Noctalia before it is run.
# It mirrors the local foot template so already-open terminals match new ones.

foreground="{{colors.on_surface.default.hex_stripped}}"
background="{{colors.surface.default.hex_stripped}}"
selection_background="{{colors.tertiary.default.hex_stripped}}"
selection_foreground="{{colors.on_tertiary.default.hex_stripped}}"

regular0="{{colors.surface_variant.default.hex_stripped}}"
regular1="{{colors.error.default.hex_stripped}}"
regular2="{{colors.primary.default.hex_stripped}}"
regular3="{{colors.secondary.default.hex_stripped}}"
regular4="{{colors.tertiary.default.hex_stripped}}"
regular5="{{colors.primary_fixed_dim.default.hex_stripped}}"
regular6="{{colors.secondary_fixed_dim.default.hex_stripped}}"
regular7="{{colors.on_surface.default.hex_stripped}}"

bright0="{{colors.on_surface_variant.default.hex_stripped}}"
bright1="{{colors.error.default.hex_stripped}}"
bright2="{{colors.primary.default.hex_stripped}}"
bright3="{{colors.secondary.default.hex_stripped}}"
bright4="{{colors.tertiary.default.hex_stripped}}"
bright5="{{colors.primary_fixed_dim.default.hex_stripped}}"
bright6="{{colors.secondary_fixed_dim.default.hex_stripped}}"
bright7="{{colors.on_surface.default.hex_stripped}}"

osc_color() {
    local color="${1#\#}"

    [[ "$color" =~ ^[[:xdigit:]]{6}$ ]] || return 1
    printf 'rgb:%s/%s/%s' "${color:0:2}" "${color:2:2}" "${color:4:2}"
}

append_osc() {
    local code="$1"
    local color
    local chunk

    color="$(osc_color "$2")" || return 0
    printf -v chunk '\033]%s;%s\033\\' "$code" "$color"
    seq+="$chunk"
}

append_palette() {
    local index="$1"
    local color
    local chunk

    color="$(osc_color "$2")" || return 0
    printf -v chunk '\033]4;%s;%s\033\\' "$index" "$color"
    seq+="$chunk"
}

seq=""
append_osc 10 "$foreground"
append_osc 11 "$background"
append_osc 17 "$selection_background"
append_osc 19 "$selection_foreground"

regular=(
    "$regular0"
    "$regular1"
    "$regular2"
    "$regular3"
    "$regular4"
    "$regular5"
    "$regular6"
    "$regular7"
)

bright=(
    "$bright0"
    "$bright1"
    "$bright2"
    "$bright3"
    "$bright4"
    "$bright5"
    "$bright6"
    "$bright7"
)

for i in "${!regular[@]}"; do
    append_palette "$i" "${regular[$i]}"
done

for i in "${!bright[@]}"; do
    append_palette "$((i + 8))" "${bright[$i]}"
done

[[ -n "$seq" ]] || exit 0

declare -A targets=()

for environ in /proc/[0-9]*/environ; do
    pid="${environ#/proc/}"
    pid="${pid%/environ}"

    [[ -r "$environ" ]] || continue

    if ! awk 'BEGIN { RS = "\0" } /^TERM=foot(-|$)/ { found = 1; exit } END { exit !found }' "$environ" 2>/dev/null; then
        continue
    fi

    for fd in 1 2; do
        target="$(readlink "/proc/$pid/fd/$fd" 2>/dev/null || true)"
        [[ "$target" == /dev/pts/* ]] || continue
        [[ -w "$target" ]] || continue
        targets["$target"]=1
    done
done

for target in "${!targets[@]}"; do
    printf '%s' "$seq" > "$target" 2>/dev/null || true
done
