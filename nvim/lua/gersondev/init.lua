require('gersondev.opt')
require('gersondev.lazy')

local augroup = vim.api.nvim_create_augroup
local gers_auto_command = augroup('Gers', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

-- Highlight on yank
autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 120,
    })
  end,
})
-- remove whitespace when writing
autocmd({ "BufWritePre" }, {
  group = gers_auto_command,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- leave paste mode when leaving insert mode (if it was on)
autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })
