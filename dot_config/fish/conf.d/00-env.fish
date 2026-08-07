set -g fisher_path $HOME/.local/share/fisher

set -g fish_cursor_default     block blink
set -g fish_cursor_insert      line blink
set -g fish_cursor_visual      block blink
set -g fish_cursor_replace_one underscore blink
set -g fish_cursor_replace     underscore blink
set -g fish_cursor_external    line blink

# Format man pages
set -gx MANROFFOPT "-c"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# environment.d feeds the systemd user manager; sshd/PAM logins never read it, so
# remote shells arrive without any of it. Bridge it: KEYS come from environment.d
# (still the single source of truth) and VALUES from the user manager, already
# expanded. Restricting to declared keys is load-bearing -- it excludes session
# state (TERM, PATH, PWD, DISPLAY, WAYLAND_DISPLAY, NIRI_SOCKET) that would be
# actively wrong in a remote shell.
if status is-login; and not set -q ENVIRONMENT_D
    # find, not a glob: fish errors on a non-matching wildcard, and this config
    # also deploys to machines with no environment.d at all.
    set -l _confs (find $HOME/.config/environment.d -maxdepth 1 -name '*.conf' -type f 2>/dev/null)
    if test (count $_confs) -gt 0
        set -l _keys (string replace -rf '^([A-Za-z_][A-Za-z0-9_]*)=.*$' '$1' -- (cat $_confs 2>/dev/null))
        for _line in (systemctl --user show-environment 2>/dev/null)
            set -l _k (string split -m1 -f1 = -- $_line)
            contains -- $_k $_keys; or continue   # only vars environment.d declares
            set -q $_k; and continue              # never override what is already set
            set -l _v (string split -m1 -f2 = -- $_line)
            string match -q -- "\$'*" $_v; and continue  # skip shell-quoted values
            set -gx $_k $_v
        end
    end
end

# ssh-agent. gcr-ssh-agent.socket only exports SSH_AUTH_SOCK via
# `systemctl --user set-environment`, which sshd/PAM logins never read -- so
# remote sessions (ssh, mosh) arrive without it and git commit signing plus
# git-over-ssh both fail. tmux drops it on attach for the same reason.
# Restore it only when absent or stale, so a forwarded agent still wins.
if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
    set -l _rt $XDG_RUNTIME_DIR
    test -n "$_rt"; or set _rt /run/user/(id -u)
    test -S $_rt/gcr/ssh; and set -gx SSH_AUTH_SOCK $_rt/gcr/ssh
end

set -gx MOSH_SERVER_NETWORK_TMOUT 21600
