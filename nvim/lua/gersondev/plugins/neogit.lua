return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Neogit",
  config = function()
    local status_ok, neogit = pcall(require, "neogit")
    if not status_ok then
      return
    end

    neogit.setup({
      status = {
        recent_commit_count = 10,
      },
      integrations = {
        diffview = true,
      },
      mappings = {
        status = {
          [">"] = "Toggle",
          ["<"] = "Toggle",
          ["T"] = "Untrack",
          ["K"] = "GoToPreviousHunkHeader",
          ["J"] = "GoToNextHunkHeader",
        },
      },
    })
  end,
}
