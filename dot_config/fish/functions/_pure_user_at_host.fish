# pure's version with the hostname cut at the first dot, like fish's default prompt (GCP hostnames are full DNS names)
function _pure_user_at_host
    set --local username (id -u -n)
    set --local at_sign_color (_pure_set_color $pure_color_at_sign)
    set --local hostname_color (_pure_set_color $pure_color_hostname)
    set --local username_color (_pure_set_color $pure_color_username_normal)
    if test "$username" = root
        set username_color (_pure_set_color $pure_color_username_root)
    end
    echo "$username_color$username$at_sign_color@$hostname_color"(prompt_hostname)
end
