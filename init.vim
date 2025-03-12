
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

lua << EOF
----------------------------------------------------------
-- Helper Functions for Window Geometry and Data
----------------------------------------------------------
local function get_win_data(win)
  local pos = vim.fn.win_screenpos(win)
  local row = pos[1]
  local col = pos[2]
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)
  return {
    win = win,
    win_row = row,
    win_col = col,
    width = width,
    height = height,
    center_x = col + width / 2,
    center_y = row + height / 2,
  }
end

local function get_candidate_windows(cur_win)
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local candidates = {}
  for _, win in ipairs(wins) do
    if win ~= cur_win then
      table.insert(candidates, get_win_data(win))
    end
  end
  return candidates
end

----------------------------------------------------------
-- Filtering Functions Based on Overlap
----------------------------------------------------------
local function filter_candidates_vertically(candidates, cur)
  local filtered = {}
  local cur_top = cur.win_row
  local cur_bottom = cur.win_row + cur.height
  for _, cand in ipairs(candidates) do
    local cand_top = cand.win_row
    local cand_bottom = cand.win_row + cand.height
    if not (cand_bottom < cur_top or cand_top > cur_bottom) then
      table.insert(filtered, cand)
    end
  end
  return filtered
end

local function filter_candidates_horizontally(candidates, cur)
  local filtered = {}
  local cur_left = cur.win_col
  local cur_right = cur.win_col + cur.width
  for _, cand in ipairs(candidates) do
    local cand_left = cand.win_col
    local cand_right = cand.win_col + cand.width
    if not (cand_right < cur_left or cand_left > cur_right) then
      table.insert(filtered, cand)
    end
  end
  return filtered
end

----------------------------------------------------------
-- Selection Functions for Each Direction
----------------------------------------------------------
local function select_left(candidates, cur)
  local best = nil
  for _, cand in ipairs(candidates) do
    if cand.center_x < cur.center_x then
      if not best or cand.center_x > best.center_x then
        best = cand
      end
    end
  end
  if best then
    return best.win
  end
  -- Wrap-around: choose candidate with the maximum center_x.
  local max_cand = nil
  for _, cand in ipairs(candidates) do
    if not max_cand or cand.center_x > max_cand.center_x then
      max_cand = cand
    end
  end
  return max_cand.win
end

local function select_right(candidates, cur)
  local best = nil
  for _, cand in ipairs(candidates) do
    if cand.center_x > cur.center_x then
      if not best or cand.center_x < best.center_x then
        best = cand
      end
    end
  end
  if best then
    return best.win
  end
  -- Wrap-around: choose candidate with the minimum center_x.
  local min_cand = nil
  for _, cand in ipairs(candidates) do
    if not min_cand or cand.center_x < min_cand.center_x then
      min_cand = cand
    end
  end
  return min_cand.win
end

local function select_up(candidates, cur)
  local best = nil
  for _, cand in ipairs(candidates) do
    if cand.center_y < cur.center_y then
      if not best or cand.center_y > best.center_y then
        best = cand
      end
    end
  end
  if best then
    return best.win
  end
  -- Wrap-around: choose candidate with the maximum center_y.
  local max_cand = nil
  for _, cand in ipairs(candidates) do
    if not max_cand or cand.center_y > max_cand.center_y then
      max_cand = cand
    end
  end
  return max_cand.win
end

local function select_down(candidates, cur)
  local best = nil
  for _, cand in ipairs(candidates) do
    if cand.center_y > cur.center_y then
      if not best or cand.center_y < best.center_y then
        best = cand
      end
    end
  end
  if best then
    return best.win
  end
  -- Wrap-around: choose candidate with the minimum center_y.
  local min_cand = nil
  for _, cand in ipairs(candidates) do
    if not min_cand or cand.center_y < min_cand.center_y then
      min_cand = cand
    end
  end
  return min_cand.win
end

----------------------------------------------------------
-- Main Window Cycling Function
----------------------------------------------------------
function cycle_window(direction)
  local cur_win = vim.api.nvim_get_current_win()
  local cur = get_win_data(cur_win)
  local candidates = get_candidate_windows(cur_win)
  if #candidates < 1 then return end

  local filtered = {}
  if direction == "left" or direction == "right" then
    filtered = filter_candidates_vertically(candidates, cur)
    if #filtered == 0 then
      filtered = candidates
    end
  elseif direction == "up" or direction == "down" then
    filtered = filter_candidates_horizontally(candidates, cur)
    if #filtered == 0 then
      filtered = candidates
    end
  end

  local target_win = nil
  if direction == "left" then
    target_win = select_left(filtered, cur)
  elseif direction == "right" then
    target_win = select_right(filtered, cur)
  elseif direction == "up" then
    target_win = select_up(filtered, cur)
  elseif direction == "down" then
    target_win = select_down(filtered, cur)
  end

  if target_win then
    vim.api.nvim_set_current_win(target_win)
  end
end

----------------------------------------------------------
-- Map CTRL + Arrow Keys to Cycle Windows
----------------------------------------------------------
vim.api.nvim_set_keymap("n", "<C-Left>",  ":lua cycle_window('left')<CR>",  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":lua cycle_window('right')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Up>",    ":lua cycle_window('up')<CR>",    { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>",  ":lua cycle_window('down')<CR>",  { noremap = true, silent = true })
EOF


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

" =====================================================
" Jump to Next/Previous Occurrence of the Word Under Cursor
" =====================================================
" Map <leader>n to set the search pattern to the current word and jump to the next match.
nnoremap <leader>n :let @/ = '\V\<'.escape(expand('<cword>'), '/') . '\>'<CR>n

" Map <leader>N to jump to the previous match.
nnoremap <leader>N :let @/ = '\V\<'.escape(expand('<cword>'), '/') . '\>'<CR>N

