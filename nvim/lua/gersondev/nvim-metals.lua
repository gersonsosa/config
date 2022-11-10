-------------------------------------------------------------------------------
-- Metals config
-------------------------------------------------------------------------------
local api = vim.api
local f = require "gersondev.functions"
local map = f.map

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals = require "metals"
local metals_config = metals.bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
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
  local leader_dap_mappings = {
    d = {
      c = { [[<cmd>lua require"dap".continue()<CR>]], 'Debug - Continue' },
      r = { [[<cmd>lua require"dap".repl.toggle()<CR>]], 'DAP - Toogle REPL' },
      K = { [[<cmd>lua require"dap.ui.widgets".hover()<CR>]], 'Debug - Hover' },
      t = { [[<cmd>lua require"dap".toggle_breakpoint()<CR>]], 'Toogle Breakpoint' },
      s = {
        o = { [[<cmd>lua require"dap".step_over()<CR>]], 'Debug - Step Over' },
        i = { [[<cmd>lua require"dap".step_into()<CR>]], 'Debug - Step into' }
      },
      l = { [[<cmd>lua require"dap".run_last()<CR>]], 'Debug - Run last' }
    },
  }

  local leader_opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = bufnr, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  local which_key = require "which-key"
  which_key.register(leader_dap_mappings, leader_opts)

  ----------------------------------
  -- Mappings -----------------------
  ----------------------------------
  map('n', '<leader>cl', '<cmd>lua vim.lsp.codelens.run()<CR>',
    { desc = 'Run code lens', buffer = bufnr })
  map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
    { desc = 'Execute code action', buffer = bufnr })
  map('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    { desc = 'Pop signature help', buffer = bufnr })
  map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
    { desc = 'Rename object', buffer = bufnr })
  map('n', '<leader>ws', '<cmd>lua require"metals".hover_worksheet()<CR>',
    { desc = 'Hover workspace', buffer = bufnr })
  -- all workspace diagnostics
  map('n', '<leader>aa', '<cmd>lua vim.diagnostic.setqflist()<CR>',
    { desc = 'Workspace diagnostics', buffer = bufnr })
  -- all workspace errors
  map('n', '<leader>ae', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>',
    { desc = 'Workspace errors', buffer = bufnr })
  -- all workspace warnings
  map('n', '<leader>aw', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>',
    { desc = 'Workspace warnings', buffer = bufnr })
  -- buffer diagnostics only
  map('n', '<leader>bd', '<cmd>lua vim.diagnostic.setloclist()<CR>',
    { desc = 'Current buffer diagnostics', buffer = bufnr })
  map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format", buffer = bufnr })

  -- LSP mappings
  map("n", "gD", function() vim.lsp.buf.definition() end,
    { desc = "Go to definition", buffer = bufnr })
  map("n", "K", function() vim.lsp.buf.hover() end,
    { desc = "Hover", buffer = bufnr })
  map("n", "gi", function() vim.lsp.buf.implementation() end,
    { desc = "Go to implementation", buffer = bufnr })
  map("n", "gr", function() vim.lsp.buf.references() end,
    { desc = "Show references", buffer = bufnr })
  map("n", "gds", function() vim.lsp.buf.document_symbol() end,
    { desc = "List symbols", buffer = bufnr })
  map("n", "gws", function() vim.lsp.buf.workspace_symbol() end,
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
