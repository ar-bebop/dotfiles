# Host aliases from ~/.ssh/config, wildcard patterns skipped
complete -c sendshot -f -a "(test -r ~/.ssh/config; and string replace -rfi '^\s*Host\s+' '' < ~/.ssh/config | string split ' ' | string match -rv '[*?]')"
complete -c sendshot -l setup -d "Install the fake xclip on a remote"
