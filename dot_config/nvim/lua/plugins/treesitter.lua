return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local ts = require('nvim-treesitter')

        ts.setup {
            install_dir = vim.fn.stdpath('data') .. '/treesitter',
        }

        -- TS indent is experimental and poor for these; let Vim handle them.
        local no_ts_indent = { python = true, yaml = true, markdown = true, html = true }

        local function attach(buf, ft)
            pcall(vim.treesitter.start, buf)
            if not no_ts_indent[ft] then
                pcall(function()
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end)
            end
        end

        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local buf = args.buf
                -- Skip special buffers (terminals, prompts, etc.).
                if vim.bo[buf].buftype ~= '' then return end

                local ft = vim.bo[buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then return end

                -- Parser already available (bundled in core or in install_dir)?
                if pcall(vim.treesitter.language.add, lang) then
                    attach(buf, ft)
                    return
                end

                -- Need to install. Requires tree-sitter CLI + a known grammar.
                if vim.fn.executable('tree-sitter') ~= 1 then return end
                if not vim.list_contains(ts.get_available(), lang) then return end

                ts.install(lang):await(function()
                    vim.schedule(function() attach(buf, ft) end)
                end)
            end,
        })
    end,
}
