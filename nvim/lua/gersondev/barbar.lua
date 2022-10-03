-- Set barbar's options
require('bufferline').setup {
  animation = true,
  tabpages = true,
  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable close button
  closable = false,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '⏽',
  icon_separator_inactive = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  exclude_ft = { 'qf' },
  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
  no_name_title = nil,
}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<space>,', ':BufferPrevious<CR>',
  { desc = "Go to previous buffer", noremap = true, silent = true })
map('n', '<space>.', ':BufferNext<CR>',
  { desc = "Go to next buffer", noremap = true, silent = true })
-- Goto buffer in position...
map('n', '<leader>1', [[:BufferGoto 1<CR>]], opts)
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
map('n', '<leader>q', ':BufferDelete<CR>', opts)
map('n', '<leader>k', ':BufferWipeout!<CR>', opts)
-- Magic buffer-picking mode
map('n', '<leader>p', ':BufferPick<CR>', opts)
