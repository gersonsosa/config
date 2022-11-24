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
    dapui.float_element("repl", {})
  else
    dapui.open({})
  end
end
