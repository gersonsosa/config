return {
  "scalameta/nvim-metals",
  dependencies = "nvim-lua/plenary.nvim",
  ft = { "scala", "sbt" },
  config = function()
    -------------------------------------------------------------------------------
    -- Metals config
    -------------------------------------------------------------------------------
    local api = vim.api

    -- workaround to metals not having statandarized lsp progress reporting
    local function metals_status_handler(err, status, ctx)
      local val = {}
      -- trim and remove spinner
      local text = status.text:gsub("[⠇⠋⠙⠸⠴⠦]", ""):gsub("^%s*(.-)%s*$", "%1")
      if status.hide then
        val = { kind = "end" }
      elseif status.show then
        val = { kind = "begin", title = text }
      elseif status.text then
        val = { kind = "report", message = text }
      else
        return
      end
      local msg = { token = "metals", value = val }
      vim.lsp.handlers["$/progress"](err, msg, ctx)
    end

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
    }

    -- hide messages and display only trough vim.g['metals_status']
    metals_config.init_options.statusBarProvider = "on"
    metals_config.handlers = { ["metals/status"] = metals_status_handler }

    metals_config.find_root_dir_max_project_nesting = 2

    -- make sure the correct capabilities for snippets are set
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

      vim.keymap.set(
        "n",
        "<leader>ws",
        '<cmd>lua require"metals".hover_worksheet()<CR>',
        { desc = "Hover worksheet", buffer = bufnr }
      )

      -- DAP mappings
      vim.keymap.set(
        "n",
        "<leader>dc",
        [[<cmd>lua require"dap".continue()<CR>]],
        { desc = "Debug - Continue", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>dr",
        [[<cmd>lua require"dap".repl.toggle()<CR>]],
        { desc = "DAP - Toogle REPL", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>dK",
        [[<cmd>lua require"dap.ui.widgets".hover()<CR>]],
        { desc = "Debug - Hover", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>dt",
        [[<cmd>lua require"dap".toggle_breakpoint()<CR>]],
        { desc = "Toogle Breakpoint", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>dso",
        [[<cmd>lua require"dap".step_over()<CR>]],
        { desc = "Debug - Step Over", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>dsi",
        [[<cmd>lua require"dap".step_into()<CR>]],
        { desc = "Debug - Step into", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>dl",
        [[<cmd>lua require"dap".run_last()<CR>]],
        { desc = "Debug - Run last", buffer = bufnr }
      )

      ----------------------------------
      -- Mappings -----------------------
      ----------------------------------
      vim.keymap.set(
        "n",
        "<leader>gS",
        [[<cmd>lua require("metals").super_method_hierarchy()<CR>]],
        { desc = "Go to super method in hierarchy", buffer = bufnr }
      )

      vim.keymap.set(
        "n",
        "<leader>tt",
        [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]],
        { desc = "Toggle tree view", buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "<leader>ttr",
        [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]],
        { desc = "Reveal in tree", buffer = bufnr }
      )
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
