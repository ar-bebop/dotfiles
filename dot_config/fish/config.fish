function fish_greeting
end

# fisher: load plugins from $fisher_path (conf.d/10-vars.fish)
! set --query fisher_path[1] || test "$fisher_path" = $__fish_config_dir && exit

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    source $file
end

# zoxide, where installed (fresh servers often lack it)
command -q zoxide; and zoxide init fish | source

# New machine: `fisher update` installs fisher itself and everything in fish_plugins
if status is-interactive; and not functions -q fisher; and command -q curl
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    and fisher update
end
