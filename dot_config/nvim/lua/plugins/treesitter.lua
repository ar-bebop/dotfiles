-- Parser manager for core vim.treesitter (nvim-treesitter was archived 2026-04).
-- Highlighting is on by default; indent is Vim's filetype indent (TS indent dropped).
return {
    'romus204/tree-sitter-manager.nvim',
    lazy = false,
    config = function()
        require('tree-sitter-manager').setup({
            auto_install = true,
            -- Bundled in nvim core; don't compile duplicates.
            noauto_install = {
                'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
            },
        })
    end,
}
