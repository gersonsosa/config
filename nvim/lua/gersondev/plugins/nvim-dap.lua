return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local status_ok, dap = pcall(require, "dap")
      if not status_ok then
        return
      end

      -- register dap ui listener to open windows on debug/run
      dap.listeners.before.event_initialized["dapui_config"] = function(session, _)
        local ok_dap_ui, dapui = pcall(require, "dapui")
        if not ok_dap_ui then
          return
        end
        if session.config and session.config.noDebug then
          dapui.open({ layout = 2 })
        else
          dapui.open({})
        end
      end

      -- close dapui and open dap repl
      local function close_ui_open_repl()
        local ok_dap_ui, dapui = pcall(require, "dapui")
        if not ok_dap_ui then
          return
        end
        dapui.close()
        dap.repl.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        close_ui_open_repl()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        close_ui_open_repl()
      end

      vim.keymap.set("n", "<leader>dq", [[<cmd>DapToggleRepl<cr>]], { desc = "Close dap ui" })

      vim.keymap.set("n", "<Leader>lp", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end)

      vim.keymap.set("n", "<leader>dl", function()
        require("dap").run_last()
      end, { desc = "Run last" })
      vim.keymap.set(
        "n",
        "<leader>du",
        [[<cmd>lua require("dapui").toggle()<cr>]],
        { desc = "Toggle dap ui" }
      )
      vim.keymap.set(
        "n",
        "<leader>de",
        [[<cmd>lua require("dapui").eval()<cr>]],
        { desc = "Evaluate expression" }
      )
      vim.keymap.set(
        "n",
        "<leader>df",
        [[<cmd>lua require("dapui").float_element()<cr>]],
        { desc = "List float elements" }
      )
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    lazy = true,
    opts = {
      controls = {
        enabled = true,
      },
    },
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
  },
}
