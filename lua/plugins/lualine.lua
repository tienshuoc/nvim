return {
    -- Lualine
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
        require('lualine').setup {
            sections = {
                lualine_z = { { 'datetime', style = '%H:%M:%S | %b-%d' } }
            }
        }
    end,
}
