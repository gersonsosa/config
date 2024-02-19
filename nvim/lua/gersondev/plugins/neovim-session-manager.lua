return {
  "Shatur/neovim-session-manager",
  config = function()
    local config = require('session_manager.config')
    require("session_manager").setup({
      autoload_mode = config.AutoloadMode.CurrentDir,
      autosave_ignore_dirs = { "~/", "~/Downloads" },   -- A list of directories where the session will not be autosaved.
    })
  end
}
