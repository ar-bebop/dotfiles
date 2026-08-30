## Useful aliases
# Replace ls with eza. ls/la/ll/lt are the listings actually used day to day, so
# a machine without eza must still get something for them rather than nothing --
# the doctor reports the missing binary, these keep the shell usable meanwhile.
if command -q eza
    alias ls='eza -al --color=always --group-directories-first --icons always' # preferred listing
    alias la='eza -a --color=always --group-directories-first --icons always' # all files and dirs
    alias ll='eza -l --color=always --group-directories-first --icons always' # long format
    alias lt='eza -aT --color=always --group-directories-first --icons always' # tree listing
    alias l.="eza -a | grep -e '^\.'"
else
    # Deliberately NOT --group-directories-first: that flag is GNU-only and
    # Alpine ships busybox ls. --color=auto is probed rather than assumed for
    # the same reason. lt degrades to -R since coreutils has no tree mode.
    set -l _lsc
    ls --color=auto /dev/null >/dev/null 2>&1; and set _lsc --color=auto
    # Every body says `command ls` explicitly. fish only inserts `command` when
    # the alias name matches the first word, so `alias la="ls -a"` would have
    # called the ls ALIAS above and silently inherited its forced -al.
    alias ls="command ls -al $_lsc"
    alias la="command ls -a $_lsc"
    alias ll="command ls -l $_lsc"
    alias lt="command ls -R $_lsc"
    alias l.="command ls -a | grep -e '^\.'"
end

# Common use
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                           # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"                      # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'                  # List amount of -git packages

alias please='sudo'
alias tb='ncat termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
