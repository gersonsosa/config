return {
  "rebelot/heirline.nvim",
  config = function()
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")

    local function setup_colors()
      return {
        bright_bg = utils.get_highlight("Folded").bg or utils.get_highlight("EndOfBuffer").fg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg or utils.get_highlight("EndOfBuffer").fg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }
    end

    require("heirline").load_colors(setup_colors())

    local resources = {}

    resources.icons = {
      powerline = {
        -- 
        vertical_bar_thin = "│",
        vertical_bar = "┃",
        block = "█",
        ----------------------------------------------
        left = "",
        left_filled = "",
        right = "",
        right_filled = "",
        ----------------------------------------------
        slant_left = "",
        slant_left_thin = "",
        slant_right = "",
        slant_right_thin = "",
        ----------------------------------------------
        slant_left_2 = "",
        slant_left_2_thin = "",
        slant_right_2 = "",
        slant_right_2_thin = "",
        ----------------------------------------------
        left_rounded = "",
        left_rounded_thin = "",
        right_rounded = "",
        right_rounded_thin = "",
        ----------------------------------------------
        trapezoid_left = "",
        trapezoid_right = "",
        ----------------------------------------------
        line_number = "",
        column_number = "",
      },
      padlock = "",
      circle_small = "●", -- ●
      circle = "", -- 
      circle_plus = "", -- 
      dot_circle_o = "", -- 
      circle_o = "⭘", -- ⭘
      diagnostic = {
        good = "",
        error = "",
        warn = "",
        info = "",
        hint = "",
      },
      lsp = {
        default = "㊙️",
        copilot = "",
        metals = "",
        pyright = "",
        tsserver = "󰛦",
        lua_ls = "",
        rust_analyzer = "",
        jdtls = "",
        gopls = "",
        ruff_lsp = "rff",
        yaml_ls = "",
        ccls = "󰙱",
        gradle_ls = "",
      },
    }

    local mode = {
      init = function(self)
        self.mode = vim.fn.mode(1) -- return the whole mode name

        if not self.once then
          vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*:*o",
            command = "redrawstatus",
          })
          self.once = true
        end
      end,
      static = {
        mode_names = {
          n = "NORMAL", -- normal
          no = "OP",
          nov = "OP-V",
          noV = "OP-C-V",
          ["no\22"] = "OP",
          niI = "INSERT[N]",
          niR = "REPLACE[N]",
          niV = "VIRTUAL[N]",
          nt = "TERM[N]",
          v = "VISUAL",
          vs = "VISUAL SEL",
          V = "VISUAL LINE",
          Vs = "SELECT[V-L]",
          ["\22"] = "^V",
          ["\22s"] = "^V",
          s = "SEL",
          S = "SEL LINE",
          ["\19"] = "^S",
          i = "INSERT",
          ic = "INSERT CMP",
          ix = "INSERT[C-X]",
          R = "REPLACE",
          Rc = "Rc",
          Rx = "Rx",
          Rv = "Rv",
          Rvc = "Rv",
          Rvx = "Rv",
          c = "COMMAND",
          cv = "EX",
          r = "...",
          rm = "MORE",
          ["r?"] = "?",
          ["!"] = "!",
          t = "",
        },
        mode_colors = {
          n = "orange",
          i = "green",
          v = "cyan",
          V = "cyan",
          ["\22"] = "cyan",
          c = "orange",
          s = "purple",
          S = "purple",
          ["\19"] = "purple",
          R = "orange",
          r = "orange",
          ["!"] = "red",
          t = "red",
        },
      },
      fallthrough = false,
    }

    local active_mode = {
      provider = function(self)
        return self.mode_names[self.mode]
      end,
      hl = function()
        return { fg = "bright_bg", bold = true }
      end,
      condition = function(self)
        return self.mode ~= "n" and vim.bo.buftype == ""
      end,
    }

    local active_mode_surrounded = utils.surround(
      { resources.icons.powerline.left_rounded, resources.icons.powerline.right_rounded },
      function(self)
        local mode_first_letter = self.mode:sub(1, 1) -- get only the first mode character
        return self.mode_colors[mode_first_letter]
      end,
      active_mode
    )

    local normal_mode = {
      provider = "%2(" .. resources.icons.circle .. "%)",
      hl = { fg = "orange", bold = true },
      condition = function(self)
        return self.mode == "n" and vim.bo.buftype == ""
      end,
    }

    mode = utils.insert(mode, normal_mode, active_mode_surrounded)

    local file_name_block = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }
    -- We can now define some children separately and add them later

    local file_icon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local file_name = {
      provider = function(self)
        self.long_filename = vim.fn.fnamemodify(self.filename, ":.")
        if self.long_filename == "" then
          return "[No Name]"
        end
      end,

      hl = { fg = utils.get_highlight("Directory").fg },

      flexible = 2,

      {
        provider = function(self)
          return self.long_filename
        end,
      },
      {
        provider = function(self)
          return vim.fn.pathshorten(self.long_filename)
        end,
      },
    }

    local file_flags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
      },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    local filename_modifier = {
      hl = function()
        if vim.bo.modified then
          -- use `force` because we need to override the child's hl foreground
          return { fg = "cyan", bold = true, force = true }
        end
      end,
    }

    -- let's add the children to our FileNameBlock component
    file_name_block = utils.insert(
      file_name_block,
      file_icon,
      utils.insert(filename_modifier, file_name), -- a new table where FileName is a child of FileNameModifier
      file_flags,
      { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    local file_type = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }

    -- We're getting minimalists here!
    local ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = "%7(%l/%3L%):%2c %P",
      hl = { fg = "blue", bold = true },
    }

    -- I take no credits for this! :lion:
    local scroll_bar = {
      static = {
        sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = "blue", bg = "bright_bg" },
    }

    local diagnostics = {
      condition = function()
        return vim.iter(vim.diagnostic.count(nil)):any(function(count)
          return count > 0
        end)
      end,
      update = { "DiagnosticChanged", "BufEnter" },

      hl = { fg = "red", bold = true },
      static = {
        error_icon = resources.icons.diagnostic.error,
        warn_icon = resources.icons.diagnostic.warn,
        success_icon = resources.icons.diagnostic.good,
      },

      init = function(self)
        local bufnr = self and self.bufnr or 0
        if vim.diagnostic.count then
          self.errors = vim.diagnostic.count(nil)[vim.diagnostic.severity.ERROR] or 0
          self.warnings = vim.diagnostic.count(nil)[vim.diagnostic.severity.WARN] or 0
          self.buf_errors = vim.diagnostic.count(bufnr)[vim.diagnostic.severity.ERROR] or 0
          self.buf_warnings = vim.diagnostic.count(bufnr)[vim.diagnostic.severity.WARN] or 0
        end
      end,

      {
        provider = function(self)
          return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = "diag_error" },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = "diag_warn" },
      },
      {
        provider = resources.icons.powerline.vertical_bar,
      },
      {
        provider = function(self)
          return self.buf_errors > 0 and (self.error_icon .. self.buf_errors .. " ")
        end,
        hl = { fg = "diag_error" },
      },
      {
        provider = function(self)
          return self.buf_warnings > 0 and (self.warn_icon .. self.buf_warnings)
        end,
        hl = { fg = "diag_warn" },
      },
    }

    local lsp_server_list = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },

      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.buf_get_clients(0)) do
          local icon = resources.icons.lsp[server.name]
            or server.name:sub(1, 1) .. resources.icons.lsp.default
          table.insert(names, icon)
        end
        return "🈸[ " .. table.concat(names, " ") .. " ]"
      end,
      hl = { fg = "purple", bold = true },
    }

    local help_filename = {
      condition = function()
        return vim.bo.filetype == "help"
      end,
      provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
      end,
      hl = { fg = "blue" },
    }

    -- Put it all together

    local align = { provider = "%=" }
    local space = { provider = " " }

    local default_status_line = {
      mode,
      space,
      file_name_block,
      space,
      diagnostics,
      space,
      align,
      lsp_server_list,
      space,
      file_type,
      space,
      ruler,
      space,
      scroll_bar,
    }

    local inactive_status_line = {
      condition = conditions.is_not_active,
      file_type,
      space,
      file_name_block,
      align,
    }

    local special_status_line = {
      condition = function()
        return conditions.buffer_matches({
          buftype = { "nofile", "prompt", "help", "quickfix" },
          filetype = { "^git.*", "fugitive" },
        })
      end,

      file_type,
      space,
      help_filename,
      align,
    }

    local status_lines = {

      hl = function()
        if conditions.is_active() then
          return "StatusLine"
        else
          return "StatusLineNC"
        end
      end,

      -- the first statusline with no condition, or which condition returns true is used.
      -- think of it as a switch case with breaks to stop fallthrough.
      fallthrough = false,

      special_status_line,
      inactive_status_line,
      default_status_line,
    }

    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
      group = "Heirline",
    })

    require("heirline").setup({ statusline = status_lines })
  end,
}
