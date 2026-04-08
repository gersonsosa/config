vim.pack.add {
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = "https://github.com/mason-org/mason.nvim" },
}

require("mason").setup()

local setup_lsp_keymap = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  if client:supports_method('textDocument/declaration') then
    vim.keymap.set(
      "n",
      "gD",
      [[<cmd>lua vim.lsp.buf.declaration()<CR>]],
      { desc = "[G]o to [D]eclaration", buffer = bufnr, nowait = true }
    )
  end
  if client:supports_method('textDocument/signatureHelp') then
    vim.keymap.set(
      "n",
      "<leader>?",
      function() vim.lsp.buf.signature_help() end,
      { desc = "Pop signature [h]elp", buffer = bufnr }
    )
  end

  vim.keymap.set(
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    { desc = "List workspace folders", buffer = bufnr }
  )

  if client:supports_method('textDocument/codeLens') then
    vim.keymap.set(
      "n",
      "<leader>cl",
      function() vim.lsp.codelens.run() end,
      { desc = "Run [c]ode [l]ens", buffer = bufnr }
    )
  end

  if client:supports_method('textDocument/codeAction') then
    vim.keymap.set(
      "n",
      "<leader>ca",
      function() vim.lsp.buf.code_action() end,
      { desc = "Run [c]ode [l]ens", buffer = bufnr }
    )
  end

  if client:supports_method('textDocument/documentSymbol') then
    vim.keymap.set("n", "<leader>ds", function()
      vim.lsp.buf.document_symbol()
    end, { desc = "List symbols", buffer = bufnr })
  end
  vim.keymap.set("n", "<leader>ws", function()
    vim.lsp.buf.workspace_symbol("")
  end, { desc = "List [w]orkspace [s]ymbols", buffer = bufnr })

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

autocmd("LspAttach", {
  group = lsp_mappings,
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client and client.server_capabilities then
      setup_lsp_keymap(client, bufnr)
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    local ignore_ft = { "json", "asciidoc" }
    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting')
        and not vim.tbl_contains(ignore_ft, vim.bo[bufnr].filetype) then
      autocmd('BufWritePre', {
        group = augroup("LspAutoformat", { clear = false }),
        buffer = args.buf,
        callback = function()
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            vim.notify("skipped format for buffer " .. bufnr, vim.log.levels.INFO)
            return
          end

          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_mappings,
  pattern = { "lua" },
  callback = function()
    require("lazydev")
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_mappings,
  pattern = { "scala" },
  callback = function()
    require("metals")
  end,
})

vim.lsp.enable({ "ruff", "ts_ls", "lua_ls", "clangd", "eslint", "ocamllsp", "gopls" })
