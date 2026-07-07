-- Wrap and check for spell in text filetypes.
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('wrap_spell', { clear = true }),
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})


-- Go to last loc when opening a buffer.
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            -- Protected call to catch errors.
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})


-- Trailing whitespace: highlight outside insert mode (replaces mini.trailspace).
-- `:match` is per-window and replaces (no stacking); re-linked on ColorScheme so
-- the noctalia SIGUSR1 reload keeps it. Trim is `<leader>rt` (see keymaps.lua).
local ws = vim.api.nvim_create_augroup('trailing_ws', { clear = true })
local function ws_hl()
    vim.api.nvim_set_hl(0, 'TrailingWhitespace', { link = 'Error', default = true })
end
ws_hl()
vim.api.nvim_create_autocmd('ColorScheme', { group = ws, callback = ws_hl })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'InsertLeave' }, {
    group = ws,
    callback = function()
        if vim.bo.buftype == '' then vim.cmd([[match TrailingWhitespace /\s\+$/]]) end
    end,
})
vim.api.nvim_create_autocmd('InsertEnter', {
    group = ws,
    callback = function() vim.cmd('match none') end,
})
