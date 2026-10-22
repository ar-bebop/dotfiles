function sendshot -d "Send the clipboard image to a remote for Ctrl+V in its Claude Code"
    # --setup installs the fake xclip that Claude Code's Ctrl+V reads on a headless remote
    if test "$argv[1]" = --setup
        if not set -q argv[2]
            echo "sendshot: give a host, e.g. sendshot --setup devbox" >&2
            return 1
        end
        printf '%s\n' '#!/bin/sh' \
            '# Fake xclip from sendshot: hands Claude Code the last image sent' \
            'case "$*" in' \
            '  *TARGETS*)   [ -s /tmp/clip.png ] && echo image/png ;;' \
            '  *image/png*) cat /tmp/clip.png ;;' \
            'esac' |
            ssh $argv[2] 'mkdir -p ~/.local/bin && cat > ~/.local/bin/xclip && chmod +x ~/.local/bin/xclip && command -v xclip'
        or return
        set -U sendshot_host $argv[2]
        return
    end

    # A bare `sendshot` reuses the last host
    set -q argv[1]; and set -U sendshot_host $argv[1]
    if not set -q sendshot_host
        echo "sendshot: give a host, e.g. sendshot devbox" >&2
        return 1
    end
    if not wl-paste -l 2>/dev/null | string match -q image/png
        echo "sendshot: no image in clipboard" >&2
        return 1
    end
    wl-paste -t image/png | ssh $sendshot_host 'umask 077; cat > /tmp/clip.png'
end
