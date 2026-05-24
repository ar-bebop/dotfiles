local opts = {
    options = {
        theme = 'base16',
        icons_enabled = true,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '▓▒░', right = '░▒▓' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = {
            'mode',
        },
        lualine_b = {
            {
                'filename',
                file_status = true,    -- Displays file status (readonly status, modified status)
                newfile_status = true, -- Display new file status (new file means no write after created)
                path = 3,
                shorting_target = 40,  -- Shortens path to leave 40 spaces in the window
                symbols = {
                    modified = '[+]',  -- Text to show when the file is modified.
                    readonly = '[-]',  -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[?]',   -- Text to show for unnamed buffers.
                    newfile = '[!]',   -- Text to show for newly created file before first write
                },
            },
        },
        lualine_c = { 'branch', 'diff', 'diagnostics' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'searchcount', 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                'buffers',
                mode = 0,
                filetype_names = {
                    TelescopePrompt = 'Telescope',
                    NvimTree = 'Tree',
                    dashboard = 'Dashboard',
                    packer = 'Packer',
                    fzf = 'FZF',
                    alpha = 'Alpha'
                },
                symbols = {
                    modified = '~~',
                    alternate_file = '#|',
                }
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' }
    },
    winbar = {},
    inactive_winbar = {},
    extensions = { 'fzf', 'lazy', 'nvim-tree', 'mason', 'oil' }
}


return opts
