return {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require('headlines').setup({
            markdown = {
                fat_headline_lower_string = "▀",
            }
        })
    end,
}
