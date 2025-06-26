return {
  -- Display hex colors.
  "norcalli/nvim-colorizer.lua",
  cond = not vim.g.is_large_file_on_startup,
  config = function()
    vim.o.termguicolors = true
    local colorizer = require("colorizer")
    colorizer.setup()
  end,
}
