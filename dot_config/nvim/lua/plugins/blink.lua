return {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- optional: provides snippets for the snippet source
    version = '1.*',
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = 'enter',
            ['<up>'] = { 'select_prev', 'fallback'},
            ['<down>'] = { 'select_next', 'fallback'},
            ['<tab>'] = { 'select_next', 'fallback'},
            ['<S-tab>'] = { 'select_prev', 'fallback'},
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback'},
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback'},
            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback'},
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            keyword = { range = 'prefix' },
            menu = {
                auto_show = true,
                draw = { treesitter = { 'lsp' } }
            },
            trigger = { show_on_trigger_character = true },
            documentation = { auto_show = true, auto_show_delay_ms = 400 },
            ghost_text = { enabled = false },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

        signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
}
