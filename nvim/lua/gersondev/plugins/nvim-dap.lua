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

    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap" },
    lazy = true,
    opts = {
      controls = {
        enabled = true
      }
    },
  },
}
