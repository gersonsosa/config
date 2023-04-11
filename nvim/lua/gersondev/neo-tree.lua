vim.g.neo_tree_remove_legacy_commands = 1

local function build_telescope_mappings(state)
  return function(bufnr, _)
    local actions = require "telescope.actions"
    actions.select_default:replace(function()
      actions.close(bufnr)
      local action_state = require "telescope.actions.state"
      local selection = action_state.get_selected_entry()
      local filename = selection.filename
      if (filename == nil) then
        filename = selection[1]
      end
      -- any way to open the file without triggering auto-close event of neo-tree?
      require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
    end)
    return true
  end
end

local function build_telescope_options(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = build_telescope_mappings(state)
  }
end

require("neo-tree").setup({
  window = {
    mappings = {
      ["J"] = function(state)
        local tree = state.tree
        local node = tree:get_node()
        local siblings = tree:get_nodes(node:get_parent_id())
        local renderer = require('neo-tree.ui.renderer')
        renderer.focus_node(state, siblings[#siblings]:get_id())
      end,
      ["K"] = function(state)
        local tree = state.tree
        local node = tree:get_node()
        local siblings = tree:get_nodes(node:get_parent_id())
        local renderer = require('neo-tree.ui.renderer')
        renderer.focus_node(state, siblings[1]:get_id())
      end,
      ["z"] = "none",
    }
  },
  filesystem = {
    window = {
      mappings = {
        ["tf"] = "telescope_find",
        ["tg"] = "telescope_grep",
      },
    },
    commands = {
      telescope_find = function(state)
        require('telescope.builtin').find_files(build_telescope_options(state))
      end,
      telescope_grep = function(state)
        require('telescope.builtin').live_grep(build_telescope_options(state))
      end,
    },
  },
})
