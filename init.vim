
" Basic Settings
" =====================================================

" Enable syntax highlighting.
syntax on

" Disable legacy Vim behavior.
set nocompatible

" -------------------------
" Line Numbering
" -------------------------
set number            " Show absolute line numbers.
set relativenumber    " Show relative line numbers.

" -------------------------
" Indentation Settings
" -------------------------
set tabstop=2         " Set tab width to 4 spaces.
set shiftwidth=2      " Auto-indent width.
set softtabstop=2     " Makes editing feel for natural
set expandtab         " Convert tabs to spaces.
set autoindent        " Auto-indent new lines.
set smartindent       " Smarter indentation for code.

" -------------------------
" Key Mappings: Movement
" -------------------------
" Disable arrow keys to force use of hjkl.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" -------------------------
" Misc:  
" -------------------------
set nowrap            " Disable line wrap

" =====================================================
" Plugin Management (vim-plug)
" =====================================================

call plug#begin('~/.config/nvim/plugged')

" LSP Support.
Plug 'neovim/nvim-lspconfig'

" Tokyo Night Colorscheme.
Plug 'folke/tokyonight.nvim'

" Treesitter for enhanced syntax highlighting and parsing.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" File manager: nvim-tree.
Plug 'kyazdani42/nvim-tree.lua'

" Completion engine and sources.
Plug 'hrsh7th/nvim-cmp'           " Core completion engine.
Plug 'hrsh7th/cmp-nvim-lsp'        " LSP source for nvim-cmp (clangd for C++).
Plug 'hrsh7th/cmp-buffer'          " Buffer completions.

" Auto-pairs for automatically inserting closing pairs.
Plug 'windwp/nvim-autopairs'

" Status bar plugin: lualine.nvim.
Plug 'nvim-lualine/lualine.nvim'

" Neovim Illuminate: Text under cursor
Plug 'RRethy/vim-illuminate'

call plug#end()

" =====================================================
" Theme Configuration: Tokyo Night
" =====================================================
lua << EOF
require("tokyonight").setup({
    style = "night",  -- Options: "night", "storm", "moon", or "day"
})
vim.cmd("colorscheme tokyonight")
EOF

" =====================================================
" nvim-illuminate Highlight Groups
" =====================================================
" Customize the appearance of highlighted words based on usage:
" - IlluminatedWordRead: For variables read/accessed.
" - IlluminatedWordWrite: For variables being written/modified.
highlight IlluminatedWordRead guifg=#FFD700 ctermfg=Yellow
highlight IlluminatedWordWrite guifg=#FF4500 ctermfg=Red

" =====================================================
" File Explorer Configuration: nvim-tree
" =====================================================
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
    vim.keymap.set("n", "h", api.node.open.horizontal, opts("Open: Split"))
    vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: VSplit"))
  end,
})
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
EOF

" =====================================================
" Status Line Configuration: lualine.nvim
" =====================================================
lua << EOF
require('lualine').setup {
  options = {
    theme = 'tokyonight',   -- Match the Tokyo Night theme.
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}
EOF

" =====================================================
" LSP Configuration: Clangd with clang-tidy
" =====================================================

lua << EOF
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
EOF



" =====================================================
" Treesitter Configuration
" =====================================================
lua << EOF
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "lua", "markdown" },
    highlight = {
        enable = true,              -- Enable Treesitter-based highlighting.
        additional_vim_regex_highlighting = true,
    }
})
EOF


" =====================================================
" Diagnostics Configuration
" =====================================================
lua << EOF
vim.diagnostic.config({
    virtual_text = false,  -- Disable inline virtual text diagnostics.
    signs = true,
    underline = true,
    update_in_insert = false,
})
EOF


" =====================================================
" General Key Mappings
" =====================================================

" Clear search highlight with Escape.
nnoremap <Esc> :nohlsearch<CR>

" Remap gg to go to the first non-blank character of the line.
nnoremap gg gg^

" =====================================================
" Toggle Diagnostic Floating Window
" =====================================================
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
    vim.diagnostic.open_float(nil, { focus = false, source = "always" })
  end
end
vim.keymap.set("n", "<Space>", ToggleDiagnosticFloat, { noremap = true, silent = true })
EOF


" =====================================================
" Completion and Auto-Pairs Configuration: nvim-cmp
" =====================================================
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

-- Setup nvim-autopairs and integrate it with nvim-cmp.
require('nvim-autopairs').setup{}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
EOF
