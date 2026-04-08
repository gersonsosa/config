-- window or global options
vim.o.number = true
vim.o.relativenumber = true
vim.go.scrolloff = 8
vim.go.showmode = false
vim.go.laststatus = 3

-- defaults to avoid 8 tabs shiftwidth
-- opt local to buffer
vim.o.undofile = true
vim.o.linebreak = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.termguicolors = true

vim.opt.shortmess:append("t")
