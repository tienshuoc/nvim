return {
    -- Buffer Explorer
    'jlanzarotta/bufexplorer',
    keys = {
        { '<leader>F', ':BufExplorer<CR>', mode = 'n', { noremap = true, silent = true }},
        { '<leader>vsF', '<CR>:vs<CR>:BufExplorer<CR>', mode = 'n', { noremap = true, silent = true }},
        { '<leader>sF', '<CR>:split<CR>:BufExplorer<CR>', mode = 'n', { noremap = true, silent = true }},
    },
}
