return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      -- library = { plugins = { "nvim-dap-ui" }, types = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local nvim_lsp = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities =
        cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local signs = { Error = "", Warn = "", Hint = "󰛩", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = " " .. icon, texthl = hl, numhl = hl })
      end

      -- Language specific configurations, move to a specific file?

      nvim_lsp.tsserver.setup({
        root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json"),
        init_options = {
          lint = true,
        },
        capabilities = capabilities,
      })

      nvim_lsp.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = {
                -- "${LUAROCKS}/my-lua-libs/share/lua/5.1",
                unpack(vim.api.nvim_get_runtime_file("", true)),
              },
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })

      nvim_lsp.pyright.setup({
        capabilities = capabilities,
        on_init = function(client)
          client.config.settings.python.venvPath = vim.fn.expand("~/.virtualenvs")
        end,
      })

      nvim_lsp.ruff_lsp.setup({
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })

      nvim_lsp.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = { format = true },
          redhat = { telemetry = { enabled = false } },
        },
      })

      nvim_lsp.ccls.setup({
        capabilities = capabilities,
        init_options = {
          compilationDatabaseDirectory = "build",
          --   index = {
          --     threads = 0;
          --   };
          clang = {
            excludeArgs = { "-frounding-math" },
          },
        },
      })

      nvim_lsp.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            imports = { granularity = { group = "module" } },
            cargo = { buildScripts = { enable = true } },
            procMacro = { enable = true },
            diagnostics = { enable = false },
          },
        },
      })

      nvim_lsp.gopls.setup({
        on_attach = function(_, bufnr)
          local dap_go_ok, dap_go = pcall(require, "dap-go")
          if dap_go_ok then
            dap_go.setup()

            vim.keymap.set("n", "<leader>dg", function()
              dap_go.debug_test()
            end, { buffer = bufnr, desc = "Debug Go Test" })
          end
        end,
        capabilities = capabilities,
        cmd = { "gopls", "serve" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      -- Use a loop to conveniently call 'setup' on multiple servers
      -- with common configurations map buffer local keybindings when
      -- the language server attaches
      local servers = { "eslint", "gradle_ls" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup({
          capabilities = capabilities,
        })
      end
    end,
  },
}
