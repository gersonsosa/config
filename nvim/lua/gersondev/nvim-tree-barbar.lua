local set_bar_offset = require('bufferline.state').set_offset
local nvim_tree = require('nvim-tree')
local nvim_tree_view = require('nvim-tree.view')

function toogle_nvim_tree()
  if nvim_tree_view.is_visible() then
    set_bar_offset(0)
    nvim_tree.toggle()
  else
    nvim_tree.toggle(true)
    set_bar_offset(nvim_tree_view.View.width + 2, 'פּ - ')
  end
end

vim.cmd ("command OffsetNvimTree :lua toogle_nvim_tree()")

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<C-n>', ':OffsetNvimTree<CR>', opts)

