-- Use nvim-navic plugin for breadcrumb support within lualine

local navic_ok, navic = pcall(require, "nvim-navic")
local function navic_breadcrumb()
  if navic_ok and navic.is_available() then
    return navic.get_location()
  else
    return ""
  end
end

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    section_separators = { left = ' | ', right = ' | ' },
    component_separators = { left = ' | ', right = ' | ' },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename', navic_breadcrumb},
    lualine_x = {
      'encoding',
      { 'fileformat', symbols = { unix = '', dos = '', mac = '' } },
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}

