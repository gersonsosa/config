local f = require "gersondev.functions"
local map = f.map

require('gitsigns').setup({
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 800,
    ignore_whitespace = false,
  },
})
