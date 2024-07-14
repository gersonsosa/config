return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local status_ok, gitsigns = pcall(require, "gitsigns")
    if not status_ok then
      return
    end
    gitsigns.setup({
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
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
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Go to next git hunk", buffer = bufnr })
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Go to previous git hunk", buffer = bufnr })
        vim.keymap.set(
          "n",
          "<leader>gd",
          gitsigns.diffthis,
          { desc = "Diff current buffer", buffer = bufnr }
        )
      end,
    })
  end,
}
