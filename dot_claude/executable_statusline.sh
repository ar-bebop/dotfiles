#!/bin/sh
# Claude Code statusline
# Left: folder, git branch. Right: thinking, effort, context, rate limits, model.
# Uses the 16 ANSI colours so it follows the terminal theme.

INPUT=$(cat)
j() { printf '%s' "$INPUT" | jq -r "$1" 2>/dev/null; }

ESC=$(printf '\033')
R="${ESC}[0m"
DIM="${ESC}[2m"

# Separator between items on the right
SEP_COL="${DIM} · ${R}"
SEP_PLAIN=" · "

# Colour for a percentage: green below 50, yellow below 80, then red
pct_color() {
  if   [ "$1" -ge 80 ]; then printf '31'
  elif [ "$1" -ge 50 ]; then printf '33'
  else printf '32'
  fi
}

# Time left until an epoch timestamp: 3d4h, 1h23m, 12m or now
fmt_eta() {
  [ -z "$1" ] && return
  local rem d h m
  rem=$(( $1 - $(date +%s) ))
  [ "$rem" -le 0 ] && { printf 'now'; return; }
  d=$(( rem / 86400 )); h=$(( (rem % 86400) / 3600 )); m=$(( (rem % 3600) / 60 ))
  if   [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"
  else printf '%dm' "$m"
  fi
}

# Rate limit: $1 label, $2 percent used, $3 reset time (epoch)
add_ratelimit() {
  local pct="${2%.*}" c eta col plain
  [ -z "$pct" ] && return
  c=$(pct_color "$pct")
  eta=$(fmt_eta "$3")
  col="${ESC}[${c}m${1} ${pct}%${R}"
  plain="${1} ${pct}%"
  if [ -n "$eta" ]; then col="$col ${DIM}${eta}${R}"; plain="$plain $eta"; fi
  add_right "$col" "$plain"
}

# Each side keeps a coloured and a plain copy; the plain one measures the width
L_COL=""; L_PLAIN=""
R_COL=""; R_PLAIN=""
add_left()  { [ -z "$2" ] && return
  [ -n "$L_PLAIN" ] && { L_COL="$L_COL ";        L_PLAIN="$L_PLAIN "; }
  L_COL="$L_COL$1"; L_PLAIN="$L_PLAIN$2"; }
add_right() { [ -z "$2" ] && return
  [ -n "$R_PLAIN" ] && { R_COL="$R_COL$SEP_COL"; R_PLAIN="$R_PLAIN$SEP_PLAIN"; }
  R_COL="$R_COL$1"; R_PLAIN="$R_PLAIN$2"; }

# Left: folder, with ~ for home
DIR=$(j '.workspace.current_dir // .cwd // empty')
DISPLAY_DIR="$DIR"
case "$DIR" in
  "$HOME")   DISPLAY_DIR="~" ;;
  "$HOME"/*) DISPLAY_DIR="~/${DIR#$HOME/}" ;;
esac
add_left "${ESC}[34m${DISPLAY_DIR}${R}" "$DISPLAY_DIR"

# Git branch, * when there are uncommitted changes
if [ -n "$DIR" ] && git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git -C "$DIR" symbolic-ref --quiet --short HEAD 2>/dev/null \
           || git -C "$DIR" rev-parse --short HEAD 2>/dev/null)
  DIRTY=""
  git -C "$DIR" diff --quiet --ignore-submodules HEAD 2>/dev/null || DIRTY="*"
  if [ -n "$BRANCH" ]; then
    add_left "${ESC}[32m ${BRANCH}${DIRTY}${R}" " ${BRANCH}${DIRTY}"
  fi
fi

# Right: thinking, when on
[ "$(j '.thinking.enabled // false')" = "true" ] && add_right "${ESC}[36mthink${R}" "think"

# Effort level, when the model has one
EFFORT=$(j '.effort.level // empty')
[ -n "$EFFORT" ] && add_right "${ESC}[35meffort:${EFFORT}${R}" "effort:${EFFORT}"

# Context used: bar and percent, !200k past 200k tokens
CTX=$(j '.context_window.used_percentage // empty'); CTX="${CTX%.*}"
if [ -n "$CTX" ]; then
  BW=8
  filled=$(( CTX * BW / 100 ))
  [ "$filled" -gt "$BW" ] && filled=$BW; [ "$filled" -lt 0 ] && filled=0
  bar=""; i=0
  while [ "$i" -lt "$filled" ]; do bar="${bar}▰"; i=$((i+1)); done
  while [ "$i" -lt "$BW" ];     do bar="${bar}▱"; i=$((i+1)); done
  c=$(pct_color "$CTX")
  cx_col="${ESC}[${c}mctx ${bar} ${CTX}%${R}"
  cx_plain="ctx ${bar} ${CTX}%"
  if [ "$(j '.exceeds_200k_tokens // false')" = "true" ]; then
    cx_col="$cx_col ${ESC}[1;31m!200k${R}"; cx_plain="$cx_plain !200k"
  fi
  add_right "$cx_col" "$cx_plain"
fi

# Rate limits (subscriptions only, after the first request)
add_ratelimit "5h" "$(j '.rate_limits.five_hour.used_percentage // empty')" "$(j '.rate_limits.five_hour.resets_at // empty')"
add_ratelimit "7d" "$(j '.rate_limits.seven_day.used_percentage // empty')" "$(j '.rate_limits.seven_day.resets_at // empty')"

# Model
MODEL=$(j '.model.display_name // empty')
add_right "${ESC}[90m${MODEL}${R}" "$MODEL"

# Render, right-aligned to $COLUMNS (set by Claude Code)
MARGIN=3  # Claude Code pads the right edge; raise if the model name gets cut
COLS=$(( ${COLUMNS:-80} - MARGIN ))
GAP=$(( COLS - ${#L_PLAIN} - ${#R_PLAIN} ))
[ "$GAP" -lt 1 ] && GAP=1
printf '%s%*s%s' "$L_COL" "$GAP" "" "$R_COL"
