vim.g.mapleader = " "
vim.go.laststatus = 3
vim.opt.completeopt = { "menuone", "fuzzy", "noinsert" }
vim.o.winborder = "rounded"

vim.o.list = true
vim.opt.listchars:append({ tab = "▸▸" })
vim.opt.listchars:append({ trail = "·" })
vim.opt.listchars:append({ lead = "·" })

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.scrolloff = 8
vim.o.undofile = true

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>") -- terminal esc
-- vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
vim.keymap.set("t", "<A-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Go to left window" })
-- vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Go to the window below" })
vim.keymap.set("t", "<A-j>", "<C-\\><C-n><C-w>j", { desc = "Go to the window below" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Go to the window below" })
-- vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Go to the window above" })
vim.keymap.set("t", "<A-k>", "<C-\\><C-n><C-w>k", { desc = "Go to the window above" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Go to the window above" })
-- vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
vim.keymap.set("t", "<A-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<leader>c", ":noh<cr>")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selected text" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- scroll down with zz to center screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [[y<C-c>:%s/\<<C-r><C-">\>/<C-r><C-">/gI<Left><Left><Left>]])
vim.keymap.set({ "x", "n" }, "<C-s>", [[<esc>:'<,'>s/\V/]], { desc = "Enter is subs mode in selection" })

vim.keymap.set("n", "<leader>t", function()
  vim.cmd.vnew()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)
  vim.cmd.term()
end, { desc = "Open the terminal" })

vim.keymap.set("v", "<leader>t", function()
  vim.cmd.vnew()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)
  vim.cmd.term()
end, { desc = "Open the terminal" })

local keymap_group = vim.api.nvim_create_augroup("FileTypeKeymaps", { clear = true })

-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })

vim.api.nvim_create_autocmd('FileType', {
  group = keymap_group,
  pattern = { "lua" },
  callback = function(args)
    vim.keymap.set("n", "<leader>o", ":update<cr>:source<cr>", { buffer = args.buf })
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = keymap_group,
  callback = function()
    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if vim.snippet.active({ direction = 1 }) then
        return vim.snippet.jump(1)
      else
        return "<C-j>"
      end
    end, { desc = "jump to the next snippet position", silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if vim.snippet.active({ direction = -1 }) then
        return vim.snippet.jump(-1)
      else
        return "<C-k>"
      end
    end, { desc = "jump to the prev snippet position", silent = true })
  end
})

vim.keymap.set("n", "<leader>B", function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local file = vim.fn.expand('%')
  vim.api.nvim_command("!gh browse " .. file .. ":" .. line)
end)

vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("tokyonight").setup({
  on_colors = function(colors)
    colors.border = colors.orange
  end,
})

vim.cmd([[colorscheme tokyonight]])

require("treesitter")
require("lsp")
require("git")
require("utils")
