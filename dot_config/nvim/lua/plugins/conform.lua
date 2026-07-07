return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
        formatters_by_ft = {
            python = { 'ruff_organize_imports', 'ruff_format' },
            sh = { 'shfmt' },
            bash = { 'shfmt' },
        },
        -- Filetypes without a formatter above fall through to the LSP formatter.
        default_format_opts = {
            lsp_format = 'fallback',
        },
        -- Sync format-on-save, with a global/per-buffer escape hatch.
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return { timeout_ms = 500 }
        end,
        formatters = {
            -- Derive shfmt indent from the buffer: expandtab -> -i <shiftwidth>,
            -- noexpandtab -> -i 0 (tabs). Overrides any project .editorconfig.
            shfmt = {
                prepend_args = function(_, ctx)
                    local bo = vim.bo[ctx.buf]
                    if bo.expandtab then
                        local width = bo.shiftwidth > 0 and bo.shiftwidth or bo.tabstop
                        return { '-i', tostring(width) }
                    end
                    return { '-i', '0' }
                end,
            },
        },
    },
    config = function(_, opts)
        require('conform').setup(opts)
        vim.api.nvim_create_user_command('FormatDisable', function(args)
            if args.bang then
                vim.g.disable_autoformat = true
            else
                vim.b.disable_autoformat = true
            end
        end, { desc = 'Disable format-on-save (! = globally)', bang = true })
        vim.api.nvim_create_user_command('FormatEnable', function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, { desc = 'Re-enable format-on-save' })
    end,
}
