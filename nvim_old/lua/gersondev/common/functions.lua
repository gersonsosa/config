local M = {}

local function get_marked_text(m1, m2)
  local _, srow, scol, _ = unpack(vim.fn.getpos(m1))
  local _, erow, ecol, _ = unpack(vim.fn.getpos(m2))

  local start_row, start_col, end_row, end_col
  if srow < erow or (srow == erow and scol <= ecol) then
    start_row, start_col, end_row, end_col = srow - 1, scol - 1, erow - 1, ecol
  else
    start_row, start_col, end_row, end_col = erow - 1, ecol - 1, srow - 1, scol
  end

  local max_col = 2147483646
  end_col = end_col <= max_col and end_col or max_col
  start_col = start_col >= 0 and start_col or 0

  return vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
end

function M.get_visual_text()
  vim.cmd("normal! ")
  local data = get_marked_text("'<", "'>")
  return table.concat(data, "\n")
end

return M
