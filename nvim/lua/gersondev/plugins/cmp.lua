return {
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "rcarriga/cmp-dap",
      "uga-rosa/cmp-dictionary",
      "onsails/lspkind.nvim",
    },
    config = function()
      -- completion related settings
      local status_ok, cmp = pcall(require, "cmp")
      if not status_ok then
        return
      end

      local compare = require("cmp.config.compare")

      local types = require "cmp.types"
      local lspkind = require("lspkind")

      require("cmp_dictionary").setup({
        paths = { vim.fn.expand("~/.local/share/dict/en.dict") },
        exact_length = 2,
        first_case_insensitive = true,
        document = {
          enable = true,
          command = { "wn", "${label}", "-over" },
        },
      })

      cmp.setup {
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            menu = ({
              buffer = "[BUF]",
              nvim_lsp = "[LSP]",
              luasnip = "[LSNIP]",
              nvim_lua = "[LUA]",
              latex_symbols = "[LATEX]",
            }),
            maxwidth = 60,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              return vim_item
            end
          })
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = 'nvim_lsp_signature_help' }
        }, {
          { name = "buffer" },
          { name = "path" },
          { name = "dictionary", keyword_length = 2 },
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-h>"] = cmp.mapping.select_prev_item({ count = 5 }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-8),
          ['<C-f>'] = cmp.mapping.scroll_docs(8),
          ['<C-Space>'] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true })
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        preselect = cmp.PreselectMode.None,
      }

      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          {
            name = 'buffer',
          }
        }
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!', 'DiffviewOpen', 'DiffviewFileHistory' }
            }
          }
        })
      })

      cmp.setup.filetype({ 'scala' }, {
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,    -- we still want offset to be higher to order after 3rd letter
            compare.score,     -- same as above
            compare.sort_text, -- add higher precedence for sort_text, it must be above `kind`
            compare.recently_used,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
        -- if you want to add preselection you have to set completeopt to new values
        completion = {
          -- completeopt = 'menu,menuone,noselect', <---- this is default value,
          completeopt = 'menu,menuone', -- remove noselect
          autocomplete = {
            types.cmp.TriggerEvent.TextChanged,
          },
        }
      })

      cmp.setup.filetype({ 'gitcommit', 'markdown' }, {
        sources = cmp.config.sources({
          { name = "dictionary", keyword_length = 2 },
          { name = "path",       keyword_length = 2 },
          { name = "buffer" },
        })
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },
}
