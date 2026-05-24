local M = {}

local function transparent_bg()
    local groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "WinBar",
        "WinBarNC",
    }

    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
end

function M.setup()
    require('base16-colorscheme').setup {
        -- Background tones
        base00 = '#111411', -- Default Background
        base01 = '#1e201d', -- Lighter Background (status bars)
        base02 = '#282b27', -- Selection Background
        base03 = '#8b9389', -- Comments, Invisibles
        -- Foreground tones
        base04 = '#c1c9be', -- Dark Foreground (status bars)
        base05 = '#e2e3de', -- Default Foreground
        base06 = '#e2e3de', -- Light Foreground
        base07 = '#e2e3de', -- Lightest Foreground
        -- Accent colors
        base08 = '#ffb4ab', -- Variables, XML Tags, Errors
        base09 = '#a2ced8', -- Integers, Constants
        base0A = '#b7ccb7', -- Classes, Search Background
        base0B = '#83d995', -- Strings, Diff Inserted
        base0C = '#a2ced8', -- Regex, Escape Chars
        base0D = '#83d995', -- Functions, Methods
        base0E = '#b7ccb7', -- Keywords, Storage
        base0F = '#93000a', -- Deprecated, Embedded Tags
    }
    transparent_bg()
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
    'sigusr1',
    vim.schedule_wrap(function()
        package.loaded['matugen'] = nil
        require('matugen').setup()
    end)
)

return M
