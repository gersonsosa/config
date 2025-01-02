return {
  "folke/zen-mode.nvim",
  cmd = { "ZenMode" },
  keys = "<leader>z",
  config = function()
    local status_ok, zenmode = pcall(require, "zen-mode")
    if not status_ok then
      return
    end
    zenmode.setup({
      window = {
        width = 120,
        height = 0.80,
        options = {
          number = true, -- disable number column
          relativenumber = true, -- disable relative numbers
          -- signcolumn = "no", -- disable signcolumn
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        tmux = { enabled = true },
      },
    })

    vim.keymap.set("n", "<leader>z", vim.cmd.ZenMode, { desc = "Toggle zen mode" })
  end,
}
