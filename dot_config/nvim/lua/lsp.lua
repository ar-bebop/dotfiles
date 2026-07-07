vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 2, source = 'if_many' },
    float = { border = 'single', source = true },
})

-- Advertise blink.cmp's extended completion capabilities to every server.
-- (require loads blink at startup so the caps are set before servers attach.)
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})
