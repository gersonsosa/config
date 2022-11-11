local dap, dapui = require("dap"), require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end

local f = require "gersondev.functions"
local map = f.map

map("n", "<leader>du", function () dapui.toggle() end)
