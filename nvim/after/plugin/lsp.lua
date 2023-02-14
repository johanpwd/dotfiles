local lsp = require("lspconfig")
local on_attach = function(client, bufnr)
  local keymap_options = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_options)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_options)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, keymap_options)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_options)
  vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_options)

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
          timeout_ms = 200,
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

require("mason-lspconfig").setup(
)

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs( -4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup the LSPs
lsp.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      format = {
        enable = true,
        defaultConfig = {
          quote_style = "double",
          indent_style = "space",
        },
      },
    },
  },
})

lsp.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lsp.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
