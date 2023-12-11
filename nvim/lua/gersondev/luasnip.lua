local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", {
  s("def", fmt("def {func_name}({params}):{body}", {
    func_name = i(1, "F"),
    params = i(2, "params..."),
    body = i(0, "..."),
  })),
  s("iff", fmt("if {cond} then {body} end", {
    cond = i(1, "cond"),
    body = i(0, "..."),
  })),
})

vim.keymap.set({ "i" }, "<C-l>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-k>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-?>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

