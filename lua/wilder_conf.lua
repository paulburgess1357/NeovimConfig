-- Enable wildmenu and set wildmode (optional, but can help with fallback)
vim.cmd('set wildmenu')
vim.cmd('set wildmode=longest:full,full')

-- Safely require wilder
local status_ok, wilder = pcall(require, "wilder")
if not status_ok then
  return
end

-- Setup wilder for command-line mode (':')
wilder.setup({ modes = { ':' } })

-- Set the renderer to popupmenu style
wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlighter = wilder.basic_highlighter(),
  pumblend = 20,           -- Adjust the transparency of the popup (0-100)
  max_height = '75%',      -- Maximum height of the popup menu
  reverse = 0,             -- Set to 1 if you want the list reversed
  left = { ' ', wilder.popupmenu_devicons() },
  right = { ' ' },         -- Removed popupmenu_index() to avoid errors
}))

