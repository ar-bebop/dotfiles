vim.cmd('highlight clear')

local fallback = {
    base00 = '#282828', base01 = '#3c3836', base02 = '#504945', base03 = '#665c54',
    base04 = '#bdae93', base05 = '#d5c4a1', base06 = '#ebdbb2', base07 = '#fbf1c7',
    base08 = '#fb4934', base09 = '#fe8019', base0A = '#fabd2f', base0B = '#b8bb26',
    base0C = '#8ec07c', base0D = '#83a598', base0E = '#d3869b', base0F = '#d65d0e',
}

-- dofile() reads fresh from disk every time; require() would cache a stale
-- palette across reloads. Protected so a missing file falls back cleanly.
local ok, generated = pcall(dofile, vim.fn.stdpath('config') .. '/lua/palette.lua')
local palette = (ok and type(generated) == 'table') and generated or fallback

require('mini.base16').setup({ palette = palette, plugins = { default = true } })

local set = vim.api.nvim_set_hl
local get = vim.api.nvim_get_hl
set(0, 'CursorLineNr', { fg = palette.base0A, bold = true })
set(0, 'Comment',      { fg = palette.base03, italic = true })

for _, group in ipairs({
    'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder',
    'SignColumn', 'FoldColumn',
    'LineNr', 'LineNrAbove', 'LineNrBelow', 'CursorLineFold', 'CursorLineSign',
    'EndOfBuffer', 'StatusLine', 'StatusLineNC',
    'TabLine', 'TabLineFill', 'WinBar', 'WinBarNC',
}) do
    local hl = get(0, { name = group })
    hl.bg, hl.ctermbg = nil, nil
    set(0, group, hl)
end

vim.g.colors_name = 'noctalia'
