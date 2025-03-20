local lspconfig = require('lspconfig')

-- Enhance LSP capabilities with nvim-cmp support.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(client, bufnr)
  -- Attach nvim-navic for breadcrumb navigation if available.
  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- Key mapping for hover documentation.
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })

  -- Auto-format on save if supported by the server.
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
-- Improved flags:
--   - --background-index: Index files in the background so all files are searchable.
--   - Explicit root_dir ensures that clangd sees your full project (using compile_commands.json, compile_flags.txt, or .git).
lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  init_options = {
    fallbackFlags = {
      "-std=c++20",
      "-I./include",
      "-Wall",
      "-Wextra",
      "-Wpedantic",
      "-Weverything",
      "-Wshadow",
      "-Wconversion",
      "-Wsign-conversion",
      "-Wundef",
      "-Wmissing-include-dirs",
      "-Wfloat-conversion",
      "-Wformat=2",
      "-Wunreachable-code",
      "-Wdouble-promotion",
      "-Wno-c++98-compat",
      -- Uncomment or add additional flags if needed:
      -- "-Werror",
      -- "-Wno-sign-compare",
      -- "-Wno-sign-conversion",
      -- "-Wno-shorten-64-to-32",
    },
  },
})

-- Python LSP: pyright
-- Using common root indicators such as pyproject.toml and setup files.
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
})

-- Bash LSP: bashls
lspconfig.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "sh", "bash" },
  root_dir = lspconfig.util.root_pattern(".git", "package.json", "."),
})

-- Lua LSP: lua_ls
-- Provides proper settings for developing Neovim config and Lua files.
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',  -- Neovim uses LuaJIT.
      },
      diagnostics = {
        globals = { 'vim' },  -- Recognize the `vim` global.
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,  -- Optional: disable prompting for third-party libraries.
      },
      telemetry = {
        enable = false,  -- Disable telemetry for privacy.
      },
    },
  },
})

