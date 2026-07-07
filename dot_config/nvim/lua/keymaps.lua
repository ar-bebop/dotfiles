local set = vim.keymap.set
local del = vim.keymap.del
local wk = require('which-key')
local telescope = require('telescope.builtin')

-- Trim trailing whitespace, preserving cursor/view (replaces MiniTrailspace.trim).
local function trim_whitespace()
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
end

del('n', 'grn')
del('n', 'gra')
del('n', 'grr')
del('n', 'gri')
del('n', 'grt')
del('n', 'gO')

wk.add({
    { '<leader>f', group = 'file' },
    { '<leader>ff', function() telescope.find_files() end, desc = 'find' },
    { '<leader>fg', function() telescope.live_grep() end, desc = 'live grep' },
    { '<leader>fo', function() telescope.oldfiles() end, desc = 'old' },

    { '<leader>e', '<cmd>Neotree focus<cr>', desc = 'neo-tree' },

    { '<leader>d', group = 'diagnostics' },
    { '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>', desc = 'diagnostics' },
    { '<leader>db', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'buffer diagnostics' },
    { '<leader>da', vim.lsp.buf.code_action, desc = 'code action' },
    { '<leader>df', vim.diagnostic.open_float, desc = 'open floating' },
    { '<leader>dq', '<cmd>Trouble qflist toggle<cr>', desc = 'quickfix list' },
    { '<leader>dl', '<cmd>Trouble loclist toggle<cr>', desc = 'location list' },
    { '<leader>do', '<cmd>Trouble symbols toggle<cr>', desc = 'document symbols' },

    { '<leader>l', group = 'LSP' },
    { '<leader>ld', '<cmd>Trouble lsp_declarations toggle<cr>', desc = 'declarations' },
    { '<leader>lD', '<cmd>Trouble lsp_definitions toggle<cr>', desc = 'definitions' },
    { '<leader>li', '<cmd>Trouble lsp_implementations toggle<cr>', desc = 'implementations' },
    { '<leader>lr', '<cmd>Trouble lsp_references toggle<cr>', desc = 'references' },
    { '<leader>ls', vim.lsp.buf.signature_help, desc = 'signature help' },
    { '<leader>lt', '<cmd>Trouble lsp_type_definitions toggle<cr>', desc = 'type definition' },

    { '<leader>w', group = 'workspace' },
    { '<leader>wa', vim.lsp.buf.add_workspace_folder, desc = 'add' },
    { '<leader>wr', vim.lsp.buf.remove_workspace_folder, desc = 'remove' },
    { '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = 'list' },

    { '<leader>r', group = 'refactor' },
    { '<leader>rt', trim_whitespace, desc = 'trim whitespace' },
    { '<leader>rf', function() require('conform').format({ async = true }) end, desc = 'format' },
    { '<leader>rr', vim.lsp.buf.rename, desc = 'rename' },

    { '<leader>n', group = 'notifications' },
    { '<leader>nh', '<cmd>Fidget history<cr>', desc = 'history'},
    { '<leader>nc', '<cmd>Fidget clear<cr>', desc = 'clear'},
    { '<leader>nC', '<cmd>Fidget history<cr>', desc = 'clear history'},

    { '<leader>m', group = 'markview'},
    { '<leader>mm', '<cmd>Markview Toggle<cr>', desc = 'toggle'},
    { '<leader>mn', '<cmd>Markview splitToggle<cr>', desc = 'split toggle'},

    { '<leader><leader>', group = 'buffer' },
    { '<leader><leader>d', '<cmd>bd<cr>', desc = 'delete' },
    { '<leader><leader>w', '<cmd>bw<cr>', desc = 'wipeout' },

    { '<leader>t', group = 'tab' },
    { '<leader>tn', '<cmd>tabnext<cr>', desc = 'next' },
    { '<leader>tp', '<cmd>tabprevious<cr>', desc = 'previous' },
    { '<leader>tt', '<cmd>tabnew<cr>', desc = 'new' },
    { '<leader>tc', '<cmd>tabclose<cr>', desc = 'close' },
})

wk.add({
    { '[q', vim.cmd.cprev, desc = 'previous quickfix' },
    { ']q', vim.cmd.cnext, desc = 'next quickfix' },
})

-- window stuff
set('n', '<C-h>', '<C-w>h', { noremap = true })
set('n', '<C-j>', '<C-w>j', { noremap = true })
set('n', '<C-k>', '<C-w>k', { noremap = true })
set('n', '<C-l>', '<C-w>l', { noremap = true })
set('n', '<C-up>', '<cmd>resize +2<cr>', { noremap = true })
set('n', '<C-down>', '<cmd>resize -2<cr>', { noremap = true })
set('n', '<C-left>', '<cmd>vertical resize +2<cr>', { noremap = true })
set('n', '<C-right>', '<cmd>vertical resize -2<cr>', { noremap = true })
set('n', '<A-w>', '<cmd>WinShift<cr>', { desc = 'window move mode' })

-- buffer stuff
set('n', '<tab>', '<cmd>bnext<cr>', { desc = 'next buffer' })
set('n', '<S-tab>', '<cmd>bNext<cr>', { desc = 'previous buffer' })

-- misc
set('n', '<C-s>', '<cmd>write<cr>', { desc = 'write buffer' })
set('i', '<S-tab>', '<C-V><tab>', { desc = 'insert true tab'})

-- leap
set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
set('n', 'S', '<Plug>(leap-from-window)')

-- Remap for dealing with word wrap
set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
