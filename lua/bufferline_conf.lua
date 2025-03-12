require("bufferline").setup{
    options = {
      mode = "buffers",               -- Show buffers instead of tabs.
      numbers = "none",               -- Disable buffer numbers.
      close_command = "bdelete! %d",   -- Command to close a buffer.
      indicator = {
        icon = '▎',                  -- Buffer indicator icon.
        style = 'icon',
      },
      separator_style = "slant",      -- Separator style.
      offsets = {
        {
          filetype = "NvimTree",      -- Offset for the file explorer.
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
  