return {
    -- Buffer Tabs
    'romgrk/barbar.nvim',
    keys = {
        { '<leader>G', '<Cmd>BufferPick<CR>', mode = 'n', { noremap = true, silent = true } },
        { '<leader>D', '<Cmd>BufferPickDelete<CR>', mode = 'n', { noremap = true, silent = true } },
    },
}
