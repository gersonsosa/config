local setup_lsp_keymap = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set(
    "n",
    "gD",
    [[<cmd>lua vim.lsp.buf.declaration()<CR>]],
    { desc = "[G]o to [D]eclaration", buffer = bufnr, nowait = true }
  )
  vim.keymap.set(
    "n",
    "<leader>?",
    [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
    { desc = "Pop signature [h]elp", buffer = bufnr }
  )
  vim.keymap.set(
    "i",
    "<C-s>",
    [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
    { desc = "Pop [s]ignature help", buffer = bufnr }
  )

  vim.keymap.set(
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    { desc = "List workspace folders", buffer = bufnr }
  )

  vim.keymap.set(
    "n",
    "<leader>cl",
    "<cmd>lua vim.lsp.codelens.run()<CR>",
    { desc = "Run [c]ode [l]ens", buffer = bufnr }
  )

  if Snacks.did_setup then
    vim.keymap.set("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, { desc = "[G]o to [d]efinition", buffer = bufnr, nowait = true })
    vim.keymap.set("n", "grr", function()
      Snacks.picker.lsp_references()
    end, { desc = "[G]o to references", buffer = bufnr })
    -- TODO: can I make this work at all in snacks? I think the calls come from vim.lsp.buf.incoming_calls()
    -- vim.keymap.set("n", "<leader>gi", function()
    --   Snacks.picker.lsp_incoming_calls()
    -- end, { desc = "[G]o to [i]ncoming calls", buffer = bufnr })
    vim.keymap.set("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, { desc = "[G]o to t[y]pe definition", buffer = bufnr })
    vim.keymap.set("n", "gri", function()
      Snacks.picker.lsp_implementations({ include_current = true })
    end, { desc = "[G]o to [i]mplementation", buffer = bufnr })
    vim.keymap.set("n", "<leader>ds", function()
      Snacks.picker.lsp_symbols()
    end, { desc = "List [d]ocument [s]ymbols", buffer = bufnr })
    vim.keymap.set("n", "<leader>ws", function()
      Snacks.picker.lsp_workspace_symbols()
    end, { desc = "List [w]orkspace [s]ymbols", buffer = bufnr })
    return
  end

  local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
  if has_telescope then
    vim.keymap.set("n", "gd", function()
      telescope_builtin.lsp_definitions()
    end, { desc = "[G]o to [d]efinition", buffer = bufnr, nowait = true })
    vim.keymap.set("n", "gr", function()
      telescope_builtin.lsp_references()
    end, { desc = "[G]o to references", buffer = bufnr })
    vim.keymap.set("n", "<leader>gi", function()
      telescope_builtin.lsp_incoming_calls()
    end, { desc = "[G]o to [i]ncoming calls", buffer = bufnr })
    vim.keymap.set("n", "gy", function()
      telescope_builtin.lsp_type_definitions()
    end, { desc = "[G]o to t[y]pe definition", buffer = bufnr })
    vim.keymap.set("n", "gI", function()
      telescope_builtin.lsp_implementations()
    end, { desc = "[G]o to [i]mplementation", buffer = bufnr })
    vim.keymap.set("n", "<leader>ds", function()
      telescope_builtin.lsp_document_symbols()
    end, { desc = "List [d]ocument [s]ymbols", buffer = bufnr })
    vim.keymap.set("n", "<leader>ws", function()
      telescope_builtin.lsp_workspace_symbols()
    end, { desc = "List [w]orkspace [s]ymbols", buffer = bufnr })
    vim.keymap.set("n", "<leader>ld", function()
      telescope_builtin.diagnostics({ sort_by = "buffer" })
    end, { desc = "[L]ist [d]iagnostics", buffer = bufnr })
    vim.keymap.set("n", "<leader>le", function()
      telescope_builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
    end, { desc = "[L]ist [e]rrors", buffer = bufnr })
    vim.keymap.set("n", "<leader>ce", function()
      telescope_builtin.diagnostics({ bufnr = 0, severity = vim.diagnostic.severity.ERROR })
    end, { desc = "[C]urrent buffer [e]rrors", buffer = bufnr })
    return
  end

  vim.notify("Couln't find snacks or telescope. Using lsp functions.", vim.log.levels.INFO)
  vim.keymap.set("n", "<leader>ds", function()
    vim.lsp.buf.document_symbol()
  end, { desc = "List symbols", buffer = bufnr })
  vim.keymap.set("n", "<leader>ws", function()
    vim.lsp.buf.workspace_symbol("")
  end, { desc = "List [w]orkspace [s]ymbols", buffer = bufnr })

  vim.keymap.set(
    "n",
    "gI",
    [[<cmd>lua vim.lsp.buf.implementation()<CR>]],
    { desc = "[G]o to [i]mplementation", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "gy",
    [[<cmd>lua vim.lsp.buf.type_definition()<CR>]],
    { desc = "[G]o to t[y]pe definition", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "gr",
    [[<cmd>lua vim.lsp.buf.references()<CR>]],
    { desc = "[G]o to references", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "gd",
    [[<cmd>lua vim.lsp.buf.definition()<CR>]],
    { desc = "[G]o to [d]efinition", buffer = bufnr, nowait = true }
  )
  vim.keymap.set(
    "n",
    "<leader>ld",
    "<cmd>lua vim.diagnostic.setloclist()<CR>",
    { desc = "Open diagnostics" }
  )
  vim.keymap.set(
    "n",
    "<leader>wd",
    "<cmd>lua vim.diagnostic.setqflist()<CR>",
    { desc = "Open diagnostics" }
  )
end

vim.diagnostic.config({
  virtual_lines = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰛩",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local lsp_mappings = augroup("LspMappings", {})

-- Setup common keymaps for all LSP clients
autocmd("LspAttach", {
  group = lsp_mappings,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities then
      setup_lsp_keymap(client, bufnr)
    end
  end,
})

vim.lsp.enable({ "ruff", "ts_ls", "lua_ls", "clangd", "eslint", "ocamllsp" })
