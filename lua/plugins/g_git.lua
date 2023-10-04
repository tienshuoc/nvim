return {
    -- Git plugins.
    {
        'tpope/vim-fugitive',
        keys = {
            { '<leader>dt', ':Git difftool -y', mode = 'n', { noremap = true, silent = true }}
        }
    },
    {
        "sindrets/diffview.nvim",  -- Git diff page.
    },
    {
        'whiteinge/diffconflicts', -- Git diff conflicts.
    }
}
