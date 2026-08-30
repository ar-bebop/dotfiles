function history
    switch $argv[1]
    case clear clear-session delete merge search
        builtin history $argv
    case '*'
        # Fall back to the plain listing where bat is not installed,
        # rather than piping into a command that does not exist.
        if command -q bat
            builtin history --show-time='%F %T ' $argv | bat
        else
            builtin history --show-time='%F %T ' $argv
        end
    end
end
