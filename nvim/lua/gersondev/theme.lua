vim.o.termguicolors = true
vim.cmd [[colorscheme catppuccin]]

require("catppuccin").setup {
  flavour = "macchiato", -- mocha, macchiato, frappe, latte
  telescope = true,
  treesitter = true,
  treesitter_context = true,
  integrations = {
    which_key = true,
    dap = {
      enabled = true,
      enable_ui = false,
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
  }
}
