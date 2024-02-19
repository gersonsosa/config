vim.g.neo_tree_remove_legacy_commands = 1

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Neotree" },
  keys = { "<M-n>", "<leader>n" },
  config = function()
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

    local telescope_find = function(state)
      require('telescope.builtin').find_files(build_telescope_options(state))
    end
    local telescope_grep = function(state)
      require('telescope.builtin').live_grep(build_telescope_options(state))
    end

    local neotree = require('neo-tree')
    neotree.setup({
      window = {
        position = "current", -- left, right, top, bottom, float, current
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
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
            ["tF"] = telescope_find,
            ["tG"] = telescope_grep,
          },
        },
      },
    })

    vim.keymap.set('n', '<leader>n', function() vim.cmd.Neotree('toggle', 'reveal') end, { desc = "Find file in tree" })
    vim.keymap.set('n', '<M-n>', function() vim.cmd.Neotree('toggle') end, { desc = "Toggle tree" })
  end
}
