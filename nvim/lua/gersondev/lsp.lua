local setup_lsp_keymap = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set(
    "n",
    "gD",
    [[<cmd>lua vim.lsp.buf.declaration()<CR>]],
    { desc = "[G]o to [D]eclaration", buffer = bufnr, nowait = true }
  )
  -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
  --   { desc = "Hover", buffer = bufnr })
  vim.keymap.set(
    "n",
    "<leader>h",
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
  vim.keymap.set(
    "n",
    "<leader>ca",
    "<cmd>lua vim.lsp.buf.code_action()<CR>",
    { desc = "Execute [c]ode [a]ction", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "<leader>rn",
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    { desc = "[R]e[n]ame object", buffer = bufnr }
  )

  -- removed in favor of comform
  -- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end,
  --   { desc = "[F]ormat", buffer = bufnr })

  -- Telescope mappings
  local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    vim.notify(
      "Couln't load telescope, is it installed?. Using lsp functions.",
      vim.log.levels.ERROR
    )
    vim.keymap.set("n", "<leader>ds", function()
      vim.lsp.buf.document_symbol()
    end, { desc = "List symbols", buffer = bufnr })
    vim.keymap.set("n", "<leader>ws", function()
      vim.lsp.buf.workspace_symbol("")
    end, { desc = "List [w]orkspace [s]ymbols", buffer = bufnr })

    vim.keymap.set(
      "n",
      "gi",
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
    -- Mappings.diagnostics
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set(
      "n",
      "<leader>ld",
      "<cmd>lua vim.diagnostic.setloclist()<CR>",
      { desc = "Open diagnostics" }
    )
    return
  end

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
  vim.keymap.set("n", "gi", function()
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
end

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
