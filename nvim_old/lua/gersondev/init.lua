require("gersondev.lazy")
require("gersondev.lsp")
local common = require("gersondev.common.functions")

local augroup = vim.api.nvim_create_augroup
local gers_auto_command = augroup("Gers", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

-- Highlight on yank
autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
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
autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })

local term_auto_command = augroup("GersTerm", {})

local term = {
  buf_id = 0,
  win_id = 0,
}

vim.keymap.set("n", "<leader>te", function()
  local function setup_win_close_autocmd()
    autocmd("WinClosed", {
      group = term_auto_command,
      pattern = "" .. term.win_id,
      callback = function()
        term.win_id = 0
      end,
    })
  end

  if term.win_id > 0 then
    vim.api.nvim_set_current_win(term.win_id)
  else
    vim.cmd.vnew()
    term.win_id = vim.api.nvim_get_current_win()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 10)
    if term.buf_id > 0 then
      vim.api.nvim_win_set_buf(term.win_id, term.buf_id)
    else
      vim.cmd.term()
    end
    setup_win_close_autocmd()
  end
end)

autocmd("TermClose", {
  group = term_auto_command,
  callback = function()
    term.buf_id = 0
    term.win_id = 0
    vim.keymap.del({ "n", "v" }, "<leader>T")
  end,
})

autocmd("TermOpen", {
  group = term_auto_command,
  callback = function(args)
    term.buf_id = args.buf
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.statuscolumn = ""
    vim.o.signcolumn = "no"
    vim.opt_local.listchars = { space = " " }

    vim.keymap.set("n", "q", function()
      vim.api.nvim_win_close(0, false)
    end, { silent = true, buffer = term.buf_id })
    vim.keymap.set({ "n", "v" }, "<leader>T", function()
      if term.buf_id > 0 then
        local text = common.get_visual_text()
        vim.fn.chansend(vim.bo[term.buf_id].channel, { text .. "\r\n" })
      end
    end)
  end,
})

vim.api.nvim_create_user_command("Chx", "!chmod +x %", {})
vim.api.nvim_create_user_command("Chrx", "!chmod -x %", {})
