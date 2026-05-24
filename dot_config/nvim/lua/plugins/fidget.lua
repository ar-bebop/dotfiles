return {
    'j-hui/fidget.nvim',
    version = '*',
    opts = {
        notification = {
            override_vim_notify = true,
            filter = vim.log.levels.INFO, -- raise/lower as you want
            window = {
                winblend = 0,
                border = 'single'
            }
        }
    }
}
