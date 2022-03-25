-- Set barbar's options
vim.g.bufferline = {
  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = true,

  -- Enable/disable close button
  closable = false,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '░',
  icon_separator_inactive = '▎',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<space>,', ':BufferPrevious<CR>', opts)
map('n', '<space>.', ':BufferNext<CR>', opts)
-- Goto buffer in position...
map('n', '<leader>1', ':BufferGoto 1<CR>', opts)
map('n', '<leader>2', ':BufferGoto 2<CR>', opts)
map('n', '<leader>3', ':BufferGoto 3<CR>', opts)
map('n', '<leader>4', ':BufferGoto 4<CR>', opts)
map('n', '<leader>5', ':BufferGoto 5<CR>', opts)
map('n', '<leader>6', ':BufferGoto 6<CR>', opts)
map('n', '<leader>7', ':BufferGoto 7<CR>', opts)
map('n', '<leader>8', ':BufferGoto 8<CR>', opts)
map('n', '<leader>9', ':BufferGoto 9<CR>', opts)
map('n', '<leader>0', ':BufferLast<CR>', opts)
-- Close buffer
map('n', '<leader>c', ':BufferClose<CR>', opts)
-- Magic buffer-picking mode
map('n', '<C-p>', ':BufferPick<CR>', opts)

