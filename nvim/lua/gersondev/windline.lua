local windline = require('windline')
local helpers = require('windline.helpers')
local b_components = require('windline.components.basic')
local state = _G.WindLine.state

local hl_list = {
  Black = { 'white', 'black' },
  White = { 'black', 'white' },
  Normal = { 'NormalFg', 'NormalBg' },
  Inactive = { 'InactiveFg', 'InactiveBg' },
  Active = { 'ActiveFg', 'ActiveBg' },
}
local basic = {}
basic.divider = { b_components.divider, hl_list.Normal }

local colors_mode = {
  Normal = { 'black', 'magenta' },
  Insert = { 'black', 'green' },
  Visual = { 'black', 'yellow' },
  Replace = { 'black', 'blue_light' },
  Command = { 'black', 'red' },
}

basic.slant_right = {
  name = "slant_right",
  hl_colors = colors_mode,
  text = function()
    return helpers.separators.slant_right
  end
}

basic.vi_mode = {
  name = 'vi_mode',
  hl_colors = colors_mode,
  text = function()
    return { { ' ' .. state.mode[1] .. ' ', state.mode[2] } }
  end,
}
basic.right = {
  hl_colors = colors_mode,
  text = function()
    return {
      { ' ', state.mode[2] },
      { b_components.progress },
      { ' ' },
      { helpers.separators.block },
      { b_components.line_col },
    }
  end,
}
basic.inactive = {
  { b_components.full_file_name, hl_list.Inactive },
  basic.divider,
  { b_components.line_col, hl_list.Inactive },
  { b_components.progress, hl_list.Inactive },
}
local default = {
  filetypes = { 'default' },
  active = {
    basic.vi_mode,
    { helpers.separators.slant_right, { 'magenta', 'NormalBg' } },
    { ' ', { 'white', 'NormalBg' } },
    { b_components.cache_file_name('[No Name]', 'unique') },
    basic.divider,
    { b_components.cache_file_type({ icon = true }), '' },
    { ' ' },
    { b_components.file_format({ icon = true }), { 'white', 'NormalBg' } },
    { ' ' },
    { b_components.file_encoding(), '' },
    { ' ' },
    { helpers.separators.slant_left, { 'magenta', 'NormalBg' } },
    basic.right,
  },
  inactive = basic.inactive,
}

windline.add_component({
  name = 'metals_status',
  text = function()
    if vim.g.metals_status ~= nil then return vim.g.metals_status else return '' end
  end,
}, {
  filetype = { 'scala', 'sbt' },
  position = 'right',
  autocmd = true,
})

windline.setup({
  statuslines = {
    default
  },
})
