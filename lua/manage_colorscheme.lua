-- init.lua runs before reading shada, so we have to read shada first.
vim.cmd("rshada")
-- Attempt to read saved colorscheme value from global variable which gets saved in shada.
-- If it's empty, just use default theme.
if vim.g.COLORSCHEME then
  vim.cmd.colorscheme(vim.g.COLORSCHEME)
else
  vim.cmd.colorscheme("PaperColor")
end

-- Automatically overwrite the saved colorscheme when changing colortheme.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- write_color_scheme()
    vim.g.COLORSCHEME = vim.g.colors_name
  end,
})
