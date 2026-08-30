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

# Shell/CLI environment. Graphical-only vars live in niri's `environment {}`.
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_STATE_HOME  $HOME/.local/state
set -gx XDG_CACHE_HOME  $HOME/.cache

set -gx PULSE_COOKIE           $XDG_STATE_HOME/pulse/cookie
set -gx CARGO_HOME             $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME            $XDG_DATA_HOME/rustup
set -gx GOPATH                 $HOME/.local/share/go
set -gx GOBIN                  $HOME/.local/bin
set -gx DOTNET_CLI_HOME        $XDG_DATA_HOME/dotnet
set -gx NUGET_PACKAGES         $XDG_CACHE_HOME/nuget
set -gx DOCKER_CONFIG          $XDG_CONFIG_HOME/docker
set -gx NPM_CONFIG_INIT_MODULE $XDG_CONFIG_HOME/npm/config/npm-init.js
set -gx NPM_CONFIG_CACHE       $XDG_CACHE_HOME/npm
set -gx NODE_REPL_HISTORY      $XDG_STATE_HOME/node_repl_history

# Inherited value wins.
set -q EDITOR;   or set -gx EDITOR nvim
set -q VISUAL;   or set -gx VISUAL nvim
set -q BROWSER;  or set -gx BROWSER zen-browser
set -q TERMINAL; or set -gx TERMINAL ghostty

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
