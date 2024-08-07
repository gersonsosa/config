return {
  'NeogitOrg/neogit',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = 'Neogit',
  keys = '<leader>gs',
  config = function()
    local status_ok, neogit = pcall(require, "neogit")
    if not status_ok then
      return
    end

    neogit.setup {
      status = {
        recent_commit_count = 10,
      },
      integrations = {
        diffview = true
      },
      mappings = {
        status = {
          ["<C-k>"] = "Toggle",
          ["<C-j>"] = "Toggle",
          ["T"] = "Untrack",
          ["K"] = "GoToPreviousHunkHeader",
          ["J"] = "GoToNextHunkHeader",
        }
      }
    }
    vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit, { desc = "Open neogit" })
  end,
}
