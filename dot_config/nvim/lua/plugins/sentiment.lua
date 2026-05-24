return {
    'utilyre/sentiment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    version = '*',
    init = function()
        vim.g.loaded_matchparen = 1
    end,
    config = true
}
