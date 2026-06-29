local o = vim.opt
local g = vim.g

-- Indents
o.autoindent = true
o.smartindent = true
o.expandtab = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4

-- Searching
o.ignorecase = true
o.smartcase = true
o.incsearch = true

-- Folds --
o.foldcolumn = '4'
o.fillchars:append('foldopen:,foldclose:')

-- ETC --
o.mouse = 'a'
o.undofile = true
o.swapfile = false
o.scrolloff = 16
o.fillchars:append('eob: ')
o.updatetime = 100
o.clipboard = 'unnamedplus'

-- UI --
o.termguicolors = true
o.completeopt = { 'menu', 'menuone', 'noselect' }
o.number = true
o.relativenumber = true
o.numberwidth = 4
o.signcolumn = 'yes'
o.cursorline = true
o.cursorlineopt = 'number'
o.splitbelow = true
o.splitright = true
o.showmode = false

-- TITLE --
o.title = true
o.titlestring = '%((%{expand("%:~:.:h")})%) %t%( %m%) - nvim '

g.mapleader = ' '
