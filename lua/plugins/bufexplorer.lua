return {
    -- Buffer Explorer
    'jlanzarotta/bufexplorer',
    keys = {
        { '<leader>F', ':BufExplorer<CR>', mode = 'n', { noremap = true, silent = true }},
        { '<leader>vsF', vim.cmd.BufExplorerVerticalSplit, mode = 'n', { noremap = true, silent = true }},
        { '<leader>sF', vim.cmd.BufExplorerHorizontalSplit, mode = 'n', { noremap = true, silent = true }},
    },
}
