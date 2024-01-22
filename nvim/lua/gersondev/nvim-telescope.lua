local t = require('telescope')

t.setup {
  defaults = {
    layout_strategy = 'flex',
    layout_config = { height = 0.95 },
    path_display = { shorten = { len = 3, exclude = { 1, -1 } } },
    preview = {
      filesize_hook = function(filepath, bufnr, opts)
        local max_bytes = 10000
        local cmd = { "head-rs", "-c", max_bytes, filepath }
        require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
      end
    },
    cache_picker = {
      num_pickers = 10,
      limit_entries = 1000,
    },
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
