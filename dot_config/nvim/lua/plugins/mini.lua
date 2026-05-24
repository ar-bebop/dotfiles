return {
    'echasnovski/mini.nvim',
    lazy = false,
    priority = 1000,
    version = '*',
    config = function()
        require('mini.surround').setup()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.pairs').setup()
        require('mini.trailspace').setup()
    end
}
