return {
    'saghen/blink.cmp',
    -- Eager (not lazy): lsp.lua requires blink at startup to advertise its LSP
    -- capabilities before servers attach, so an InsertEnter trigger wouldn't help.
    lazy = false,
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
        -- 'enter' = <CR> to accept (<C-y> also works). :h blink-cmp-config-keymap
        -- Presets already bind <Up>/<Down>, <C-n>/<C-p>, <C-b>/<C-f> (docs), <C-k> (signature).
        keymap = {
            preset = 'enter',
            -- Menu open → select; inside a snippet → jump between placeholders.
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        },

        completion = {
            -- Nothing preselected: <CR> at rest is a newline; select first (Tab/arrows), then <CR> accepts.
            list = { selection = { preselect = false } },
            menu = { border = 'single', draw = { treesitter = { 'lsp' } } },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 400,
                window = { border = 'single' },
            },
            ghost_text = { enabled = true },
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        signature = { enabled = true, window = { border = 'single' } },

        cmdline = {
            completion = {
                list = { selection = { preselect = false } },
                -- Live menu for : commands only (not / searches).
                menu = { auto_show = function() return vim.fn.getcmdtype() == ':' end },
            },
        },
    },
    opts_extend = { 'sources.default' }
}
