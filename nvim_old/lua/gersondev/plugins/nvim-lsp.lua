return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "nvim-dap-ui",
        { path = "snacks.nvim", words = { "snacks" } },
        { path = "oil.nvim", words = { "oil" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>]",
        function()
          require("trouble").next()
          require("trouble").jump_only()
        end,
        desc = "Trouble next",
      },
      {
        "<leader>[",
        function()
          require("trouble").prev()
          require("trouble").jump_only()
        end,
        desc = "Trouble next",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local nvim_lsp = require("lspconfig")
      nvim_lsp.yamlls.setup({
        settings = {
          yaml = { format = true },
          redhat = { telemetry = { enabled = false } },
        },
      })

      nvim_lsp.rust_analyzer.setup({
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
    end,
  },
}
