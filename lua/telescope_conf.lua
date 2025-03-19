-- Telescope configuration remains the same
require('telescope').setup{
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "smart" },
  },
  pickers = {
    -- Customize individual pickers here if needed
  },
  extensions = {
    -- Configuration for extensions (if you add any)
  }
}

-- Key mappings for Telescope LSP pickers:
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { noremap = true, silent = true })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, silent = true })

