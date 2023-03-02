local t = require('telescope')
t.setup {
  defaults = {
    path_display = { "shorten" },
    preview = {
      filesize_hook = function(filepath, bufnr, opts)
        local max_bytes = 10000
        local cmd = { "head", "-c", max_bytes, filepath }
        require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
      end
    }
  },
  prompt_prefix = "❯",
  pickers = {
    find_files = { theme = "ivy" },
    git_files = { theme = "ivy" },
    buffers = { theme = "ivy" },
    oldfiles = { theme = "ivy" },
    frecency = { theme = "ivy" },
    live_grep = { theme = "dropdown" },
    grep_string = { theme = "dropdown" }
  },
}

t.load_extension('zf-native')
t.load_extension('ui-select')
