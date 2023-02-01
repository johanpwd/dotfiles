local lsp = require("lspconfig")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
        })
      end,
    })
  end
end

-- Setup mason
require("mason").setup({
  ui = {
    border = "rounded",
  },
})

require("mason-lspconfig").setup()

-- Setup the LSPs
lsp.sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      format = {
        defaultConfig = {
          quote_style = "double",
        },
      },
    },
  },
})
