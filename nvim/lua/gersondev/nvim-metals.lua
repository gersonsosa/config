-------------------------------------------------------------------------------
-- These are example settings to use with nvim-metals and the nvim built-in
-- LSP. Be sure to thoroughly read the `:help nvim-metals` docs to get an
-- idea of what everything does. Again, these are meant to serve as an example,
-- if you just copy pasta them, then should work,  but hopefully after time
-- goes on you'll cater them to your own liking especially since some of the stuff
-- in here is just an example, not what you probably want your setup to be.
--
-- Unfamiliar with Lua and Neovim?
--  - Check out https://github.com/nanotee/nvim-lua-guide
--
-- The below configuration also makes use of the following plugins besides
-- nvim-metals, and therefore is a bit opinionated:
--
-- - https://github.com/hrsh7th/nvim-cmp
--   - hrsh7th/cmp-nvim-lsp for lsp completion sources
--   - hrsh7th/cmp-vsnip for snippet sources
--   - hrsh7th/vim-vsnip for snippet sources
--
-- - https://github.com/wbthomason/packer.nvim for package management
-- - https://github.com/mfussenegger/nvim-dap (for debugging)
-------------------------------------------------------------------------------
local api = vim.api

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt_global.shortmess:remove("F"):append("c")

local which_key = require "which-key"

local leader_opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local space_opts = {
  mode = "n", -- NORMAL mode
  prefix = "<space>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local leader_mappings = {
  c = {
    l = {
      '<cmd>lua vim.lsp.codelens.run()<CR>',
      'Run code lens'
    },
    a = {
      '<cmd>lua vim.lsp.buf.code_action()<CR>',
      'Execute code action'
    }
  },
  s = {
    h = {
      '<cmd>lua vim.lsp.buf.signature_help()<CR>',
      "Pop signature help"
    }
  },
  r = {
    n = {
      '<cmd>lua vim.lsp.buf.rename()<CR>',
      "Rename object"
    }
  },
  w = {
    s = {
      '<cmd>lua require"metals".hover_worksheet()<CR>',
      "Hover workspace"
    }
  },
  a = {
    a = {
      '<cmd>lua vim.diagnostic.setqflist()<CR>',
      "workspace diagnostics"
    }, -- all workspace diagnostics
    e = {
      '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>',
      "Workspace errors"
    }, -- all workspace errors
    w = {
      '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>',
      "Workspace warnings"
    }, -- all workspace warnings
  },
  d = {
    '<cmd>lua vim.diagnostic.setloclist()<CR>',
    "Current buffer diagnostics"
  } -- buffer diagnostics only
}

local space_mappings = {
  f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', "Format" },
}

which_key.register(leader_mappings, leader_opts)
which_key.register(space_mappings, space_opts)

-- LSP mappings
map("n", "gD", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover" })
map("n", "gi", function() vim.lsp.buf.implementation() end, { desc = "Go to implementation" })
map("n", "gr", function() vim.lsp.buf.references() end, { desc = "Show references" })
map("n", "gds", function() vim.lsp.buf.document_symbol() end, { desc = "List symbols" })
map("n", "gws", function() vim.lsp.buf.workspace_symbol() end, { desc = "List workspace symbols" })
map("n", "[c", function() vim.diagnostic.goto_prev { wrap = false } end, { desc = "Go to prev diag" })
map("n", "]c", function() vim.diagnostic.goto_next { wrap = false } end, { desc = "Go to next diag" })

-- DAP mappings
local leader_dap_mappings = {
  d = {
    c = { [[<cmd>lua require"dap".continue()<CR>]], 'Debug - Continue' },
    r = { [[<cmd>lua require"dap".repl.toggle()<CR>]], 'DAP - Toogle REPL' },
    K = { [[<cmd>lua require"dap.ui.widgets".hover()<CR>]], 'Debug - Hover' },
    t = { [[<cmd>lua require"dap".toggle_breakpoint()<CR>]], 'Toogle Breakpoint' },
    s = {
      o = { [[<cmd>lua require"dap".step_over()<CR>]], 'Debug - Step Over' },
      i = { [[<cmd>lua require"dap".step_into()<CR>]], 'Debug - Step into' }
    },
    l = { [[<cmd>lua require"dap".run_last()<CR>]], 'Debug - Run last' }
  },
}

which_key.register(leader_dap_mappings, leader_opts)

-- completion related settings
local cmp = require "cmp"
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- None of this made sense to me when first looking into this since there
    -- is no vim docs, but you can't have select = true here _unless_ you are
    -- also using the snippet stuff. So keep in mind that if you remove
    -- snippets you need to remove this select
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- I use tabs... some say you should stick to ins-completion but this is just here as an example
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
})

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- hide messages and display only trough vim.g['metals_status']
metals_config.init_options.statusBarProvider = "on"

-- make sure the correct capabilities for snippets are set
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function()
  require("metals").setup_dap()
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
