## Neovim Quick Reference

---

## Current Plugins

- **LSP Support:** [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- **Colorscheme:** [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- **Treesitter:** [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (with `:TSUpdate`)
- **File Manager:** [kyazdani42/nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)
- **Completion Engine:** [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- **LSP Completion Source:** [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- **Buffer Completion Source:** [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- **Auto-Pairs:** [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- **Status Line:** [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Illuminate:** [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- **Bufferline:** [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- **Rainbow Delimiters:** [HiPhish/rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
- **Telescope & Dependencies:**
  - [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
  - [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- **Breadcrumb Support:** [SmiteshP/nvim-navic](https://github.com/SmiteshP/nvim-navic)
- **Terminal Integration:** [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- **Web Devicons:** [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- **Vim Command Completion:** [gelguy/wilder.nvim](https://github.com/gelguy/wilder.nvim)

---

## LSP Setup and Requirements

This Neovim configuration uses several Language Server Protocol (LSP) servers. To ensure full functionality, please install the following packages:

### C/C++ (clangd)
- **Server:** clangd
- **Installation (Ubuntu/Debian):**
  ```bash
  sudo apt install clangd
  ```
- **Additional Tool:** clang-tidy (for enhanced code analysis)
  **Installation (Ubuntu/Debian):**
  ```bash
  sudo apt install clang-tidy
  ```
- **Notes:**
  The configuration uses additional flags: `--clang-tidy` and `--completion-style=detailed`.

### Python (pyright)
- **Server:** pyright
- **Installation:**
  ```bash
  npm install -g pyright
  ```

### Bash (bashls)
- **Server:** bash-language-server
- **Installation:**
  ```bash
  npm install -g bash-language-server
  ```
- **Additional Linting Tools:**
  For proper linting, consider installing:
  - **ShellCheck:**
    ```bash
    sudo apt install shellcheck
    ```
  - **shfmt (optional):**
    Install via Snap or manually.

---

## Repository Setup for C/C++ Projects

To set up a repository for C/C++ development, follow these steps:

1. **Generate the Compilation Database:**
   - Run CMake with the export flag. For example:
     ```bash
     cmake ../ -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
     ```

2. **Make a Symlink to the Project Root:**
   - Create a symlink for the generated `compile_commands.json` in your project root:
     ```bash
     ln -s path/to/build/compile_commands.json ./compile_commands.json
     ```

3. **Copy Clang Configuration Files to the Project Root:**
   - Copy your configuration files (such as `.clangd`, `.clang-format`, and `.clang-tidy`) into the project root to ensure consistent formatting and diagnostics.

---


## Other Recommendations:
- **RipGrep (for Telescope)**
  - RipGrep is used by Telescope for its live grep functionality.
  - **Installation (Ubuntu/Debian):**
    ```bash
    sudo apt install ripgrep
    ```

- **fd (for Telescope)**
  - fd is an optional dependency for Telescope’s file search picker (`find_files`). When installed, Telescope will automatically use fd for faster file searching.
  - **Installation (Ubuntu/Debian):**
    ```bash
    sudo apt install fd-find
    ```

## Neovim Setup

**Minimum Version Required:**
v0.10.4

**Clone the Repository:**
Clone this repository to your local machine:
```bash
git clone git@github.com:paulburgess1357/NeovimConfig.git
```

**Copy Neovim Configuration Files:**
1. **Neovim Config Files:**
   - Copy the `init.vim` file from the `neovim_files` directory to your Neovim configuration directory:
     ```bash
     ~/.config/nvim/
     ```
   - Copy the entire `lua` folder from the repository into the same Neovim configuration directory (`~/.config/nvim/`).

2. **Clang Configuration Files (Optional for C++):**
   - The `clang_files` directory contains files like `.clangd`, `.clang-format`, and `.clang-tidy`.
   - Copy these files to your C++ working directory (or wherever you manage your C++ projects) to maintain consistent clang tool configurations.

**Neovim Download & Installation:**
- Download the latest release from the [Neovim homepage](https://neovim.io/).

**Install Plugins:**
After setting up your configuration, open Neovim and run:
```vim
:PlugInstall
```
If you're using [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (which is included in the init file), run:
```vim
:TSUpdate
```
This will install all the plugins specified in your configuration and update Treesitter parsers.

---

## Fonts (Optional)

**Plugin Requirement:**
For proper icon display, [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) requires a Nerd Font.

**Overview:**
Nerd Fonts are patched fonts that add a large number of glyphs (icons) to your standard fonts. You can choose any Nerd Font from the [Nerd Fonts website](https://www.nerdfonts.com/). I use Mononoki.

**Installation Steps:**

1. **Download the Font Archive:**
   - Visit the [Nerd Fonts Download Page](https://www.nerdfonts.com/font-downloads).
   - Download your preferred font archive (for example, the Mononoki archive).

2. **Extract the Files:**
   - Unzip the downloaded archive to extract all the `.ttf` files. You’ll notice multiple variants such as Regular, Bold, Italic, etc.

3. **Install the Fonts:**

   **Linux:**
   - Open a terminal and create a local fonts directory if it doesn't exist:
     ```bash
     mkdir -p ~/.local/share/fonts
     ```
   - Copy all the `.ttf` files from the extracted folder to your local fonts directory:
     ```bash
     cp *.ttf ~/.local/share/fonts/
     ```
   - Update the font cache:
     ```bash
     fc-cache -fv
     ```

After installing all variants, configure your terminal emulator and any other relevant applications to use your newly installed Nerd Font. This ensures that both icon support and text styling (bold, italic, etc.) are rendered correctly.

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

- **Go to References (using Telescope Live Grep)**
  Key: `gr`

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

## Terminal Integration Keybindings

- **Switch out of Terminal Insert Mode:**
  In terminal mode, press `Esc` (mapped to `<C-\><C-n>`) to exit insert mode and enter normal mode.

- **Open/Toggle Terminal Instance #2:**
  Key: `<leader>t2`  (Supports 2-9 horizontally)
  (For example, if your leader is `\`, press: `\t2`)

- **Force-Close Terminal:**
  In terminal mode, press `<leader>q` to switch to normal mode and force-close the terminal (using `:q!`).

*Note:*
- The terminal settings use `persist_size = true` so the terminal remembers its size between toggles.
- `close_on_exit = true` will automatically close the terminal window when the process exits.

---

## Telescope Commands

- **Find Files**
  Command: `:Telescope find_files`
  Description: Opens a fuzzy finder to search for files in your project directory.

- **Live Grep**
  Command: `:Telescope live_grep`
  Description: Searches for a given string pattern in all files in your project.
  (I also map `gr` to trigger this action.)

- **Current Buffer Fuzzy Find**
  Command: `:Telescope current_buffer_fuzzy_find`
  Description: Allows you to search within the current buffer.

---

## Neovim Custom Keybindings Quick Reference

**General Navigation:**
- **Clear Search Highlight:** `Esc`
- **Go to Start of File:** `gg`
- **Search Current Word:**
  - Next occurrence: `<leader>n`
  - Previous occurrence: `<leader>N`

**LSP & Diagnostics:**
- **Go to Definition:** `gd`
- **Go to References (using Telescope Live Grep):** `gr`
- **Hover Documentation:** `K`
- **Rename Symbol:** `<leader>rn`
- **Toggle Diagnostic Floating Window:** `Space`
- **Fix Clang Issues / Trigger Code Action:** `<leader>cf`

**File Navigation:**
- **Toggle File Explorer (Nvim-Tree):** `CTRL + n`

**Window & Buffer Management:**
- **Cycle Windows:**
  - Left: `CTRL + Left Arrow`
  - Right: `CTRL + Right Arrow`
  - Up: `CTRL + Up Arrow`
  - Down: `CTRL + Down Arrow`
- **Window Resizing:**
  - Vertical Splits:
    - Increase width: `CTRL + Shift + Left Arrow`
    - Decrease width: `CTRL + Shift + Right Arrow`
  - Horizontal Splits:
    - Increase height: `CTRL + Shift + Up Arrow`
    - Decrease height: `CTRL + Shift + Down Arrow`
- **Buffer Navigation:**
  - Previous buffer: `Shift + Left Arrow`
  - Next buffer: `Shift + Right Arrow`

**Terminal Integration:**
- **Exit Terminal Insert Mode:** Press `Esc` (mapped to `<C-\><C-n>`)
- **Open/Toggle Terminal Instance #2:** `<leader>t2`
- **Force-Close Terminal:** `<leader>q`

**Telescope Commands:**
- **Find Files:** `:Telescope find_files`
- **Live Grep:** `:Telescope live_grep`
- **Current Buffer Fuzzy Find:** `:Telescope current_buffer_fuzzy_find`


