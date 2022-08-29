local jdtls = require('jdtls')

local jdtls_home = '/usr/share/java/jdtls'

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require('jdtls.setup').find_root(root_markers)

local jar_path = vim.fn.expand(jdtls_home .. '/plugins/org.eclipse.equinox.launcher_*.jar')

local Path = require('plenary.path')
local config_dir = Path:new "/tmp/my_jdtls_config_linux"
config_dir:mkdir()

local jdtls_config = Path:new(jdtls_home .. '/config_linux')
jdtls_config:copy({ destination = config_dir, recursive = true })

local home = os.getenv('HOME')
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java', -- or '/path/to/java11_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', jar_path,


    -- 💀
    '-configuration', config_dir:expand(),

    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_folder,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      saveActions = {
        organizeImports = true,
      },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },

  flags = {
    allow_incremental_sync = true
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },

  on_attach = function()
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls.setup.add_commands()
  end
}

-- Adjust vim tab options
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local which_key = require "which-key"

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  L = {
    name = "Java",
    o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
    v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
    c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
    t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
    T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
    u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
  },
}

local vmappings = {
  L = {
    name = "Java",
    v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
    c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
    m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
