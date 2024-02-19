return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = "ToggleTerm",
  keys = { "<c-\\>" },
  config = function()
    require("toggleterm").setup { open_mapping = [[<c-\>]] }

    local trim_spaces = true
    vim.keymap.set("v", "<leader>s", function()
      require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
    end)
    -- Replace with these for the other two options
    -- require("toggleterm").send_lines_to_terminal("visual_line", trim_spaces, { args = vim.v.count })
    -- require("toggleterm").send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })

    -- For use as an operator map:
    -- Send motion to terminal
    -- vim.keymap.set("n", [[<leader><c-\>]], function()
    --   local set_opfunc = vim.fn[vim.api.nvim_exec([[
    --     func s:set_opfunc(val)
    --       let &opfunc = a:val
    --     endfunc
    --     echon get(function('s:set_opfunc'), 'name')
    --   ]], true)]
    --   set_opfunc(function(motion_type)
    --     require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
    --   end)
    --   vim.api.nvim_feedkeys("g@", "n", false)
    -- end)
  end,
}
