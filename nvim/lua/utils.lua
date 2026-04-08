vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/echasnovski/mini.icons" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon",    version = "harpoon2" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },
})

local function git_root_or_cwd()
  local git_dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error == 0 and git_dir ~= '' then
    return git_dir
  else
    return vim.loop.cwd() -- fallback to current working directory
  end
end

require("mini.icons").setup()
require('mini.pick').setup({
  source = {
    cwd = git_root_or_cwd()
  }
})

vim.ui.select = MiniPick.ui_select

vim.keymap.set("n", "<leader>gg", function() MiniPick.builtin.files({ tool = "git" }) end)
vim.keymap.set("n", "<leader>f", function() MiniPick.builtin.files({ tool = "fd" }) end)
vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end)
vim.keymap.set("n", "<leader>gp",
  function()
    local dir = vim.fn.expand("%:p:h")
    vim.notify(dir, vim.log.levels.INFO)
    MiniPick.builtin.grep_live({ source = { cwd = dir } })
  end)
vim.keymap.set("n", "<leader>h", function() MiniPick.builtin.help() end)
vim.keymap.set("n", "<leader>b", function() MiniPick.builtin.buffers() end)
vim.keymap.set("n", "<leader>*", [[:Pick grep pattern='<cword>'<cr>]])
vim.keymap.set("n", "<leader>ma", function() MiniPick.start({ source = { items = vim.fn.argv, name = "argv" } }) end)
vim.keymap.set("n", "<leader>mo",
  function()
    local root_dir = git_root_or_cwd() or "/"
    local oldfiles = vim.tbl_filter(function(file)
      return vim.startswith(vim.fs.normalize(file), root_dir)
    end, vim.v.oldfiles)
    MiniPick.start({
      source = {
        items = oldfiles,
        name = "OldFiles @ " .. root_dir,
        show = function(buf_id, items, query)
          MiniPick.default_show(buf_id, items, query, { show_icons = true })
        end
      },
    })
  end)
vim.keymap.set("n", "<leader><leader>", function() MiniPick.builtin.resume() end)

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(event)
    if event.data.updated then
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  prompt = "> ",
  keymaps = {
    close = "<C-c>",
    select = "<CR>",
    select_split = "<C-s>",
    select_vsplit = "<C-v>",
    select_tab = "<C-t>",
    move_up = { "<Up>", "<C-p>" },
    move_down = { "<Down>", "<C-n>" },
    preview_scroll_up = "<C-u>",
    preview_scroll_down = "<C-d>",
    toggle_debug = "<F2>",
  },
}

vim.keymap.set("n", "ff", function() require("fff").find_files() end, { desc = "FFFind files" })
vim.keymap.set("n", "<leader>gf", function() require("fff").find_files() end, { desc = "FFFind files" })

require("oil").setup({
  keymaps = {
    ["-"] = function()
      require("oil.actions").parent.callback()
      vim.cmd.lcd(require("oil").get_current_dir())
    end,
    ["<CR>"] = function()
      require("oil").select(nil, function(err)
        if not err then
          local curdir = git_root_or_cwd()
          if curdir then
            vim.cmd.lcd(curdir)
          end
        end
      end)
    end,
  }
})
vim.keymap.set("n", "-", function() vim.cmd.Oil() end)

local harpoon = nil
local lazy_harpoon = function()
  if not harpoon then
    harpoon = require("harpoon")
    harpoon:setup()
  end
  return harpoon
end
vim.keymap.set("n", "<leader>a", function()
  lazy_harpoon():list():add()
end)
vim.keymap.set("n", "<C-e>", function()
  lazy_harpoon().ui:toggle_quick_menu(lazy_harpoon():list())
end)
vim.keymap.set("n", "<C-j>", function()
  lazy_harpoon():list():select(1)
end)
vim.keymap.set("n", "<C-k>", function()
  lazy_harpoon():list():select(2)
end)
vim.keymap.set("n", "<C-l>", function()
  lazy_harpoon():list():select(3)
end)
vim.keymap.set("n", "<C-;>", function()
  lazy_harpoon():list():select(4)
end)

require("todo-comments").setup()
