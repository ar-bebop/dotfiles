#!/bin/sh
# Runs the missing-tool checklist after every `chezmoi apply`.
#
# dotfiles-doctor is silent when nothing is missing, so a healthy machine sees
# no extra output; a fresh one gets the list of what its new config expects.
#
# Deliberately NOT run_once_ or run_onchange_: the whole point is to re-check
# every time, because tools get uninstalled and features get toggled long after
# the first bootstrap.
#
# run_after_ guarantees this executes once every file has been written, so the
# doctor itself is already in place. The -x guard covers the case where the
# doctor is somehow absent, and the unconditional exit 0 keeps a missing tool
# from ever making `chezmoi apply` look like it failed.
doctor="$HOME/.local/bin/dotfiles-doctor"
[ -x "$doctor" ] && "$doctor"
exit 0
