set -g fisher_path $HOME/.local/share/fisher

set -g fish_cursor_default     block blink
set -g fish_cursor_insert      line blink
set -g fish_cursor_visual      block blink
set -g fish_cursor_replace_one underscore blink
set -g fish_cursor_replace     underscore blink
set -g fish_cursor_external    line blink

# Format man pages through bat. Both variables exist only to drive bat, so
# without it leave them unset and let man use its own pager -- pointing
# MANPAGER at a missing binary breaks every man page on the machine.
if command -q bat
    set -gx MANROFFOPT "-c"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# environment.d feeds the systemd user manager; sshd/PAM logins never read it,
# so remote shells arrive without any of it. Bridge it.
#
# KEYS always come from environment.d, which stays the single source of truth
# on every distro. Restricting to declared keys is load-bearing: it excludes
# session state (TERM, PATH, PWD, DISPLAY, WAYLAND_DISPLAY, NIRI_SOCKET) that
# would be actively wrong in a remote shell.
#
# VALUES come from the user manager where there is one, because those are
# already expanded and reflect anything set later in the session. Where there
# is no systemd at all (Alpine runs OpenRC) nothing ever reads environment.d,
# so the files are expanded here instead -- otherwise EDITOR, the XDG dirs and
# every toolchain path would simply be unset on those machines.
if status is-login; and not set -q ENVIRONMENT_D
    # find, not a glob: fish errors on a non-matching wildcard, and this config
    # also deploys to machines with no environment.d at all. Sorted, because
    # environment.d applies files in lexical order and later ones build on
    # earlier ones (10-paths expands ${XDG_STATE_HOME}, set by 00-xdg).
    set -l _confs (find $HOME/.config/environment.d -maxdepth 1 -name '*.conf' -type f 2>/dev/null | sort)
    if test (count $_confs) -gt 0
        set -l _keys (string replace -rf '^([A-Za-z_][A-Za-z0-9_]*)=.*$' '$1' -- (cat $_confs 2>/dev/null))

        set -l _from_systemd
        for _line in (systemctl --user show-environment 2>/dev/null)
            set -l _k (string split -m1 -f1 = -- $_line)
            contains -- $_k $_keys; or continue   # only vars environment.d declares
            set -a _from_systemd $_k
            set -q $_k; and continue              # never override what is already set
            set -l _v (string split -m1 -f2 = -- $_line)
            string match -q -- "\$'*" $_v; and continue  # skip shell-quoted values
            set -gx $_k $_v
        end

        # No systemd, or a key it did not carry: expand the file value here.
        # Only the literal and ${VAR}/$VAR forms are handled. environment.d(5)
        # also defines ${VAR:-default}, ${VAR:+alt}, $$ escaping, quoted values
        # and backslash continuations; none of these files use any of them, and
        # a line using one is skipped rather than silently mis-parsed.
        for _line in (cat $_confs 2>/dev/null)
            set _line (string trim -- $_line)
            string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- $_line; or continue
            set -l _k (string split -m1 -f1 = -- $_line)
            contains -- $_k $_from_systemd; and continue
            set -q $_k; and continue
            set -l _v (string trim -- (string split -m1 -f2 = -- $_line))
            string match -qr '\$\$|\$\{[A-Za-z_][A-Za-z0-9_]*:|\\\\$' -- $_v; and continue
            string match -q '"*' -- $_v; and continue
            string match -q "'*" -- $_v; and continue

            # A reference to something unset would expand to a bogus value --
            # this is exactly how SSH_AUTH_SOCK could have become "/gcr/ssh" on
            # a host with no XDG_RUNTIME_DIR. Skip the whole assignment instead,
            # since an unset variable is nearly always safer than a wrong one.
            set -l _refs (string match -agr '\$\{?([A-Za-z_][A-Za-z0-9_]*)\}?' -- $_v)
            set -l _ok 1
            for _r in $_refs
                if not set -q $_r; or test -z "$$_r"
                    set _ok 0
                    break
                end
            end
            test $_ok -eq 1; or continue

            for _r in $_refs
                set _v (string replace -a '${'"$_r"'}' "$$_r" -- $_v)
                set _v (string replace -a '$'"$_r" "$$_r" -- $_v)
            end
            set -gx $_k $_v
        end
    end
end

# ssh-agent. gcr-ssh-agent.socket only exports SSH_AUTH_SOCK via
# `systemctl --user set-environment`, which sshd/PAM logins never read -- so
# remote sessions (ssh, mosh) arrive without it and git commit signing plus
# git-over-ssh both fail. tmux drops it on attach for the same reason.
#
# A forwarded agent always wins: if SSH_AUTH_SOCK already names a live socket
# this block does nothing. Otherwise try the known locations in turn -- gcr on
# the CachyOS desktops, then the systemd ssh-agent unit, then gpg-agent's ssh
# support. A machine with none of them (Alpine ships no gcr) ends with
# SSH_AUTH_SOCK CLEARED rather than pointing at a socket that is not there:
# unset makes ssh fall back to asking for the passphrase, while a dead path
# makes it fail outright.
if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
    set -l _rt $XDG_RUNTIME_DIR
    test -n "$_rt"; or set _rt /run/user/(id -u)
    set -e SSH_AUTH_SOCK
    for _sock in $_rt/gcr/ssh $_rt/ssh-agent.socket $_rt/gnupg/S.gpg-agent.ssh
        if test -S $_sock
            set -gx SSH_AUTH_SOCK $_sock
            break
        end
    end
end

set -gx MOSH_SERVER_NETWORK_TMOUT 21600
set -gx CLOUDSDK_PYTHON_SITEPACKAGES 1
