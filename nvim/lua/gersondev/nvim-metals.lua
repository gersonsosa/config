-------------------------------------------------------------------------------
-- Metals config
-------------------------------------------------------------------------------
local api = vim.api
local f = require "gersondev.common.functions"
local map = f.map
local setup_lsp_keymap = require "gersondev.common.lsp".setup_lsp_keymap

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals = require "metals"
local metals_config = metals.bare_config()

metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  },
  testUserInterface = "Test Explorer",
}

-- hide messages and display only trough vim.g['metals_status']
metals_config.init_options.statusBarProvider = "on"

-- make sure the correct capabilities for snippets are set
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run",
    metals = {
      runType = "run",
    }
  },
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(_, bufnr)
  metals.setup_dap()

  -- Telescope mappings
  local function metals_commands()
    local telescope_ok, telescope = pcall(require, "telescope")
    if not telescope_ok then
      vim.notify("Couln't load telescope, is it installed?", vim.log.levels.ERROR)
    end
    telescope.extensions.metals.commands()
  end

  map("n", "<leader>mc", metals_commands, { desc = 'Show metals commands', buffer = bufnr })

  map('n', '<leader>ws', '<cmd>lua require"metals".hover_worksheet()<CR>',
    { desc = 'Hover worksheet', buffer = bufnr })

  -- DAP mappings
  map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]], { desc = "Debug - Continue", buffer = bufnr })
  map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]], { desc = 'DAP - Toogle REPL', buffer = bufnr })
  map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]], { desc = 'Debug - Hover', buffer = bufnr })
  map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]],
    { desc = 'Toogle Breakpoint', buffer = bufnr })
  map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]], { desc = 'Debug - Step Over', buffer = bufnr })
  map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]], { desc = 'Debug - Step into', buffer = bufnr })
  map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]], { desc = 'Debug - Run last', buffer = bufnr })

  ----------------------------------
  -- Mappings -----------------------
  ----------------------------------
  setup_lsp_keymap(nil, bufnr)
  map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]],
    { desc = 'Toggle tree view', buffer = bufnr })
  map("n", "<leader>ttr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]],
    { desc = 'Reveal in tree', buffer = bufnr })

  -- all workspace diagnostics
  map('n', '<leader>wd', '<cmd>lua vim.diagnostic.setqflist()<CR>',
    { desc = 'Workspace diagnostics', buffer = bufnr })
  -- all workspace errors
  map('n', '<leader>we', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>',
    { desc = 'Workspace errors', buffer = bufnr })
  -- all workspace warnings
  map('n', '<leader>ww', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>',
    { desc = 'Workspace warnings', buffer = bufnr })
  -- buffer diagnostics only
  map('n', '<leader>dil', '<cmd>lua vim.diagnostic.setloclist()<CR>',
    { desc = 'Current buffer diagnostics', buffer = bufnr })
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
