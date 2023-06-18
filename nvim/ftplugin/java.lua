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

  on_attach = function(_, bufnr)
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls.setup.add_commands()

    local f = require "gersondev.functions"
    local map = f.map

    map('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, { desc = "Format", buffer = bufnr })
    map("n", "gD", function() vim.lsp.buf.definition() end,
      { desc = "Go to definition", buffer = bufnr })
    map("n", "K", function() vim.lsp.buf.hover() end,
      { desc = "Hover", buffer = bufnr })
    map("n", "gi", function() vim.lsp.buf.implementation() end,
      { desc = "Go to implementation", buffer = bufnr })
    map("n", "gr", function() vim.lsp.buf.references() end,
      { desc = "Show references", buffer = bufnr })
    map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
      { desc = 'Execute code action', buffer = bufnr })
    map('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
      { desc = 'Pop signature help', buffer = bufnr })
    map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
      { desc = 'Rename object', buffer = bufnr })
    map("n", "gd", function() vim.lsp.buf.declaration() end,
      { desc = "Go to definition", buffer = bufnr })
  end
}

-- Adjust vim tab options
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local f = require("gersondev.functions")
local map = f.map

map("n", "<leader>Jo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
map("n", "<leader>Jv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
map("n", "<leader>Jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Extract Constant" })
map("n", "<leader>Jt", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", { desc = "Test Method" })
map("n", "<leader>JT", "<Cmd>lua require'jdtls'.test_class()<CR>", { desc = "Test Class" })
map("n", "<leader>Ju", "<Cmd>JdtUpdateConfig<CR>", { desc = "Update Config" })
map("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("v", "<leader>Lv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = "Extract Variable" })
map("v", "<leader>Lc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { desc = "Extract Constant" })
map("v", "<leader>Lm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = "Extract Method" })

-- LSP mappings
map("n", "<leader>wa", '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
map("n", "<leader>wr", '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
map("n", "<leader>wl", '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
map("n", "<leader>D", '<cmd>lua vim.lsp.buf.type_definition()<CR>')
map("n", "<leader>rn", '<cmd>lua vim.lsp.buf.rename()<CR>')
map("n", "<leader>ca", '<cmd>lua vim.lsp.buf.code_action()<CR>')

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
