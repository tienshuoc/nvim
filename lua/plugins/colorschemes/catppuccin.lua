return {
    -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    'catppuccin/nvim',
    config = function()
        require('catppuccin').setup({
            transparent_background = true,
            dim_inactive = {
                enabled = false,
            }
        })
    end,
}
