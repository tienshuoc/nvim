return {
  -- Display hex colors.
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    vim.o.termguicolors = true
    local colorizer = require("colorizer")
    colorizer.setup()
  end,
}
