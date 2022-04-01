local M = {}

M.toggle_nvim_tree_offset = function ()
  local set_bar_offset = require('bufferline.state').set_offset
  local nvim_tree = require('nvim-tree')
  local nvim_tree_view = require('nvim-tree.view')

  if nvim_tree_view.is_visible() then
    set_bar_offset(0)
    nvim_tree.toggle()
  else
    nvim_tree.toggle(true)
    set_bar_offset(nvim_tree_view.View.width + 4, 'פּ - ')
  end
end

return M

