function fish_greeting
end

! set --query fisher_path[1] || test "$fisher_path" = $__fish_config_dir && exit

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    source $file
end

# Guarded: an unguarded `zoxide init` prints an error on every single shell
# start on a machine that has no zoxide, which is every fresh server.
command -q zoxide; and zoxide init fish | source

# Bootstrap fisher, then install everything fish_plugins declares.
#
# `fisher install jorgebucaran/fisher` installed only the plugin manager, so a
# fresh machine ended up with fisher and none of pure, autopair or done -- they
# are declared in fish_plugins, and `fisher update` is the only command that
# reads that file. fisher is itself listed there, so update bootstraps it too
# and the separate install is redundant.
#
# fisher rewrites fish_plugins afterwards, but preserves the file's existing
# order and only appends plugins missing from it, so the rewrite is
# content-identical here and produces no chezmoi drift.
if status is-interactive; and not functions -q fisher; and command -q curl
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    and fisher update
end
