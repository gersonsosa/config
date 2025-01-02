local function toggle_dap_ui(session)
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

local function setup_debug_keymaps(bufnr)
  vim.keymap.set("n", "<leader>dc", function()
    require("dap").continue()
  end, { desc = "Debug - Continue", buffer = bufnr })
  vim.keymap.set("n", "<leader>dK", function()
    require("dap.ui.widgets").hover()
  end, { desc = "Debug - Hover", buffer = bufnr })
  vim.keymap.set("n", "<leader>do", function()
    require("dap").step_over()
  end, { desc = "Debug - Step Over", buffer = bufnr })
  vim.keymap.set("n", "<leader>di", function()
    require("dap").step_into()
  end, { desc = "Debug - Step into", buffer = bufnr })
  vim.keymap.set("n", "<leader>de", function()
    require("dapui").eval()
  end, { desc = "Evaluate expression", buffer = bufnr })
end

local function clear_debug_keymaps(bufnr)
  vim.keymap.del("n", "<leader>dc", { buffer = bufnr })
  vim.keymap.del("n", "<leader>dK", { buffer = bufnr })
  vim.keymap.del("n", "<leader>do", { buffer = bufnr })
  vim.keymap.del("n", "<leader>di", { buffer = bufnr })
  vim.keymap.del("n", "<leader>de", { buffer = bufnr })
end

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
      dap.listeners.before.attach.dapui_config = toggle_dap_ui
      dap.listeners.before.launch.dapui_config = toggle_dap_ui

      dap.listeners.after.event_initialized.me = function(session)
        vim
          .iter(vim.lsp.get_clients())
          :map(function(client)
            return vim.lsp.get_buffers_by_client_id(client.id)
          end)
          :flatten()
          :filter(function(bufnr)
            return vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == session.filetype
          end)
          :each(function(bufnr)
            setup_debug_keymaps(bufnr)
          end)
      end

      dap.listeners.before.event_terminated.me = function(session)
        vim
          .iter(vim.lsp.get_clients())
          :map(function(client)
            return vim.lsp.get_buffers_by_client_id(client.id)
          end)
          :flatten()
          :filter(function(bufnr)
            return vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == session.filetype
          end)
          :each(function(bufnr)
            clear_debug_keymaps(bufnr)
          end)
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

      dap.listeners.before.event_terminated.dapui_config = function()
        close_ui_open_repl()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        close_ui_open_repl()
      end

      vim.diagnostic.config({
        signs = {
          "DapBreakpoint",
          { text = "🔴", texthl = "", linehl = "", numhl = "" },
          "DapBreakpointConditional",
          { text = "🔶", texthl = "", linehl = "", numhl = "" },
          "DapBreakpointRejected",
          { text = "🚫", texthl = "", linehl = "", numhl = "" },
          "DapLogPoint",
          { text = "⭕", texthl = "", linehl = "", numhl = "" },
        },
      })
      -- vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      -- vim.fn.sign_define(
      --   "DapBreakpointConditional",
      --   { text = "🔶", texthl = "", linehl = "", numhl = "" }
      -- )
      -- vim.fn.sign_define(
      --   "DapBreakpointRejected",
      --   { text = "🚫", texthl = "", linehl = "", numhl = "" }
      -- )
      -- vim.fn.sign_define("DapLogPoint", { text = "⭕", texthl = "", linehl = "", numhl = "" })

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

      vim.keymap.set("n", "<leader>lb", function()
        require("dap").list_breakpoints()
      end, { desc = "List breakpoints" })
      vim.keymap.set("n", "<leader>dt", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Toogle Breakpoint" })
      vim.keymap.set("n", "<leader>dl", function()
        require("dap").run_last()
      end, { desc = "Run last" })
      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle()
      end, { desc = "Toggle dap ui" })
      vim.keymap.set("n", "<leader>dr", function()
        require("dap").repl.toggle()
      end, { desc = "DAP - Toogle REPL" })
      vim.keymap.set("n", "<leader>df", function()
        require("dapui").float_element()
      end, { desc = "List float elements" })
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
