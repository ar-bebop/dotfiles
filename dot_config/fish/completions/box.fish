function __fish_box_needs_command
    set -l cmd (commandline -opc)
    test (count $cmd) -eq 1
end

function __fish_box_using_command
    set -l cmd (commandline -opc)
    test (count $cmd) -ge 2
    and test "$cmd[2]" = "$argv[1]"
end

complete -c box -f

complete -c box -n '__fish_box_needs_command' -a init -d 'Initialize box, provision packages, seed dotfiles'
complete -c box -n '__fish_box_needs_command' -a enter -d 'Enter current directory box; auto-stop on exit'
complete -c box -n '__fish_box_needs_command' -a status -d 'Show current box info'
complete -c box -n '__fish_box_needs_command' -a provision -d 'Install or update baseline packages inside box'
complete -c box -n '__fish_box_needs_command' -a seed -d 'Apply chezmoi dotfiles and fish plugins into ./home'
complete -c box -n '__fish_box_needs_command' -a stop -d 'Stop current directory container'
complete -c box -n '__fish_box_needs_command' -a rebuild -d 'Recreate container, keep ./home'
complete -c box -n '__fish_box_needs_command' -a purge -d 'Remove container and delete .box/ and ./home'
complete -c box -n '__fish_box_needs_command' -a name -d 'Print container name'

complete -c box -n '__fish_box_using_command init' -a '(basename (pwd) | string replace -ra "[^A-Za-z0-9._-]" "-")' -d 'Default box name'
