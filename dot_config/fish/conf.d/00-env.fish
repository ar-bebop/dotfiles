# Environment for every fish, login or not. Desktop-only vars live in mango's env.conf.

# XDG base directories
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_STATE_HOME  $HOME/.local/state
set -gx XDG_CACHE_HOME  $HOME/.cache

# Keep tools out of $HOME
set -gx CARGO_HOME             $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME            $XDG_DATA_HOME/rustup
set -gx GOPATH                 $XDG_DATA_HOME/go
set -gx GOBIN                  $HOME/.local/bin
set -gx DOTNET_CLI_HOME        $XDG_DATA_HOME/dotnet
set -gx NUGET_PACKAGES         $XDG_CACHE_HOME/nuget
set -gx DOCKER_CONFIG          $XDG_CONFIG_HOME/docker
set -gx NPM_CONFIG_INIT_MODULE $XDG_CONFIG_HOME/npm/config/npm-init.js
set -gx NPM_CONFIG_CACHE       $XDG_CACHE_HOME/npm
set -gx NODE_REPL_HISTORY      $XDG_STATE_HOME/node_repl_history
set -gx PULSE_COOKIE           $XDG_STATE_HOME/pulse/cookie

# Defaults; an inherited value (e.g. from mango) wins
set -q EDITOR;   or set -gx EDITOR nvim
set -q VISUAL;   or set -gx VISUAL nvim
set -q BROWSER;  or set -gx BROWSER zen-browser
set -q TERMINAL; or set -gx TERMINAL ghostty

# Man pages through bat, only where bat exists (a missing MANPAGER breaks man)
if command -q bat
    set -gx MANPAGER "bat -plman"
    set -gx BAT_THEME base16
end

# ssh-agent: agents publish SSH_AUTH_SOCK to systemd at most, which neither the desktop
# nor ssh/mosh logins inherit, so set it here. A live (e.g. forwarded) socket wins;
# otherwise the first agent that exists (gcr, systemd ssh-agent, gpg-agent), or none.
if not test -S "$SSH_AUTH_SOCK"
    set -e SSH_AUTH_SOCK
    for sock in $XDG_RUNTIME_DIR/{gcr/ssh,ssh-agent.socket,gnupg/S.gpg-agent.ssh}
        test -S $sock; and set -gx SSH_AUTH_SOCK $sock; and break
    end
end

# Other tools
set -gx MOSH_SERVER_NETWORK_TMOUT 21600  # mosh-server gives up after 6 h without a client
set -gx CLOUDSDK_PYTHON_SITEPACKAGES 1   # gcloud may use the system Python's packages
