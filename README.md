# Neovim Custom Keybindings Quick Reference
---

## Vim (init.vim) Keybindings

- **Clear Search Highlight**  
  nnoremap <Esc> :nohlsearch<CR>

- **Go to Start of File (with column adjustment)**  
  nnoremap gg gg^

- **Search Current Word**  
  - Next occurrence: nnoremap <leader>n :let @/ = '\V\<'.escape(expand('<cword>'), '/') . '\>'<CR>n
  - Previous occurrence: nnoremap <leader>N :let @/ = '\V\<'.escape(expand('<cword>'), '/') . '\>'<CR>N

- **Buffer Close Abbreviations**  
  These abbreviations replace the default :q, :q!, and :qw commands with a custom Bclose command:
  - cabbrev <expr> q  getcmdline() ==# 'q'  ? 'Bclose'  : 'q'
  - cabbrev <expr> q! getcmdline() ==# 'q!' ? 'Bclose!' : 'q!'
  - cabbrev <expr> qw getcmdline() ==# 'qw' ? 'Bclose' : 'qw'

---

## Lua Configuration Keybindings

### Diagnostics & LSP
- **Toggle Diagnostic Floating Window**  
  (Press <Space> in normal mode)
  vim.keymap.set("n", "<Space>", ToggleDiagnosticFloat, { noremap = true, silent = true })

- **Fix Clang Issues / Trigger LSP Code Action**  
  (Press <leader>cf)
  vim.keymap.set("n", "<leader>cf", vim.lsp.buf.code_action, { noremap = true, silent = true })

- **Go to Definition:** gd  
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })

- **Hover Documentation:** K  
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })

- **Rename Symbol:** <leader>rn  
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })

### Nvim-Tree (File Explorer)
- **Toggle File Explorer:** (Press <C-n>)
  vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
- **Within Explorer (when attached):**
  - o: Open in new tab
  - h: Open in horizontal split
  - v: Open in vertical split

### Window Cycling & Resizing & Buffer Navigation 
- **Cycle Windows** (Arrow direction difference)
  - Left: <C-Left> → :lua cycle_window('left')<CR>
  - Right: <C-Right> → :lua cycle_window('right')<CR>
  - Up: <C-Up> → :lua cycle_window('up')<CR>
  - Down: <C-Down> → :lua cycle_window('down')<CR>

- **Window Resizing**  
  (Vertical Splits)
  - Increase width: nnoremap <C-S-Left> :vertical resize +4<CR>
  - Decrease width: nnoremap <C-S-Right> :vertical resize -4<CR>
  (Horizontal Splits)
  - Increase height: nnoremap <C-S-Up> :resize +4<CR>
  - Decrease height: nnoremap <C-S-Down> :resize -4<CR>

- **Buffer Navigation**  
  - Previous buffer: nnoremap <S-Left> :BufferLineCyclePrev<CR>
  - Next buffer: nnoremap <S-Right> :BufferLineCycleNext<CR>

---

## Common Telescope Commands

- **Find Files**
  - **Command:** `:Telescope find_files`
  - **Description:** Opens a fuzzy finder to search for files in your project directory.

- **Live Grep**
  - **Command:** `:Telescope live_grep`
  - **Description:** Searches for a given string pattern in all files in your project.

- **Current Buffer Fuzzy Find**
  - **Command:** `:Telescope current_buffer_fuzzy_find`
  - **Description:** Allows you to search within the current buffer.

---
