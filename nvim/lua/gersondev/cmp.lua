-- completion related settings

local cmp = require "cmp"
if cmp == nil then
  return
end

local types = require "cmp.types"

cmp.setup {
  sources = cmp.config.sources({
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "vsnip", keyword_length = 2 },
  }, {
    { name = "path", keyword_length = 2 },
    { name = "buffer", keyword_length = 99 },
    { name = "dictionary", keyword_length = 99 },
  }),
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-h>"] = cmp.mapping.select_prev_item({ count = 5 }),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-l>"] = cmp.mapping.select_next_item({ count = 5 }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-8),
    ['<C-f>'] = cmp.mapping.scroll_docs(8),
    ['<C-Space>'] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = true })
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
}

require("cmp_dictionary").setup({
  dic = { ["*"] = { "/usr/share/dict/words" } }
})

cmp.setup.filetype({ 'scala' }, {
  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
  }
})

cmp.setup.filetype({ 'gitcommit', 'markdown' }, {
  sources = cmp.config.sources({
    { name = "buffer", keyword_length = 99 },
    { name = "path", keyword_length = 2 },
    { name = "dictionary", keyword_length = 2 },
  })
})
