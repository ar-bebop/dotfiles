# Trigger tmux-window-name rename on cd, so directory-named windows
# update immediately instead of waiting for a window switch.
# Lives in conf.d: --on-variable handlers can't be autoloaded from functions/.
function _tmux_window_name --on-variable PWD
    if status is-interactive; and set -q TMUX; and set -q TMUX_PLUGIN_MANAGER_PATH
        $TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py >/dev/null 2>&1 &
        disown
    end
end
