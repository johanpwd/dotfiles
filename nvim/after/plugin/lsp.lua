local lsp = require("lspconfig")
local on_attach = function(client, bufnr)
  -- Automatically format
  if client.supports_method("textDocument/formatting") then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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

  -- Handle golang imports automatically
  if client.name == "gopls" then
    local augroup = vim.api.nvim_create_augroup("GolangImports", {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
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

lsp.gopls.setup({
  on_attach = on_attach,
})
