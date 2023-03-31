local languages = {
  "java",
  "scala",
  "c",
  "cpp",
  "rust",
  "kotlin",
  "javascript",
  "typescript",
  "fish",
  "lua",
  "bash",
  "yaml",
  "python",
  "vim",
  "sql"
};
require 'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = languages,
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "go" }, -- List of parsers to ignore installing
  highlight = {
    enable = languages, -- false will disable the whole extension
    disable = { "go" }, -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  -- indent = {
  --   enable = true
  -- },
}

vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldlevel = 20
vim.o.foldenable = true
