require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "lua", "markdown" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    }
  })
  