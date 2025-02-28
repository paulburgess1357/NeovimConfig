" Enable syntax highlighting
syntax on

" Line numbering
set number            " Show absolute line numbers
set relativenumber    " Show relative line numbers

" Indentation settings
set tabstop=4         " Set tab width to 4 spaces
set shiftwidth=4      " Auto-indent width
set expandtab         " Convert tabs to spaces
set autoindent        " Auto-indent new lines
set smartindent       " Smarter indentation for code

" Disable legacy Vim behavior
set nocompatible

" Disable arrow keys for movement (force usage of hjkl)
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Initialize plugins with vim-plug
call plug#begin('~/.config/nvim/plugged')

" LSP Support
Plug 'neovim/nvim-lspconfig'

" Tokyo Night Colorscheme
Plug 'folke/tokyonight.nvim'

" Treesitter for enhanced syntax highlighting and parsing.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" File manager: nvim-tree
Plug 'kyazdani42/nvim-tree.lua'

" Completion engine and sources
Plug 'hrsh7th/nvim-cmp'           " Core completion engine
Plug 'hrsh7th/cmp-nvim-lsp'       " LSP source for nvim-cmp (clangd for C++)
Plug 'hrsh7th/cmp-buffer'         " Buffer completions

call plug#end()

" Configure Tokyo Night theme
lua << EOF
require("tokyonight").setup({
    style = "night",  -- Options: "night", "storm", "moon", or "day"
})
vim.cmd("colorscheme tokyonight")
EOF

" Configure nvim-tree and map CTRL-n to toggle it
lua << EOF
local api = require("nvim-tree.api")
require("nvim-tree").setup({
  view = {
    width = 20,
    side = "left",
  },
  filters = {
    dotfiles = false,
  },
  on_attach = function(bufnr)
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Split"))
    vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: VSplit"))
  end,
})
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
EOF

" Configure clangd for LSP with clang-tidy and detailed completions.
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
    cmd = { "clangd", "--clang-tidy", "--completion-style=detailed" },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- LSP keybindings
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
    end
})
EOF

" Treesitter configuration.
lua << EOF
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "lua", "markdown" },
    highlight = {
        enable = true,              -- Enable Treesitter-based highlighting
        additional_vim_regex_highlighting = true,
    },
})
EOF

" Configure diagnostics: disable inline virtual text but keep signs, underlines, etc.
lua << EOF
vim.diagnostic.config({
    virtual_text = false,  -- Disable inline virtual text diagnostics
    signs = true,
    underline = true,
    update_in_insert = false,
})
EOF

" Other key mappings
nnoremap <Esc> :nohlsearch<CR>
nnoremap gg gg^

" Toggle diagnostic floating window with spacebar
lua << EOF
function ToggleDiagnosticFloat()
  local diagnostic_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      diagnostic_win = win
      break
    end
  end
  if diagnostic_win then
    vim.api.nvim_win_close(diagnostic_win, true)
  else
    vim.diagnostic.open_float(nil, { focus = false })
  end
end
vim.keymap.set("n", "<Space>", ToggleDiagnosticFloat, { noremap = true, silent = true })
EOF

" Configure nvim-cmp for code completion
lua << EOF
local cmp = require'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),  -- Scroll docs up.
    ['<C-f>'] = cmp.mapping.scroll_docs(4),     -- Scroll docs down.
    ['<C-Space>'] = cmp.mapping.complete(),     -- Trigger completion.
    ['<C-e>'] = cmp.mapping.abort(),            -- Abort completion.
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})
EOF

