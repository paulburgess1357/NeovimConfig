local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
  cmd = { "clangd", "--clang-tidy", "--completion-style=detailed" },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })

    if client.supports_method("textDocument/formatting") then
      vim.cmd([[
      augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })
      augroup END
      ]])
    end
  end
})
