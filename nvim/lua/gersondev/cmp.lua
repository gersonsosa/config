-- completion related settings
local cmp = require "cmp"
if cmp == nil then return end

local compare = require("cmp.config.compare")

local types = require "cmp.types"

cmp.setup {
  sources = cmp.config.sources({
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "vsnip",    keyword_length = 2 },
  }, {
    { name = "dictionary", keyword_length = 3 },
    { name = "path" },
    { name = "buffer",     keyword_length = 99 },
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
    completion = cmp.config.window.bordered({ col_offset = -5 }),
    documentation = cmp.config.window.bordered(),
  },
  preselect = cmp.PreselectMode.None,
}

local dict = require("cmp_dictionary")
dict.switcher({ spelllang = { en = "~/.local/share/dict/en.dict" } })
dict.update()

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
    { name = "dictionary", keyword_length = 3 },
    { name = "path",       keyword_length = 3 },
    { name = "buffer",     keyword_length = 99 },
  })
})
