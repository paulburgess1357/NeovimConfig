
-- Bufferline configuration with devicon integration for icons
require("bufferline").setup{
  options = {
    mode = "buffers",               -- Show buffers instead of tabs.
    numbers = "none",               -- Disable buffer numbers.
    close_command = "bdelete! %d",   -- Command to close a buffer.
    indicator = {
      icon = '▎',                 -- Buffer indicator icon.
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
    show_buffer_close_icons = false,
    show_close_icon = false,         -- Display the global close icon.
    close_icon = "",               -- Icon to close the current buffer.
    buffer_close_icon = "",        -- Alternate icon to close an individual buffer.
    modified_icon = "●",            -- Icon to indicate a modified buffer.
    left_trunc_marker = "",         -- Icon for left truncation.
    right_trunc_marker = "",        -- Icon for right truncation.
    enforce_regular_tabs = false,
    always_show_bufferline = true,
  }
}

