local utils = require("heirline.utils")

local function setup_colors()
  return {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
  }
end

require('heirline').load_colors(setup_colors())

local conditions = require("heirline.conditions")

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = setup_colors()
    utils.on_colorscheme(colors)
  end,
  group = "Heirline",
})

local resources = {}

resources.icons = {
  powerline    = {
    -- 
    vertical_bar_thin = '│',
    vertical_bar = '┃',
    block = '█',
    ----------------------------------------------
    left = '', left_filled = '',
    right = '', right_filled = '',
    ----------------------------------------------
    slant_left = '', slant_left_thin = '',
    slant_right = '', slant_right_thin = '',
    ----------------------------------------------
    slant_left_2 = '', slant_left_2_thin = '',
    slant_right_2 = '', slant_right_2_thin = '',
    ----------------------------------------------
    left_rounded = '', left_rounded_thin = '',
    right_rounded = '', right_rounded_thin = '',
    ----------------------------------------------
    trapezoid_left = '', trapezoid_right = '',
    ----------------------------------------------
    line_number = '', column_number = '',
  },
  padlock      = '',
  circle_small = '●', -- ●
  circle       = '', -- 
  circle_plus  = '', -- 
  dot_circle_o = '', -- 
  circle_o     = '⭘', -- ⭘
}

local mode = {
  init = function(self)
    self.mode = vim.fn.mode(1) -- return the whole mode name

    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:*o",
        command = 'redrawstatus'
      })
      self.once = true
    end
  end,
  static = {
    mode_names = {
      n = "NORMAL", -- normal
      no = "OP",
      nov = "OP-V",
      noV = "OP-C-V",
      ["no\22"] = "OP",
      niI = "INSERT[N]",
      niR = "REPLACE[N]",
      niV = "VIRTUAL[N]",
      nt = "TERM[N]",
      v = "VISUAL",
      vs = "VISUAL SEL",
      V = "VISUAL LINE",
      Vs = "SELECT[V-L]",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "SEL",
      S = "SEL LINE",
      ["\19"] = "^S",
      i = "INSERT",
      ic = "INSERT CMP",
      ix = "INSERT[C-X]",
      R = "REPLACE",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "COMMAND",
      cv = "EX",
      r = "...",
      rm = "MORE",
      ["r?"] = "?",
      ["!"] = "!",
      t = "",
    },
    mode_colors = {
      n = "orange",
      i = "green",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan",
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple",
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "red",
    }
  },
  fallthrough = false,
}

local active_mode = {
  provider = function(self)
    return self.mode_names[self.mode]
  end,
  hl = function()
    return { fg = "bright_bg", bold = true, }
  end,
  condition = function(self)
    return self.mode ~= 'n' and vim.bo.buftype == ''
  end,
}

local active_mode_surrounded = utils.surround(
  { resources.icons.powerline.left_rounded, resources.icons.powerline.right_rounded },
  function(self)
    local mode_first_letter = self.mode:sub(1, 1) -- get only the first mode character
    return self.mode_colors[mode_first_letter]
  end, active_mode)

local normal_mode = {
  provider = "%2(" .. resources.icons.circle .. "%)",
  hl = { fg = "orange", bold = true },
  condition = function(self)
    return self.mode == 'n' and vim.bo.buftype == ''
  end,
}

mode = utils.insert(
  mode,
  normal_mode,
  active_mode_surrounded
)

local file_name_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local file_icon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local file_name = {
  provider = function(self)
    self.long_filename = vim.fn.fnamemodify(self.filename, ":.")
    if self.long_filename == "" then return "[No Name]" end
  end,

  hl = { fg = utils.get_highlight("Directory").fg },

  flexible = 2,

  {
    provider = function(self)
      return self.long_filename
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.long_filename)
    end,
  },
}

local file_flags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "orange" },
  },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local filename_modifier = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "cyan", bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
file_name_block = utils.insert(
  file_name_block,
  file_icon,
  utils.insert(filename_modifier, file_name), -- a new table where FileName is a child of FileNameModifier
  file_flags,
  { provider = '%<' }-- this means that the statusline is cut here when there's not enough space
)

local file_type = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

-- We're getting minimalists here!
local ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
}

-- I take no credits for this! :lion:
local scrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = "blue", bg = "bright_bg" },
}

local lsp_server_list = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },

  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.buf_get_clients(0)) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "]"
  end,
  hl       = { fg = "green", bold = true },
}

local helpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = setup_colors().blue },
}

local metals_status = {
  condition = function()
    return (vim.bo.filetype == 'scala'
        or vim.bo.filetype == 'sbt')
        and vim.g['metals_status'] ~= nil
        and vim.g['metals_status'] ~= ''
  end,
  provider = function() return ' ' .. vim.g['metals_status'] end,
  hl = { fg = setup_colors().blue },
}

-- Put it all together

local align = { provider = "%=" }
local space = { provider = " " }

local defaultStatusline = {
  mode, space, file_name_block, space, align,
  metals_status, space, lsp_server_list, space, file_type, space, ruler, space, scrollBar
}

local inactiveStatusline = {
  condition = conditions.is_not_active,
  file_type, space, file_name_block, align,
}

local specialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,

  file_type, space, helpFileName, align
}

local statusLines = {

  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  -- the first statusline with no condition, or which condition returns true is used.
  -- think of it as a switch case with breaks to stop fallthrough.
  fallthrough = false,

  specialStatusline, inactiveStatusline, defaultStatusline,
}

require 'heirline'.setup(statusLines)
