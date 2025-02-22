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

call plug#begin('~/.config/nvim/plugged')

" LSP Support
    Plug 'neovim/nvim-lspconfig'

" Tokyo Night Colorscheme
Plug 'folke/tokyonight.nvim'

" Treesitter for enhanced syntax highlighting and parsing.
" The { 'do': ':TSUpdate' } part automatically updates installed parsers.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" Set Tokyo Night as the colorscheme
colorscheme tokyonight

lua << EOF
-- Configure clangd for LSP with clang-tidy and detailed completions.
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
    cmd = { "clangd", "--clang-tidy", "--completion-style=detailed" },
    on_attach = function(client, bufnr)
        -- LSP keybindings
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
    end
})

-- Configure the Tokyo Night theme.
require("tokyonight").setup({
    style = "night",  -- Options: "night", "storm", "moon", or "day"
})
vim.cmd("colorscheme tokyonight")

-- Treesitter configuration.
-- This ensures Treesitter installs parsers for C, C++, Lua, and Markdown.
-- Markdown is included to prevent errors when hovering.
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "lua", "markdown" },
    highlight = {
        enable = true,              -- Enable Treesitter-based highlighting
        additional_vim_regex_highlighting = false,
    },
})

-- Configure diagnostics: disable inline virtual text but keep signs, underlines, etc.
vim.diagnostic.config({
    virtual_text = false,  -- Disable inline virtual text diagnostics
    signs = true,
    underline = true,
    update_in_insert = false,
})
EOF

nnoremap <Esc> :nohlsearch<CR>
nnoremap gg gg^

" Toggle diagnostic floating window with spacebar
lua << EOF
function ToggleDiagnosticFloat()
  local diagnostic_win = nil
  -- Iterate through all windows to find a floating window
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

