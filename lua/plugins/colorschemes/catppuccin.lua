return {
  -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
  "catppuccin/nvim",
  config = function()
    require("catppuccin").setup({
      transparent_background = false,
      dim_inactive = {
        enabled = false,
      },
    })
  end,
}
