-- neovim teminal mode mappings
vim.keymap.set("t", "<esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>c", "<cmd>noh<cr>", { desc = "Clear highlights" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selected text" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- scroll down with zz to center screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.api.nvim_create_augroup("FileTypeKeymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.lua" },
  callback = function()
    vim.keymap.set("n", "<leader><leader>", function()
      vim.cmd("so")
    end, { desc = "Source current file", buffer = true })
  end,
  group = "FileTypeKeymaps",
})

vim.keymap.set(
  "n",
  "<leader>e",
  [[:e <c-r>=expand("%:p:h") . "/" <cr>]],
  { desc = "Set command to expand to current file dir" }
)

vim.keymap.set(
  "n",
  "<leader>dA",
  [[:%bd | norm <C-o><cr>]],
  { desc = "Delete all buffers but the current one" }
)
vim.keymap.set(
  "n",
  "<leader>dO",
  vim.cmd.BufDelOthers,
  { desc = "Delete all buffers but the current one" }
)

-- git related mappings
vim.keymap.set("n", "<leader>gh", "<cmd>diffget //3<CR>")
vim.keymap.set("n", "<leader>gu", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "<leader>ga", "<cmd>!git fetch --all<CR>")
