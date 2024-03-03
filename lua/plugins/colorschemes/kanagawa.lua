return {
    -- kanagawa, kanagawa-wave, kanagawa-lotus, kanagawa-dragon
    'rebelot/kanagawa.nvim',
    config = function()
        require('kanagawa').setup({
            dimInactive = true,
        })
    end,
}
