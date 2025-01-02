return {
  {
    "Saghen/blink.cmp",
    version = "v0.*",
    opts = {
      keymap = {
        ["<C-h>"] = { "select_prev" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "luasnip", "buffer", "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      completion = {
        trigger = {
          show_on_trigger_character = false,
          show_on_keyword = false,
        },
      },
    },
  },
}
