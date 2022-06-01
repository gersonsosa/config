local nvim_tree_events = require('nvim-tree.events')
local bufferline_state = require('bufferline.state')
local nvim_tree_view = require('nvim-tree.view')

local nvim_tree_offset = 4

nvim_tree_events.on_tree_open(function ()
  bufferline_state.set_offset(nvim_tree_view.View.width + nvim_tree_offset, ' - ')
end)

nvim_tree_events.on_tree_close(function ()
  bufferline_state.set_offset(0)
end)

