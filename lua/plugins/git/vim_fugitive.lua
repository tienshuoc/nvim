return {
    'tpope/vim-fugitive',
    lazy = false,
    keys = {
        { '<leader>dt', ':Git difftool -y<CR>', mode = 'n', { noremap = true, silent = true } },
        { '<leader>gs', vim.cmd.Git,            mode = 'n', { noremap = true, silent = true } }
    }
}
