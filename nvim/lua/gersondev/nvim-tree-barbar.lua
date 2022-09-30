local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')
local nvim_tree_view = require('nvim-tree.view')

local nvim_tree_offset = 4

local function get_tree_size()
  return nvim_tree_view.View.width + nvim_tree_offset, ' - '
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)
