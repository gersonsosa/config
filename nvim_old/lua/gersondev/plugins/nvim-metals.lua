return {
  "scalameta/nvim-metals",
  -- dir = "~/dev/code/lua_projects/nvim-metals",
  dependencies = "nvim-lua/plenary.nvim",
  ft = { "scala", "sbt" },
  config = function()
    local api = vim.api
    local metals = require("metals")
    local metals_config = metals.bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      testUserInterface = "Test Explorer",
      -- serverVersion = "latest.snapshot",
    }

    metals_config.init_options.statusBarProvider = "off"
    metals_config.find_root_dir_max_project_nesting = 2

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
      -- commands mappings
      local function metals_commands()
        return Snacks.picker.commands({
          transform = function(item, _)
            if vim.startswith(item.text, "Metals") then
              return item
            end
            return false
          end,
          preview = "none",
          layout = {
            preset = "vscode",
          },
          confirm = function(picker, item)
            picker:close()
            if item then
              vim.schedule(function()
                vim.cmd(item.text)
              end)
            end
          end,
        })
      end

      vim.keymap.set(
        "n",
        "<leader>mc",
        metals_commands,
        { desc = "Show metals commands", buffer = bufnr }
      )

      vim.keymap.set("n", "<leader>tr", function()
        -- TODO: run the closest test or case
      end, { desc = "Run test under cursor", buffer = bufnr })

      vim.keymap.set("n", "<leader>H", function()
        metals.hover_worksheet()
      end, { desc = "Hover worksheet", buffer = bufnr })

      vim.keymap.set("n", "gs", function()
        metals.super_method_hierarchy()
      end, { desc = "Go to super method in hierarchy", buffer = bufnr })

      vim.keymap.set("n", "<leader>tv", function()
        require("metals.tvp").toggle_tree_view()
      end, { desc = "Toggle tree view", buffer = bufnr })
      vim.keymap.set("n", "<leader>tV", function()
        require("metals.tvp").reveal_in_tree()
      end, { desc = "Reveal in tree", buffer = bufnr })
    end

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
