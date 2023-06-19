local f = require "gersondev.common.functions"
local lsp_commons = require "gersondev.common.lsp"
local map = f.map

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = lsp_commons.setup_lsp_keymap

local nvim_lsp = require('lspconfig')
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Language specific configurations, move to a specific file?

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json"),
  init_options = {
    lint = true,
  },
  capabilities = capabilities,
}

nvim_lsp.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = function(client)
    client.config.settings.python.venvPath = vim.fn.expand('~/.virtualenvs')
  end
}

nvim_lsp.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = { format = true },
    redhat = { telemetry = { enabled = false } }
  }
}

nvim_lsp.ccls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    compilationDatabaseDirectory = "build",
    --   index = {
    --     threads = 0;
    --   };
    clang = {
      excludeArgs = { "-frounding-math" },
    },
  }
}

nvim_lsp.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      imports = { granularity = { group = "module" } },
      cargo = { buildScripts = { enable = true } },
      procMacro = { enable = true },
      diagnostics = { enable = false }
    }
  }
})

-- Use a loop to conveniently call 'setup' on multiple servers
-- with common configurations map buffer local keybindings when
-- the language server attaches
local servers = { "eslint", "gradle_ls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
