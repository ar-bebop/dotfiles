set -g fisher_path $HOME/.local/share/fisher

set -g fish_cursor_default     line blink
set -g fish_cursor_insert      line blink
set -g fish_cursor_visual      block blink
set -g fish_cursor_replace_one underscore blink
set -g fish_cursor_replace     underscore blink
set -g fish_cursor_external    line blink

# Format man pages
set -gx MANROFFOPT "-c"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
