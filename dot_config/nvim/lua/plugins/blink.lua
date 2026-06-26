return {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
        -- 'enter' = <CR> to accept (<C-y> also works). :h blink-cmp-config-keymap
        keymap = {
            preset = 'enter',
            ['<up>'] = { 'select_prev', 'fallback' },
            ['<down>'] = { 'select_next', 'fallback' },
            ['<tab>'] = { 'select_next', 'fallback' },
            ['<S-tab>'] = { 'select_prev', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },

        completion = {
            menu = { draw = { treesitter = { 'lsp' } } },
            documentation = { auto_show = true, auto_show_delay_ms = 400 },
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        signature = { enabled = true },
    },
    opts_extend = { 'sources.default' }
}
