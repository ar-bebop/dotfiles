complete -c box -f

complete -c box -n '__fish_use_subcommand' -a init   -d 'Initialize a box in current directory'
complete -c box -n '__fish_use_subcommand' -a enter  -d 'Enter current directory box'
complete -c box -n '__fish_use_subcommand' -a status -d 'Show current box info'
complete -c box -n '__fish_use_subcommand' -a rm     -d 'Remove container, keep .box'
complete -c box -n '__fish_use_subcommand' -a purge  -d 'Remove container and .box'
complete -c box -n '__fish_use_subcommand' -a name   -d 'Print container name'

complete -c box -n '__fish_seen_subcommand_from enter status rm purge name' -f
