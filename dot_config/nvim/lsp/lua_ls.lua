-- Merged over nvim-lspconfig's bundled lsp/lua_ls.lua (user rtp wins).
return {
    on_init = function(client)
        -- Defer to a project-local .luarc.json anywhere outside the nvim config.
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT',
                -- Find modules the way Neovim does (:h lua-module-load).
                path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
                checkThirdParty = false,
                -- Neovim runtime files: teaches the server the `vim` global and API types.
                library = { vim.env.VIMRUNTIME },
            },
        })
    end,
    settings = {
        Lua = {},
    },
}
