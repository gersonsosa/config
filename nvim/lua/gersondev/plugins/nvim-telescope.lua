return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "natecraddock/telescope-zf-native.nvim",
  },
  config = function()
    local has_telescope, t = pcall(require, "telescope")
    if not has_telescope then
      vim.notify("ERROR: couldn't load telescope")
      return
    end


    t.setup {
      defaults = {
        layout_strategy = 'flex',
        path_display = { shorten = { len = 2, exclude = { 2, -2, -1 } } },
        preview = {
          filesize_hook = function(filepath, bufnr, opts)
            local max_bytes = 10000
            local cmd = { "head-rs", "-c", max_bytes, filepath }
            require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
          end
        },
        cache_picker = {
          num_pickers = 5,
          limit_entries = 1000,
        },
      },
      prompt_prefix = "❯",
      pickers = {
        find_files = { theme = "ivy" },
        git_files = { theme = "ivy" },
        buffers = { theme = "ivy" },
        oldfiles = { theme = "dropdown" },
        live_grep = { theme = "dropdown" },
        grep_string = { theme = "dropdown" }
      },
    }

    t.load_extension('zf-native')

    vim.keymap.set("n", "<leader>of", [[<cmd>Telescope find_files<cr>]], { desc = "Find files" })
    vim.keymap.set("n", "<leader>gg", [[<cmd>Telescope git_files<cr>]], { desc = "Find git files" })
    vim.keymap.set("n", "<leader>b", [[<cmd>Telescope buffers<cr>]], { desc = "Buffers" })
    vim.keymap.set("n", "<leader>rr", [[<cmd>Telescope registers<cr>]], { desc = "Registers" })
    vim.keymap.set("n", "<leader>cc", [[<cmd>Telescope commands<cr>]], { desc = "Commands" })
    vim.keymap.set("n", "<leader>hh", [[<cmd>Telescope help_tags<cr>]], { desc = "Search help tags" })
    vim.keymap.set("n", "<leader>tr", [[<cmd>Telescope pickers<cr>]], { desc = "Resume a telescope prompt" })
    vim.keymap.set("n", "<leader>wg", [[<cmd>Telescope grep_string<cr>]], { desc = "Grep selected string" })

    local has_builtin, builtin = pcall(require, "telescope.builtin")
    if not has_builtin then
      vim.notify("ERROR: couldn't load telescope builtin")
      return
    end

    local has_themes, themes = pcall(require, "telescope.themes")
    if not has_themes then
      vim.notify("ERROR: couldn't load telescope themes")
      return
    end

    vim.keymap.set("n", "<leader>ol", function()
      builtin.oldfiles({
        cwd = vim.loop.cwd(),
        cwd_only = true,
      })
    end, { desc = "Recently opened files" })

    vim.keymap.set("n", "<leader>rg", function()
      builtin.live_grep({
        cwd = vim.loop.cwd(),
        glob_pattern = { "!*.js" },
        attach_mappings = function(_, map)
          map('i', '<C-f>', function()
            vim.ui.select({ 'scala', 'markdown', 'kotlin', 'java', 'typescript', 'sql', 'js' }, {
              prompt = 'Select type filter:',
              format_item = function(item)
                return item
              end,
            }, function(choice)
              builtin.live_grep({
                cwd = vim.loop.cwd(),
                type_filter = choice,
                glob_pattern = { "!*Code.js", "!*lib*.js" },
              })
            end)
          end)
          return true
        end,
      })
    end, { desc = "Live grep" })

    vim.keymap.set("n", "<leader>rf", function()
      vim.ui.input({ prompt = 'Glob pattern: ' }, function(glob_pattern)
        builtin.live_grep({
          cwd = vim.loop.cwd(),
          glob_pattern = glob_pattern,
        })
      end)
    end, { desc = "Live grep with type filter" })

    vim.keymap.set("n", "<leader>t", function()
      builtin.builtin(themes.get_ivy({
        layout_config = {
          preview_width = 0.8,
        },
      }))
    end, { desc = "Show all telescope builtin functions" })

    local has_text, text = pcall(require, "gersondev.common.functions")
    if not has_text then
      vim.notify("ERROR: couldn't load gersondev.common.functions")
      return
    end

    vim.keymap.set("x", "<leader>wg", function()
        builtin.grep_string({ search = text.get_visual_text() })
      end,
      { desc = "Grep selected string" })
  end,
}
