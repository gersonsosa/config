local function get_current_buffer_directory()
  local buffer_path = vim.api.nvim_buf_get_name(0)

  if buffer_path == "" then
    return vim.fn.getcwd() -- Return current working directory if no file
  end
  return vim.fn.fnamemodify(buffer_path, ":h")
end

return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local has_telescope, telescope = pcall(require, "telescope")
      if not has_telescope then
        vim.notify("ERROR: couldn't load telescope")
        return
      end

      telescope.setup({
        defaults = {
          layout_strategy = "flex",
          path_display = { truncate = 3, filename_first = true },
          -- path_display = { shorten = { len = 2, exclude = { 2, -2, -1 } } },
          preview = {
            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = { "head-rs", "-c", max_bytes, filepath }
              require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
            end,
          },
          cache_picker = {
            num_pickers = 5,
            limit_entries = 1000,
          },
        },
        prompt_prefix = "❯",
        pickers = {
          find_files = {
            theme = "ivy",
            layout_config = { width = 0.8, prompt_position = "top" },
          },
          git_files = {
            theme = "ivy",
            layout_config = { width = 0.8, prompt_position = "top" },
          },
          buffers = {
            theme = "ivy",
            layout_strategy = "bottom_pane",
            layout_config = { width = 0.8, prompt_position = "top" },
          },
          oldfiles = { theme = "dropdown" },
          live_grep = { theme = "dropdown" },
          grep_string = { theme = "dropdown" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = false, -- use zf
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
          ["zf-native"] = {
            file = {
              enable = true,
              highlight_results = true,
              match_filename = true,
              initial_sort = nil,
              smart_case = true,
            },

            -- options for sorting all other items
            generic = {
              enable = false,
              highlight_results = true,
              match_filename = false,
              initial_sort = nil,
              smart_case = true,
            },
          },
        },
      })

      telescope.load_extension("zf-native")
      telescope.load_extension("fzf")

      vim.keymap.set("n", "<leader>of", [[<cmd>Telescope find_files<cr>]], { desc = "Find files" })
      vim.keymap.set(
        "n",
        "<leader>gg",
        [[<cmd>Telescope git_files<cr>]],
        { desc = "Find git files" }
      )
      vim.keymap.set("n", "<leader>b", [[<cmd>Telescope buffers<cr>]], { desc = "Buffers" })
      vim.keymap.set("n", "<leader>rr", [[<cmd>Telescope registers<cr>]], { desc = "Registers" })
      vim.keymap.set("n", "<leader>cc", [[<cmd>Telescope commands<cr>]], { desc = "Commands" })
      vim.keymap.set(
        "n",
        "<leader>hh",
        [[<cmd>Telescope help_tags<cr>]],
        { desc = "Search help tags" }
      )
      vim.keymap.set(
        "n",
        "<leader>tr",
        [[<cmd>Telescope pickers<cr>]],
        { desc = "Resume a telescope prompt" }
      )
      vim.keymap.set(
        "n",
        "<leader>wg",
        [[<cmd>Telescope grep_string<cr>]],
        { desc = "Grep selected string" }
      )
      vim.keymap.set(
        "x",
        "<leader>wg",
        [[<cmd>Telescope grep_string<cr>]],
        { desc = "Grep selected string" }
      )

      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

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
            map({ "i", "n" }, "<C-f>", function()
              -- TODO: get all file types from the current list?
              vim.ui.select(
                { "scala", "rust", "markdown", "kotlin", "java", "typescript", "sql", "js" },
                {
                  prompt = "Select type filter:",
                  format_item = function(item)
                    return item
                  end,
                },
                function(choice)
                  builtin.live_grep({
                    cwd = vim.loop.cwd(),
                    type_filter = choice,
                    glob_pattern = { "!*Code.js", "!*lib*.js" }, -- exclude large files
                  })
                end
              )
            end)
            return true
          end,
        })
      end, { desc = "Live grep" })

      vim.keymap.set("n", "<leader>rf", function()
        vim.ui.input({ prompt = "Enter glob pattern: ", default = "*." }, function(glob_pattern)
          if glob_pattern == "*." then
            builtin.live_grep({
              cwd = vim.loop.cwd(),
            })
          end
          builtin.live_grep({
            cwd = vim.loop.cwd(),
            glob_pattern = glob_pattern,
          })
        end)
      end, { desc = "Live grep with type filter" })

      vim.keymap.set("n", "<leader>td", function()
        builtin.live_grep({ cwd = get_current_buffer_directory() })
      end, { desc = "Live grep in the current buffer directory" })

      vim.keymap.set("n", "<leader>t", function()
        builtin.builtin(themes.get_ivy({
          layout_config = {
            preview_width = 0.8,
          },
        }))
      end, { desc = "Show all telescope builtin functions" })

      vim.keymap.set("n", "<leader>Wg", function()
        builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
      end, { desc = "Grep selected string" })
    end,
  },
}
