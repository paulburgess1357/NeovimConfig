" =====================================================
" Basic Settings
" =====================================================
syntax on
set nocompatible

" -------------------------
" Line Numbering
" -------------------------
set number
set relativenumber

" -------------------------
" Indentation Settings
" -------------------------
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent

" -------------------------
" Misc Settings
" -------------------------
set nowrap
set splitright

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
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'

" Auto-pairs.
Plug 'windwp/nvim-autopairs'

" Status line plugin.
Plug 'nvim-lualine/lualine.nvim'

" Neovim Illuminate.
Plug 'RRethy/vim-illuminate'

" Bufferline.
Plug 'akinsho/bufferline.nvim'

" Rainbow Delimiters.
Plug 'HiPhish/rainbow-delimiters.nvim'
call plug#end()

" =====================================================
" Custom Buffer Close Commands
" =====================================================
command! -bang Bclose call s:CloseBuffer(<bang>0)
function! s:CloseBuffer(bang)
  if winnr('$') > 1
    if a:bang
      execute "bdelete! %"
    else
      execute "bdelete %"
    endif
  else
    let l:listed_buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    if len(l:listed_buffers) <= 1
      if a:bang
        execute "qa!"
      else
        execute "qa"
      endif
    else
      if a:bang
        execute "bdelete! %"
      else
        execute "bdelete %"
      endif
    endif
  endif
endfunction

" Remap :q, :q!, and :qw to use Bclose.
cabbrev <expr> q  getcmdline() ==# 'q'  ? 'Bclose'  : 'q'
cabbrev <expr> q! getcmdline() ==# 'q!' ? 'Bclose!' : 'q!'
cabbrev <expr> qw getcmdline() ==# 'qw' ? 'Bclose' : 'qw'

" =====================================================
" nvim-illuminate Highlight Groups
" =====================================================
highlight IlluminatedWordRead guifg=#FFD700 ctermfg=Yellow
highlight IlluminatedWordWrite guifg=#FF4500 ctermfg=Red

" =====================================================
" General Key Mappings
" =====================================================
nnoremap <Esc> :nohlsearch<CR>
nnoremap gg gg^
nnoremap <leader>n :let @/ = '\V\<'.escape(expand('<cword>'), '/') . '\>'<CR>n
nnoremap <leader>N :let @/ = '\V\<'.escape(expand('<cword>'), '/') . '\>'<CR>N
nnoremap <S-Left> :BufferLineCyclePrev<CR>
nnoremap <S-Right> :BufferLineCycleNext<CR>

" =====================================================
" Load Lua Modules
" =====================================================
lua require('theme')
lua require('window_cycle')
lua require('bufferline_conf')
lua require('nvim_tree')
lua require('lualine_conf')
lua require('lsp')
lua require('treesitter')
lua require('diagnostics')
lua require('completion')
