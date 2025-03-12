-- Helper Functions for Window Geometry and Data
local function get_win_data(win)
    local pos = vim.fn.win_screenpos(win)
    local row = pos[1]
    local col = pos[2]
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)
    return {
      win = win,
      win_row = row,
      win_col = col,
      width = width,
      height = height,
      center_x = col + width / 2,
      center_y = row + height / 2,
    }
  end
  
  local function get_candidate_windows(cur_win)
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local candidates = {}
    for _, win in ipairs(wins) do
      if win ~= cur_win then
        table.insert(candidates, get_win_data(win))
      end
    end
    return candidates
  end
  
  -- Filtering Functions Based on Overlap
  local function filter_candidates_vertically(candidates, cur)
    local filtered = {}
    local cur_top = cur.win_row
    local cur_bottom = cur.win_row + cur.height
    for _, cand in ipairs(candidates) do
      local cand_top = cand.win_row
      local cand_bottom = cand.win_row + cand.height
      if not (cand_bottom < cur_top or cand_top > cur_bottom) then
        table.insert(filtered, cand)
      end
    end
    return filtered
  end
  
  local function filter_candidates_horizontally(candidates, cur)
    local filtered = {}
    local cur_left = cur.win_col
    local cur_right = cur.win_col + cur.width
    for _, cand in ipairs(candidates) do
      local cand_left = cand.win_col
      local cand_right = cand.win_col + cand.width
      if not (cand_right < cur_left or cand_left > cur_right) then
        table.insert(filtered, cand)
      end
    end
    return filtered
  end
  
  -- Selection Functions for Each Direction
  local function select_left(candidates, cur)
    local best = nil
    for _, cand in ipairs(candidates) do
      if cand.center_x < cur.center_x then
        if not best or cand.center_x > best.center_x then
          best = cand
        end
      end
    end
    if best then
      return best.win
    end
    local max_cand = nil
    for _, cand in ipairs(candidates) do
      if not max_cand or cand.center_x > max_cand.center_x then
        max_cand = cand
      end
    end
    return max_cand.win
  end
  
  local function select_right(candidates, cur)
    local best = nil
    for _, cand in ipairs(candidates) do
      if cand.center_x > cur.center_x then
        if not best or cand.center_x < best.center_x then
          best = cand
        end
      end
    end
    if best then
      return best.win
    end
    local min_cand = nil
    for _, cand in ipairs(candidates) do
      if not min_cand or cand.center_x < min_cand.center_x then
        min_cand = cand
      end
    end
    return min_cand.win
  end
  
  local function select_up(candidates, cur)
    local best = nil
    for _, cand in ipairs(candidates) do
      if cand.center_y < cur.center_y then
        if not best or cand.center_y > best.center_y then
          best = cand
        end
      end
    end
    if best then
      return best.win
    end
    local max_cand = nil
    for _, cand in ipairs(candidates) do
      if not max_cand or cand.center_y > max_cand.center_y then
        max_cand = cand
      end
    end
    return max_cand.win
  end
  
  local function select_down(candidates, cur)
    local best = nil
    for _, cand in ipairs(candidates) do
      if cand.center_y > cur.center_y then
        if not best or cand.center_y < best.center_y then
          best = cand
        end
      end
    end
    if best then
      return best.win
    end
    local min_cand = nil
    for _, cand in ipairs(candidates) do
      if not min_cand or cand.center_y < min_cand.center_y then
        min_cand = cand
      end
    end
    return min_cand.win
  end
  
  -- Main Window Cycling Function
  function cycle_window(direction)
    local cur_win = vim.api.nvim_get_current_win()
    local cur = get_win_data(cur_win)
    local candidates = get_candidate_windows(cur_win)
    if #candidates < 1 then return end
  
    local filtered = {}
    if direction == "left" or direction == "right" then
      filtered = filter_candidates_vertically(candidates, cur)
      if #filtered == 0 then filtered = candidates end
    elseif direction == "up" or direction == "down" then
      filtered = filter_candidates_horizontally(candidates, cur)
      if #filtered == 0 then filtered = candidates end
    end
  
    local target_win = nil
    if direction == "left" then
      target_win = select_left(filtered, cur)
    elseif direction == "right" then
      target_win = select_right(filtered, cur)
    elseif direction == "up" then
      target_win = select_up(filtered, cur)
    elseif direction == "down" then
      target_win = select_down(filtered, cur)
    end
  
    if target_win then
      vim.api.nvim_set_current_win(target_win)
    end
  end
  
  -- Map CTRL + Arrow Keys to Cycle Windows
  vim.api.nvim_set_keymap("n", "<C-Left>",  ":lua cycle_window('left')<CR>",  { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-Right>", ":lua cycle_window('right')<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-Up>",    ":lua cycle_window('up')<CR>",    { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-Down>",  ":lua cycle_window('down')<CR>",  { noremap = true, silent = true })
  