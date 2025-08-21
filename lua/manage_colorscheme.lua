-- Attempt to read saved colorscheme value from global variable.
-- If it's empty, just use default theme.

-- Automatically save the colorscheme name to a global variable whenever you change it.
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.g.COLORSCHEME = vim.g.colors_name
  end,
})

-- After Neovim has fully started, load the saved colorscheme.
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    -- Attempt to read the saved value. If it's not set, use a default.
    if vim.g.COLORSCHEME then
      vim.cmd.colorscheme(vim.g.COLORSCHEME)
    else
      vim.cmd.colorscheme("PaperColor")
    end
  end,
})
