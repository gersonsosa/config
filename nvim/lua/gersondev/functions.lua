local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- shamelessly taken from https://github.com/ojroques/nvim-osc52
local commands = {
  operator = { block = "`[\\<C-v>`]y", char = "`[v`]y", line = "'[V']y" },
  visual = { ['V'] = 'y', ['v'] = 'y', [''] = 'y' },
}

local function get_text(mode, type)
  local clipboard = vim.go.clipboard
  local register = vim.fn.getreginfo('"')
  local visual_marks = { vim.fn.getpos("'<"), vim.fn.getpos("'>") }

  -- Retrieve text
  vim.go.clipboard = ''
  local command = string.format('keepjumps normal! %s', commands[mode][type])
  vim.cmd(string.format('silent execute "%s"', command))
  local text = vim.fn.getreg('"')

  -- Restore user settings
  vim.go.clipboard = clipboard
  vim.fn.setreg('"', register)
  vim.fn.setpos("'<", visual_marks[1])
  vim.fn.setpos("'>", visual_marks[2])

  return text or ''
end

local function get_visual_text()
  local text = get_text('visual', vim.fn.visualmode())
  return text
end

local function get_operator_text_callback()
  local text = get_text('operator', type)
  return text
end

local function get_operator_text()
  vim.go.operatorfunc = get_operator_text_callback
  return 'g@'
end

return {
  map = map,
  get_visual_text = get_visual_text,
  get_operator_text = get_operator_text
}
