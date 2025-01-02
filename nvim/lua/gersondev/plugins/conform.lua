return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { "json", "asciidoc" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      scala = { "scalafmt" },
      go = { "gofmt" },
      json = { "jq" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    },
  },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
}
