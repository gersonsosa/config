return {
  "L3MON4D3/LuaSnip",
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")

    local s = ls.snippet
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt

    ls.add_snippets("scala", {
      s(
        "def",
        fmt("def {func_name}({params}):{body}", {
          func_name = i(1, "F"),
          params = i(2, "params..."),
          body = i(0, "..."),
        })
      ),
    })

    ls.add_snippets("go", {
      s(
        "ife",
        fmt(
          [[
            if {err} != nil {{
              fmt.Errorf("{message} %w", {err})
            }}
          ]],
          {
            err = i(1, "err"),
            message = i(2, "message..."),
          }
        )
      ),
    })

    ls.add_snippets("lua", {
      s(
        "iff",
        fmt("if {cond} then {body} end", {
          cond = i(1, "cond"),
          body = i(0, "..."),
        })
      ),
    })

    vim.keymap.set({ "i" }, "<C-l>", function()
      ls.expand()
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      ls.jump(1)
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      ls.jump(-1)
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-x>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
  end,
}
