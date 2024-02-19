return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = "BufRead",
  config = function()
    local languages = {
      "scala",
      "rust",
      "java",
      "lua",
      "haskell",
      "zig",
      "cpp",
      "c",
      "go",
      "cmake",
      "kotlin",
      "javascript",
      "typescript",
      "python",
      "sql",
      "fish",
      "teal",
      "bash",
      "yaml",
      "vim",
      "toml",
      "terraform",
      "nix",
      "ledger",
      "make",
      "jq",
      "awk"
    }

    require 'nvim-treesitter.configs'.setup {
      -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      ensure_installed = languages,
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      auto_install = false, -- install missing parsers automatically
      ignore_install = {},  -- List of parsers to ignore installing
      highlight = {
        enable = true,      -- false will disable the whole extension
        disable = {},       -- list of language that will be disabled
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        disable = {}, -- list of language that will be disabled
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            ["]t"] = { query = "@trait.outer", desc = "Next trait start" },
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[t"] = { query = "@trait.outer", desc = "Next trait start" },
            ["[S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
            ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>s"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>S"] = "@parameter.inner",
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = true,
        },
      }
    }

    local treesitter_context = require("treesitter-context")
    treesitter_context.setup {
      multiline_threshold = 10
    }

    vim.keymap.set("n", "[C", function()
      treesitter_context.go_to_context(vim.v.count1)
    end, { desc = "Go to previous context" })

    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    vim.o.foldmethod = "expr"
    vim.o.foldlevel = 20
    vim.o.foldenable = true
  end,
}
