local PALETTE = vim.fn.stdpath('config') .. '/lua/palette.lua'

local FALLBACK = {
    base00 = '#282828',
    base01 = '#3c3836',
    base02 = '#504945',
    base03 = '#665c54',
    base04 = '#bdae93',
    base05 = '#d5c4a1',
    base06 = '#ebdbb2',
    base07 = '#fbf1c7',
    base08 = '#fb4934',
    base09 = '#fe8019',
    base0A = '#fabd2f',
    base0B = '#b8bb26',
    base0C = '#8ec07c',
    base0D = '#83a598',
    base0E = '#d3869b',
    base0F = '#d65d0e',
}

local function palette()
    local ok, p = pcall(dofile, PALETTE)
    if ok and type(p) == 'table' then return p end
    return FALLBACK
end

local p = palette()
local function theme()
    return {
        normal   = {
            a = { fg = p.base00, bg = p.base0D, gui = 'bold' },
            b = { fg = p.base05, bg = p.base00 },
            c = { fg = p.base03, bg = 'none' }
        },
        insert   = { a = { fg = p.base00, bg = p.base0B, gui = 'bold' } },
        visual   = { a = { fg = p.base00, bg = p.base0E, gui = 'bold' } },
        replace  = { a = { fg = p.base00, bg = p.base08, gui = 'bold' } },
        command  = { a = { fg = p.base00, bg = p.base0A, gui = 'bold' } },
        inactive = {
            a = { fg = p.base03, bg = 'none' },
            b = { fg = p.base03, bg = 'none' },
            c = { fg = p.base03, bg = 'none' }
        },
    }
end

local opts = {
    options = {
        theme = theme,
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
                file_status = true,
                newfile_status = true,
                path = 3,
                shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                symbols = {
                    modified = '[+]', -- Text to show when the file is modified.
                    readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[?]',  -- Text to show for unnamed buffers.
                    newfile = '[!]',  -- Text to show for newly created file before first write
                },
            },
        },
        lualine_c = {
            'branch',
            {
                'diff',
                colored = true,
                diff_color = {
                    added    = 'LuaLineDiffAdd',
                    modified = 'LuaLineDiffChange',
                    removed  = 'LuaLineDiffDelete',
                },
                symbols = { added = '+', modified = '~', removed = '-' }
            },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic', 'nvim_lsp' },
                sections = { 'error', 'warn', 'info', 'hint' },
                diagnostics_color = {
                    error = 'DiagnosticError',
                    warn  = 'DiagnosticWarn',
                    info  = 'DiagnosticInfo',
                    hint  = 'DiagnosticHint',
                },
                symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
                colored = true,
            }
        },
        lualine_x = {
            {
                'lsp_status',
                icon = '',
                symbols = {
                    spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                    done = '✓',
                    separator = ' ',
                },
                ignore_lsp = {},
                show_name = true,
            }
        },
        lualine_y = { 'filetype', 'encoding', 'fileformat' },
        lualine_z = { 'location', 'progress' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { 'filename' },
        lualine_c = {},
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                'buffers',
                component_separators = { left = '' },
                section_separators = { left = '' },
                buffers_color = {
                    active = { fg = p.base00, bg = p.base0B },
                    inactive = { fg = p.base05, bg = 'none' },
                },
                mode = 0,
                symbols = {
                    modified = '~',
                    alternate_file = '',
                    directory = '=>'
                }
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = { 'fzf', 'lazy', 'mason', 'nvim-tree', 'oil', 'trouble' }
}


return opts
