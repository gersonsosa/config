require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = '',
    section_separators = { left = ' ', right = ' ' },
    disabled_filetypes = { 'qf' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '█', right = ' ' }, right_padding = 2 },
    },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'g:metals_status' },
    lualine_y = { { require('auto-session-library').current_session_name }, 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { left = ' ', right = '█' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
