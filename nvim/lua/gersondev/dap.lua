local dap = require("dap")

local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
  return
end

dapui.setup({
  controls = {
    enabled = false
  }
})

dap.listeners.after.event_initialized["dapui_config"] = function(session, _)
  if session.config.noDebug then
    dapui.float_element("repl")
  else
    dapui.open()
  end
end

local f = require "gersondev.functions"
local map = f.map

map("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle dap ui" })
map("n", "<leader>de", function() dapui.eval() end, { desc = "Evaluate expression" })
map("n", "<leader>df", function() dapui.float_element() end, { desc = "Evaluate expression" })
