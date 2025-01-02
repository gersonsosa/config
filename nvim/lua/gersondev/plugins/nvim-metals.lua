return {
  "scalameta/nvim-metals",
  dependencies = "nvim-lua/plenary.nvim",
  ft = { "scala", "sbt" },
  config = function()
    -------------------------------------------------------------------------------
    -- Metals config
    -------------------------------------------------------------------------------
    local api = vim.api

    ----------------------------------
    -- LSP Setup ---------------------
    ----------------------------------
    local metals = require("metals")
    local metals_config = metals.bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      testUserInterface = "Test Explorer",
      serverVersion = "latest.snapshot",
    }

    metals_config.init_options.statusBarProvider = "off"

    metals_config.find_root_dir_max_project_nesting = 2

    -- make sure the correct capabilities for snippets are set
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    metals_config.capabilities = capabilities

    -- Debug settings if you're using nvim-dap
    local dap = require("dap")

    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "Run",
        metals = {
          runType = "run",
        },
      },
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

    metals_config.on_attach = function(_, bufnr)
      metals.setup_dap()

      -- Telescope mappings
      local function metals_commands()
        local telescope_ok, telescope = pcall(require, "telescope")
        if not telescope_ok then
          vim.notify("Couln't load telescope, is it installed?", vim.log.levels.ERROR)
        end
        telescope.extensions.metals.commands()
      end

      vim.keymap.set(
        "n",
        "<leader>mc",
        metals_commands,
        { desc = "Show metals commands", buffer = bufnr }
      )

      vim.keymap.set("n", "<leader>ws", function()
        metals.hover_worksheet()
      end, { desc = "Hover worksheet", buffer = bufnr })

      ----------------------------------
      -- Mappings -----------------------
      ----------------------------------
      vim.keymap.set("n", "gs", function()
        metals.super_method_hierarchy()
      end, { desc = "Go to super method in hierarchy", buffer = bufnr })

      vim.keymap.set("n", "<leader>tt", function()
        require("metals.tvp").toggle_tree_view()
      end, { desc = "Toggle tree view", buffer = bufnr })
      vim.keymap.set("n", "<leader>ttr", function()
        require("metals.tvp").reveal_in_tree()
      end, { desc = "Reveal in tree", buffer = bufnr })
    end

    -- Autocmd that will actually be in charging of starting the whole thing
    local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
    api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
