#!/bin/sh
# Recolour open foot windows; foot never reloads its config
osc=$(cat "$HOME/.cache/noctalia/foot-osc") || exit 1
seqs=$(printf '\033]%s\033\\' $osc) # unquoted: one sequence per line

# Each window's pty is the controlling tty of a direct child of foot (server or standalone)
pids=$(pgrep -d, -x foot) || exit 0
for tty in $(ps -o tty= --ppid "$pids" | sort -u); do
    case $tty in pts/*) printf %s "$seqs" >"/dev/$tty" ;; esac
done
