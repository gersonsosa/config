-- completion related settings

local cmp = require "cmp"
if cmp == nil then
  return
end

cmp.setup {
  completion = {
    autocomplete = false
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer", keyword_length = 99 },
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
