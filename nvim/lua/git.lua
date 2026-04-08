vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.keymap.set("n", "<leader>gs", function() vim.cmd([[G]]) end)

require("gitsigns").setup({
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 500,
    ignore_whitespace = false,
    use_focus = true,
  },
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    vim.keymap.set(
      "n",
      "<leader>gb",
      gitsigns.toggle_current_line_blame,
      { desc = "Toggle line blame", buffer = bufnr }
    )
    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Go to next git hunk", buffer = bufnr })
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Go to previous git hunk", buffer = bufnr })
  end,
})
