
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
" -------------------------
" Misc:  
" -------------------------
set nowrap            " Disable line wrap
set splitright        " Open vertical splits to the right

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

"Bufferline: Tabs & TabStyle
Plug 'akinsho/bufferline.nvim'

" Rainbow Delimiters for colorful parentheses.
Plug 'HiPhish/rainbow-delimiters.nvim'

call plug#end()

" =====================================================
" Custom Buffer Close Commands (Simplified for split behavior)
" =====================================================
command! -bang Bclose call s:CloseBuffer(<bang>0)
function! s:CloseBuffer(bang)
  " If there is more than one window, simply delete the current buffer.
  if winnr('$') > 1
    if a:bang
      execute "bdelete! %"
    else
      execute "bdelete %"
    endif
  else
    " Only one window: check listed buffers.
    let l:listed_buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    if len(l:listed_buffers) <= 1
      if a:bang
        execute "qa!"
      else
        execute "qa"
      endif
    else
      " More than one listed buffer but still only one window.
      if a:bang
        execute "bdelete! %"
      else
        execute "bdelete %"
      endif
    endif
  endif
endfunction

" Remap :q, :q!, and :qw to use our Bclose command.
cabbrev <expr> q  getcmdline() ==# 'q'  ? 'Bclose'  : 'q'
cabbrev <expr> q! getcmdline() ==# 'q!' ? 'Bclose!' : 'q!'
cabbrev <expr> qw getcmdline() ==# 'qw' ? 'Bclose' : 'qw'

" =====================================================
" Enhanced Window Cycling (only within same row or column)
" =====================================================

" Horizontal cycling: only cycle among windows on the same row.
function! CycleWindowRightNonTree()
  let cur_win = winnr()
  let cur_pos = win_screenpos(cur_win)
  let cur_row = cur_pos[0]
  let cur_col = cur_pos[1]

  " Collect windows in the same row (excluding NvimTree)
  let wins = []
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'NvimTree'
      continue
    endif
    let pos = win_screenpos(w)
    if pos[0] == cur_row
      call add(wins, { 'num': w, 'col': pos[1] })
    endif
  endfor

  " Only proceed if there’s more than one window in this row.
  if len(wins) <= 1
    return
  endif

  " Sort windows by their column position.
  call sort(wins, {a, b -> a.col - b.col})
  " Find the current window’s index.
  let cur_index = -1
  for i in range(0, len(wins)-1)
    if wins[i].num == cur_win
      let cur_index = i
      break
    endif
  endfor
  if cur_index == -1
    return
  endif

  " Move to the next window in the row (wrap around if needed).
  let next_index = (cur_index + 1) % len(wins)
  execute wins[next_index].num . "wincmd w"
endfunction

function! CycleWindowLeftNonTree()
  let cur_win = winnr()
  let cur_pos = win_screenpos(cur_win)
  let cur_row = cur_pos[0]
  let cur_col = cur_pos[1]

  " Collect windows in the same row (excluding NvimTree)
  let wins = []
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'NvimTree'
      continue
    endif
    let pos = win_screenpos(w)
    if pos[0] == cur_row
      call add(wins, { 'num': w, 'col': pos[1] })
    endif
  endfor

  if len(wins) <= 1
    return
  endif

  call sort(wins, {a, b -> a.col - b.col})
  let cur_index = -1
  for i in range(0, len(wins)-1)
    if wins[i].num == cur_win
      let cur_index = i
      break
    endif
  endfor
  if cur_index == -1
    return
  endif

  " Move to the previous window in the row (wrap around if needed).
  let prev_index = (cur_index - 1 + len(wins)) % len(wins)
  execute wins[prev_index].num . "wincmd w"
endfunction

" Vertical cycling: only cycle among windows in the same column.
function! CycleWindowDownNonTree()
  let cur_win = winnr()
  let cur_pos = win_screenpos(cur_win)
  let cur_row = cur_pos[0]
  let cur_col = cur_pos[1]

  " Collect windows in the same column (excluding NvimTree)
  let wins = []
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'NvimTree'
      continue
    endif
    let pos = win_screenpos(w)
    if pos[1] == cur_col
      call add(wins, { 'num': w, 'row': pos[0] })
    endif
  endfor

  if len(wins) <= 1
    return
  endif

  " Sort windows by their row position.
  call sort(wins, {a, b -> a.row - b.row})
  let cur_index = -1
  for i in range(0, len(wins)-1)
    if wins[i].num == cur_win
      let cur_index = i
      break
    endif
  endfor
  if cur_index == -1
    return
  endif

  " Move to the next window in the column (wrap around if needed).
  let next_index = (cur_index + 1) % len(wins)
  execute wins[next_index].num . "wincmd w"
endfunction

function! CycleWindowUpNonTree()
  let cur_win = winnr()
  let cur_pos = win_screenpos(cur_win)
  let cur_row = cur_pos[0]
  let cur_col = cur_pos[1]

  " Collect windows in the same column (excluding NvimTree)
  let wins = []
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'NvimTree'
      continue
    endif
    let pos = win_screenpos(w)
    if pos[1] == cur_col
      call add(wins, { 'num': w, 'row': pos[0] })
    endif
  endfor

  if len(wins) <= 1
    return
  endif

  call sort(wins, {a, b -> a.row - b.row})
  let cur_index = -1
  for i in range(0, len(wins)-1)
    if wins[i].num == cur_win
      let cur_index = i
      break
    endif
  endfor
  if cur_index == -1
    return
  endif

  " Move to the previous window in the column (wrap around if needed).
  let prev_index = (cur_index - 1 + len(wins)) % len(wins)
  execute wins[prev_index].num . "wincmd w"
endfunction

" Key Mappings
nnoremap <C-Right> :call CycleWindowRightNonTree()<CR>
nnoremap <C-Left>  :call CycleWindowLeftNonTree()<CR>
nnoremap <C-Down>  :call CycleWindowDownNonTree()<CR>
nnoremap <C-Up>    :call CycleWindowUpNonTree()<CR>

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
" Bufferline Configuration: akinsho/bufferline.nvim
" =====================================================
lua << EOF
require("bufferline").setup{
  options = {
    mode = "buffers",                    -- Show buffers instead of tabs.
    numbers = "none",                    -- Disable buffer numbers.
    close_command = "bdelete! %d",        -- Command to close a buffer.
    indicator = {
      icon = '▎',                       -- Icon used as a buffer indicator.
      style = 'icon',
    },
    separator_style = "slant",           -- Style of separator between buffers.
    offsets = {
      {
        filetype = "NvimTree",           -- Offset for file explorer.
        text = "File Explorer",
        text_align = "left",
        padding = 1,
      },
    },
    show_buffer_close_icons = true,
    show_close_icon = false,
    enforce_regular_tabs = false,
    always_show_bufferline = true,
  }
}
EOF

nnoremap <S-Left> :BufferLineCyclePrev<CR>
nnoremap <S-Right> :BufferLineCycleNext<CR>

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
    vim.keymap.set("n", "o", api.node.open.tab, opts("Open: New Tab"))
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
