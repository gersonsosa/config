local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- options
vim.opt.completeopt = { "menuone", "noinsert" }
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.list = true
vim.opt.listchars:append({ tab = "▸▸" })
vim.opt.listchars:append({ trail = "·" })
vim.opt.listchars:append({ lead = "·" })

vim.opt_global.dictionary:append({ "/usr/share/dict/words" })

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = "gersondev.plugins",
  change_detection = { notify = false },
  rocks = { enable = false },
})
