-- Removed packadd; nvim-lspconfig is loaded by vim-plug
local lspconfig = require('lspconfig')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(client, bufnr)
  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })

  if client.supports_method("textDocument/formatting") then
    vim.cmd([[
      augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })
      augroup END
    ]])
  end
end

-- C/C++ LSP: clangd
-- Ensure clangd is installed on your system (e.g., via your package manager).
-- On Ubuntu, you can install clangd with:
--     sudo apt install clangd
lspconfig.clangd.setup({
  cmd = { "clangd", "--clang-tidy", "--completion-style=detailed" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Python LSP: pyright
-- Install pyright globally using npm:
--     npm install -g pyright
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Bash LSP: bashls
-- Install bash-language-server globally using npm:
--     npm install -g bash-language-server
-- For proper linting, also install:
--   - ShellCheck (e.g., on Ubuntu: sudo apt install shellcheck)
--   - (Optional) shfmt for formatting (e.g., install via snap or manually)
lspconfig.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "sh", "bash" },
})

