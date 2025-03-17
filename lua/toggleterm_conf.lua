require("toggleterm").setup{
  size = 20,                     -- terminal height for horizontal split
  open_mapping = [[<c-\>]],      -- key mapping to toggle the terminal
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = false, 
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

