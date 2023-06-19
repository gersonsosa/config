-------------------------------------------------------------------------------
-- Metals config
-------------------------------------------------------------------------------
local api = vim.api
local f = require "gersondev.common.functions"
local map = f.map

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
  local telescope = require "telescope"
  local telescope_builtin = require "telescope.builtin"

  local function metals_commands()
    telescope.extensions.metals.commands()
  end

  local function telescope_lsp_doc_symbols()
    telescope_builtin.lsp_document_symbols()
  end

  map("n", "<leader>mc", metals_commands, { desc = 'Show metals commands', buffer = bufnr })
  map("n", "<leader>ds", telescope_lsp_doc_symbols, { desc = 'List document symbols', buffer = bufnr })

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
  map('n', '<leader>cl', '<cmd>lua vim.lsp.codelens.run()<CR>',
    { desc = 'Run code lens', buffer = bufnr })
  map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
    { desc = 'Execute code action', buffer = bufnr })
  map('n', '<leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    { desc = 'Pop signature help', buffer = bufnr })
  map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
    { desc = 'Rename object', buffer = bufnr })
  map('n', '<leader>ws', '<cmd>lua require"metals".hover_worksheet()<CR>',
    { desc = 'Hover workspace', buffer = bufnr })
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
  map('n', '<leader>bd', '<cmd>lua vim.diagnostic.setloclist()<CR>',
    { desc = 'Current buffer diagnostics', buffer = bufnr })

  map('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, { desc = "Format", buffer = bufnr })

  -- LSP mappings
  map("n", "gD", function() vim.lsp.buf.definition() end,
    { desc = "Go to definition", buffer = bufnr })
  map("n", "gd", function() vim.lsp.buf.declaration() end,
    { desc = "Go to declaration", buffer = bufnr })
  map('n', 'gy', function() vim.lsp.buf.type_definition() end,
    { desc = "Go to type definition", buffer = bufnr })
  map("n", "gr", function() vim.lsp.buf.references() end,
    { desc = "Show references", buffer = bufnr })
  map("n", "K", function() vim.lsp.buf.hover() end,
    { desc = "Hover", buffer = bufnr })
  map("n", "gi", function() vim.lsp.buf.implementation() end,
    { desc = "Go to implementation", buffer = bufnr })

  map("n", "gdS", function() vim.lsp.buf.document_symbol() end,
    { desc = "List symbols", buffer = bufnr })
  map("n", "gwS", function() vim.lsp.buf.workspace_symbol() end,
    { desc = "List workspace symbols", buffer = bufnr })
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
