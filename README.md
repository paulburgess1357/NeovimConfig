## Neovim Custom Keybindings Quick Reference

---

## Current Plugins

- **LSP Support:** `neovim/nvim-lspconfig`
- **Colorscheme:** `folke/tokyonight.nvim`
- **Treesitter:** `nvim-treesitter/nvim-treesitter` (with `:TSUpdate`)
- **File Manager:** `kyazdani42/nvim-tree.lua`
- **Completion Engine:** `hrsh7th/nvim-cmp`
- **LSP Completion Source:** `hrsh7th/cmp-nvim-lsp`
- **Buffer Completion Source:** `hrsh7th/cmp-buffer`
- **Auto-Pairs:** `windwp/nvim-autopairs`
- **Status Line:** `nvim-lualine/lualine.nvim`
- **Illuminate:** `RRethy/vim-illuminate`
- **Bufferline:** `akinsho/bufferline.nvim`
- **Rainbow Delimiters:** `HiPhish/rainbow-delimiters.nvim`
- **Telescope & Dependencies:** `nvim-lua/plenary.nvim`, `nvim-telescope/telescope.nvim`
- **Breadcrumb Support:** `SmiteshP/nvim-navic`

---

## LSP Setup and Requirements

This Neovim configuration uses several Language Server Protocol (LSP) servers. To ensure full functionality, please install the following packages:

### C/C++ (clangd)
- **Server:** clangd  
- **Installation (Ubuntu/Debian):**
~~~bash
sudo apt install clangd
~~~
- **Additional Tool:** clang-tidy (for enhanced code analysis)  
  **Installation (Ubuntu/Debian):**
~~~bash
sudo apt install clang-tidy
~~~
- **Notes:**  
  The configuration uses additional flags: `--clang-tidy` and `--completion-style=detailed`.

### Python (pyright)
- **Server:** pyright  
- **Installation:**
~~~bash
npm install -g pyright
~~~

### Bash (bashls)
- **Server:** bash-language-server  
- **Installation:**
~~~bash
npm install -g bash-language-server
~~~
- **Additional Linting Tools:**  
  For proper linting, consider installing:
  - **ShellCheck:**  
    ~~~bash
    sudo apt install shellcheck
    ~~~
  - **shfmt (optional):**  
    Install via Snap or manually.

---

## Vim Keybindings

- **Clear Search Highlight**  
  Key: `Esc`

- **Go to Start of File (with column adjustment)**  
  Key: `gg`

- **Search Current Word**  
  - Next occurrence: `<leader>n`  
  - Previous occurrence: `<leader>N`

- **Buffer Close Abbreviations**  
  *Replaces default `:q`, `:q!`, and `:qw` with a custom `Bclose` command:*  
  - `q`: Bclose  
  - `q!`: Bclose!  
  - `qw`: Bclose

---

## Diagnostics & LSP Keybindings

- **Toggle Diagnostic Floating Window**  
  Key: `Space` (in normal mode)

- **Fix Clang Issues / Trigger LSP Code Action**  
  Key: `<leader>cf`

- **Go to Definition**  
  Key: `gd`

- **Hover Documentation**  
  Key: `K`

- **Rename Symbol**  
  Key: `<leader>rn`

---

## Nvim-Tree Keybindings

- **Toggle File Explorer**  
  Key: `CTRL + n`

- **Within Explorer (when attached):**
  - `o`: Open in new tab  
  - `h`: Open in horizontal split  
  - `v`: Open in vertical split

---

## Window & Buffer Management Keybindings

- **Cycle Windows** (Arrow direction difference)  
  - Left: `CTRL + Left Arrow`  
  - Right: `CTRL + Right Arrow`  
  - Up: `CTRL + Up Arrow`  
  - Down: `CTRL + Down Arrow`

- **Window Resizing**  
  **Vertical Splits:**  
  - Increase width: `CTRL + Shift + Left Arrow`  
  - Decrease width: `CTRL + Shift + Right Arrow`  
  **Horizontal Splits:**  
  - Increase height: `CTRL + Shift + Up Arrow`  
  - Decrease height: `CTRL + Shift + Down Arrow`

- **Buffer Navigation**  
  - Previous buffer: `Shift + Left Arrow`  
  - Next buffer: `Shift + Right Arrow`

---

## Telescope Commands

- **Find Files**  
  Command: `:Telescope find_files`  
  Description: Opens a fuzzy finder to search for files in your project directory.

- **Live Grep**  
  Command: `:Telescope live_grep`  
  Description: Searches for a given string pattern in all files in your project.

- **Current Buffer Fuzzy Find**  
  Command: `:Telescope current_buffer_fuzzy_find`  
  Description: Allows you to search within the current buffer.
 Neovim Custom Keybindings Quick Reference

---

