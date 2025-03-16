-- diagnostics.lua

-- Configure diagnostics: disable virtual text, enable signs and underline, and update diagnostics only on save.
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Function to toggle a floating diagnostic window.
local function ToggleDiagnosticFloat()
  local diagnostic_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      diagnostic_win = win
      break
    end
  end
  if diagnostic_win then
    vim.api.nvim_win_close(diagnostic_win, true)
  else
    vim.diagnostic.open_float(nil, { focus = false, source = "always" })
  end
end

-- Map <Space> to toggle the diagnostic float.
vim.keymap.set("n", "<Space>", ToggleDiagnosticFloat, { noremap = true, silent = true })

-- Map <leader>cf to trigger the LSP code action (i.e. apply available fixes).
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.code_action, { noremap = true, silent = true })

