vim.o.termguicolors = true

require("catppuccin").setup {
  flavour = "macchiato", -- mocha, macchiato, frappe, latte
  integrations = {
    telescope = true,
    neogit = true,
    gitsigns = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,
    markdown = true,
    nvimtree = true,
    lsp_trouble = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "bold" },
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
      colored_indent_levels = true,
    },
  }
}

vim.cmd [[colorscheme catppuccin]]
