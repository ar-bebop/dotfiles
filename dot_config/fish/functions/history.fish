function history
    switch $argv[1]
    case clear clear-session delete merge search
        builtin history $argv
    case '*'
        builtin history --show-time='%F %T ' $argv | bat
    end
end
