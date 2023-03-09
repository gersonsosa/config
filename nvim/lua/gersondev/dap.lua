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
