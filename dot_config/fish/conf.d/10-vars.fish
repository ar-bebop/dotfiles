# vi mode
set -U fish_key_bindings fish_vi_key_bindings
set -g fish_cursor_default     block blink
set -g fish_cursor_insert      line blink
set -g fish_cursor_visual      block blink
set -g fish_cursor_replace_one underscore blink
set -g fish_cursor_replace     underscore blink
set -g fish_cursor_external    line blink

# fisher
set -g fisher_path $XDG_DATA_HOME/fisher

# pure
set -U pure_symbol_prompt '$'
set -U pure_enable_single_line_prompt true
set -U fish_transient_prompt 1
set -U pure_show_prefix_root_prompt true
set -U pure_symbol_container_prefix '📦 '
set -U pure_color_username_normal green
set -U pure_color_hostname cyan

# done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low
