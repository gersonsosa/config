vim.g.mapleader = " "

-- global
vim.opt_global.completeopt = { "menuone", "noinsert" }
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- window or global options
vim.go.guicursor = ""
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "auto"
vim.wo.colorcolumn = "80"
vim.go.scrolloff = 8
vim.go.showmode = false
vim.wo.cursorline = true
vim.go.laststatus = 3

-- opt local to buffer
vim.o.undofile = true
vim.o.linebreak = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.termguicolors = true

vim.wo.list = true
vim.opt_global.listchars:append({ tab = "▸▸" })
vim.opt_global.listchars:append({ trail = "·" })
vim.opt_global.listchars:append({ lead = "·" })

vim.opt_global.dictionary:append({ "/usr/share/dict/words" })
