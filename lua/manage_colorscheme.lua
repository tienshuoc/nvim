-- Maintain file as single source of truth for current colors.
-- This file contains a single line with colorscheme, e.g. gruvbox-material
local colorscheme_fname = vim.fn.expand(vim.fn.stdpath("config") .. "/colorscheme_value")

-- Read colorscheme from file.
if vim.fn.filereadable(colorscheme_fname) == 1 then
  vim.cmd.colorscheme(vim.fn.readfile(colorscheme_fname)[1])
else
  vim.cmd.colorscheme("vscode")
end

-- Define a function to write the current color scheme to a file
local function write_color_scheme()
  local colorscheme = vim.g.colors_name
  vim.fn.writefile({ colorscheme }, colorscheme_fname)
end

-- Automatically execute the function when the color scheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    write_color_scheme()
  end,
})
