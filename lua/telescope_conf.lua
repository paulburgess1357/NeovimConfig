-- Telescope configuration using FZF as the default sorter
require('telescope').setup{
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "smart" },
    file_sorter = require('telescope.sorters').get_fzf_sorter,
    generic_sorter = require('telescope.sorters').get_fzf_sorter,
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '-F',  -- fixed-string mode: disables regex interpretation
    },
  },
  pickers = {
    -- Customize individual pickers here if needed
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- enable fuzzy matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- use smart case matching
    },
  },
}

-- Load the fzf extension
require('telescope').load_extension('fzf')

-- Key mappings for Telescope LSP pickers:
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { noremap = true, silent = true })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, silent = true })

