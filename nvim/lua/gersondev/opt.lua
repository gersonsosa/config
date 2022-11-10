-- opt
vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.number = true

-- global
vim.opt_global.completeopt = { "menuone", "noinsert" }

vim.opt.undofile = true

vim.opt.colorcolumn = "80"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.listchars:append({ tab = "▸▸" })
vim.opt.listchars:append({ trail = "·" })
vim.opt.listchars:append({ lead = "·" })
vim.opt.list = true

vim.opt.timeoutlen = 800
vim.opt.dictionary:append("/usr/share/dict/words")

vim.opt.mouse = "i"
vim.opt.showmode = false
