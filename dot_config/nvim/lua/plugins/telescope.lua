return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        defaults = {
            border = true,
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
        }
    }
}
