set -g fisher_path $HOME/.local/share/fisher

# Format man pages
set -gx MANROFFOPT "-c"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
