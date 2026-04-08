local function setup_debug_keymaps()
  vim.keymap.set("n", "<leader>dT", function()
    require("dap").terminate()
  end, { desc = "Debug - Continue" })
  vim.keymap.set("n", "<leader>dc", function()
    require("dap").continue()
  end, { desc = "Debug - Continue" })
  vim.keymap.set("n", "<leader>dC", function()
    require("dap").run_to_cursor()
  end, { desc = "Debug - Continue" })
  vim.keymap.set("n", "<leader>dh", function()
    require("dap.ui.widgets").hover()
  end, { desc = "Debug - Hover" })
  vim.keymap.set({ "n", "v" }, "<leader>dp", function()
    require("dap.ui.widgets").preview()
  end, { desc = "Debug - Preview" })
  vim.keymap.set("n", "<leader>do", function()
    require("dap").step_over()
  end, { desc = "Debug - Step Over" })
  vim.keymap.set("n", "<leader>di", function()
    require("dap").step_into()
  end, { desc = "Debug - Step into" })
  vim.keymap.set("n", "<leader>da", function()
    require("dap-view").add_expr()
  end, { desc = "Evaluate expression" })
  vim.keymap.set("n", "<leader>dE", function()
    require("dap").eval()
  end, { desc = "Evaluate expression" })
end

local function clear_debug_keymaps()
  vim.keymap.del("n", "<leader>dT")
  vim.keymap.del("n", "<leader>dc")
  vim.keymap.del("n", "<leader>dC")
  vim.keymap.del("n", "<leader>dh")
  vim.keymap.del({ "n", "v" }, "<leader>dp")
  vim.keymap.del("n", "<leader>do")
  vim.keymap.del("n", "<leader>di")
  vim.keymap.del("n", "<leader>da")
  vim.keymap.del("n", "<leader>dE")
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = {
          windows = {
            terminal = {
              hide = { "scala", "go" },
            },
          },
        },
      },
    },
    config = function()
      local status_ok, dap = pcall(require, "dap")
      if not status_ok then
        return
      end

      dap.listeners.after.event_initialized.me = function()
        setup_debug_keymaps()
      end

      dap.listeners.before.event_terminated.me = function()
        clear_debug_keymaps()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointConditional",
        { text = "🔶", texthl = "", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "🚫", texthl = "", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "⭕", texthl = "", linehl = "", numhl = "" })

      vim.keymap.set("n", "<leader>dq", function()
        require("dap").repl.close()
      end, { desc = "Close dap ui" })

      vim.keymap.set("n", "<leader>dL", function()
        vim.ui.input(
          { prompt = "Log point message (use {foo} for intepolation): " },
          function(message)
            require("dap").toggle_breakpoint(nil, nil, message)
          end
        )
      end)

      -- always on keymaps
      vim.keymap.set("n", "<leader>lb", function()
        require("dap").list_breakpoints()
      end, { desc = "List breakpoints" })
      vim.keymap.set("n", "<leader>dt", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Toogle Breakpoint" })
      vim.keymap.set("n", "<leader>rl", function()
        require("dap").run_last()
      end, { desc = "Run last" })
      vim.keymap.set("n", "<leader>du", function()
        require("dap-view").toggle()
      end, { desc = "Toggle dap ui" })
      vim.keymap.set("n", "<leader>dr", function()
        require("dap").repl.toggle()
      end, { desc = "DAP - Toogle REPL" })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Dap Go Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
      })
    end,
  },
}
