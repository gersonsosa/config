local languages = {
  "awk",
  "bash",
  "c",
  "cmake",
  "cpp",
  "go",
  "haskell",
  "java",
  "javascript",
  "jq",
  "kotlin",
  "ledger",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "python",
  "regex",
  "rust",
  "scala",
  "sql",
  "terraform",
  "toml",
  "typescript",
  "vim",
  "yaml",
  "zig",
}

require("nvim-treesitter.configs").setup({
  ensure_installed = languages,
  auto_install = false,
  ignore_install = {},
  sync_install = false,
  modules = {},
  highlight = {
    enable = true,
    disable = function(_, buf)        -- function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "gnn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
