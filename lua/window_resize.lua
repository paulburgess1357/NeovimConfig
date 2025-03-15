-- Adjust left/right border of the active window.
-- For non-leftmost windows, we adjust the left border by resizing the left neighbor.
-- For the leftmost window, we adjust the right border directly.
function adjust_lr(direction, amount)
  local cur_win = vim.api.nvim_get_current_win()
  local left_win = vim.fn.win_getid("h")  -- gets the window to the left
  if left_win ~= cur_win then
    -- Active window is not leftmost; adjust its left border via the left neighbor.
    vim.cmd("wincmd h")
    if direction == "left" then
      -- Move the border left: shrink left neighbor.
      vim.cmd("vertical resize -" .. amount)
    elseif direction == "right" then
      -- Move the border right: enlarge left neighbor.
      vim.cmd("vertical resize +" .. amount)
    end
    vim.api.nvim_set_current_win(cur_win)
  else
    -- Active window is leftmost; adjust its right border.
    if direction == "left" then
      vim.cmd("vertical resize -" .. amount)
    elseif direction == "right" then
      vim.cmd("vertical resize +" .. amount)
    end
  end
end

-- Adjust up/down border of the active window.
-- For non-topmost windows, we adjust the top border by resizing the window above.
-- For the topmost window, we adjust the bottom border directly.
function adjust_ud(direction, amount)
  local cur_win = vim.api.nvim_get_current_win()
  local above_win = vim.fn.win_getid("k")  -- gets the window above
  if above_win ~= cur_win then
    vim.cmd("wincmd k")
    if direction == "up" then
      -- Move the top border upward: shrink the above neighbor.
      vim.cmd("resize -" .. amount)
    elseif direction == "down" then
      -- Move the top border downward: enlarge the above neighbor.
      vim.cmd("resize +" .. amount)
    end
    vim.api.nvim_set_current_win(cur_win)
  else
    -- Active window is topmost; adjust its bottom border.
    if direction == "up" then
      vim.cmd("resize -" .. amount)
    elseif direction == "down" then
      vim.cmd("resize +" .. amount)
    end
  end
end

-- Map the functions to Ctrl+Shift+Arrow keys (with an increment of 4).
vim.api.nvim_set_keymap("n", "<C-S-Left>",  ':lua adjust_lr("left", 4)<CR>',  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Right>", ':lua adjust_lr("right", 4)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Up>",    ':lua adjust_ud("up", 4)<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Down>",  ':lua adjust_ud("down", 4)<CR>',  { noremap = true, silent = true })
